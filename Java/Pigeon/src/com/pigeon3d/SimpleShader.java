package com.pigeon3d;

import objd.lang.*;
import android.opengl.GLES20;
import com.pigeon3d.geometry.Rect;

public class SimpleShader extends Shader<ColorSource> {
    public final SimpleShaderKey key;
    public final ShaderAttribute uvSlot;
    public final ShaderAttribute positionSlot;
    public final ShaderUniformMat4 mvpUniform;
    public final ShaderUniformVec4 colorUniform;
    public final ShaderUniformVec2 uvScale;
    public final ShaderUniformVec2 uvShift;
    @Override
    public void loadAttributesVbDesc(final VertexBufferDesc<Object> vbDesc) {
        this.positionSlot.setFromBufferWithStrideValuesCountValuesTypeShift(((int)(vbDesc.stride())), ((int)(3)), GLES20.GL_FLOAT, ((int)(vbDesc.position)));
        if(this.key.texture) {
            if(this.uvSlot != null) {
                this.uvSlot.setFromBufferWithStrideValuesCountValuesTypeShift(((int)(vbDesc.stride())), ((int)(2)), GLES20.GL_FLOAT, ((int)(vbDesc.uv)));
            }
        }
    }
    @Override
    public void loadUniformsParam(final ColorSource param) {
        this.mvpUniform.applyMatrix(Global.matrix.value().mwcp());
        if(this.colorUniform != null) {
            this.colorUniform.applyVec4(param.color);
        }
        if(this.key.texture) {
            {
                final Texture tex = param.texture;
                if(tex != null) {
                    Global.context.bindTextureTexture(((Texture)(tex)));
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
    }
    public SimpleShader(final SimpleShaderKey key) {
        super(key.program());
        this.key = key;
        this.uvSlot = ((key.texture) ? (attributeForName("vertexUV")) : (null));
        this.positionSlot = attributeForName("position");
        this.mvpUniform = uniformMat4Name("mvp");
        this.colorUniform = uniformVec4OptName("color");
        this.uvScale = ((key.region) ? (uniformVec2Name("uvScale")) : (null));
        this.uvShift = ((key.region) ? (uniformVec2Name("uvShift")) : (null));
    }
    public String toString() {
        return String.format("SimpleShader(%s)", this.key);
    }
}