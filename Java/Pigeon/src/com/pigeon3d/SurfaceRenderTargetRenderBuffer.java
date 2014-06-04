package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.gl.eg;
import android.opengl.GLES20;
import com.pigeon3d.geometry.vec2i;

public class SurfaceRenderTargetRenderBuffer extends SurfaceRenderTarget {
    public final int renderBuffer;
    public static SurfaceRenderTargetRenderBuffer applySize(final vec2i size) {
        final int buf = eg.egGenRenderBuffer();
        Global.context.bindRenderBufferId(buf);
        GLES20.glRenderbufferStorage(GLES20.GL_RENDERBUFFER, GLES20.GL_RGBA8_OES, ((int)(size.x)), ((int)(size.y)));
        return new SurfaceRenderTargetRenderBuffer(buf, size);
    }
    @Override
    public void link() {
        GLES20.glFramebufferRenderbuffer(GLES20.GL_FRAMEBUFFER, GLES20.GL_COLOR_ATTACHMENT0, GLES20.GL_RENDERBUFFER, this.renderBuffer);
    }
    @Override
    public void finalize() throws Throwable {
        super.finalize();
        Global.context.deleteRenderBufferId(this.renderBuffer);
    }
    public SurfaceRenderTargetRenderBuffer(final int renderBuffer, final vec2i size) {
        super(size);
        this.renderBuffer = renderBuffer;
    }
    public String toString() {
        return String.format("SurfaceRenderTargetRenderBuffer(%d)", this.renderBuffer);
    }
}