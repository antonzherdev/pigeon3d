package com.pigeon3d;

import objd.lang.*;

public interface IndexSource {
    void bind();
    void draw();
    void drawWithStartCount(final int start, final int count);
    boolean isMutable();
    boolean isEmpty();
    String toString();
}