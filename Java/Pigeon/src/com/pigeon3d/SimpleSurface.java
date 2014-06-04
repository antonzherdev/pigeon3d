package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.geometry.vec2i;
import android.opengl.GLES20;
import com.pigeon3d.gl.eg;
import com.pigeon3d.geometry.RectI;

public class SimpleSurface extends RenderTargetSurface {
    public final boolean depth;
    public final int frameBuffer;
    @Override
    public int frameBuffer() {
        return frameBuffer;
    }
    private final int depthRenderBuffer;
    public static SimpleSurface toTextureSizeDepth(final vec2i size, final boolean depth) {
        return new SimpleSurface(SurfaceRenderTargetTexture.applySize(size), depth);
    }
    public static SimpleSurface toRenderBufferSizeDepth(final vec2i size, final boolean depth) {
        return new SimpleSurface(SurfaceRenderTargetRenderBuffer.applySize(size), depth);
    }
    public void init() {
        GLES20.glGetError();
        GLES20.glBindFramebuffer(GLES20.GL_FRAMEBUFFER, this.frameBuffer);
        this.renderTarget.link();
        if(GLES20.glGetError() != 0) {
            final String e = String.format("Error in texture creation for surface with size %dx%d", this.size.x, this.size.y);
            throw new RuntimeException(e);
        }
        final int status = GLES20.glCheckFramebufferStatus(GLES20.GL_FRAMEBUFFER);
        if(status != GLES20.GL_FRAMEBUFFER_COMPLETE) {
            throw new RuntimeException(String.format("Error in frame buffer color attachment: %d", status));
        }
        if(this.depth) {
            Global.context.bindRenderBufferId(this.depthRenderBuffer);
            GLES20.glRenderbufferStorage(GLES20.GL_RENDERBUFFER, GLES20.GL_DEPTH_COMPONENT16, ((int)(this.size.x)), ((int)(this.size.y)));
            GLES20.glFramebufferRenderbuffer(GLES20.GL_FRAMEBUFFER, GLES20.GL_DEPTH_ATTACHMENT, GLES20.GL_RENDERBUFFER, this.depthRenderBuffer);
            final int status2 = GLES20.glCheckFramebufferStatus(GLES20.GL_FRAMEBUFFER);
            if(status2 != GLES20.GL_FRAMEBUFFER_COMPLETE) {
                throw new RuntimeException(String.format("Error in frame buffer depth attachment: %d", status));
            }
        }
    }
    @Override
    public void finalize() throws Throwable {
        super.finalize();
        final int fb = this.frameBuffer;
        Director.current().onGLThreadF(new P0() {
            @Override
            public void apply() {
                eg.egDeleteFrameBuffer(fb);
            }
        });
        if(this.depth) {
            Global.context.deleteRenderBufferId(this.depthRenderBuffer);
        }
    }
    @Override
    public void bind() {
        GLES20.glBindFramebuffer(GLES20.GL_FRAMEBUFFER, this.frameBuffer);
        Global.context.setViewport(RectI.applyXYWidthHeight(((float)(0)), ((float)(0)), ((float)(this.size.x)), ((float)(this.size.y))));
    }
    @Override
    public void unbind() {
    }
    public SimpleSurface(final SurfaceRenderTarget renderTarget, final boolean depth) {
        super(renderTarget);
        this.depth = depth;
        this.frameBuffer = eg.egGenFrameBuffer();
        this.depthRenderBuffer = ((depth) ? (eg.egGenRenderBuffer()) : (((int)(0))));
    }
    public String toString() {
        return String.format("SimpleSurface(%d)", this.depth);
    }
}