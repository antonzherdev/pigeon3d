package com.pigeon3d;

import objd.lang.*;
import java.nio.FloatBuffer;
import com.pigeon3d.geometry.vec3;
import com.pigeon3d.geometry.vec2;
import com.pigeon3d.geometry.vec4;
import objd.collection.Buffer;

public class BillboardBufferDataBuffer extends Buffer<BillboardBufferData> {
    public final FloatBuffer bytes;
    @Override
    public FloatBuffer bytes() {
        return bytes;
    }
    public BillboardBufferData get() {
        return new BillboardBufferData(new vec3(this.bytes.get(), this.bytes.get(), this.bytes.get()), new vec2(this.bytes.get(), this.bytes.get()), new vec4(this.bytes.get(), this.bytes.get(), this.bytes.get(), this.bytes.get()), new vec2(this.bytes.get(), this.bytes.get()));
    }
    public void setV(final BillboardBufferData v) {
        this.bytes.put(v.position.x);
        this.bytes.put(v.position.y);
        this.bytes.put(v.position.z);
        this.bytes.put(v.model.x);
        this.bytes.put(v.model.y);
        this.bytes.put(v.color.x);
        this.bytes.put(v.color.y);
        this.bytes.put(v.color.z);
        this.bytes.put(v.color.w);
        this.bytes.put(v.uv.x);
        this.bytes.put(v.uv.y);
    }
    public BillboardBufferDataBuffer(final int count) {
        super(((int)(count)), ((int)(44)));
        this.bytes = FloatBuffer.allocate(((int)(count)));
    }
    public String toString() {
        return "BillboardBufferDataBuffer";
    }
}