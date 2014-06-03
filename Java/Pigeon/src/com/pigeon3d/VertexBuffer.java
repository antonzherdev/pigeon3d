package com.pigeon3d;

import objd.lang.*;

public interface VertexBuffer<T> {
    VertexBufferDesc<T> desc();
    int count();
    int handle();
    boolean isMutable();
    void bind();
    String toString();
}