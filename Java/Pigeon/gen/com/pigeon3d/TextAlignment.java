package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.geometry.vec2;

public class TextAlignment {
    public static final TextAlignment left;
    public static final TextAlignment right;
    public static final TextAlignment center;
    public final float x;
    public final float y;
    public final boolean baseline;
    public final vec2 shift;
    public static TextAlignment applyXY(final float x, final float y) {
        return new TextAlignment(x, y, false, new vec2(((float)(0)), ((float)(0))));
    }
    public static TextAlignment applyXYShift(final float x, final float y, final vec2 shift) {
        return new TextAlignment(x, y, false, shift);
    }
    public static TextAlignment baselineX(final float x) {
        return new TextAlignment(x, ((float)(0)), true, new vec2(((float)(0)), ((float)(0))));
    }
    public TextAlignment(final float x, final float y, final boolean baseline, final vec2 shift) {
        this.x = x;
        this.y = y;
        this.baseline = baseline;
        this.shift = shift;
    }
    public String toString() {
        return String.format("TextAlignment(%f, %f, %d, %s)", this.x, this.y, this.baseline, this.shift);
    }
    public boolean equals(final TextAlignment to) {
        return this.x.equals(to.x) && this.y.equals(to.y) && this.baseline.equals(to.baseline) && this.shift.equals(to.shift);
    }
    public int hashCode() {
        int hash = 0;
        hash = hash * 31 + Float4.hashCode(this.x);
        hash = hash * 31 + Float4.hashCode(this.y);
        hash = hash * 31 + this.baseline;
        hash = hash * 31 + vec2.hashCode(this.shift);
        return hash;
    }
    static {
        left = new TextAlignment(((float)(-1)), ((float)(0)), true, new vec2(((float)(0)), ((float)(0))));
        right = new TextAlignment(((float)(1)), ((float)(0)), true, new vec2(((float)(0)), ((float)(0))));
        center = new TextAlignment(((float)(0)), ((float)(0)), true, new vec2(((float)(0)), ((float)(0))));
    }
}