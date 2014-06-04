package com.pigeon3d;

import objd.lang.*;
import android.opengl.GLES20;

public class BillboardShader extends Shader<ColorSource> {
    public final BillboardShaderKey key;
    public final ShaderAttribute positionSlot;
    public final ShaderAttribute modelSlot;
    public final ShaderAttribute uvSlot;
    public final ShaderAttribute colorSlot;
    public final ShaderUniformVec4 colorUniform;
    public final ShaderUniformF4 alphaTestLevelUniform;
    public final ShaderUniformMat4 wcUniform;
    public final ShaderUniformMat4 pUniform;
    public final ShaderUniformMat4 wcpUniform;
    @Override
    public void loadAttributesVbDesc(final VertexBufferDesc<Object> vbDesc) {
        this.positionSlot.setFromBufferWithStrideValuesCountValuesTypeShift(((int)(vbDesc.stride())), ((int)(3)), GLES20.GL_FLOAT, ((int)(vbDesc.position)));
        this.modelSlot.setFromBufferWithStrideValuesCountValuesTypeShift(((int)(vbDesc.stride())), ((int)(2)), GLES20.GL_FLOAT, ((int)(vbDesc.model)));
        this.colorSlot.setFromBufferWithStrideValuesCountValuesTypeShift(((int)(vbDesc.stride())), ((int)(4)), GLES20.GL_FLOAT, ((int)(vbDesc.color)));
        if(this.key.texture) {
            if(this.uvSlot != null) {
                this.uvSlot.setFromBufferWithStrideValuesCountValuesTypeShift(((int)(vbDesc.stride())), ((int)(2)), GLES20.GL_FLOAT, ((int)(vbDesc.uv)));
            }
        }
    }
    @Override
    public void loadUniformsParam(final ColorSource param) {
        if(this.key.modelSpace == BillboardShaderSpace.camera) {
            if(this.wcUniform != null) {
                this.wcUniform.applyMatrix(Global.matrix.value().wc());
            }
            if(this.pUniform != null) {
                this.pUniform.applyMatrix(Global.matrix.value().p());
            }
        } else {
            if(this.wcpUniform != null) {
                this.wcpUniform.applyMatrix(Global.matrix.value().wcp());
            }
        }
        if(this.key.alpha) {
            if(this.alphaTestLevelUniform != null) {
                this.alphaTestLevelUniform.applyF4(param.alphaTestLevel);
            }
        }
        if(this.key.texture) {
            {
                final Texture _ = param.texture;
                if(_ != null) {
                    Global.context.bindTextureTexture(((Texture)(_)));
                }
            }
        }
        this.colorUniform.applyVec4(param.color);
    }
    public BillboardShader(final BillboardShaderKey key, final ShaderProgram program) {
        super(program);
        this.key = key;
        this.positionSlot = attributeForName("position");
        this.modelSlot = attributeForName("model");
        this.uvSlot = ((key.texture) ? (attributeForName("vertexUV")) : (null));
        this.colorSlot = attributeForName("vertexColor");
        this.colorUniform = uniformVec4Name("color");
        this.alphaTestLevelUniform = ((key.alpha) ? (uniformF4Name("alphaTestLevel")) : (null));
        this.wcUniform = ((key.modelSpace == BillboardShaderSpace.camera) ? (uniformMat4Name("wc")) : (null));
        this.pUniform = ((key.modelSpace == BillboardShaderSpace.camera) ? (uniformMat4Name("p")) : (null));
        this.wcpUniform = ((key.modelSpace == BillboardShaderSpace.projection) ? (uniformMat4Name("wcp")) : (null));
    }
    public String toString() {
        return String.format("BillboardShader(%s)", this.key);
    }
}