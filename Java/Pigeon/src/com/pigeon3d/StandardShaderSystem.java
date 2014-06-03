package com.pigeon3d;

import objd.lang.*;
import objd.collection.MHashMap;
import objd.react.Observer;
import objd.collection.ImArray;

public class StandardShaderSystem extends ShaderSystem<StandardMaterial> {
    public static final StandardShaderSystem instance;
    private static final MHashMap<StandardShaderKey, StandardShader> shaders;
    public static final Observer<ShadowType> settingsChangeObs;
    @Override
    public Shader<Material> shaderForParamRenderTarget(final StandardMaterial param, final RenderTarget renderTarget) {
        if(renderTarget instanceof ShadowRenderTarget) {
            if(ShadowShaderSystem.isColorShaderForParam(param.diffuse)) {
                return ((Shader<Material>)(((Shader)(((Shader<StandardMaterial>)(((Shader)(StandardShadowShader.instanceForColor))))))));
            } else {
                return ((Shader<Material>)(((Shader)(((Shader<StandardMaterial>)(((Shader)(StandardShadowShader.instanceForTexture))))))));
            }
        } else {
            final ImArray<Light> lights = Global.context.environment.lights;
            final int directLightsWithShadowsCount = lights.chain().filterWhen(new F<Light, Boolean>() {
                @Override
                public Boolean apply(final Light _) {
                    return _ instanceof DirectLight && _.hasShadows;
                }
            }).count();
            final int directLightsWithoutShadowsCount = lights.chain().filterWhen(new F<Light, Boolean>() {
                @Override
                public Boolean apply(final Light _) {
                    return _ instanceof DirectLight && !(_.hasShadows);
                }
            }).count();
            final Texture texture = param.diffuse.texture;
            final boolean t = texture != null;
            if(texture == null) {
                throw new NullPointerException();
            }
            final boolean region = t && ((texture != null) ? (texture instanceof TextureRegion) : (false));
            final boolean spec = param.specularSize > 0;
            final boolean normalMap = param.normalMap != null;
            final StandardShaderKey key = ((platform.egPlatform().shadows && Global.context.considerShadows) ? (new StandardShaderKey(directLightsWithShadowsCount, directLightsWithoutShadowsCount, t, param.diffuse.blendMode, region, spec, normalMap)) : (new StandardShaderKey(((int)(0)), directLightsWithShadowsCount + directLightsWithoutShadowsCount, t, param.diffuse.blendMode, region, spec, normalMap)));
            return ((Shader<Material>)(((Shader)(((Shader<StandardMaterial>)(((Shader)(StandardShaderSystem.shaders.applyKeyOrUpdateWith(key, new F0<StandardShader>() {
                @Override
                public StandardShader apply() {
                    return key.shader();
                }
            })))))))));
        }
    }
    public StandardShaderSystem() {
    }
    public String toString() {
        return "StandardShaderSystem";
    }
    static {
        instance = new StandardShaderSystem();
        shaders = new MHashMap<StandardShaderKey, StandardShader>();
        settingsChangeObs = Global.settings.shadowTypeChanged.observeF(new P<ShadowType>() {
            @Override
            public void apply(final ShadowType _) {
                StandardShaderSystem.shaders.clear();
            }
        });
    }
}