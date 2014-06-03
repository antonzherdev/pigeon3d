package com.pigeon3d;

import objd.lang.*;

public class ShadowRenderTarget extends RenderTarget {
    public static final ShadowRenderTarget aDefault;
    public final Light shadowLight;
    @Override
    public boolean isShadow() {
        return true;
    }
    public ShadowRenderTarget(final Light shadowLight) {
        this.shadowLight = shadowLight;
    }
    public String toString() {
        return String.format("ShadowRenderTarget(%s)", this.shadowLight);
    }
    static {
        aDefault = new ShadowRenderTarget(Light.aDefault);
    }
}