package com.pigeon3d;

import objd.lang.*;

public abstract class VertexBuffer_impl<T> implements VertexBuffer<T> {
    public VertexBuffer_impl() {
    }
    public boolean isMutable() {
        return false;
    }
}