package com.pigeon3d.geometry;

import objd.lang.*;
import objd.collection.MTreeMap;
import objd.collection.MArray;
import objd.collection.Iterator;
import objd.collection.ImArray;
import objd.collection.Seq;

public class BentleyOttmannEventQueue<T> {
    public final MTreeMap<vec2, MArray<BentleyOttmannEvent<T>>> events;
    public boolean isEmpty() {
        return this.events.isEmpty();
    }
    public static <T> BentleyOttmannEventQueue<T> newWithSegmentsSweepLine(final ImArray<Tuple<T, LineSegment>> segments, final SweepLine sweepLine) {
        final BentleyOttmannEventQueue<T> ret = new BentleyOttmannEventQueue<T>();
        if(!(segments.isEmpty())) {
            {
                final Iterator<Tuple<T, LineSegment>> __il__1t_0i = segments.iterator();
                while(__il__1t_0i.hasNext()) {
                    final Tuple<T, LineSegment> s = __il__1t_0i.next();
                    {
                        final LineSegment segment = s.b;
                        ret.offerPointEvent(segment.p0, ((BentleyOttmannEvent)(new BentleyOttmannPointEvent<T>(true, s.a, segment, segment.p0))));
                        ret.offerPointEvent(segment.p1, ((BentleyOttmannEvent)(new BentleyOttmannPointEvent<T>(false, s.a, segment, segment.p1))));
                    }
                }
            }
            sweepLine.queue = ((BentleyOttmannEventQueue)(ret));
        }
        return ret;
    }
    public void offerPointEvent(final vec2 point, final BentleyOttmannEvent event) {
        this.events.applyKeyOrUpdateWith(point, new F0<MArray<BentleyOttmannEvent<T>>>() {
            @Override
            public MArray<BentleyOttmannEvent<T>> apply() {
                return new MArray<BentleyOttmannEvent<T>>();
            }
        }).appendItem(((BentleyOttmannEvent<T>)(((BentleyOttmannEvent)(event)))));
    }
    public Seq<BentleyOttmannEvent> poll() {
        final Tuple<vec2, MArray<BentleyOttmannEvent<T>>> __tmpln = this.events.pollFirst();
        if(__tmpln == null) {
            throw new NullPointerException();
        }
        return ((Seq<BentleyOttmannEvent>)(((Seq)(__tmpln.b))));
    }
    public BentleyOttmannEventQueue() {
        this.events = new MTreeMap<vec2, MArray<BentleyOttmannEvent<T>>>(new F2<vec2, vec2, Integer>() {
            @Override
            public Integer apply(final vec2 a, final vec2 b) {
                return vec2.compareTo(a, b);
            }
        });
    }
    public String toString() {
        return "BentleyOttmannEventQueue";
    }
}