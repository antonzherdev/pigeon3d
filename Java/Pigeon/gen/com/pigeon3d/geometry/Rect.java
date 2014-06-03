package com.pigeon3d.geometry;

import objd.lang.*;

public class Rect {
    public final vec2 p;
    public final vec2 size;
    public static Rect applyXYWidthHeight(final float x, final float y, final float width, final float height) {
        return new Rect(new vec2(x, y), new vec2(width, height));
    }
    public static Rect applyXYSize(final float x, final float y, final vec2 size) {
        return new Rect(new vec2(x, y), size);
    }
    public static Rect applyRectI(final RectI rectI) {
        return new Rect(vec2.applyVec2i(rectI.p), vec2.applyVec2i(rectI.size));
    }
    public float x() {
        return this.p.x;
    }
    public float y() {
        return this.p.y;
    }
    public float x2() {
        return this.p.x + this.size.x;
    }
    public float y2() {
        return this.p.y + this.size.y;
    }
    public float width() {
        return this.size.x;
    }
    public float height() {
        return this.size.y;
    }
    public boolean containsVec2(final vec2 vec2) {
        return this.p.x <= vec2.x && vec2.x <= this.p.x + this.size.x && this.p.y <= vec2.y && vec2.y <= this.p.y + this.size.y;
    }
    public Rect addVec2(final vec2 vec2) {
        return new Rect(vec2.addVec2(this.p, vec2), this.size);
    }
    public Rect subVec2(final vec2 vec2) {
        return new Rect(vec2.subVec2(this.p, vec2), this.size);
    }
    public Rect mulF(final double f) {
        return new Rect(vec2.mulF(this.p, f), vec2.mulF(this.size, f));
    }
    public Rect mulVec2(final vec2 vec2) {
        return new Rect(vec2.mulVec2(this.p, vec2), vec2.mulVec2(this.size, vec2));
    }
    public boolean intersectsRect(final Rect rect) {
        return this.p.x <= Rect.x2(rect) && Rect.x2(this) >= rect.p.x && this.p.y <= Rect.y2(rect) && Rect.y2(this) >= rect.p.y;
    }
    public Rect thickenHalfSize(final vec2 halfSize) {
        return new Rect(vec2.subVec2(this.p, halfSize), vec2.addVec2(this.size, vec2.mulI(halfSize, 2)));
    }
    public Rect divVec2(final vec2 vec2) {
        return new Rect(vec2.divVec2(this.p, vec2), vec2.divVec2(this.size, vec2));
    }
    public Rect divF(final double f) {
        return new Rect(vec2.divF(this.p, f), vec2.divF(this.size, f));
    }
    public Rect divF4(final float f4) {
        return new Rect(vec2.divF4(this.p, f4), vec2.divF4(this.size, f4));
    }
    public vec2 ph() {
        return new vec2(this.p.x, this.p.y + this.size.y);
    }
    public vec2 pw() {
        return new vec2(this.p.x + this.size.x, this.p.y);
    }
    public vec2 phw() {
        return new vec2(this.p.x + this.size.x, this.p.y + this.size.y);
    }
    public Rect moveToCenterForSize(final vec2 size) {
        return new Rect(vec2.mulF(vec2.subVec2(size, this.size), 0.5), this.size);
    }
    public Quad quad() {
        return new Quad(this.p, Rect.ph(this), Rect.phw(this), Rect.pw(this));
    }
    public Quad stripQuad() {
        return new Quad(this.p, Rect.ph(this), Rect.pw(this), Rect.phw(this));
    }
    public Quad upsideDownStripQuad() {
        return new Quad(Rect.ph(this), this.p, Rect.phw(this), Rect.pw(this));
    }
    public Rect centerX() {
        return new Rect(new vec2(this.p.x - this.size.x / 2, this.p.y), this.size);
    }
    public Rect centerY() {
        return new Rect(new vec2(this.p.x, this.p.y - this.size.y / 2), this.size);
    }
    public vec2 center() {
        return vec2.addVec2(this.p, vec2.divI(this.size, 2));
    }
    public vec2 closestPointForVec2(final vec2 vec2) {
        return vec2.maxVec2(vec2.minVec2(vec2, Rect.phw(this)), this.p);
    }
    public vec2 pXY(final float x, final float y) {
        return new vec2(this.p.x + this.size.x * x, this.p.y + this.size.y * y);
    }
    public Rect(final vec2 p, final vec2 size) {
        this.p = p;
        this.size = size;
    }
    public String toString() {
        return String.format("Rect(%s, %s)", this.p, this.size);
    }
    public boolean equals(final Rect to) {
        return this.p.equals(to.p) && this.size.equals(to.size);
    }
    public int hashCode() {
        int hash = 0;
        hash = hash * 31 + vec2.hashCode(this.p);
        hash = hash * 31 + vec2.hashCode(this.size);
        return hash;
    }
}