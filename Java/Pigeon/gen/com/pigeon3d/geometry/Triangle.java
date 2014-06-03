package com.pigeon3d.geometry;

import objd.lang.*;

public class Triangle {
    public final vec2 p0;
    public final vec2 p1;
    public final vec2 p2;
    public boolean containsVec2(final vec2 vec2) {
        final vec2 r0 = vec2.subVec2(this.p0, vec2);
        final vec2 r1 = vec2.subVec2(this.p1, vec2);
        final vec2 r2 = vec2.subVec2(this.p2, vec2);
        final float c0 = vec2.crossVec2(r0, r1);
        final float c1 = vec2.crossVec2(r1, r2);
        final float c2 = vec2.crossVec2(r2, r0);
        return (c0 > 0 && c1 > 0 && c2 > 0) || (c0 < 0 && c1 < 0 && c2 < 0);
    }
    public Triangle(final vec2 p0, final vec2 p1, final vec2 p2) {
        this.p0 = p0;
        this.p1 = p1;
        this.p2 = p2;
    }
    public String toString() {
        return String.format("Triangle(%s, %s, %s)", this.p0, this.p1, this.p2);
    }
    public boolean equals(final Triangle to) {
        return this.p0.equals(to.p0) && this.p1.equals(to.p1) && this.p2.equals(to.p2);
    }
    public int hashCode() {
        int hash = 0;
        hash = hash * 31 + vec2.hashCode(this.p0);
        hash = hash * 31 + vec2.hashCode(this.p1);
        hash = hash * 31 + vec2.hashCode(this.p2);
        return hash;
    }
}