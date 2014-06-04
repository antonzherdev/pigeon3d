package com.pigeon3d;

import objd.lang.*;
import android.opengl.GLES20;

public class ShadowShader extends Shader<ColorSource> {
    public static final ShadowShader instanceForColor;
    public static final ShadowShader instanceForTexture;
    public final boolean texture;
    public final ShaderAttribute uvSlot;
    public final ShaderAttribute positionSlot;
    public final ShaderUniformMat4 mvpUniform;
    public final ShaderUniformF4 alphaTestLevelUniform;
    @Override
    public void loadAttributesVbDesc(final VertexBufferDesc<Object> vbDesc) {
        this.positionSlot.setFromBufferWithStrideValuesCountValuesTypeShift(((int)(vbDesc.stride())), ((int)(3)), GLES20.GL_FLOAT, ((int)(vbDesc.position)));
        if(this.texture) {
            if(this.uvSlot != null) {
                this.uvSlot.setFromBufferWithStrideValuesCountValuesTypeShift(((int)(vbDesc.stride())), ((int)(2)), GLES20.GL_FLOAT, ((int)(vbDesc.uv)));
            }
        }
    }
    @Override
    public void loadUniformsParam(final ColorSource param) {
        this.mvpUniform.applyMatrix(Global.matrix.value().mwcp());
        if(this.texture) {
            if(this.alphaTestLevelUniform != null) {
                this.alphaTestLevelUniform.applyF4(param.alphaTestLevel);
            }
            {
                final Texture _ = param.texture;
                if(_ != null) {
                    Global.context.bindTextureTexture(((Texture)(_)));
                }
            }
        }
    }
    public ShadowShader(final boolean texture, final ShaderProgram program) {
        super(program);
        this.texture = texture;
        this.uvSlot = ((texture) ? (attributeForName("vertexUV")) : (null));
        this.positionSlot = attributeForName("position");
        this.mvpUniform = uniformMat4Name("mwcp");
        this.alphaTestLevelUniform = ((texture) ? (uniformF4Name("alphaTestLevel")) : (null));
    }
    public String toString() {
        return String.format("ShadowShader(%d)", this.texture);
    }
    static {
        instanceForColor = new ShadowShader(false, new ShadowShaderText(false).program());
        instanceForTexture = new ShadowShader(true, new ShadowShaderText(true).program());
    }
}