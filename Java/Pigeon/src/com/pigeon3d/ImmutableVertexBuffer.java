package com.pigeon3d;

import objd.lang.*;
import android.opengl.GLES20;

public class ImmutableVertexBuffer<T> extends Buffer<T> implements VertexBuffer<T> {
    public final VertexBufferDesc<T> desc;
    @Override
    public VertexBufferDesc<T> desc() {
        return desc;
    }
    public final int length;
    @Override
    public int length() {
        return length;
    }
    public final int count;
    @Override
    public int count() {
        return count;
    }
    @Override
    public void bind() {
        Global.context.bindVertexBufferBuffer(((VertexBuffer<Object>)(((VertexBuffer)(this)))));
    }
    public ImmutableVertexBuffer(final VertexBufferDesc<T> desc, final int handle, final int length, final int count) {
        super(desc.dataType, GLES20.GL_ARRAY_BUFFER, handle);
        this.desc = desc;
        this.length = length;
        this.count = count;
    }
    public String toString() {
        return String.format("ImmutableVertexBuffer(%s, %d, %d)", this.desc, this.length, this.count);
    }
    public boolean isMutable() {
        return false;
    }
}