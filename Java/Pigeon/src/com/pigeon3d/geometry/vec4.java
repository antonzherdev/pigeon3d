package com.pigeon3d.geometry;

import objd.lang.*;
import objd.math;

public class vec4 {
    public final float x;
    public final float y;
    public final float z;
    public final float w;
    public static vec4 applyF(final double f) {
        return new vec4(((float)(f)), ((float)(f)), ((float)(f)), ((float)(f)));
    }
    public static vec4 applyF4(final float f4) {
        return new vec4(f4, f4, f4, f4);
    }
    public static vec4 applyVec3W(final vec3 vec3, final float w) {
        return new vec4(vec3.x, vec3.y, vec3.z, w);
    }
    public static vec4 applyVec2ZW(final vec2 vec2, final float z, final float w) {
        return new vec4(vec2.x, vec2.y, z, w);
    }
    public vec4 addVec2(final vec2 vec2) {
        return new vec4(this.x + vec2.x, this.y + vec2.y, this.z, this.w);
    }
    public vec4 addVec3(final vec3 vec3) {
        return new vec4(this.x + vec3.x, this.y + vec3.y, this.z + vec3.z, this.w);
    }
    public vec4 addVec4(final vec4 vec4) {
        return new vec4(this.x + vec4.x, this.y + vec4.y, this.z + vec4.z, this.w + vec4.w);
    }
    public vec3 xyz() {
        return new vec3(this.x, this.y, this.z);
    }
    public vec2 xy() {
        return new vec2(this.x, this.y);
    }
    public vec4 mulK(final float k) {
        return new vec4(k * this.x, k * this.y, k * this.z, k * this.w);
    }
    public vec4 divMat4(final mat4 mat4) {
        return mat4.divBySelfVec4(this);
    }
    public vec4 divF4(final float f4) {
        return new vec4(this.x / f4, this.y / f4, this.z / f4, this.w / f4);
    }
    public vec4 divF(final double f) {
        return new vec4(this.x / f, this.y / f, this.z / f, this.w / f);
    }
    public vec4 divI(final int i) {
        return new vec4(this.x / i, this.y / i, this.z / i, this.w / i);
    }
    public float lengthSquare() {
        return this.x * this.x + this.y * this.y + this.z * this.z + this.w * this.w;
    }
    public double length() {
        return math.sqrt(((double)(vec4.lengthSquare(this))));
    }
    public vec4 setLength(final float length) {
        return mulK(length / vec4.length(this));
    }
    public vec4 normalize() {
        return setLength(((float)(1.0)));
    }
    public vec4(final float x, final float y, final float z, final float w) {
        this.x = x;
        this.y = y;
        this.z = z;
        this.w = w;
    }
    public String toString() {
        return String.format("vec4(%f, %f, %f, %f)", this.x, this.y, this.z, this.w);
    }
    public boolean equals(final vec4 to) {
        return this.x.equals(to.x) && this.y.equals(to.y) && this.z.equals(to.z) && this.w.equals(to.w);
    }
    public int hashCode() {
        int hash = 0;
        hash = hash * 31 + Float4.hashCode(this.x);
        hash = hash * 31 + Float4.hashCode(this.y);
        hash = hash * 31 + Float4.hashCode(this.z);
        hash = hash * 31 + Float4.hashCode(this.w);
        return hash;
    }
}