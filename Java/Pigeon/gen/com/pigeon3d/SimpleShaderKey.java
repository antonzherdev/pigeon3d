package com.pigeon3d;

import objd.lang.*;

public final class SimpleShaderKey extends ShaderTextBuilder_impl {
    public final boolean texture;
    public final boolean region;
    public final BlendMode blendMode;
    public final String fragment;
    public String vertex() {
        return String.format("%s\n%s highp vec3 position;\nuniform mat4 mvp;\n\n%s\n%s\n\nvoid main(void) {\n    gl_Position = mvp * vec4(position, 1);\n%s\n}", this.vertexHeader(), this.ain(), ((this.texture) ? (String.format("%s mediump vec2 vertexUV;\n%s mediump vec2 UV;", this.ain(), this.out())) : ("")), ((this.region) ? ("uniform mediump vec2 uvShift;\nuniform mediump vec2 uvScale;") : ("")), ((this.texture && this.region) ? ("    UV = uvScale*vertexUV + uvShift;") : (String.format("%s", ((this.texture) ? ("\n    UV = vertexUV; ") : (""))))));
    }
    public ShaderProgram program() {
        return ShaderProgram.applyNameVertexFragment("Simple", this.vertex(), this.fragment);
    }
    public SimpleShaderKey(final boolean texture, final boolean region, final BlendMode blendMode) {
        this.texture = texture;
        this.region = region;
        this.blendMode = blendMode;
        this.fragment = String.format("%s\n%s\nuniform lowp vec4 color;\n\nvoid main(void) {\n   %s = %s;\n}", this.fragmentHeader(), ((texture) ? (String.format("%s mediump vec2 UV;\nuniform lowp sampler2D txt;", this.in())) : ("")), this.fragColor(), blendModeAB(blendMode, "color", String.format("%s(txt, UV)", this.texture2D())));
    }
    public String toString() {
        return String.format("SimpleShaderKey(%d, %d, %s)", this.texture, this.region, this.blendMode);
    }
    public boolean equals(final Object to) {
        if(this == to) {
            return true;
        }
        if(to == null || !(to instanceof SimpleShaderKey)) {
            return false;
        }
        final SimpleShaderKey o = ((SimpleShaderKey)(to));
        return this.texture.equals(o.texture) && this.region.equals(o.region) && this.blendMode == o.blendMode;
    }
    public int hashCode() {
        int hash = 0;
        hash = hash * 31 + this.texture;
        hash = hash * 31 + this.region;
        hash = hash * 31 + this.blendMode.hashCode();
        return hash;
    }
}