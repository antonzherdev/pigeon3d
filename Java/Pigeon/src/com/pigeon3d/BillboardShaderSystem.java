package com.pigeon3d;

import objd.lang.*;
import objd.collection.MHashMap;

public class BillboardShaderSystem extends ShaderSystem<ColorSource> {
    public static final BillboardShaderSystem cameraSpace;
    public static final BillboardShaderSystem projectionSpace;
    private static final MHashMap<BillboardShaderKey, BillboardShader> map;
    public final BillboardShaderSpace space;
    @Override
    public BillboardShader shaderForParamRenderTarget(final ColorSource param, final RenderTarget renderTarget) {
        final BillboardShaderKey key = new BillboardShaderKey((renderTarget instanceof ShadowRenderTarget && !(ShadowShaderSystem.isColorShaderForParam(param))) || param.texture != null, param.alphaTestLevel > -0.1, renderTarget instanceof ShadowRenderTarget, this.space);
        return BillboardShaderSystem.map.applyKeyOrUpdateWith(key, new F0<BillboardShader>() {
            @Override
            public BillboardShader apply() {
                return key.shader();
            }
        });
    }
    public static BillboardShader shaderForKey(final BillboardShaderKey key) {
        return BillboardShaderSystem.map.applyKeyOrUpdateWith(key, new F0<BillboardShader>() {
            @Override
            public BillboardShader apply() {
                return key.shader();
            }
        });
    }
    public BillboardShaderSystem(final BillboardShaderSpace space) {
        this.space = space;
    }
    public String toString() {
        return String.format("BillboardShaderSystem(%s)", this.space);
    }
    static {
        cameraSpace = new BillboardShaderSystem(BillboardShaderSpace.camera);
        projectionSpace = new BillboardShaderSystem(BillboardShaderSpace.projection);
        map = new MHashMap<BillboardShaderKey, BillboardShader>();
    }
}