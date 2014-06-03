package com.pigeon3d;

import objd.lang.*;

public class FontShaderBuilder extends ShaderTextBuilder_impl {
    public String vertex() {
        return String.format("%s\nuniform highp vec2 shift;\n%s highp vec2 position;\n%s mediump vec2 vertexUV;\n\n%s mediump vec2 UV;\n\nvoid main(void) {\n    gl_Position = vec4(position.x + shift.x, position.y + shift.y, 0, 1);\n    UV = vertexUV;\n}", this.vertexHeader(), this.ain(), this.ain(), this.out());
    }
    public String fragment() {
        return String.format("%s\n%s mediump vec2 UV;\nuniform lowp sampler2D txt;\nuniform lowp vec4 color;\n\nvoid main(void) {\n    %s = color * %s(txt, UV);\n}", this.fragmentHeader(), this.in(), this.fragColor(), this.texture2D());
    }
    public ShaderProgram program() {
        return ShaderProgram.applyNameVertexFragment("Font", this.vertex(), this.fragment());
    }
    public FontShaderBuilder() {
    }
    public String toString() {
        return "FontShaderBuilder";
    }
}