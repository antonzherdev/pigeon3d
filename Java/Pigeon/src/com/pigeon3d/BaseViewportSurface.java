package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.geometry.vec2i;
import com.pigeon3d.geometry.vec2;
import objd.collection.ImArray;

public abstract class BaseViewportSurface {
    public abstract RenderTargetSurface createSurface();
    public static Mesh fullScreenMesh() {
        return _lazy_fullScreenMesh.get();
    }
    private static final Lazy<Mesh> _lazy_fullScreenMesh;
    public static VertexArray<ViewportSurfaceShaderParam> fullScreenVao() {
        return _lazy_fullScreenVao.get();
    }
    private static final Lazy<VertexArray<ViewportSurfaceShaderParam>> _lazy_fullScreenVao;
    public final F<vec2i, SurfaceRenderTarget> createRenderTarget;
    private RenderTargetSurface _surface;
    private SurfaceRenderTarget _renderTarget;
    public RenderTargetSurface surface() {
        return this._surface;
    }
    public SurfaceRenderTarget renderTarget() {
        final vec2i __tmp_0cb = ((this._renderTarget != null) ? (this._renderTarget.size) : (null));
        if(this._renderTarget == null || __tmp_0cb == null || !(__tmp_0cb.equals(Global.context.viewSize.value()))) {
            this._renderTarget = this.createRenderTarget.apply(Global.context.viewSize.value());
        }
        if(this._renderTarget == null) {
            throw new NullPointerException();
        }
        return this._renderTarget;
    }
    private void maybeRecreateSurface() {
        if(this.needRedraw()) {
            this._surface = this.createSurface();
        }
    }
    public Texture texture() {
        return ((SurfaceRenderTargetTexture)(this.renderTarget())).texture;
    }
    public int renderBuffer() {
        return ((SurfaceRenderTargetRenderBuffer)(this.renderTarget())).renderBuffer;
    }
    public boolean needRedraw() {
        final vec2i __tmpb = ((this._surface != null) ? (this._surface.size) : (null));
        return this._surface == null || __tmpb == null || !(__tmpb.equals(Global.context.viewSize.value()));
    }
    public void bind() {
        this.maybeRecreateSurface();
        if(this._surface != null) {
            this._surface.bind();
        }
    }
    public void applyDraw(final P0 draw) {
        this.bind();
        draw.apply();
        this.unbind();
    }
    public void maybeDraw(final P0 draw) {
        if(this.needRedraw()) {
            {
                this.bind();
                draw.apply();
                this.unbind();
            }
        }
    }
    public void maybeForceDraw(final boolean force, final P0 draw) {
        if(force || this.needRedraw()) {
            {
                this.bind();
                draw.apply();
                this.unbind();
            }
        }
    }
    public void unbind() {
        if(this._surface != null) {
            this._surface.unbind();
        }
    }
    public BaseViewportSurface(final F<vec2i, SurfaceRenderTarget> createRenderTarget) {
        this.createRenderTarget = createRenderTarget;
        this._surface = null;
        this._renderTarget = null;
    }
    public String toString() {
        return String.format(")");
    }
    static {
        _lazy_fullScreenMesh = new Lazy(new F0<Mesh>() {
            @Override
            public Mesh apply() {
                return new Mesh(((VertexBuffer<Object>)(((VertexBuffer)(VBO.vec2Data(((vec2[0])(ImArray.fromObjects(new vec2(((float)(0)), ((float)(0))), new vec2(((float)(1)), ((float)(0))), new vec2(((float)(0)), ((float)(1))), new vec2(((float)(1)), ((float)(1))))))))))), EmptyIndexSource.triangleStrip);
            }
        });
        _lazy_fullScreenVao = new Lazy(new F0<VertexArray<ViewportSurfaceShaderParam>>() {
            @Override
            public VertexArray<ViewportSurfaceShaderParam> apply() {
                return BaseViewportSurface.fullScreenMesh().<ViewportSurfaceShaderParam>vaoShader(((Shader<ViewportSurfaceShaderParam>)(((Shader)(ViewportSurfaceShader.instance)))));
            }
        });
    }
}