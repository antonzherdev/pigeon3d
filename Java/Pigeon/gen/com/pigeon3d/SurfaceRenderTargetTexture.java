package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.geometry.vec2;
import com.pigeon3d.gl.gl;
import com.pigeon3d.geometry.vec2i;

public class SurfaceRenderTargetTexture extends SurfaceRenderTarget {
    public final Texture texture;
    public static SurfaceRenderTargetTexture applySize(final vec2i size) {
        final EmptyTexture t = new EmptyTexture(vec2.applyVec2i(size));
        Global.context.bindTextureTexture(t);
        gl.glTexParameteriTargetPnameParam(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_WRAP_S, ((int)(gl.GL_CLAMP_TO_EDGE)));
        gl.glTexParameteriTargetPnameParam(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_WRAP_T, ((int)(gl.GL_CLAMP_TO_EDGE)));
        gl.glTexParameteriTargetPnameParam(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_MIN_FILTER, ((int)(gl.GL_NEAREST)));
        gl.glTexParameteriTargetPnameParam(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_MAG_FILTER, ((int)(gl.GL_NEAREST)));
        gl.glTexImage2DTargetLevelInternalformatWidthHeightBorderFormatTpPixels(gl.GL_TEXTURE_2D, ((int)(0)), ((int)(gl.GL_RGBA)), ((int)(size.x)), ((int)(size.y)), ((int)(0)), gl.GL_RGBA, gl.GL_UNSIGNED_BYTE, ERROR: Unknown null<void>);
        return new SurfaceRenderTargetTexture(t, size);
    }
    @Override
    public void link() {
        gl.egFramebufferTextureTargetAttachmentTextureLevel(gl.GL_FRAMEBUFFER, gl.GL_COLOR_ATTACHMENT0, this.texture.id(), ((int)(0)));
    }
    public SurfaceRenderTargetTexture(final Texture texture, final vec2i size) {
        super(size);
        this.texture = texture;
    }
    public String toString() {
        return String.format("SurfaceRenderTargetTexture(%s)", this.texture);
    }
}