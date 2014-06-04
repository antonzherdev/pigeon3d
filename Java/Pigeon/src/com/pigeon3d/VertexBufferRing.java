package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.gl.eg;

public class VertexBufferRing<T> extends BufferRing<T, MutableVertexBuffer<T>> {
    public final VertexBufferDesc<T> desc;
    public final int usage;
    public VertexBufferRing(final int ringSize, final VertexBufferDesc<T> desc, final int usage) {
        super(ringSize, new F0<MutableVertexBuffer<T>>() {
            @Override
            public MutableVertexBuffer<T> apply() {
                return new MutableVertexBuffer<T>(desc, eg.egGenBuffer(), usage);
            }
        });
        this.desc = desc;
        this.usage = usage;
    }
    public String toString() {
        return String.format("VertexBufferRing(%s, %d)", this.desc, this.usage);
    }
}