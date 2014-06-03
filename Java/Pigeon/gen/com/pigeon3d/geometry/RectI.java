package com.pigeon3d.geometry;

import objd.lang.*;

public class RectI {
    public final vec2i p;
    public final vec2i size;
    public static RectI applyXYWidthHeight(final float x, final float y, final float width, final float height) {
        return new RectI(vec2i.applyVec2(new vec2(x, y)), vec2i.applyVec2(new vec2(width, height)));
    }
    public static RectI applyRect(final Rect rect) {
        return new RectI(vec2i.applyVec2(rect.p), vec2i.applyVec2(rect.size));
    }
    public int x() {
        return this.p.x;
    }
    public int y() {
        return this.p.y;
    }
    public int x2() {
        return this.p.x + this.size.x;
    }
    public int y2() {
        return this.p.y + this.size.y;
    }
    public int width() {
        return this.size.x;
    }
    public int height() {
        return this.size.y;
    }
    public RectI moveToCenterForSize(final vec2 size) {
        return new RectI(vec2i.applyVec2(vec2.mulF(vec2.subVec2(size, vec2.applyVec2i(this.size)), 0.5)), this.size);
    }
    public RectI(final vec2i p, final vec2i size) {
        this.p = p;
        this.size = size;
    }
    public String toString() {
        return String.format("RectI(%s, %s)", this.p, this.size);
    }
    public boolean equals(final RectI to) {
        return this.p.equals(to.p) && this.size.equals(to.size);
    }
    public int hashCode() {
        int hash = 0;
        hash = hash * 31 + vec2i.hashCode(this.p);
        hash = hash * 31 + vec2i.hashCode(this.size);
        return hash;
    }
}