package com.pigeon3d;

import objd.lang.*;
import java.nio.FloatBuffer;
import com.pigeon3d.geometry.vec2;
import objd.collection.Buffer;

public class FontPrintDataBuffer extends Buffer<FontPrintData> {
    public final FloatBuffer bytes;
    @Override
    public FloatBuffer bytes() {
        return bytes;
    }
    public FontPrintData get() {
        return new FontPrintData(new vec2(this.bytes.get(), this.bytes.get()), new vec2(this.bytes.get(), this.bytes.get()));
    }
    public void setV(final FontPrintData v) {
        this.bytes.put(v.position.x);
        this.bytes.put(v.position.y);
        this.bytes.put(v.uv.x);
        this.bytes.put(v.uv.y);
    }
    public FontPrintDataBuffer(final int count) {
        super(((int)(count)), ((int)(44)));
        this.bytes = FloatBuffer.allocate(((int)(count)));
    }
    public String toString() {
        return "FontPrintDataBuffer";
    }
}