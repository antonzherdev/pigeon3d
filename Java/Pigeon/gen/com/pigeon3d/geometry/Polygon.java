package com.pigeon3d.geometry;

import objd.lang.*;
import objd.collection.ImArray;
import objd.collection.Iterator;

public final class Polygon extends Figure_impl {
    public final ImArray<vec2> points;
    public final ImArray<LineSegment> segments;
    @Override
    public ImArray<LineSegment> segments() {
        return segments;
    }
    @Override
    public Rect boundingRect() {
        double minX = Float.max;
        double maxX = Float.min;
        double minY = Float.max;
        double maxY = Float.min;
        {
            final Iterator<vec2> __il__4i = this.points.iterator();
            while(__il__4i.hasNext()) {
                final vec2 p = __il__4i.next();
                {
                    if(p.x < minX) {
                        minX = ((double)(p.x));
                    }
                    if(p.x > maxX) {
                        maxX = ((double)(p.x));
                    }
                    if(p.y < minY) {
                        minY = ((double)(p.y));
                    }
                    if(p.y > maxY) {
                        maxY = ((double)(p.y));
                    }
                }
            }
        }
        return vec2.rectToVec2(new vec2(((float)(minX)), ((float)(minY))), new vec2(((float)(maxX)), ((float)(maxY))));
    }
    public Polygon(final ImArray<vec2> points) {
        this.points = points;
        this.segments = points.chain().neighboursRing().<LineSegment>mapF(new F<Tuple<vec2, vec2>, LineSegment>() {
            @Override
            public LineSegment apply(final Tuple<vec2, vec2> ps) {
                return LineSegment.newWithP0P1(ps.a, ps.b);
            }
        }).toArray();
    }
    public String toString() {
        return String.format("Polygon(%s)", this.points);
    }
    public boolean equals(final Object to) {
        if(this == to) {
            return true;
        }
        if(to == null || !(to instanceof Polygon)) {
            return false;
        }
        final Polygon o = ((Polygon)(to));
        return this.points.equals(o.points);
    }
    public int hashCode() {
        int hash = 0;
        hash = hash * 31 + this.points.hashCode();
        return hash;
    }
}