package com.pigeon3d;

import objd.lang.*;
import objd.react.Observer;
import objd.collection.MHashMap;
import objd.collection.ImArray;

public class ShadowDrawShaderSystem extends ShaderSystem<ShadowDrawParam> {
    public static final ShadowDrawShaderSystem instance;
    public static final Observer<ShadowType> settingsChangeObs;
    private static final MHashMap<ShadowDrawShaderKey, ShadowDrawShader> shaders;
    @Override
    public ShadowDrawShader shaderForParamRenderTarget(final ShadowDrawParam param, final RenderTarget renderTarget) {
        final ImArray<Light> lights = Global.context.environment.lights;
        final int directLightsCount = lights.chain().filterWhen(new F<Light, Boolean>() {
            @Override
            public Boolean apply(final Light _) {
                return _ instanceof DirectLight && _.hasShadows;
            }
        }).count();
        final ShadowDrawShaderKey key = new ShadowDrawShaderKey(directLightsCount, param.viewportSurface != null);
        return ShadowDrawShaderSystem.shaders.applyKeyOrUpdateWith(key, new F0<ShadowDrawShader>() {
            @Override
            public ShadowDrawShader apply() {
                return key.shader();
            }
        });
    }
    public ShadowDrawShaderSystem() {
    }
    public String toString() {
        return "ShadowDrawShaderSystem";
    }
    static {
        instance = new ShadowDrawShaderSystem();
        settingsChangeObs = Global.settings.shadowTypeChanged.observeF(new P<ShadowType>() {
            @Override
            public void apply(final ShadowType _) {
                ShadowDrawShaderSystem.shaders.clear();
            }
        });
        shaders = new MHashMap<ShadowDrawShaderKey, ShadowDrawShader>();
    }
}