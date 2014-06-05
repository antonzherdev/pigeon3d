package com.pigeon3d.geometry;

import objd.lang.*;
import java.nio.FloatBuffer;
import objd.collection.Buffer;

public class Vec3Buffer extends Buffer<vec3> {
    public final FloatBuffer bytes;
    @Override
    public FloatBuffer bytes() {
        return bytes;
    }
    public vec3 get() {
        return new vec3(this.bytes.get(), this.bytes.get(), this.bytes.get());
    }
    public void setXYZ(final float x, final float y, final float z) {
        this.bytes.put(x);
        this.bytes.put(y);
        this.bytes.put(z);
    }
    public void setV(final vec3 v) {
        this.bytes.put(v.x);
        this.bytes.put(v.y);
        this.bytes.put(v.z);
    }
    public Vec3Buffer(final int count) {
        super(((int)(count)), ((int)(12)));
        this.bytes = FloatBuffer.allocate(((int)(count)));
    }
    public String toString() {
        return "Vec3Buffer";
    }
}