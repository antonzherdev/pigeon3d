package com.pigeon3d;

import objd.lang.*;

public class ShadowSurfaceShaderBuilder extends ViewportShaderBuilder {
    @Override
    public String fragment() {
        return String.format("%s\n%s mediump vec2 UV;\n\nuniform mediump sampler2D txt;\n\nvoid main(void) {\n    lowp vec4 col = %s(txt, UV);\n    %s = vec4(col.x, col.x, col.x, 1);\n}", this.fragmentHeader(), this.in(), this.texture2D(), this.fragColor());
    }
    public ShadowSurfaceShaderBuilder() {
    }
    public String toString() {
        return "ShadowSurfaceShaderBuilder";
    }
}