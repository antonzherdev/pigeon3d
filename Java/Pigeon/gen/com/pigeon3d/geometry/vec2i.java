package com.pigeon3d.geometry;

import objd.lang.*;
import objd.math;

public class vec2i {
    public final int x;
    public final int y;
    public static vec2i applyVec2(final vec2 vec2) {
        return new vec2i(Float4.round(vec2.x), Float4.round(vec2.y));
    }
    public vec2 addVec2(final vec2 vec2) {
        return new vec2(this.x + vec2.x, this.y + vec2.y);
    }
    public vec2i addVec2i(final vec2i vec2i) {
        return new vec2i(this.x + vec2i.x, this.y + vec2i.y);
    }
    public vec2 subVec2(final vec2 vec2) {
        return new vec2(this.x - vec2.x, this.y - vec2.y);
    }
    public vec2i subVec2i(final vec2i vec2i) {
        return new vec2i(this.x - vec2i.x, this.y - vec2i.y);
    }
    public vec2i mulI(final int i) {
        return new vec2i(this.x * i, this.y * i);
    }
    public vec2 mulF(final double f) {
        return new vec2(((float)(this.x)) * f, ((float)(this.y)) * f);
    }
    public vec2 mulF4(final float f4) {
        return new vec2(((float)(this.x)) * f4, ((float)(this.y)) * f4);
    }
    public vec2 divF4(final float f4) {
        return new vec2(((float)(this.x)) / f4, ((float)(this.y)) / f4);
    }
    public vec2 divF(final double f) {
        return new vec2(((float)(this.x)) / f, ((float)(this.y)) / f);
    }
    public vec2i divI(final int i) {
        return new vec2i(this.x / i, this.y / i);
    }
    public vec2i negate() {
        return new vec2i(-(this.x), -(this.y));
    }
    public int compareTo(final vec2i to) {
        final int dX = Int.compareTo(this.x, to.x);
        if(dX != 0) {
            return dX;
        } else {
            return Int.compareTo(this.y, to.y);
        }
    }
    public RectI rectToVec2i(final vec2i vec2i) {
        return new RectI(this, vec2i.subVec2i(vec2i, this));
    }
    public int dotVec2i(final vec2i vec2i) {
        return this.x * vec2i.x + this.y * vec2i.y;
    }
    public int lengthSquare() {
        return dotVec2i(this);
    }
    public float length() {
        return ((float)(math.sqrt(((double)(vec2i.lengthSquare(this))))));
    }
    public float ratio() {
        return ((float)(this.x)) / ((float)(this.y));
    }
    public vec2i(final int x, final int y) {
        this.x = x;
        this.y = y;
    }
    public String toString() {
        return String.format("vec2i(%d, %d)", this.x, this.y);
    }
    public boolean equals(final vec2i to) {
        return this.x == to.x && this.y == to.y;
    }
    public int hashCode() {
        int hash = 0;
        hash = hash * 31 + this.x;
        hash = hash * 31 + this.y;
        return hash;
    }
}