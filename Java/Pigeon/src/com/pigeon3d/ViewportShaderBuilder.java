package com.pigeon3d;

import objd.lang.*;

public class ViewportShaderBuilder extends ShaderTextBuilder_impl {
    public String vertex() {
        return String.format("%s\n\n%s highp vec2 position;\nuniform lowp float z;\n%s mediump vec2 UV;\n\nvoid main(void) {\n    gl_Position = vec4(2.0*position.x - 1.0, 2.0*position.y - 1.0, z, 1);\n    UV = position;\n}", this.vertexHeader(), this.ain(), this.out());
    }
    public String fragment() {
        return String.format("%s\n%s mediump vec2 UV;\n\nuniform lowp sampler2D txt;\n\nvoid main(void) {\n    %s = %s(txt, UV);\n}", this.fragmentHeader(), this.in(), this.fragColor(), this.texture2D());
    }
    public ShaderProgram program() {
        return ShaderProgram.applyNameVertexFragment("Viewport", this.vertex(), this.fragment());
    }
    public ViewportShaderBuilder() {
    }
    public String toString() {
        return "ViewportShaderBuilder";
    }
}