package com.pigeon3d;

import objd.lang.*;
import objd.collection.ImArray;
import com.pigeon3d.gl.gl;
import com.pigeon3d.geometry.Rect;
import objd.collection.Iterator;
import com.pigeon3d.geometry.vec3;

public class StandardShader extends Shader<StandardMaterial> {
    public final StandardShaderKey key;
    public final ShaderAttribute positionSlot;
    public final ShaderAttribute normalSlot;
    public final ShaderAttribute uvSlot;
    public final ShaderUniformI4 diffuseTexture;
    public final ShaderUniformI4 normalMap;
    public final ShaderUniformVec2 uvScale;
    public final ShaderUniformVec2 uvShift;
    public final ShaderUniformVec4 ambientColor;
    public final ShaderUniformVec4 specularColor;
    public final ShaderUniformF4 specularSize;
    public final ShaderUniformVec4 diffuseColorUniform;
    public final ShaderUniformMat4 mwcpUniform;
    public final ShaderUniformMat4 mwcUniform;
    public final ImArray<ShaderUniformVec3> directLightDirections;
    public final ImArray<ShaderUniformVec4> directLightColors;
    public final ImArray<ShaderUniformI4> directLightShadows;
    public final ImArray<ShaderUniformMat4> directLightDepthMwcp;
    @Override
    public void loadAttributesVbDesc(final VertexBufferDesc<Object> vbDesc) {
        this.positionSlot.setFromBufferWithStrideValuesCountValuesTypeShift(((int)(vbDesc.stride())), ((int)(3)), gl.GL_FLOAT, ((int)(vbDesc.position)));
        if(this.key.needUV) {
            if(this.uvSlot != null) {
                this.uvSlot.setFromBufferWithStrideValuesCountValuesTypeShift(((int)(vbDesc.stride())), ((int)(2)), gl.GL_FLOAT, ((int)(vbDesc.uv)));
            }
        }
        if(this.key.directLightCount > 0) {
            if(this.normalSlot != null) {
                this.normalSlot.setFromBufferWithStrideValuesCountValuesTypeShift(((int)(vbDesc.stride())), ((int)(3)), gl.GL_FLOAT, ((int)(vbDesc.normal)));
            }
        }
    }
    @Override
    public void loadUniformsParam(final StandardMaterial param) {
        this.mwcpUniform.applyMatrix(Global.matrix.value().mwcp());
        if(this.key.texture) {
            {
                final Texture tex = param.diffuse.texture;
                if(tex != null) {
                    Global.context.bindTextureTexture(((Texture)(tex)));
                    if(this.diffuseTexture != null) {
                        this.diffuseTexture.applyI4(((int)(0)));
                    }
                    if(this.key.region) {
                        final Rect r = ((TextureRegion)(tex)).uv;
                        if(this.uvShift != null) {
                            this.uvShift.applyVec2(r.p);
                        }
                        if(this.uvScale != null) {
                            this.uvScale.applyVec2(r.size);
                        }
                    }
                }
            }
        }
        if(this.key.normalMap) {
            if(this.normalMap != null) {
                this.normalMap.applyI4(((int)(1)));
            }
            {
                final NormalMap __tmp_2t_1lu = param.normalMap;
                final Texture _ = ((__tmp_2t_1lu != null) ? (__tmp_2t_1lu.texture) : (null));
                if(_ != null) {
                    Global.context.bindTextureSlotTargetTexture(gl.GL_TEXTURE1, gl.GL_TEXTURE_2D, ((Texture)(_)));
                }
            }
        }
        if(this.diffuseColorUniform != null) {
            this.diffuseColorUniform.applyVec4(param.diffuse.color);
        }
        final Environment env = Global.context.environment;
        this.ambientColor.applyVec4(env.ambientColor);
        if(this.key.directLightCount > 0) {
            if(this.key.specular) {
                if(this.specularColor != null) {
                    this.specularColor.applyVec4(param.specularColor);
                }
                if(this.specularSize != null) {
                    this.specularSize.applyF4(((float)(param.specularSize)));
                }
            }
            if(this.mwcUniform != null) {
                this.mwcUniform.applyMatrix(Global.context.matrixStack.value().mwc());
            }
            int i = ((int)(0));
            if(this.key.directLightWithShadowsCount > 0) {
                {
                    final Iterator<DirectLight> __il__6t_3t_0i = env.directLightsWithShadows.iterator();
                    while(__il__6t_3t_0i.hasNext()) {
                        final DirectLight light = __il__6t_3t_0i.next();
                        {
                            final vec3 dir = vec4.xyz(Global.matrix.value().wc().mulVec3W(((DirectLight)(light)).direction, ((float)(0))));
                            this.directLightDirections[i].applyVec3(vec3.normalize(dir));
                            this.directLightColors[i].applyVec4(light.color);
                            this.directLightDepthMwcp[i].applyMatrix(light.shadowMap().biasDepthCp.mulMatrix(Global.matrix.mw()));
                            this.directLightShadows[i].applyI4(((int)(i + 2)));
                            Global.context.bindTextureSlotTargetTexture(gl.GL_TEXTURE0 + i + 2, gl.GL_TEXTURE_2D, light.shadowMap().texture);
                            i++;
                        }
                    }
                }
            }
            if(this.key.directLightWithoutShadowsCount > 0) {
                {
                    final Iterator<DirectLight> __il__6t_4t_0i = ((Global.context.considerShadows) ? (env.directLightsWithoutShadows) : (env.directLights)).iterator();
                    while(__il__6t_4t_0i.hasNext()) {
                        final DirectLight light = __il__6t_4t_0i.next();
                        {
                            final vec3 dir = vec4.xyz(Global.matrix.value().wc().mulVec3W(((DirectLight)(light)).direction, ((float)(0))));
                            this.directLightDirections[i].applyVec3(vec3.normalize(dir));
                            this.directLightColors[i].applyVec4(light.color);
                        }
                    }
                }
            }
        }
    }
    public StandardShader(final StandardShaderKey key, final ShaderProgram program) {
        super(program);
        this.key = key;
        this.positionSlot = attributeForName("position");
        this.normalSlot = ((key.directLightCount > 0 && !(key.normalMap)) ? (attributeForName("normal")) : (null));
        this.uvSlot = ((key.needUV) ? (attributeForName("vertexUV")) : (null));
        this.diffuseTexture = ((key.texture) ? (uniformI4Name("diffuseTexture")) : (null));
        this.normalMap = ((key.normalMap) ? (uniformI4Name("normalMap")) : (null));
        this.uvScale = ((key.region) ? (uniformVec2Name("uvScale")) : (null));
        this.uvShift = ((key.region) ? (uniformVec2Name("uvShift")) : (null));
        this.ambientColor = uniformVec4Name("ambientColor");
        this.specularColor = ((key.directLightCount > 0 && key.specular) ? (uniformVec4Name("specularColor")) : (null));
        this.specularSize = ((key.directLightCount > 0 && key.specular) ? (uniformF4Name("specularSize")) : (null));
        this.diffuseColorUniform = uniformVec4OptName("diffuseColor");
        this.mwcpUniform = uniformMat4Name("mwcp");
        this.mwcUniform = ((key.directLightCount > 0) ? (uniformMat4Name("mwc")) : (null));
        this.directLightDirections = UInt.range(key.directLightCount).chain().<ShaderUniformVec3>mapF(new F<Integer, ShaderUniformVec3>() {
            @Override
            public ShaderUniformVec3 apply(final Integer i) {
                return uniformVec3Name(String.format("dirLightDirection%s", i));
            }
        }).toArray();
        this.directLightColors = UInt.range(key.directLightCount).chain().<ShaderUniformVec4>mapF(new F<Integer, ShaderUniformVec4>() {
            @Override
            public ShaderUniformVec4 apply(final Integer i) {
                return uniformVec4Name(String.format("dirLightColor%s", i));
            }
        }).toArray();
        this.directLightShadows = UInt.range(key.directLightWithShadowsCount).chain().<ShaderUniformI4>mapF(new F<Integer, ShaderUniformI4>() {
            @Override
            public ShaderUniformI4 apply(final Integer i) {
                return uniformI4Name(String.format("dirLightShadow%s", i));
            }
        }).toArray();
        this.directLightDepthMwcp = UInt.range(key.directLightWithShadowsCount).chain().<ShaderUniformMat4>mapF(new F<Integer, ShaderUniformMat4>() {
            @Override
            public ShaderUniformMat4 apply(final Integer i) {
                return uniformMat4Name(String.format("dirLightDepthMwcp%s", i));
            }
        }).toArray();
    }
    public String toString() {
        return String.format("StandardShader(%s)", this.key);
    }
}