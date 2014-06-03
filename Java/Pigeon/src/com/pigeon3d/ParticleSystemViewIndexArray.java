package com.pigeon3d;

import objd.lang.*;

public abstract class ParticleSystemViewIndexArray<P, D, M> extends ParticleSystemView {
    @Override
    public int indexCount() {
        return ((ParticleSystemIndexArray)(this.system)).indexCount();
    }
    @Override
    protected IndexSource createIndexSource() {
        final Pointer ia = ((ParticleSystemIndexArray)(this.system)).createIndexArray();
        final ImmutableIndexBuffer ib = IBO.applyPointerCount(ia, this.indexCount() * this.maxCount);
        Pointer.free(ia);
        return ib;
    }
    public ParticleSystemViewIndexArray(final ParticleSystem<P> system, final VertexBufferDesc<D> vbDesc, final Shader<M> shader, final M material, final BlendFunction blendFunc) {
        super(system, vbDesc, shader, material, blendFunc);
    }
    public String toString() {
        return "ParticleSystemViewIndexArray";
    }
}