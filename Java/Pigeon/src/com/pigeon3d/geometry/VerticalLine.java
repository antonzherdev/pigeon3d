package com.pigeon3d.geometry;

import objd.lang.*;
import objd.math;

public final class VerticalLine extends Line {
    public final double x;
    @Override
    public boolean containsPoint(final vec2 point) {
        return point.x.equals(this.x);
    }
    @Override
    public boolean isVertical() {
        return true;
    }
    @Override
    public boolean isHorizontal() {
        return false;
    }
    @Override
    public double xIntersectionWithLine(final Line line) {
        return this.x;
    }
    @Override
    public vec2 intersectionWithLine(final Line line) {
        if(line.isVertical()) {
            return null;
        } else {
            return line.intersectionWithLine(this);
        }
    }
    @Override
    public boolean isRightPoint(final vec2 point) {
        return point.x > this.x;
    }
    @Override
    public double slope() {
        return Float.max;
    }
    @Override
    public VerticalLine moveWithDistance(final double distance) {
        return new VerticalLine(this.x + distance);
    }
    @Override
    public double angle() {
        return math.M_PI_2;
    }
    @Override
    public Line perpendicularWithPoint(final vec2 point) {
        return new SlopeLine(((double)(0)), ((double)(point.y)));
    }
    public VerticalLine(final double x) {
        this.x = x;
    }
    public String toString() {
        return String.format("VerticalLine(%f)", this.x);
    }
    public boolean equals(final Object to) {
        if(this == to) {
            return true;
        }
        if(to == null || !(to instanceof VerticalLine)) {
            return false;
        }
        final VerticalLine o = ((VerticalLine)(to));
        return this.x.equals(o.x);
    }
    public int hashCode() {
        int hash = 0;
        hash = hash * 31 + Float.hashCode(this.x);
        return hash;
    }
}