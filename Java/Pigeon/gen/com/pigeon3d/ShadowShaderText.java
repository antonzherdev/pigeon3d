package com.pigeon3d;

import objd.lang.*;

public class ShadowShaderText extends ShaderTextBuilder_impl {
    public final boolean texture;
    public String vertex() {
        return String.format("%s\n%s\n%s highp vec3 position;\nuniform mat4 mwcp;\n\nvoid main(void) {\n    gl_Position = mwcp * vec4(position, 1);%s\n}", this.vertexHeader(), ((this.texture) ? (String.format("%s mediump vec2 vertexUV;\n%s mediump vec2 UV;", this.ain(), this.out())) : ("")), this.ain(), ((this.texture) ? ("\n    UV = vertexUV;") : ("")));
    }
    public String fragment() {
        return String.format("#version %d\n%s\n%s\n\nvoid main(void) {\n   %s\n   %s\n}", this.version(), ((this.texture) ? (String.format("%s mediump vec2 UV;\nuniform lowp sampler2D txt;\nuniform lowp float alphaTestLevel;", this.in())) : ("")), ((this.version() > 100) ? ("out float depth;") : ("")), ((this.texture) ? (String.format("    if(%s(txt, UV).a < alphaTestLevel) {\n        discard;\n    }\n   ", this.texture2D())) : ("")), ((this.version() > 100) ? ("    depth = gl_FragCoord.z;\n   ") : ("")));
    }
    public ShaderProgram program() {
        return ShaderProgram.applyNameVertexFragment("Shadow", this.vertex(), this.fragment());
    }
    public ShadowShaderText(final boolean texture) {
        this.texture = texture;
    }
    public String toString() {
        return String.format("ShadowShaderText(%d)", this.texture);
    }
}