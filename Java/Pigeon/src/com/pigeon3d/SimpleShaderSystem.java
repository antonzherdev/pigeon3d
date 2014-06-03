package com.pigeon3d;

import objd.lang.*;
import objd.collection.MHashMap;
import com.pigeon3d.geometry.vec4;

public class SimpleShaderSystem extends ShaderSystem<ColorSource> {
    public static final SimpleShaderSystem instance;
    private static final MHashMap<SimpleShaderKey, SimpleShader> shaders;
    public static Shader<ColorSource> colorShader() {
        return SimpleShaderSystem.instance.shaderForParamRenderTarget(ColorSource.applyColor(new vec4(((float)(0)), ((float)(0)), ((float)(0)), ((float)(1)))), Global.context.renderTarget);
    }
    @Override
    public Shader<ColorSource> shaderForParamRenderTarget(final ColorSource param, final RenderTarget renderTarget) {
        if(renderTarget instanceof ShadowRenderTarget) {
            return ((Shader<ColorSource>)(((Shader)(ShadowShaderSystem.instance.shaderForParam(param)))));
        } else {
            final boolean t = param.texture != null;
            final Texture __tmpf_1p1b = param.texture;
            final SimpleShaderKey key = new SimpleShaderKey(t, t && ((__tmpf_1p1b != null) ? (param.texture instanceof TextureRegion) : (false)), param.blendMode);
            return ((Shader<ColorSource>)(((Shader)(((Shader<Object>)(((Shader)(SimpleShaderSystem.shaders.applyKeyOrUpdateWith(key, new F0<SimpleShader>() {
                @Override
                public SimpleShader apply() {
                    return new SimpleShader(key);
                }
            })))))))));
        }
    }
    public SimpleShaderSystem() {
    }
    public String toString() {
        return "SimpleShaderSystem";
    }
    static {
        instance = new SimpleShaderSystem();
        shaders = new MHashMap<SimpleShaderKey, SimpleShader>();
    }
}