package com.pigeon3d.geometry;

import objd.lang.*;
import objd.math;

public final class SlopeLine extends Line {
    public final double slope;
    @Override
    public double slope() {
        return slope;
    }
    public final double constant;
    @Override
    public boolean containsPoint(final vec2 point) {
        return point.y.equals(this.slope * point.x + this.constant);
    }
    @Override
    public boolean isVertical() {
        return false;
    }
    @Override
    public boolean isHorizontal() {
        return this.slope == 0;
    }
    @Override
    public double xIntersectionWithLine(final Line line) {
        if(line.isVertical()) {
            return line.xIntersectionWithLine(this);
        } else {
            final SlopeLine that = ((SlopeLine)(line));
            return (that.constant - this.constant) / (this.slope - that.slope);
        }
    }
    public double yForX(final double x) {
        return this.slope * x + this.constant;
    }
    @Override
    public vec2 intersectionWithLine(final Line line) {
        if(!(line.isVertical()) && ((SlopeLine)(line)).slope.equals(this.slope)) {
            return null;
        } else {
            final double xInt = xIntersectionWithLine(line);
            return new vec2(((float)(xInt)), ((float)(yForX(xInt))));
        }
    }
    @Override
    public boolean isRightPoint(final vec2 point) {
        if(containsPoint(point)) {
            return false;
        } else {
            return point.y < yForX(((double)(point.x)));
        }
    }
    @Override
    public SlopeLine moveWithDistance(final double distance) {
        return new SlopeLine(this.slope, this.constant + distance);
    }
    @Override
    public double angle() {
        final double a = math.atan(this.slope);
        if(a < 0) {
            return math.M_PI + a;
        } else {
            return a;
        }
    }
    @Override
    public Line perpendicularWithPoint(final vec2 point) {
        if(this.slope == 0) {
            return ((Line)(new VerticalLine(((double)(point.x)))));
        } else {
            return Line.applySlopePoint(-(this.slope), point);
        }
    }
    public SlopeLine(final double slope, final double constant) {
        this.slope = slope;
        this.constant = constant;
    }
    public String toString() {
        return String.format("SlopeLine(%f, %f)", this.slope, this.constant);
    }
    public boolean equals(final Object to) {
        if(this == to) {
            return true;
        }
        if(to == null || !(to instanceof SlopeLine)) {
            return false;
        }
        final SlopeLine o = ((SlopeLine)(to));
        return this.slope.equals(o.slope) && this.constant.equals(o.constant);
    }
    public int hashCode() {
        int hash = 0;
        hash = hash * 31 + Float.hashCode(this.slope);
        hash = hash * 31 + Float.hashCode(this.constant);
        return hash;
    }
}