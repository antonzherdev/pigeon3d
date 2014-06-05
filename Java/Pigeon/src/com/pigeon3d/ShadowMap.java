package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.geometry.mat4;
import com.pigeon3d.gl.eg;
import android.opengl.GLES20;
import com.pigeon3d.geometry.RectI;
import com.pigeon3d.geometry.vec2;
import com.pigeon3d.geometry.vec2i;

public class ShadowMap extends Surface {
    public static final mat4 biasMatrix;
    public final int frameBuffer;
    @Override
    public int frameBuffer() {
        return frameBuffer;
    }
    public mat4 biasDepthCp;
    public final Texture texture;
    private ShadowSurfaceShader shader() {
        return _lazy_shader.get();
    }
    private final Lazy<ShadowSurfaceShader> _lazy_shader;
    private VertexArray<ColorSource> vao() {
        return _lazy_vao.get();
    }
    private final Lazy<VertexArray<ColorSource>> _lazy_vao;
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
    }
    @Override
    public void bind() {
        GLES20.glBindFramebuffer(GLES20.GL_FRAMEBUFFER, this.frameBuffer);
        Global.context.setViewport(RectI.applyXYWidthHeight(((float)(0)), ((float)(0)), ((float)(this.size.x)), ((float)(this.size.y))));
    }
    @Override
    public void unbind() {
        eg.egCheckError();
    }
    public void draw() {
        {
            final CullFace __tmp__il__0self = Global.context.cullFace;
            {
                final int __il__0oldValue = __tmp__il__0self.disable();
                this.vao().drawParam(ColorSource.applyTexture(this.texture));
                if(__il__0oldValue != GLES20.GL_NONE) {
                    __tmp__il__0self.setValue(__il__0oldValue);
                }
            }
        }
    }
    public ShadowMap(final vec2i size) {
        super(size);
        this.frameBuffer = eg.egGenFrameBuffer();
        this.biasDepthCp = mat4.identity();
        this.texture = t;
        this._lazy_shader = new Lazy<ShadowSurfaceShader>(new F0<ShadowSurfaceShader>() {
            @Override
            public ShadowSurfaceShader apply() {
                return new ShadowSurfaceShader();
            }
        });
        this._lazy_vao = new Lazy<VertexArray<ColorSource>>(new F0<VertexArray<ColorSource>>() {
            @Override
            public VertexArray<ColorSource> apply() {
                return BaseViewportSurface.fullScreenMesh().<ColorSource>vaoShader(((Shader<ColorSource>)(((Shader)(new ShadowSurfaceShader())))));
            }
        });
    }
    public String toString() {
        return "ShadowMap";
    }
    static {
        biasMatrix = mat4.identity().translateXYZ(((float)(0.5)), ((float)(0.5)), ((float)(0.5))).scaleXYZ(((float)(0.5)), ((float)(0.5)), ((float)(0.5)));
    }
}