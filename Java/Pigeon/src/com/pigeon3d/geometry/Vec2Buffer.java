package com.pigeon3d.geometry;

import objd.lang.*;
import java.nio.FloatBuffer;
import objd.collection.Buffer;

public class Vec2Buffer extends Buffer<vec2> {
    public final FloatBuffer bytes;
    @Override
    public FloatBuffer bytes() {
        return bytes;
    }
    public vec2 get() {
        return new vec2(this.bytes.get(), this.bytes.get());
    }
    public void setXY(final float x, final float y) {
        this.bytes.put(x);
        this.bytes.put(y);
    }
    public void setV(final vec2 v) {
        this.bytes.put(v.x);
        this.bytes.put(v.y);
    }
    public Vec2Buffer(final int count) {
        super(((int)(count)), ((int)(8)));
        this.bytes = FloatBuffer.allocate(((int)(count)));
    }
    public String toString() {
        return "Vec2Buffer";
    }
}