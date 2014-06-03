package com.pigeon3d.geometry;

import objd.lang.*;
import objd.math;

public class vec2 {
    public final float x;
    public final float y;
    public static vec2 applyVec2i(final vec2i vec2i) {
        return new vec2(((float)(vec2i.x)), ((float)(vec2i.y)));
    }
    public static vec2 applyF(final double f) {
        return new vec2(((float)(f)), ((float)(f)));
    }
    public static vec2 applyF4(final float f4) {
        return new vec2(f4, f4);
    }
    public static vec2 min() {
        return new vec2(Float4.min, Float4.min);
    }
    public static vec2 max() {
        return new vec2(Float4.max, Float4.max);
    }
    public vec2 addVec2(final vec2 vec2) {
        return new vec2(this.x + vec2.x, this.y + vec2.y);
    }
    public vec2 addF4(final float f4) {
        return new vec2(this.x + f4, this.y + f4);
    }
    public vec2 addF(final double f) {
        return new vec2(this.x + f, this.y + f);
    }
    public vec2 addI(final int i) {
        return new vec2(this.x + i, this.y + i);
    }
    public vec2 subVec2(final vec2 vec2) {
        return new vec2(this.x - vec2.x, this.y - vec2.y);
    }
    public vec2 subF4(final float f4) {
        return new vec2(this.x - f4, this.y - f4);
    }
    public vec2 subF(final double f) {
        return new vec2(this.x - f, this.y - f);
    }
    public vec2 subI(final int i) {
        return new vec2(this.x - i, this.y - i);
    }
    public vec2 mulVec2(final vec2 vec2) {
        return new vec2(this.x * vec2.x, this.y * vec2.y);
    }
    public vec2 mulF4(final float f4) {
        return new vec2(this.x * f4, this.y * f4);
    }
    public vec2 mulF(final double f) {
        return new vec2(this.x * f, this.y * f);
    }
    public vec2 mulI(final int i) {
        return new vec2(this.x * i, this.y * i);
    }
    public vec2 divVec2(final vec2 vec2) {
        return new vec2(this.x / vec2.x, this.y / vec2.y);
    }
    public vec2 divF4(final float f4) {
        return new vec2(this.x / f4, this.y / f4);
    }
    public vec2 divF(final double f) {
        return new vec2(this.x / f, this.y / f);
    }
    public vec2 divI(final int i) {
        return new vec2(this.x / i, this.y / i);
    }
    public vec2 negate() {
        return new vec2(-(this.x), -(this.y));
    }
    public float degreeAngle() {
        return ((float)(180.0 / math.M_PI * math.atan2(((double)(this.y)), ((double)(this.x)))));
    }
    public float angle() {
        return ((float)(math.atan2(((double)(this.y)), ((double)(this.x)))));
    }
    public float dotVec2(final vec2 vec2) {
        return this.x * vec2.x + this.y * vec2.y;
    }
    public float crossVec2(final vec2 vec2) {
        return this.x * vec2.y - vec2.x * this.y;
    }
    public float lengthSquare() {
        return dotVec2(this);
    }
    public float length() {
        return ((float)(math.sqrt(((double)(vec2.lengthSquare(this))))));
    }
    public vec2 midVec2(final vec2 vec2) {
        return vec2.mulF(addVec2(vec2), 0.5);
    }
    public float distanceToVec2(final vec2 vec2) {
        return vec2.length(subVec2(vec2));
    }
    public vec2 setLength(final float length) {
        return mulF4(length / vec2.length(this));
    }
    public vec2 normalize() {
        return setLength(((float)(1.0)));
    }
    public int compareTo(final vec2 to) {
        final int dX = Float4.compareTo(this.x, to.x);
        if(dX != 0) {
            return dX;
        } else {
            return Float4.compareTo(this.y, to.y);
        }
    }
    public Rect rectToVec2(final vec2 vec2) {
        return new Rect(this, vec2.subVec2(vec2, this));
    }
    public Rect rectInCenterWithSize(final vec2 size) {
        return new Rect(vec2.mulF(vec2.subVec2(size, this), 0.5), this);
    }
    public static vec2 rnd() {
        return new vec2(Float4.rnd() - 0.5, Float4.rnd() - 0.5);
    }
    public boolean isEmpty() {
        return this.x == 0 && this.y == 0;
    }
    public vec2i round() {
        return new vec2i(Float4.round(this.x), Float4.round(this.y));
    }
    public vec2 minVec2(final vec2 vec2) {
        return new vec2(Float4.minB(this.x, vec2.x), Float4.minB(this.y, vec2.y));
    }
    public vec2 maxVec2(final vec2 vec2) {
        return new vec2(Float4.maxB(this.x, vec2.x), Float4.maxB(this.y, vec2.y));
    }
    public vec2 abs() {
        return new vec2(Float4.abs(this.x), Float4.abs(this.y));
    }
    public float ratio() {
        return this.x / this.y;
    }
    public vec2(final float x, final float y) {
        this.x = x;
        this.y = y;
    }
    public String toString() {
        return String.format("vec2(%f, %f)", this.x, this.y);
    }
    public boolean equals(final vec2 to) {
        return this.x.equals(to.x) && this.y.equals(to.y);
    }
    public int hashCode() {
        int hash = 0;
        hash = hash * 31 + Float4.hashCode(this.x);
        hash = hash * 31 + Float4.hashCode(this.y);
        return hash;
    }
}