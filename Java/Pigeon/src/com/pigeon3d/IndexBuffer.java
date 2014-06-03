package com.pigeon3d;

import objd.lang.*;

public interface IndexBuffer extends IndexSource {
    int handle();
    int mode();
    int count();
    @Override
    void draw();
    @Override
    void drawWithStartCount(final int start, final int count);
    String toString();
}