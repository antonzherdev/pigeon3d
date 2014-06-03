package com.pigeon3d.geometry;

import objd.lang.*;
import objd.collection.ImArray;
import objd.math;

public final class LineSegment extends Figure_impl {
    public final vec2 p0;
    public final vec2 p1;
    private final boolean dir;
    private Line _line;
    public final Rect boundingRect;
    @Override
    public Rect boundingRect() {
        return boundingRect;
    }
    public static LineSegment newWithP0P1(final vec2 p0, final vec2 p1) {
        if(vec2.compareTo(p0, p1) < 0) {
            return new LineSegment(p0, p1);
        } else {
            return new LineSegment(p1, p0);
        }
    }
    public static LineSegment newWithX1Y1X2Y2(final double x1, final double y1, final double x2, final double y2) {
        return LineSegment.newWithP0P1(new vec2(((float)(x1)), ((float)(y1))), new vec2(((float)(x2)), ((float)(y2))));
    }
    public boolean isVertical() {
        return this.p0.x.equals(this.p1.x);
    }
    public boolean isHorizontal() {
        return this.p0.y.equals(this.p1.y);
    }
    public Line line() {
        if(this._line == null) {
            this._line = Line.applyP0P1(this.p0, this.p1);
            if(this._line == null) {
                throw new NullPointerException();
            }
            return ((Line)(this._line));
        } else {
            return ((Line)(this._line));
        }
    }
    public boolean containsPoint(final vec2 point) {
        return this.p0.equals(point) || this.p1.equals(point) || (this.line().containsPoint(point) && Rect.containsVec2(this.boundingRect, point));
    }
    public boolean containsInBoundingRectPoint(final vec2 point) {
        return Rect.containsVec2(this.boundingRect, point);
    }
    public vec2 intersectionWithSegment(final LineSegment segment) {
        if(this.p0.equals(segment.p1)) {
            return this.p0;
        } else {
            if(this.p1.equals(segment.p0)) {
                return this.p0;
            } else {
                if(this.p0.equals(segment.p0)) {
                    if(this.line().equals(segment.line())) {
                        return null;
                    } else {
                        return this.p0;
                    }
                } else {
                    if(this.p1.equals(segment.p1)) {
                        if(this.line().equals(segment.line())) {
                            return null;
                        } else {
                            return this.p1;
                        }
                    } else {
                        final vec2 p = this.line().intersectionWithLine(segment.line());
                        if(p != null) {
                            if(containsInBoundingRectPoint(((vec2)(p))) && segment.containsInBoundingRectPoint(((vec2)(p)))) {
                                return ((vec2)(p));
                            } else {
                                return null;
                            }
                        } else {
                            return null;
                        }
                    }
                }
            }
        }
    }
    public boolean endingsContainPoint(final vec2 point) {
        return this.p0.equals(point) || this.p1.equals(point);
    }
    @Override
    public ImArray<LineSegment> segments() {
        return ImArray.fromObjects(this);
    }
    public LineSegment moveWithPoint(final vec2 point) {
        return moveWithXY(((double)(point.x)), ((double)(point.y)));
    }
    public LineSegment moveWithXY(final double x, final double y) {
        final LineSegment ret = new LineSegment(new vec2(this.p0.x + x, this.p0.y + y), new vec2(this.p1.x + x, this.p1.y + y));
        ret.setLine(this.line().moveWithDistance(x + y));
        return ret;
    }
    private void setLine(final Line line) {
        this._line = line;
    }
    public vec2 mid() {
        return vec2.midVec2(this.p0, this.p1);
    }
    public double angle() {
        if(this.dir) {
            return this.line().angle();
        } else {
            return math.M_PI + this.line().angle();
        }
    }
    public double degreeAngle() {
        if(this.dir) {
            return this.line().degreeAngle();
        } else {
            return 180 + this.line().degreeAngle();
        }
    }
    public float length() {
        return vec2.length(vec2.subVec2(this.p1, this.p0));
    }
    public vec2 vec() {
        return vec2.subVec2(this.p1, this.p0);
    }
    public vec2 vec1() {
        return vec2.subVec2(this.p0, this.p1);
    }
    public LineSegment(final vec2 p0, final vec2 p1) {
        this.p0 = p0;
        this.p1 = p1;
        this.dir = p0.y < p1.y || (p0.y.equals(p1.y) && p0.x < p1.x);
        this.boundingRect = vec2.rectToVec2(new vec2(Float4.minB(p0.x, p1.x), Float4.minB(p0.y, p1.y)), new vec2(Float4.maxB(p0.x, p1.x), Float4.maxB(p0.y, p1.y)));
    }
    public String toString() {
        return String.format("LineSegment(%s, %s)", this.p0, this.p1);
    }
    public boolean equals(final Object to) {
        if(this == to) {
            return true;
        }
        if(to == null || !(to instanceof LineSegment)) {
            return false;
        }
        final LineSegment o = ((LineSegment)(to));
        return this.p0.equals(o.p0) && this.p1.equals(o.p1);
    }
    public int hashCode() {
        int hash = 0;
        hash = hash * 31 + vec2.hashCode(this.p0);
        hash = hash * 31 + vec2.hashCode(this.p1);
        return hash;
    }
}