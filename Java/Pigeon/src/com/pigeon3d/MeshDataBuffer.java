package com.pigeon3d;

import objd.lang.*;
import java.nio.FloatBuffer;
import com.pigeon3d.geometry.vec2;
import com.pigeon3d.geometry.vec3;
import objd.collection.Buffer;

public class MeshDataBuffer extends Buffer<MeshData> {
    public final FloatBuffer bytes;
    @Override
    public FloatBuffer bytes() {
        return bytes;
    }
    public MeshData get() {
        return new MeshData(new vec2(this.bytes.get(), this.bytes.get()), new vec3(this.bytes.get(), this.bytes.get(), this.bytes.get()), new vec3(this.bytes.get(), this.bytes.get(), this.bytes.get()));
    }
    public void setV(final MeshData v) {
        this.bytes.put(v.uv.x);
        this.bytes.put(v.uv.y);
        this.bytes.put(v.normal.x);
        this.bytes.put(v.normal.y);
        this.bytes.put(v.normal.z);
        this.bytes.put(v.position.x);
        this.bytes.put(v.position.y);
        this.bytes.put(v.position.z);
    }
    public void forF(final P<MeshData> f) {
        int i = 0;
        this.bytes.clear();
        while(i < this.count) {
            f.apply(new MeshData(new vec2(this.bytes.get(), this.bytes.get()), new vec3(this.bytes.get(), this.bytes.get(), this.bytes.get()), new vec3(this.bytes.get(), this.bytes.get(), this.bytes.get())));
            i++;
        }
    }
    public MeshDataBuffer(final int count) {
        super(((int)(count)), ((int)(32)));
        this.bytes = FloatBuffer.allocate(((int)(count)));
    }
    public String toString() {
        return "MeshDataBuffer";
    }
}