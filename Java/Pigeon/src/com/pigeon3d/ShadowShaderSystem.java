package com.pigeon3d;

import objd.lang.*;

public class ShadowShaderSystem extends ShaderSystem<ColorSource> {
    public static final ShadowShaderSystem instance;
    @Override
    public ShadowShader shaderForParamRenderTarget(final ColorSource param, final RenderTarget renderTarget) {
        if(ShadowShaderSystem.isColorShaderForParam(param)) {
            return ShadowShader.instanceForColor;
        } else {
            return ShadowShader.instanceForTexture;
        }
    }
    public static boolean isColorShaderForParam(final ColorSource param) {
        return param.texture == null || param.alphaTestLevel < 0;
    }
    public ShadowShaderSystem() {
    }
    public String toString() {
        return "ShadowShaderSystem";
    }
    static {
        instance = new ShadowShaderSystem();
    }
}