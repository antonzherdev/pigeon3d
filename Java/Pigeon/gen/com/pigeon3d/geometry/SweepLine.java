package com.pigeon3d.geometry;

import objd.lang.*;
import objd.collection.MTreeSet;
import objd.collection.MHashMap;
import objd.collection.MSet;
import objd.collection.Iterator;
import objd.collection.Seq;
import objd.collection.ImArray;
import objd.collection.MHashSet;

public class SweepLine<T> {
    public MTreeSet<BentleyOttmannPointEvent<T>> events;
    public final MHashMap<vec2, MSet<BentleyOttmannPointEvent<T>>> intersections;
    private vec2 currentEventPoint;
    public BentleyOttmannEventQueue queue;
    public void handleEvents(final Seq<BentleyOttmannEvent<T>> events) {
        {
            final Iterator<BentleyOttmannEvent<T>> __il__0i = events.iterator();
            while(__il__0i.hasNext()) {
                final BentleyOttmannEvent<T> _ = __il__0i.next();
                handleOneEvent(_);
            }
        }
    }
    private void sweepToEvent(final BentleyOttmannEvent<T> event) {
        this.currentEventPoint = event.point();
    }
    private void handleOneEvent(final BentleyOttmannEvent<T> event) {
        if(event.isStart()) {
            sweepToEvent(event);
            final BentleyOttmannPointEvent<T> pe = ((BentleyOttmannPointEvent<T>)(((BentleyOttmannPointEvent)(event))));
            if(pe.isVertical()) {
                final float minY = pe.segment.p0.y;
                final float maxY = pe.segment.p1.y;
                final Iterator<BentleyOttmannPointEvent<T>> i = this.events.iteratorHigherThanItem(pe);
                while(i.hasNext()) {
                    final BentleyOttmannPointEvent<T> e = i.next();
                    if(!(e.isVertical())) {
                        final double y = e.yForX(((double)(this.currentEventPoint.x)));
                        if(y > maxY) {
                            break;
                        }
                        if(y >= minY) {
                            registerIntersectionABPoint(pe, e, new vec2(this.currentEventPoint.x, ((float)(y))));
                        }
                    }
                }
            } else {
                this.events.appendItem(pe);
                checkIntersectionAB(event, aboveEvent(pe));
                checkIntersectionAB(event, belowEvent(pe));
            }
        } else {
            if(event.isEnd()) {
                final BentleyOttmannPointEvent<T> pe = ((BentleyOttmannPointEvent<T>)(((BentleyOttmannPointEvent)(event))));
                if(!(pe.isVertical())) {
                    final BentleyOttmannPointEvent<T> a = aboveEvent(pe);
                    final BentleyOttmannPointEvent<T> b = belowEvent(pe);
                    this.events.removeItem(pe);
                    sweepToEvent(event);
                    checkIntersectionAB(a, b);
                }
            } else {
                final MSet<BentleyOttmannPointEvent<T>> __tmp_0ff_0n = this.intersections.applyKey(event.point());
                if(__tmp_0ff_0n == null) {
                    throw new NullPointerException();
                }
                final MSet<BentleyOttmannPointEvent<T>> set = __tmp_0ff_0n;
                final ImArray<BentleyOttmannPointEvent<T>> toInsert = set.chain().filterWhen(new F<BentleyOttmannPointEvent<T>, Boolean>() {
                    @Override
                    public Boolean apply(final BentleyOttmannPointEvent<T> _) {
                        return SweepLine.this.events.removeItem(_);
                    }
                }).toArray();
                sweepToEvent(event);
                {
                    final Iterator<BentleyOttmannPointEvent<T>> __il__0ff_3i = toInsert.iterator();
                    while(__il__0ff_3i.hasNext()) {
                        final BentleyOttmannPointEvent<T> e = __il__0ff_3i.next();
                        {
                            this.events.appendItem(e);
                            checkIntersectionAB(e, aboveEvent(e));
                            checkIntersectionAB(e, belowEvent(e));
                        }
                    }
                }
            }
        }
    }
    private BentleyOttmannPointEvent<T> aboveEvent(final BentleyOttmannPointEvent<T> event) {
        return this.events.higherThanItem(event);
    }
    private BentleyOttmannPointEvent<T> belowEvent(final BentleyOttmannPointEvent<T> event) {
        return this.events.lowerThanItem(event);
    }
    private void checkIntersectionAB(final BentleyOttmannEvent<T> a, final BentleyOttmannEvent<T> b) {
        if(a != null && b != null && a instanceof BentleyOttmannPointEvent && b instanceof BentleyOttmannPointEvent) {
            final BentleyOttmannPointEvent<T> aa = ((BentleyOttmannPointEvent<T>)(((BentleyOttmannPointEvent)(a))));
            final BentleyOttmannPointEvent<T> bb = ((BentleyOttmannPointEvent<T>)(((BentleyOttmannPointEvent)(b))));
            {
                final vec2 _ = aa.segment.intersectionWithSegment(bb.segment);
                if(_ != null) {
                    registerIntersectionABPoint(aa, bb, ((vec2)(_)));
                }
            }
        }
    }
    private void registerIntersectionABPoint(final BentleyOttmannPointEvent<T> a, final BentleyOttmannPointEvent<T> b, final vec2 point) {
        if(!(a.segment.endingsContainPoint(point)) || !(b.segment.endingsContainPoint(point))) {
            final MSet<BentleyOttmannPointEvent<T>> existing = this.intersections.applyKeyOrUpdateWith(point, ((F0<MSet<BentleyOttmannPointEvent<T>>>)(((F0)(new F0<MHashSet<BentleyOttmannPointEvent<T>>>() {
                @Override
                public MHashSet<BentleyOttmannPointEvent<T>> apply() {
                    return new MHashSet<BentleyOttmannPointEvent<T>>();
                }
            })))));
            existing.appendItem(a);
            existing.appendItem(b);
            if(point.x > this.currentEventPoint.x || (point.x.equals(this.currentEventPoint.x) && point.y > this.currentEventPoint.y)) {
                final BentleyOttmannIntersectionEvent<T> intersection = new BentleyOttmannIntersectionEvent<T>(point);
                if(this.queue != null) {
                    this.queue.offerPointEvent(point, ((BentleyOttmannEvent)(intersection)));
                }
            }
        }
    }
    private int compareEventsAB(final BentleyOttmannPointEvent<T> a, final BentleyOttmannPointEvent<T> b) {
        if(a.equals(b)) {
            return 0;
        }
        final double ay = a.yForX(((double)(this.currentEventPoint.x)));
        final double by = b.yForX(((double)(this.currentEventPoint.x)));
        int c = Float.compareTo(ay, by);
        if(c == 0) {
            if(a.isVertical()) {
                c = -1;
            } else {
                if(b.isVertical()) {
                    c = 1;
                } else {
                    c = Float.compareTo(a.slope(), b.slope());
                    if(ay > this.currentEventPoint.y) {
                        c = -(c);
                    }
                    if(c == 0) {
                        c = Float4.compareTo(a.point.x, b.point.x);
                    }
                }
            }
        }
        return c;
    }
    public SweepLine() {
        this.events = MTreeSet.<BentleyOttmannPointEvent<T>>applyComparator(new F2<BentleyOttmannPointEvent<T>, BentleyOttmannPointEvent<T>, Integer>() {
            @Override
            public Integer apply(final BentleyOttmannPointEvent<T> a, final BentleyOttmannPointEvent<T> b) {
                return compareEventsAB(a, b);
            }
        });
        this.intersections = new MHashMap<vec2, MSet<BentleyOttmannPointEvent<T>>>();
        this.currentEventPoint = new vec2(((float)(0)), ((float)(0)));
        this.queue = null;
    }
    public String toString() {
        return "SweepLine";
    }
}