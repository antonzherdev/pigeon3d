package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.geometry.vec2;
import android.opengl.GLES20;
import com.pigeon3d.geometry.vec2i;
import com.pigeon3d.gl.eg;

public class SurfaceRenderTargetTexture extends SurfaceRenderTarget {
    public final Texture texture;
    public static SurfaceRenderTargetTexture applySize(final vec2i size) {
        final EmptyTexture t = new EmptyTexture(vec2.applyVec2i(size));
        Global.context.bindTextureTexture(t);
        GLES20.glTexParameteri(GLES20.GL_TEXTURE_2D, GLES20.GL_TEXTURE_WRAP_S, ((int)(GLES20.GL_CLAMP_TO_EDGE)));
        GLES20.glTexParameteri(GLES20.GL_TEXTURE_2D, GLES20.GL_TEXTURE_WRAP_T, ((int)(GLES20.GL_CLAMP_TO_EDGE)));
        GLES20.glTexParameteri(GLES20.GL_TEXTURE_2D, GLES20.GL_TEXTURE_MIN_FILTER, ((int)(GLES20.GL_NEAREST)));
        GLES20.glTexParameteri(GLES20.GL_TEXTURE_2D, GLES20.GL_TEXTURE_MAG_FILTER, ((int)(GLES20.GL_NEAREST)));
        GLES20.glTexImage2D(GLES20.GL_TEXTURE_2D, ((int)(0)), ((int)(GLES20.GL_RGBA)), ((int)(size.x)), ((int)(size.y)), ((int)(0)), GLES20.GL_RGBA, GLES20.GL_UNSIGNED_BYTE, null);
        return new SurfaceRenderTargetTexture(t, size);
    }
    @Override
    public void link() {
        eg.egFramebufferTexture(GLES20.GL_FRAMEBUFFER, GLES20.GL_COLOR_ATTACHMENT0, this.texture.id(), ((int)(0)));
    }
    public SurfaceRenderTargetTexture(final Texture texture, final vec2i size) {
        super(size);
        this.texture = texture;
    }
    public String toString() {
        return String.format("SurfaceRenderTargetTexture(%s)", this.texture);
    }
}