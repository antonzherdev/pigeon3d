package com.pigeon3d;

import objd.lang.*;
import objd.collection.ImArray;
import android.opengl.GLES20;

public class ShadowDrawShader extends Shader<ShadowDrawParam> {
    public final ShadowDrawShaderKey key;
    public final ShaderAttribute positionSlot;
    public final ShaderUniformMat4 mwcpUniform;
    public final ImArray<ShaderUniformF4> directLightPercents;
    public final ImArray<ShaderUniformMat4> directLightDepthMwcp;
    public final ImArray<ShaderUniformI4> directLightShadows;
    @Override
    public void loadAttributesVbDesc(final VertexBufferDesc<Object> vbDesc) {
        this.positionSlot.setFromBufferWithStrideValuesCountValuesTypeShift(((int)(vbDesc.stride())), ((int)(3)), GLES20.GL_FLOAT, ((int)(vbDesc.position)));
    }
    @Override
    public void loadUniformsParam(final ShadowDrawParam param) {
        this.mwcpUniform.applyMatrix(Global.matrix.value().mwcp());
        final Environment env = Global.context.environment;
        {
            final ViewportSurface _ = param.viewportSurface;
            if(_ != null) {
                Global.context.bindTextureTexture(_.texture());
            }
        }
        final Mut<Integer> i = new Mut<Integer>(((int)(0)));
        env.lights.chain().filterWhen(new F<Light, Boolean>() {
            @Override
            public Boolean apply(final Light _) {
                return _ instanceof DirectLight && _.hasShadows;
            }
        }).forEach(new P<Light>() {
            @Override
            public void apply(final Light light) {
                final Float __tmp_4r_0n = param.percents.applyIndex(((int)(i.value)));
                if(__tmp_4r_0n == null) {
                    throw new NullPointerException();
                }
                final float p = ((float)(__tmp_4r_0n));
                ShadowDrawShader.this.directLightPercents[i.value].applyF4(p);
                ShadowDrawShader.this.directLightDepthMwcp[i.value].applyMatrix(light.shadowMap().biasDepthCp.mulMatrix(Global.matrix.mw()));
                ShadowDrawShader.this.directLightShadows[i.value].applyI4(((int)(i.value + 1)));
                Global.context.bindTextureSlotTargetTexture(GLES20.GL_TEXTURE0 + i.value + 1, GLES20.GL_TEXTURE_2D, light.shadowMap().texture);
                i.value++;
            }
        });
    }
    public ShadowDrawShader(final ShadowDrawShaderKey key, final ShaderProgram program) {
        super(program);
        this.key = key;
        this.positionSlot = attributeForName("position");
        this.mwcpUniform = uniformMat4Name("mwcp");
        this.directLightPercents = UInt.range(key.directLightCount).chain().<ShaderUniformF4>mapF(new F<Integer, ShaderUniformF4>() {
            @Override
            public ShaderUniformF4 apply(final Integer i) {
                return uniformF4Name(String.format("dirLightPercent%s", i));
            }
        }).toArray();
        this.directLightDepthMwcp = UInt.range(key.directLightCount).chain().<ShaderUniformMat4>mapF(new F<Integer, ShaderUniformMat4>() {
            @Override
            public ShaderUniformMat4 apply(final Integer i) {
                return uniformMat4Name(String.format("dirLightDepthMwcp%s", i));
            }
        }).toArray();
        this.directLightShadows = UInt.range(key.directLightCount).chain().<ShaderUniformI4>mapF(new F<Integer, ShaderUniformI4>() {
            @Override
            public ShaderUniformI4 apply(final Integer i) {
                return uniformI4Name(String.format("dirLightShadow%s", i));
            }
        }).toArray();
    }
    public String toString() {
        return String.format("ShadowDrawShader(%s)", this.key);
    }
}