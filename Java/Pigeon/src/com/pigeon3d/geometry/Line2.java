package com.pigeon3d.geometry;

import objd.lang.*;

public class Line2 {
    public final vec2 p0;
    public final vec2 u;
    public static Line2 applyP0P1(final vec2 p0, final vec2 p1) {
        return new Line2(p0, vec2.subVec2(p1, p0));
    }
    public vec2 rT(final float t) {
        return vec2.addVec2(this.p0, vec2.mulF4(this.u, t));
    }
    public vec2 crossPointLine2(final Line2 line2) {
        final float dot = vec2.dotVec2(Line2.n(line2), this.u);
        if(dot == 0) {
            return null;
        } else {
            return vec2.addVec2(this.p0, vec2.mulF4(this.u, vec2.dotVec2(Line2.n(line2), vec2.subVec2(line2.p0, this.p0)) / dot));
        }
    }
    public float angle() {
        return vec2.angle(this.u);
    }
    public float degreeAngle() {
        return vec2.degreeAngle(this.u);
    }
    public Line2 setLength(final float length) {
        return new Line2(this.p0, vec2.setLength(this.u, length));
    }
    public Line2 normalize() {
        return new Line2(this.p0, vec2.normalize(this.u));
    }
    public vec2 mid() {
        return vec2.addVec2(this.p0, vec2.divI(this.u, 2));
    }
    public vec2 p1() {
        return vec2.addVec2(this.p0, this.u);
    }
    public Line2 addVec2(final vec2 vec2) {
        return new Line2(vec2.addVec2(this.p0, vec2), this.u);
    }
    public Line2 subVec2(final vec2 vec2) {
        return new Line2(vec2.subVec2(this.p0, vec2), this.u);
    }
    public vec2 n() {
        return vec2.normalize(new vec2(-(this.u.y), this.u.x));
    }
    public vec2 projectionVec2(final vec2 vec2) {
        final vec2 __tmpn = crossPointLine2(new Line2(vec2, Line2.n(this)));
        if(__tmpn == null) {
            throw new NullPointerException();
        }
        return __tmpn;
    }
    public vec2 projectionOnSegmentVec2(final vec2 vec2) {
        {
            final vec2 p = crossPointLine2(new Line2(vec2, Line2.n(this)));
            if(p != null) {
                if(Rect.containsVec2(Line2.boundingRect(this), ((vec2)(p)))) {
                    return ((vec2)(p));
                } else {
                    return null;
                }
            } else {
                return null;
            }
        }
    }
    public Rect boundingRect() {
        return Rect.applyXYSize(((this.u.x > 0) ? (this.p0.x) : (this.p0.x + this.u.x)), ((this.u.y > 0) ? (this.p0.y) : (this.p0.y + this.u.y)), vec2.abs(this.u));
    }
    public Line2 positive() {
        if(this.u.x < 0 || (this.u.x == 0 && this.u.y < 0)) {
            return new Line2(Line2.p1(this), vec2.negate(this.u));
        } else {
            return this;
        }
    }
    public Line2(final vec2 p0, final vec2 u) {
        this.p0 = p0;
        this.u = u;
    }
    public String toString() {
        return String.format("Line2(%s, %s)", this.p0, this.u);
    }
    public boolean equals(final Line2 to) {
        return this.p0.equals(to.p0) && this.u.equals(to.u);
    }
    public int hashCode() {
        int hash = 0;
        hash = hash * 31 + vec2.hashCode(this.p0);
        hash = hash * 31 + vec2.hashCode(this.u);
        return hash;
    }
}