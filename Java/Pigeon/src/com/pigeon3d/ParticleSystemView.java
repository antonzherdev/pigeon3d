package com.pigeon3d;

import objd.lang.*;
import objd.concurrent.Future;
import android.opengl.GLES20;

public abstract class ParticleSystemView<P, D, M> {
    public abstract int indexCount();
    protected abstract IndexSource createIndexSource();
    public final ParticleSystem<P> system;
    public final VertexBufferDesc<D> vbDesc;
    public final Shader<M> shader;
    public final M material;
    public final BlendFunction blendFunc;
    public final int maxCount;
    public final int vertexCount;
    private final int _indexCount;
    public final IndexSource index;
    public final VertexArrayRing<M> vaoRing;
    private VertexArray<M> _vao;
    private MappedBufferData<D> _data;
    private Future<Integer> _lastWriteFuture;
    public void prepare() {
        this._vao = this.vaoRing.next();
        if(this._vao != null) {
            this._vao.syncWait();
        }
        {
            final MutableVertexBuffer<Object> vbo = ((this._vao != null) ? (this._vao.mutableVertexBuffer()) : (null));
            if(vbo != null) {
                this._data = ((MappedBufferData<D>)(((MappedBufferData)(vbo.beginWriteCount(this.vertexCount * this.maxCount)))));
                if(this._data != null) {
                    this._lastWriteFuture = this.system.writeToArray(this._data);
                } else {
                    this._lastWriteFuture = null;
                }
            }
        }
    }
    public void draw() {
        if(this._data != null) {
            this._data.finish();
            if(this._data.wasUpdated() && this._lastWriteFuture != null) {
                final Try<Integer> r = this._lastWriteFuture.waitResultPeriod(((double)(1)));
                if(r != null && r.isSuccess()) {
                    final int n = r.get();
                    if(n > 0) {
                        {
                            final EnablingState __tmp__il__0t_1t_1t_1t_0self = Global.context.depthTest;
                            {
                                final boolean __il__0t_1t_1t_1t_0changed = __tmp__il__0t_1t_1t_1t_0self.disable();
                                {
                                    final CullFace __tmp__il__0t_1t_1t_1t_0rp0self = Global.context.cullFace;
                                    {
                                        final int __il__0t_1t_1t_1t_0rp0oldValue = __tmp__il__0t_1t_1t_1t_0rp0self.disable();
                                        {
                                            {
                                                final EnablingState __il__0t_1t_1t_1t_0rp0rp0__tmp__il__0self = Global.context.blend;
                                                {
                                                    final boolean __il__0t_1t_1t_1t_0rp0rp0__il__0changed = __il__0t_1t_1t_1t_0rp0rp0__tmp__il__0self.enable();
                                                    {
                                                        Global.context.setBlendFunction(this.blendFunc);
                                                        if(this._vao != null) {
                                                            this._vao.drawParamStartEnd(this.material, ((int)(0)), ((int)(this._indexCount * n)));
                                                        }
                                                    }
                                                    if(__il__0t_1t_1t_1t_0rp0rp0__il__0changed) {
                                                        __il__0t_1t_1t_1t_0rp0rp0__tmp__il__0self.disable();
                                                    }
                                                }
                                            }
                                        }
                                        if(__il__0t_1t_1t_1t_0rp0oldValue != GLES20.GL_NONE) {
                                            __tmp__il__0t_1t_1t_1t_0rp0self.setValue(__il__0t_1t_1t_1t_0rp0oldValue);
                                        }
                                    }
                                }
                                if(__il__0t_1t_1t_1t_0changed) {
                                    __tmp__il__0t_1t_1t_1t_0self.enable();
                                }
                            }
                        }
                    }
                    if(this._vao != null) {
                        this._vao.syncSet();
                    }
                } else {
                    Log.infoText(String.format("Incorrect result in particle system: %s", r));
                }
            }
        }
    }
    public ParticleSystemView(final ParticleSystem<P> system, final VertexBufferDesc<D> vbDesc, final Shader<M> shader, final M material, final BlendFunction blendFunc) {
        this.system = system;
        this.vbDesc = vbDesc;
        this.shader = shader;
        this.material = material;
        this.blendFunc = blendFunc;
        this.maxCount = system.maxCount;
        this.vertexCount = system.vertexCount();
        this._indexCount = this.indexCount();
        this.index = this.createIndexSource();
        this.vaoRing = new VertexArrayRing<M>(((int)(3)), ((F<Integer, VertexArray<M>>)(((F)(new F<Integer, SimpleVertexArray<M>>() {
            @Override
            public SimpleVertexArray<M> apply(final Integer _) {
                return shader.vaoVboIbo(((VertexBuffer<Object>)(((VertexBuffer)(VBO.<D>mutDescUsage(vbDesc, GLES20.GL_STREAM_DRAW))))), ParticleSystemView.this.index);
            }
        })))));
    }
    public String toString() {
        return String.format("ParticleSystemView(%s, %s, %s, %s, %s)", this.system, this.vbDesc, this.shader, this.material, this.blendFunc);
    }
}