package com.pigeon3d;

import objd.lang.*;
import android.opengl.GLES20;
import com.pigeon3d.geometry.vec4;

public class FontShader extends Shader<FontShaderParam> {
    public static final FontShader instance;
    public final ShaderAttribute uvSlot;
    public final ShaderAttribute positionSlot;
    public final ShaderUniformVec4 colorUniform;
    public final ShaderUniformVec2 shiftSlot;
    @Override
    public void loadAttributesVbDesc(final VertexBufferDesc<Object> vbDesc) {
        this.positionSlot.setFromBufferWithStrideValuesCountValuesTypeShift(((int)(vbDesc.stride())), ((int)(2)), GLES20.GL_FLOAT, ((int)(vbDesc.position)));
        this.uvSlot.setFromBufferWithStrideValuesCountValuesTypeShift(((int)(vbDesc.stride())), ((int)(2)), GLES20.GL_FLOAT, ((int)(vbDesc.uv)));
    }
    @Override
    public void loadUniformsParam(final FontShaderParam param) {
        Global.context.bindTextureTexture(param.texture);
        this.colorUniform.applyVec4(param.color);
        this.shiftSlot.applyVec2(vec4.xy(Global.matrix.p().mulVec4(vec4.applyVec2ZW(param.shift, ((float)(0)), ((float)(0))))));
    }
    public FontShader() {
        super(new FontShaderBuilder().program());
        this.uvSlot = attributeForName("vertexUV");
        this.positionSlot = attributeForName("position");
        this.colorUniform = uniformVec4Name("color");
        this.shiftSlot = uniformVec2Name("shift");
    }
    public String toString() {
        return "FontShader";
    }
    static {
        instance = new FontShader();
    }
}