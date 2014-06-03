package com.pigeon3d;

import objd.lang.*;

public class BillboardParticleSystemView<P> extends ParticleSystemViewIndexArray<P, BillboardBufferData, ColorSource> {
    public BillboardParticleSystemView(final ParticleSystem system, final ColorSource material, final BlendFunction blendFunc) {
        super(((ParticleSystem<P>)(((ParticleSystem)(system)))), Sprite.vbDesc, ((Shader<ColorSource>)(((Shader)(BillboardShaderSystem.cameraSpace.shaderForParam(material))))), material, blendFunc);
    }
    static public <P> BillboardParticleSystemView<P> applySystemMaterial(final ParticleSystem system, final ColorSource material) {
        return new BillboardParticleSystemView<P>(system, material, BlendFunction.standard);
    }
    public String toString() {
        return "BillboardParticleSystemView";
    }
}