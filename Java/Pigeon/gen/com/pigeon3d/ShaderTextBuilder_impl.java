package com.pigeon3d;

import objd.lang.*;

public abstract class ShaderTextBuilder_impl implements ShaderTextBuilder {
    public ShaderTextBuilder_impl() {
    }
    public String versionString() {
        return String.format("#version %d", this.version());
    }
    public String vertexHeader() {
        return String.format("#version %d", this.version());
    }
    public String fragmentHeader() {
        return String.format("#version %d\n%s", this.version(), this.fragColorDeclaration());
    }
    public String fragColorDeclaration() {
        if(this.isFragColorDeclared()) {
            return "";
        } else {
            return "out lowp vec4 fragColor;";
        }
    }
    public boolean isFragColorDeclared() {
        return ShaderProgram.version < 110;
    }
    public int version() {
        return ShaderProgram.version;
    }
    public String ain() {
        if(this.version() < 150) {
            return "attribute";
        } else {
            return "in";
        }
    }
    public String in() {
        if(this.version() < 150) {
            return "varying";
        } else {
            return "in";
        }
    }
    public String out() {
        if(this.version() < 150) {
            return "varying";
        } else {
            return "out";
        }
    }
    public String fragColor() {
        if(this.version() > 100) {
            return "fragColor";
        } else {
            return "gl_FragColor";
        }
    }
    public String texture2D() {
        if(this.version() > 100) {
            return "texture";
        } else {
            return "texture2D";
        }
    }
    public String shadowExt() {
        if(this.version() == 100 && Global.settings.shadowType() == ShadowType.shadow2d) {
            return "#extension GL_EXT_shadow_samplers : require";
        } else {
            return "";
        }
    }
    public String sampler2DShadow() {
        if(Global.settings.shadowType() == ShadowType.shadow2d) {
            return "sampler2DShadow";
        } else {
            return "sampler2D";
        }
    }
    public String shadow2DTextureVec3(final String texture, final String vec3) {
        if(Global.settings.shadowType() == ShadowType.shadow2d) {
            return String.format("%s(%s, %s)", this.shadow2DEXT(), texture, vec3);
        } else {
            return String.format("(%s(%s, %s.xy).x < %s.z ? 0.0 : 1.0)", this.texture2D(), texture, vec3, vec3);
        }
    }
    public String blendModeAB(final BlendMode mode, final String a, final String b) {
        return mode.blend.apply(a, b);
    }
    public String shadow2DEXT() {
        if(this.version() == 100) {
            return "shadow2DEXT";
        } else {
            return "texture";
        }
    }
}