package com.pigeon3d.geometry;

import objd.lang.*;
import objd.math;

public class vec3 {
    public final float x;
    public final float y;
    public final float z;
    public static vec3 applyVec2(final vec2 vec2) {
        return new vec3(vec2.x, vec2.y, ((float)(0)));
    }
    public static vec3 applyVec2Z(final vec2 vec2, final float z) {
        return new vec3(vec2.x, vec2.y, z);
    }
    public static vec3 applyVec2iZ(final vec2i vec2i, final float z) {
        return new vec3(((float)(vec2i.x)), ((float)(vec2i.y)), z);
    }
    public static vec3 applyF4(final float f4) {
        return new vec3(f4, f4, f4);
    }
    public static vec3 applyF(final double f) {
        return new vec3(((float)(f)), ((float)(f)), ((float)(f)));
    }
    public vec3 addVec3(final vec3 vec3) {
        return new vec3(this.x + vec3.x, this.y + vec3.y, this.z + vec3.z);
    }
    public vec3 subVec3(final vec3 vec3) {
        return new vec3(this.x - vec3.x, this.y - vec3.y, this.z - vec3.z);
    }
    public vec3 sqr() {
        return mulK(((float)(vec3.length(this))));
    }
    public vec3 negate() {
        return new vec3(-(this.x), -(this.y), -(this.z));
    }
    public vec3 mulK(final float k) {
        return new vec3(k * this.x, k * this.y, k * this.z);
    }
    public float dotVec3(final vec3 vec3) {
        return this.x * vec3.x + this.y * vec3.y + this.z * vec3.z;
    }
    public vec3 crossVec3(final vec3 vec3) {
        return new vec3(this.y * vec3.z - this.z * vec3.y, this.x * vec3.z - vec3.x * this.z, this.x * vec3.y - vec3.x * this.y);
    }
    public float lengthSquare() {
        return this.x * this.x + this.y * this.y + this.z * this.z;
    }
    public double length() {
        return math.sqrt(((double)(vec3.lengthSquare(this))));
    }
    public vec3 setLength(final float length) {
        return mulK(length / vec3.length(this));
    }
    public vec3 normalize() {
        return setLength(((float)(1.0)));
    }
    public vec2 xy() {
        return new vec2(this.x, this.y);
    }
    public static vec3 rnd() {
        return new vec3(Float4.rnd() - 0.5, Float4.rnd() - 0.5, Float4.rnd() - 0.5);
    }
    public boolean isEmpty() {
        return this.x == 0 && this.y == 0 && this.z == 0;
    }
    public vec3(final float x, final float y, final float z) {
        this.x = x;
        this.y = y;
        this.z = z;
    }
    public String toString() {
        return String.format("vec3(%f, %f, %f)", this.x, this.y, this.z);
    }
    public boolean equals(final vec3 to) {
        return this.x.equals(to.x) && this.y.equals(to.y) && this.z.equals(to.z);
    }
    public int hashCode() {
        int hash = 0;
        hash = hash * 31 + Float4.hashCode(this.x);
        hash = hash * 31 + Float4.hashCode(this.y);
        hash = hash * 31 + Float4.hashCode(this.z);
        return hash;
    }
}