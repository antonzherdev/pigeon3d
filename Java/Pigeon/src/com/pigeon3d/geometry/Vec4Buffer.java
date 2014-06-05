package com.pigeon3d.geometry;

import objd.lang.*;
import java.nio.FloatBuffer;
import objd.collection.Buffer;

public class Vec4Buffer extends Buffer<vec4> {
    public final FloatBuffer bytes;
    @Override
    public FloatBuffer bytes() {
        return bytes;
    }
    public vec4 get() {
        return new vec4(this.bytes.get(), this.bytes.get(), this.bytes.get(), this.bytes.get());
    }
    public void setXYZW(final float x, final float y, final float z, final float w) {
        this.bytes.put(x);
        this.bytes.put(y);
        this.bytes.put(z);
        this.bytes.put(w);
    }
    public void setV(final vec4 v) {
        this.bytes.put(v.x);
        this.bytes.put(v.y);
        this.bytes.put(v.z);
        this.bytes.put(v.w);
    }
    public Vec4Buffer(final int count) {
        super(((int)(count)), ((int)(16)));
        this.bytes = FloatBuffer.allocate(((int)(count)));
    }
    public String toString() {
        return "Vec4Buffer";
    }
}