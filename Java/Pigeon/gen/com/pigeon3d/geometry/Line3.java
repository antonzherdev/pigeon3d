package com.pigeon3d.geometry;

import objd.lang.*;

public class Line3 {
    public final vec3 r0;
    public final vec3 u;
    public vec3 rT(final float t) {
        return vec3.addVec3(this.r0, vec3.mulK(this.u, t));
    }
    public vec3 rPlane(final Plane plane) {
        return vec3.addVec3(this.r0, vec3.mulK(this.u, vec3.dotVec3(plane.n, vec3.subVec3(plane.p0, this.r0)) / vec3.dotVec3(plane.n, this.u)));
    }
    public Line3(final vec3 r0, final vec3 u) {
        this.r0 = r0;
        this.u = u;
    }
    public String toString() {
        return String.format("Line3(%s, %s)", this.r0, this.u);
    }
    public boolean equals(final Line3 to) {
        return this.r0.equals(to.r0) && this.u.equals(to.u);
    }
    public int hashCode() {
        int hash = 0;
        hash = hash * 31 + vec3.hashCode(this.r0);
        hash = hash * 31 + vec3.hashCode(this.u);
        return hash;
    }
}