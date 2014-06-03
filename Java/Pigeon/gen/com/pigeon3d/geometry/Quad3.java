package com.pigeon3d.geometry;

import objd.lang.*;
import objd.collection.ImArray;

public class Quad3 {
    public final PlaneCoord planeCoord;
    public final Quad quad;
    public vec3 p0() {
        return PlaneCoord.pVec2(this.planeCoord, this.quad.p0);
    }
    public vec3 p1() {
        return PlaneCoord.pVec2(this.planeCoord, this.quad.p1);
    }
    public vec3 p2() {
        return PlaneCoord.pVec2(this.planeCoord, this.quad.p2);
    }
    public vec3 p3() {
        return PlaneCoord.pVec2(this.planeCoord, this.quad.p3);
    }
    public ImArray<vec3> ps() {
        return ImArray.fromObjects(Quad3.p0(this), Quad3.p1(this), Quad3.p2(this), Quad3.p3(this));
    }
    public Quad3 mulMat4(final mat4 mat4) {
        return new Quad3(PlaneCoord.mulMat4(this.planeCoord, mat4), this.quad);
    }
    public Quad3(final PlaneCoord planeCoord, final Quad quad) {
        this.planeCoord = planeCoord;
        this.quad = quad;
    }
    public String toString() {
        return String.format("Quad3(%s, %s)", this.planeCoord, this.quad);
    }
    public boolean equals(final Quad3 to) {
        return this.planeCoord.equals(to.planeCoord) && this.quad.equals(to.quad);
    }
    public int hashCode() {
        int hash = 0;
        hash = hash * 31 + PlaneCoord.hashCode(this.planeCoord);
        hash = hash * 31 + Quad.hashCode(this.quad);
        return hash;
    }
}