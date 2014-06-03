package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.gl.gl;

public enum TextureFilter {
    nearest(gl.GL_NEAREST, gl.GL_NEAREST),
    linear(gl.GL_LINEAR, gl.GL_LINEAR),
    mipmapNearest(gl.GL_LINEAR, gl.GL_LINEAR_MIPMAP_NEAREST);
    private TextureFilter(final int magFilter, final int minFilter) {
        this.magFilter = magFilter;
        this.minFilter = minFilter;
    }
    public final int magFilter;
    public final int minFilter;
}