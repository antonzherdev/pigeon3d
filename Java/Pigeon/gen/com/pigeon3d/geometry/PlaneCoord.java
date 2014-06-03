package com.pigeon3d.geometry;

import objd.lang.*;

public class PlaneCoord {
    public final Plane plane;
    public final vec3 x;
    public final vec3 y;
    public static PlaneCoord applyPlaneX(final Plane plane, final vec3 x) {
        return new PlaneCoord(plane, x, vec3.crossVec3(x, plane.n));
    }
    public vec3 pVec2(final vec2 vec2) {
        return vec3.addVec3(vec3.addVec3(this.plane.p0, vec3.mulK(this.x, vec2.x)), vec3.mulK(this.y, vec2.y));
    }
    public PlaneCoord addVec3(final vec3 vec3) {
        return new PlaneCoord(Plane.addVec3(this.plane, vec3), this.x, this.y);
    }
    public PlaneCoord setX(final vec3 x) {
        return new PlaneCoord(this.plane, x, this.y);
    }
    public PlaneCoord setY(final vec3 y) {
        return new PlaneCoord(this.plane, this.x, y);
    }
    public PlaneCoord mulMat4(final mat4 mat4) {
        return new PlaneCoord(Plane.mulMat4(this.plane, mat4), mat4.mulVec3(this.x), mat4.mulVec3(this.y));
    }
    public PlaneCoord(final Plane plane, final vec3 x, final vec3 y) {
        this.plane = plane;
        this.x = x;
        this.y = y;
    }
    public String toString() {
        return String.format("PlaneCoord(%s, %s, %s)", this.plane, this.x, this.y);
    }
    public boolean equals(final PlaneCoord to) {
        return this.plane.equals(to.plane) && this.x.equals(to.x) && this.y.equals(to.y);
    }
    public int hashCode() {
        int hash = 0;
        hash = hash * 31 + Plane.hashCode(this.plane);
        hash = hash * 31 + vec3.hashCode(this.x);
        hash = hash * 31 + vec3.hashCode(this.y);
        return hash;
    }
}