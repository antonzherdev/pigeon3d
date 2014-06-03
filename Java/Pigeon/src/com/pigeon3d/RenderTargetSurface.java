package com.pigeon3d;

import objd.lang.*;

public abstract class RenderTargetSurface extends Surface {
    public final SurfaceRenderTarget renderTarget;
    public Texture texture() {
        return ((SurfaceRenderTargetTexture)(this.renderTarget)).texture;
    }
    public int renderBuffer() {
        return ((SurfaceRenderTargetRenderBuffer)(this.renderTarget)).renderBuffer;
    }
    public RenderTargetSurface(final SurfaceRenderTarget renderTarget) {
        super(renderTarget.size);
        this.renderTarget = renderTarget;
    }
    public String toString() {
        return String.format("RenderTargetSurface(%s)", this.renderTarget);
    }
}