package com.pigeon3d;

import objd.lang.*;

public class BillboardShaderBuilder extends ShaderTextBuilder_impl {
    public final BillboardShaderKey key;
    public String vertex() {
        return String.format("%s\n%s highp vec3 position;\n%s lowp vec2 model;\n%s\n%s lowp vec4 vertexColor;\n%s\n%s vec4 fColor;\n\nvoid main(void) {\n   %s%s\n    fColor = vertexColor;\n}", this.vertexHeader(), this.ain(), this.ain(), ((this.key.texture) ? (String.format("%s mediump vec2 vertexUV;\n%s mediump vec2 UV;", this.ain(), this.out())) : ("")), this.ain(), ((this.key.modelSpace == BillboardShaderSpace.camera) ? ("uniform mat4 wc;\nuniform mat4 p;") : ("uniform mat4 wcp;")), this.out(), ((this.key.modelSpace == BillboardShaderSpace.camera) ? ("    highp vec4 pos = wc*vec4(position, 1);\n    pos.x += model.x;\n    pos.y += model.y;\n    gl_Position = p*pos;\n   ") : ("    gl_Position = wcp*vec4(position.xy, position.z, 1);\n    gl_Position.xy += model;\n   ")), ((this.key.texture) ? ("\n    UV = vertexUV;") : ("")));
    }
    public String fragment() {
        return String.format("%s\n\n%s\nuniform lowp vec4 color;\nuniform lowp float alphaTestLevel;\n%s lowp vec4 fColor;\n%s\n\nvoid main(void) {%s\n   %s\n   %s%s\n}", this.versionString(), ((this.key.texture) ? (String.format("%s mediump vec2 UV;\nuniform lowp sampler2D txt;", this.in())) : ("")), this.in(), ((this.key.shadow && this.version() > 100) ? ("out float depth;") : (String.format("%s", this.fragColorDeclaration()))), ((this.key.shadow && !(this.isFragColorDeclared())) ? ("\n    lowp vec4 fragColor;") : ("")), ((this.key.texture) ? (String.format("    %s = fColor * color * %s(txt, UV);\n   ", this.fragColor(), this.texture2D())) : (String.format("    %s = fColor * color;\n   ", this.fragColor()))), ((this.key.alpha) ? (String.format("    if(%s.a < alphaTestLevel) {\n        discard;\n    }\n   ", this.fragColor())) : ("")), ((this.key.shadow && this.version() > 100) ? ("\n    depth = gl_FragCoord.z;") : ("")));
    }
    public ShaderProgram program() {
        return ShaderProgram.applyNameVertexFragment("Billboard", this.vertex(), this.fragment());
    }
    public BillboardShaderBuilder(final BillboardShaderKey key) {
        this.key = key;
    }
    public String toString() {
        return String.format("BillboardShaderBuilder(%s)", this.key);
    }
}