package com.pigeon3d.geometry;

import objd.lang.*;
import objd.collection.ImArray;
import objd.math;

public final class ThickLineSegment extends Figure_impl {
    public final LineSegment segment;
    public final double thickness;
    public final double thickness_2;
    private ImArray<LineSegment> _segments;
    @Override
    public Rect boundingRect() {
        return Rect.thickenHalfSize(this.segment.boundingRect, new vec2(((this.segment.isHorizontal()) ? (((float)(((double)(0))))) : (((float)(this.thickness_2)))), ((this.segment.isVertical()) ? (((float)(((double)(0))))) : (((float)(this.thickness_2))))));
    }
    @Override
    public ImArray<LineSegment> segments() {
        if(this._segments == null) {
            double dx = ((double)(0));
            double dy = ((double)(0));
            if(this.segment.isVertical()) {
                dx = this.thickness_2;
                dy = ((double)(0));
            } else {
                if(this.segment.isHorizontal()) {
                    dx = ((double)(0));
                    dy = this.thickness_2;
                } else {
                    final double k = this.segment.line().slope();
                    dy = this.thickness_2 / math.sqrt(1 + k);
                    dx = k * dy;
                }
            }
            final LineSegment line1 = this.segment.moveWithXY(-(dx), dy);
            final LineSegment line2 = this.segment.moveWithXY(dx, -(dy));
            final LineSegment line3 = LineSegment.newWithP0P1(line1.p0, line2.p0);
            this._segments = ImArray.fromObjects(line1, line2, line3, line3.moveWithPoint(vec2.subVec2(this.segment.p1, this.segment.p0)));
            if(this._segments == null) {
                throw new NullPointerException();
            }
            return this._segments;
        } else {
            return this._segments;
        }
    }
    public ThickLineSegment(final LineSegment segment, final double thickness) {
        this.segment = segment;
        this.thickness = thickness;
        this.thickness_2 = thickness / 2;
    }
    public String toString() {
        return String.format("ThickLineSegment(%s, %f)", this.segment, this.thickness);
    }
    public boolean equals(final Object to) {
        if(this == to) {
            return true;
        }
        if(to == null || !(to instanceof ThickLineSegment)) {
            return false;
        }
        final ThickLineSegment o = ((ThickLineSegment)(to));
        return this.segment.equals(o.segment) && this.thickness.equals(o.thickness);
    }
    public int hashCode() {
        int hash = 0;
        hash = hash * 31 + this.segment.hashCode();
        hash = hash * 31 + Float.hashCode(this.thickness);
        return hash;
    }
}