package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.gl.gl;

public class ViewportSurfaceShader extends Shader<ViewportSurfaceShaderParam> {
    public static final ViewportSurfaceShader instance;
    public final ShaderAttribute positionSlot;
    public final ShaderUniformF4 zUniform;
    @Override
    public void loadAttributesVbDesc(final VertexBufferDesc<Object> vbDesc) {
        this.positionSlot.setFromBufferWithStrideValuesCountValuesTypeShift(((int)(vbDesc.stride())), ((int)(2)), gl.GL_FLOAT, ((int)(vbDesc.model)));
    }
    @Override
    public void loadUniformsParam(final ViewportSurfaceShaderParam param) {
        Global.context.bindTextureTexture(param.texture);
        this.zUniform.applyF4(param.z);
    }
    public ViewportSurfaceShader() {
        super(new ViewportShaderBuilder().program());
        this.positionSlot = attributeForName("position");
        this.zUniform = uniformF4Name("z");
    }
    public String toString() {
        return "ViewportSurfaceShader";
    }
    static {
        instance = new ViewportSurfaceShader();
    }
}