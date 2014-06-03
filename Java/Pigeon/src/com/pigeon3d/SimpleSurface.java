package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.geometry.vec2i;
import com.pigeon3d.gl.gl;
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
        gl.glGetError();
        gl.glBindFramebufferHandle(gl.GL_FRAMEBUFFER, this.frameBuffer);
        this.renderTarget.link();
        if(gl.glGetError() != 0) {
            final String e = String.format("Error in texture creation for surface with size %dx%d", this.size.x, this.size.y);
            throw new RuntimeException(e);
        }
        final int status = gl.glCheckFramebufferStatusTarget(gl.GL_FRAMEBUFFER);
        if(status != gl.GL_FRAMEBUFFER_COMPLETE) {
            throw new RuntimeException(String.format("Error in frame buffer color attachment: %d", status));
        }
        if(this.depth) {
            Global.context.bindRenderBufferId(this.depthRenderBuffer);
            gl.glRenderbufferStorageComponentWidthHeight(gl.GL_RENDERBUFFER, gl.GL_DEPTH_COMPONENT16, ((int)(this.size.x)), ((int)(this.size.y)));
            gl.glFramebufferRenderbufferTargetAttachmentBuftargetBuffer(gl.GL_FRAMEBUFFER, gl.GL_DEPTH_ATTACHMENT, gl.GL_RENDERBUFFER, this.depthRenderBuffer);
            final int status2 = gl.glCheckFramebufferStatusTarget(gl.GL_FRAMEBUFFER);
            if(status2 != gl.GL_FRAMEBUFFER_COMPLETE) {
                throw new RuntimeException(String.format("Error in frame buffer depth attachment: %d", status));
            }
        }
    }
    @Override
    public void finalize() {
        final int fb = this.frameBuffer;
        Director.current().onGLThreadF(new P0() {
            @Override
            public void apply() {
                gl.egDeleteFrameBufferHandle(fb);
            }
        });
        if(this.depth) {
            Global.context.deleteRenderBufferId(this.depthRenderBuffer);
        }
    }
    @Override
    public void bind() {
        gl.glBindFramebufferHandle(gl.GL_FRAMEBUFFER, this.frameBuffer);
        Global.context.setViewport(RectI.applyXYWidthHeight(((float)(0)), ((float)(0)), ((float)(this.size.x)), ((float)(this.size.y))));
    }
    @Override
    public void unbind() {
    }
    public SimpleSurface(final SurfaceRenderTarget renderTarget, final boolean depth) {
        super(renderTarget);
        this.depth = depth;
        this.frameBuffer = gl.egGenFrameBuffer();
        this.depthRenderBuffer = ((depth) ? (gl.egGenRenderBuffer()) : (((int)(0))));
    }
    public String toString() {
        return String.format("SimpleSurface(%d)", this.depth);
    }
}