package com.pigeon3d.geometry;

import objd.lang.*;
import objd.math;

public abstract class Line {
    public abstract boolean containsPoint(final vec2 point);
    public abstract boolean isVertical();
    public abstract boolean isHorizontal();
    public abstract vec2 intersectionWithLine(final Line line);
    public abstract double xIntersectionWithLine(final Line line);
    public abstract boolean isRightPoint(final vec2 point);
    public abstract double slope();
    public abstract Line moveWithDistance(final double distance);
    public abstract double angle();
    public abstract Line perpendicularWithPoint(final vec2 point);
    public static Line applySlopePoint(final double slope, final vec2 point) {
        return new SlopeLine(slope, Line.calculateConstantWithSlopePoint(slope, point));
    }
    public static Line applyP0P1(final vec2 p0, final vec2 p1) {
        if(p0.x.equals(p1.x)) {
            return ((Line)(new VerticalLine(((double)(p0.x)))));
        } else {
            final double slope = Line.calculateSlopeWithP0P1(p0, p1);
            return ((Line)(new SlopeLine(slope, Line.calculateConstantWithSlopePoint(slope, p0))));
        }
    }
    public static double calculateSlopeWithP0P1(final vec2 p0, final vec2 p1) {
        return ((double)((p1.y - p0.y) / (p1.x - p0.x)));
    }
    public static double calculateConstantWithSlopePoint(final double slope, final vec2 point) {
        return ((double)(point.y - slope * point.x));
    }
    public double degreeAngle() {
        return (this.angle() * 180) / math.M_PI;
    }
    public Line() {
    }
    public String toString() {
        return "Line";
    }
}