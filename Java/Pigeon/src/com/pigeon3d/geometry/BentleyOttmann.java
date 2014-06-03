package com.pigeon3d.geometry;

import objd.lang.*;
import objd.collection.Set;
import objd.collection.ImHashSet;
import objd.collection.ImArray;
import objd.collection.Seq;
import objd.collection.Pair;
import objd.chain.Chain;
import objd.collection.MSet;
import objd.collection.Traversable;

public class BentleyOttmann {
    public static <T> Set<Intersection<T>> intersectionsForSegments(final ImArray<Tuple<T, LineSegment>> segments) {
        if(segments.count() < 2) {
            return ((Set<Intersection<T>>)(((Set)(new ImHashSet<Intersection<T>>()))));
        } else {
            final SweepLine<T> sweepLine = new SweepLine<T>();
            final BentleyOttmannEventQueue<T> queue = BentleyOttmannEventQueue.<T>newWithSegmentsSweepLine(((ImArray<Tuple<T, LineSegment>>)(((ImArray)(segments)))), ((SweepLine)(sweepLine)));
            while(!(queue.isEmpty())) {
                final Seq<BentleyOttmannEvent> events = queue.poll();
                sweepLine.handleEvents(((Seq<BentleyOttmannEvent<T>>)(((Seq)(events)))));
            }
            return sweepLine.intersections.chain().<Intersection<T>>flatMapF(((F<Tuple<vec2, MSet<BentleyOttmannPointEvent<T>>>, Traversable<Intersection<T>>>)(((F)(new F<Tuple<vec2, MSet<BentleyOttmannPointEvent<T>>>, Chain<Intersection<T>>>() {
                @Override
                public Chain<Intersection<T>> apply(final Tuple<vec2, MSet<BentleyOttmannPointEvent<T>>> p) {
                    return p.b.chain().combinations().filterWhen(new F<Tuple<BentleyOttmannPointEvent<T>, BentleyOttmannPointEvent<T>>, Boolean>() {
                        @Override
                        public Boolean apply(final Tuple<BentleyOttmannPointEvent<T>, BentleyOttmannPointEvent<T>> comb) {
                            return !(comb.a.isVertical()) || !(comb.b.isVertical());
                        }
                    }).<Intersection<T>>mapF(new F<Tuple<BentleyOttmannPointEvent<T>, BentleyOttmannPointEvent<T>>, Intersection<T>>() {
                        @Override
                        public Intersection<T> apply(final Tuple<BentleyOttmannPointEvent<T>, BentleyOttmannPointEvent<T>> comb) {
                            return new Intersection<T>(new Pair<T>(comb.a.data, comb.b.data), p.a);
                        }
                    });
                }
            }))))).toSet();
        }
    }
    public BentleyOttmann() {
    }
    public String toString() {
        return "BentleyOttmann";
    }
}