package com.pigeon3d;

import objd.lang.*;
import android.opengl.GLES20;

public enum TextureFilter {
    nearest(GLES20.GL_NEAREST, GLES20.GL_NEAREST),
    linear(GLES20.GL_LINEAR, GLES20.GL_LINEAR),
    mipmapNearest(GLES20.GL_LINEAR, GLES20.GL_LINEAR_MIPMAP_NEAREST);
    private TextureFilter(final int magFilter, final int minFilter) {
        this.magFilter = magFilter;
        this.minFilter = minFilter;
    }
    public final int magFilter;
    public final int minFilter;
}