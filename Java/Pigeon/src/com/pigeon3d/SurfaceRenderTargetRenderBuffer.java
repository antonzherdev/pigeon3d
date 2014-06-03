package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.gl.gl;
import com.pigeon3d.geometry.vec2i;

public class SurfaceRenderTargetRenderBuffer extends SurfaceRenderTarget {
    public final int renderBuffer;
    public static SurfaceRenderTargetRenderBuffer applySize(final vec2i size) {
        final int buf = gl.egGenRenderBuffer();
        Global.context.bindRenderBufferId(buf);
        gl.glRenderbufferStorageComponentWidthHeight(gl.GL_RENDERBUFFER, gl.GL_RGBA8_OES, ((int)(size.x)), ((int)(size.y)));
        return new SurfaceRenderTargetRenderBuffer(buf, size);
    }
    @Override
    public void link() {
        gl.glFramebufferRenderbufferTargetAttachmentBuftargetBuffer(gl.GL_FRAMEBUFFER, gl.GL_COLOR_ATTACHMENT0, gl.GL_RENDERBUFFER, this.renderBuffer);
    }
    @Override
    public void finalize() {
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