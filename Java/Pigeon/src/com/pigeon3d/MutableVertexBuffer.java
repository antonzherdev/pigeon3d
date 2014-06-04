package com.pigeon3d;

import objd.lang.*;
import android.opengl.GLES20;

public class MutableVertexBuffer<T> extends MutableBuffer<T> implements VertexBuffer<T> {
    public final VertexBufferDesc<T> desc;
    @Override
    public VertexBufferDesc<T> desc() {
        return desc;
    }
    @Override
    public boolean isMutable() {
        return true;
    }
    @Override
    public void bind() {
        Global.context.bindVertexBufferBuffer(((VertexBuffer<Object>)(((VertexBuffer)(this)))));
    }
    @Override
    public boolean isEmpty() {
        return false;
    }
    public MutableVertexBuffer(final VertexBufferDesc<T> desc, final int handle, final int usage) {
        super(desc.dataType, GLES20.GL_ARRAY_BUFFER, handle, usage);
        this.desc = desc;
    }
    public String toString() {
        return String.format("MutableVertexBuffer(%s)", this.desc);
    }
}