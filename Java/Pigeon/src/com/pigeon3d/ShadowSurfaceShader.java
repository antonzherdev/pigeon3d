package com.pigeon3d;

import objd.lang.*;
import android.opengl.GLES20;

public class ShadowSurfaceShader extends Shader<ColorSource> {
    public final ShaderAttribute positionSlot;
    @Override
    public void loadAttributesVbDesc(final VertexBufferDesc<Object> vbDesc) {
        this.positionSlot.setFromBufferWithStrideValuesCountValuesTypeShift(((int)(vbDesc.stride())), ((int)(2)), GLES20.GL_FLOAT, ((int)(vbDesc.model)));
    }
    @Override
    public void loadUniformsParam(final ColorSource param) {
        {
            final Texture _ = param.texture;
            if(_ != null) {
                Global.context.bindTextureTexture(((Texture)(_)));
            }
        }
    }
    public ShadowSurfaceShader() {
        super(new ShadowSurfaceShaderBuilder().program());
        this.positionSlot = this.program.attributeForName("position");
    }
    public String toString() {
        return "ShadowSurfaceShader";
    }
}