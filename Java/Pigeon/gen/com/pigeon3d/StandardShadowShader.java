package com.pigeon3d;

import objd.lang.*;

public class StandardShadowShader extends Shader<StandardMaterial> {
    public static final StandardShadowShader instanceForColor;
    public static final StandardShadowShader instanceForTexture;
    public final ShadowShader shadowShader;
    @Override
    public void loadAttributesVbDesc(final VertexBufferDesc<Object> vbDesc) {
        this.shadowShader.loadAttributesVbDesc(((VertexBufferDesc<Object>)(((VertexBufferDesc)(vbDesc)))));
    }
    @Override
    public void loadUniformsParam(final StandardMaterial param) {
        this.shadowShader.loadUniformsParam(param.diffuse);
    }
    public StandardShadowShader(final ShadowShader shadowShader) {
        super(shadowShader.program);
        this.shadowShader = shadowShader;
    }
    public String toString() {
        return String.format("StandardShadowShader(%s)", this.shadowShader);
    }
    static {
        instanceForColor = new StandardShadowShader(ShadowShader.instanceForColor);
        instanceForTexture = new StandardShadowShader(ShadowShader.instanceForTexture);
    }
}