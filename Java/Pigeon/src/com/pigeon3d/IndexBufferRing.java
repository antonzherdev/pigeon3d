package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.gl.eg;

public class IndexBufferRing extends BufferRing<Integer, MutableIndexBuffer> {
    public final int mode;
    public final int usage;
    public IndexBufferRing(final int ringSize, final int mode, final int usage) {
        super(ringSize, new F0<MutableIndexBuffer>() {
            @Override
            public MutableIndexBuffer apply() {
                return new MutableIndexBuffer(eg.egGenBuffer(), mode, usage);
            }
        });
        this.mode = mode;
        this.usage = usage;
    }
    public String toString() {
        return String.format("IndexBufferRing(%d, %d)", this.mode, this.usage);
    }
}