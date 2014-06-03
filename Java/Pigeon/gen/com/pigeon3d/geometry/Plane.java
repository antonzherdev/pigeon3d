package com.pigeon3d.geometry;

import objd.lang.*;

public class Plane {
    public final vec3 p0;
    public final vec3 n;
    public boolean containsVec3(final vec3 vec3) {
        return vec3.dotVec3(this.n, vec3.subVec3(vec3, this.p0)) == 0;
    }
    public Plane addVec3(final vec3 vec3) {
        return new Plane(vec3.addVec3(this.p0, vec3), this.n);
    }
    public Plane mulMat4(final mat4 mat4) {
        return new Plane(mat4.mulVec3(this.p0), vec4.xyz(mat4.mulVec3W(this.n, ((float)(0)))));
    }
    public Plane(final vec3 p0, final vec3 n) {
        this.p0 = p0;
        this.n = n;
    }
    public String toString() {
        return String.format("Plane(%s, %s)", this.p0, this.n);
    }
    public boolean equals(final Plane to) {
        return this.p0.equals(to.p0) && this.n.equals(to.n);
    }
    public int hashCode() {
        int hash = 0;
        hash = hash * 31 + vec3.hashCode(this.p0);
        hash = hash * 31 + vec3.hashCode(this.n);
        return hash;
    }
}