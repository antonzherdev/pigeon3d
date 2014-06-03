package com.pigeon3d;

import objd.lang.*;

public final class ShadowDrawShaderKey extends ShaderTextBuilder_impl {
    public final int directLightCount;
    public final boolean viewportSurface;
    public ShadowDrawShader shader() {
        final String vertexShader = String.format("%s\n%s highp vec3 position;\nuniform mat4 mwcp;\n%s\n%s\n%s\n\nvoid main(void) {\n   gl_Position = mwcp * vec4(position, 1);\n  %s\n   %s\n}", this.vertexHeader(), this.ain(), this.lightsVertexUniform(), this.lightsOut(), ((this.viewportSurface) ? (String.format("%s mediump vec2 viewportUV;", this.out())) : ("")), ((this.viewportSurface) ? ("   viewportUV = gl_Position.xy*0.5 + vec2(0.5, 0.5);\n  ") : ("")), this.lightsCalculateVaryings());
        final String fragmentShader = String.format("%s\n%s\n%s\n%s\n%s\n\nvoid main(void) {\n   lowp float visibility;\n   lowp float a = 0.0;\n   %s\n   %s = vec4(0, 0, 0, a) + (1.0 - a)*%s(viewport, viewportUV);\n}", this.fragmentHeader(), this.shadowExt(), ((this.viewportSurface) ? (String.format("uniform lowp sampler2D viewport;\n%s mediump vec2 viewportUV;", this.in())) : ("")), this.lightsIn(), this.lightsFragmentUniform(), this.lightsDiffuse(), this.fragColor(), this.texture2D());
        return new ShadowDrawShader(this, ShaderProgram.applyNameVertexFragment("ShadowDraw", vertexShader, fragmentShader));
    }
    public String lightsVertexUniform() {
        if(Global.settings.shadowType().isOff()) {
            return "";
        } else {
            return UInt.range(this.directLightCount).chain().<String>mapF(new F<Integer, String>() {
                @Override
                public String apply(final Integer i) {
                    return String.format("uniform mat4 dirLightDepthMwcp%s;", i);
                }
            }).toStringDelimiter("\n");
        }
    }
    public String lightsIn() {
        if(Global.settings.shadowType().isOff()) {
            return "";
        } else {
            return UInt.range(this.directLightCount).chain().<String>mapF(new F<Integer, String>() {
                @Override
                public String apply(final Integer i) {
                    return String.format("%s mediump vec3 dirLightShadowCoord%s;", ShadowDrawShaderKey.this.in(), i);
                }
            }).toStringDelimiter("\n");
        }
    }
    public String lightsOut() {
        if(Global.settings.shadowType().isOff()) {
            return "";
        } else {
            return UInt.range(this.directLightCount).chain().<String>mapF(new F<Integer, String>() {
                @Override
                public String apply(final Integer i) {
                    return String.format("%s mediump vec3 dirLightShadowCoord%s;", ShadowDrawShaderKey.this.out(), i);
                }
            }).toStringDelimiter("\n");
        }
    }
    public String lightsCalculateVaryings() {
        return UInt.range(this.directLightCount).chain().<String>mapF(new F<Integer, String>() {
            @Override
            public String apply(final Integer i) {
                if(Global.settings.shadowType().isOff()) {
                    return "";
                } else {
                    return String.format("dirLightShadowCoord%s = (dirLightDepthMwcp%s * vec4(position, 1)).xyz;\ndirLightShadowCoord%s.z -= 0.005;", i, i, i);
                }
            }
        }).toStringDelimiter("\n");
    }
    public String lightsFragmentUniform() {
        if(Global.settings.shadowType().isOff()) {
            return "";
        } else {
            return UInt.range(this.directLightCount).chain().<String>mapF(new F<Integer, String>() {
                @Override
                public String apply(final Integer i) {
                    return String.format("uniform lowp float dirLightPercent%s;\nuniform mediump %s dirLightShadow%s;", i, ShadowDrawShaderKey.this.sampler2DShadow(), i);
                }
            }).toStringDelimiter("\n");
        }
    }
    public String lightsDiffuse() {
        return UInt.range(this.directLightCount).chain().<String>mapF(new F<Integer, String>() {
            @Override
            public String apply(final Integer i) {
                return String.format("a += dirLightPercent%s*(1.0 - %s);", i, shadow2DTextureVec3(String.format("dirLightShadow%s", i), String.format("dirLightShadowCoord%s", i)));
            }
        }).toStringDelimiter("\n");
    }
    public ShadowDrawShaderKey(final int directLightCount, final boolean viewportSurface) {
        this.directLightCount = directLightCount;
        this.viewportSurface = viewportSurface;
    }
    public String toString() {
        return String.format("ShadowDrawShaderKey(%d, %d)", this.directLightCount, this.viewportSurface);
    }
    public boolean equals(final Object to) {
        if(this == to) {
            return true;
        }
        if(to == null || !(to instanceof ShadowDrawShaderKey)) {
            return false;
        }
        final ShadowDrawShaderKey o = ((ShadowDrawShaderKey)(to));
        return this.directLightCount == o.directLightCount && this.viewportSurface.equals(o.viewportSurface);
    }
    public int hashCode() {
        int hash = 0;
        hash = hash * 31 + this.directLightCount;
        hash = hash * 31 + this.viewportSurface;
        return hash;
    }
}