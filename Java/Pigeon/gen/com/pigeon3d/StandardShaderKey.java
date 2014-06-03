package com.pigeon3d;

import objd.lang.*;

public final class StandardShaderKey extends ShaderTextBuilder_impl {
    public final int directLightWithShadowsCount;
    public final int directLightWithoutShadowsCount;
    public final boolean texture;
    public final BlendMode blendMode;
    public final boolean region;
    public final boolean specular;
    public final boolean normalMap;
    public final boolean perPixel;
    public final boolean needUV;
    public final int directLightCount;
    public StandardShader shader() {
        final String vertexShader = String.format("%s\n%s\n\n%s highp vec3 position;\nuniform highp mat4 mwcp;\nuniform highp mat4 mwc;\n%s\n%s\n\n%s\n%s\n%s\n%s\n\nvoid main(void) {\n%s eyeDirection = normalize(-(mwc * vec4(position, 1)).xyz);\n%s\n   gl_Position = mwcp * vec4(position, 1);\n%s\n   %s\n}", this.vertexHeader(), ((!(this.normalMap)) ? (String.format("%s mediump vec3 normal;", this.ain())) : ("")), this.ain(), ((this.region) ? ("uniform mediump vec2 uvShift;\nuniform mediump vec2 uvScale;") : ("")), this.lightsVertexUniform(), ((this.needUV || this.normalMap) ? (String.format("%s mediump vec2 vertexUV;\n%s mediump vec2 UV;", this.ain(), this.out())) : ("")), ((this.perPixel) ? (String.format("%s mediump vec3 eyeDirection;", this.out())) : ("")), ((this.perPixel && !(this.normalMap)) ? (String.format("   %s mediump vec3 normalMWC;", this.out())) : ("")), this.lightsOut(), ((!(this.perPixel)) ? ("vec3") : ("")), ((!(this.normalMap) || !(this.perPixel)) ? (String.format("   %s normalMWC = normalize((mwc * vec4(normal, 0)).xyz);", ((!(this.perPixel)) ? ("vec3") : ("")))) : ("")), ((this.needUV && this.region) ? ("   UV = uvScale*vertexUV + uvShift;") : (String.format("%s", ((this.needUV) ? ("\n   UV = vertexUV; ") : (""))))), this.lightsCalculateVaryings());
        final String fragmentShader = String.format("%s\n%s\n%s\n%s\nuniform lowp vec4 diffuseColor;\nuniform lowp vec4 ambientColor;\n%s\n%s\n%s\n%s\n\nvoid main(void) {%s\n   lowp vec4 materialColor = %s;\n  %s\n   lowp vec4 color = ambientColor * materialColor;\n   %s\n   %s = color;\n}", this.fragmentHeader(), this.shadowExt(), ((this.needUV) ? (String.format("%s mediump vec2 UV;\nuniform lowp sampler2D diffuseTexture;", this.in())) : ("")), ((this.normalMap) ? ("uniform lowp sampler2D normalMap;") : ("")), ((this.specular) ? ("uniform lowp vec4 specularColor;\nuniform lowp float specularSize;") : ("")), ((this.perPixel) ? (String.format("%s mediump vec3 eyeDirection;\n   %s", this.in(), ((this.normalMap) ? ("    uniform highp mat4 mwc;\n   ") : (String.format("    %s mediump vec3 normalMWC;\n   ", this.in()))))) : ("")), this.lightsIn(), this.lightsFragmentUniform(), ((this.directLightWithShadowsCount > 0) ? ("\n   highp float visibility;") : ("")), blendModeAB(this.blendMode, "diffuseColor", String.format("%s(diffuseTexture, UV)", this.texture2D())), ((this.normalMap) ? (String.format("   mediump vec3 normalMWC = normalize((mwc * vec4(2.0*%s(normalMap, UV).xyz - 1.0, 0)).xyz);\n  ", this.texture2D())) : ("")), this.lightsDiffuse(), this.fragColor());
        return new StandardShader(this, ShaderProgram.applyNameVertexFragment("Standard", vertexShader, fragmentShader));
    }
    public String lightsVertexUniform() {
        return UInt.range(this.directLightCount).chain().<String>mapF(new F<Integer, String>() {
            @Override
            public String apply(final Integer i) {
                return String.format("%s\n%s\n", ((!(StandardShaderKey.this.perPixel)) ? (String.format("uniform mediump vec3 dirLightDirection%s;", i)) : ("")), ((i < StandardShaderKey.this.directLightWithShadowsCount) ? (String.format("uniform highp mat4 dirLightDepthMwcp%s;", i)) : ("")));
            }
        }).toStringDelimiter("\n");
    }
    public String lightsIn() {
        return UInt.range(this.directLightCount).chain().<String>mapF(new F<Integer, String>() {
            @Override
            public String apply(final Integer i) {
                return String.format("%s\n%s\n%s\n", ((!(StandardShaderKey.this.perPixel)) ? (String.format("%s mediump float dirLightDirectionCos%s;", StandardShaderKey.this.in(), i)) : ("")), ((StandardShaderKey.this.specular && !(StandardShaderKey.this.perPixel)) ? (String.format("%s mediump float dirLightDirectionCosA%s;", StandardShaderKey.this.in(), i)) : ("")), ((i < StandardShaderKey.this.directLightWithShadowsCount) ? (String.format("%s highp vec3 dirLightShadowCoord%s;", StandardShaderKey.this.in(), i)) : ("")));
            }
        }).toStringDelimiter("\n");
    }
    public String lightsOut() {
        return UInt.range(this.directLightCount).chain().<String>mapF(new F<Integer, String>() {
            @Override
            public String apply(final Integer i) {
                return String.format("%s\n%s\n%s\n", ((!(StandardShaderKey.this.perPixel)) ? (String.format("%s mediump float dirLightDirectionCos%s;", StandardShaderKey.this.out(), i)) : ("")), ((StandardShaderKey.this.specular && !(StandardShaderKey.this.perPixel)) ? (String.format("%s mediump float dirLightDirectionCosA%s;", StandardShaderKey.this.out(), i)) : ("")), ((i < StandardShaderKey.this.directLightWithShadowsCount) ? (String.format("%s highp vec3 dirLightShadowCoord%s;", StandardShaderKey.this.out(), i)) : ("")));
            }
        }).toStringDelimiter("\n");
    }
    public String lightsCalculateVaryings() {
        return UInt.range(this.directLightCount).chain().<String>mapF(new F<Integer, String>() {
            @Override
            public String apply(final Integer i) {
                return String.format("%s\n%s\n%s\n", ((!(StandardShaderKey.this.perPixel)) ? (String.format("dirLightDirectionCos%s = max(dot(normalMWC, -dirLightDirection%s), 0.0);", i, i)) : ("")), ((StandardShaderKey.this.specular && !(StandardShaderKey.this.perPixel)) ? (String.format("dirLightDirectionCosA%s = max(dot(eyeDirection, reflect(dirLightDirection%s, normalMWC)), 0.0);", i, i)) : ("")), ((i < StandardShaderKey.this.directLightWithShadowsCount) ? (String.format("dirLightShadowCoord%s = (dirLightDepthMwcp%s * vec4(position, 1)).xyz;\ndirLightShadowCoord%s.z -= 0.0005;", i, i, i)) : ("")));
            }
        }).toStringDelimiter("\n");
    }
    public String lightsFragmentUniform() {
        return UInt.range(this.directLightCount).chain().<String>mapF(new F<Integer, String>() {
            @Override
            public String apply(final Integer i) {
                return String.format("uniform lowp vec4 dirLightColor%s;\n%s\n%s", i, ((StandardShaderKey.this.perPixel) ? (String.format("uniform mediump vec3 dirLightDirection%s;", i)) : ("")), ((i < StandardShaderKey.this.directLightWithShadowsCount) ? (String.format("uniform highp %s dirLightShadow%s;", StandardShaderKey.this.sampler2DShadow(), i)) : ("")));
            }
        }).toStringDelimiter("\n");
    }
    public String lightsDiffuse() {
        return UInt.range(this.directLightCount).chain().<String>mapF(new F<Integer, String>() {
            @Override
            public String apply(final Integer i) {
                return String.format("\n%s\n%s\n%s\n%s\n", ((StandardShaderKey.this.perPixel) ? (String.format("mediump float dirLightDirectionCos%s = max(dot(normalMWC, -dirLightDirection%s), 0.0);", i, i)) : ("")), ((StandardShaderKey.this.specular && StandardShaderKey.this.perPixel) ? (String.format("mediump float dirLightDirectionCosA%s = max(dot(eyeDirection, reflect(dirLightDirection%s, normalMWC)), 0.0);", i, i)) : ("")), ((i < StandardShaderKey.this.directLightWithShadowsCount) ? (String.format("visibility = %s;\ncolor += visibility * dirLightDirectionCos%s * (materialColor * dirLightColor%s);", shadow2DTextureVec3(String.format("dirLightShadow%s", i), String.format("dirLightShadowCoord%s", i)), i, i)) : (String.format("color += dirLightDirectionCos%s * (materialColor * dirLightColor%s);", i, i))), ((StandardShaderKey.this.specular && i < StandardShaderKey.this.directLightWithShadowsCount) ? (String.format("color += max(visibility * specularColor * dirLightColor%s * pow(dirLightDirectionCosA%s, 5.0/specularSize), vec4(0, 0, 0, 0));", i, i)) : (String.format("%s", ((StandardShaderKey.this.specular) ? (String.format("color += max(specularColor * dirLightColor%s * pow(dirLightDirectionCosA%s, 5.0/specularSize), vec4(0, 0, 0, 0));", i, i)) : (""))))));
            }
        }).toStringDelimiter("\n");
    }
    public StandardShaderKey(final int directLightWithShadowsCount, final int directLightWithoutShadowsCount, final boolean texture, final BlendMode blendMode, final boolean region, final boolean specular, final boolean normalMap) {
        this.directLightWithShadowsCount = directLightWithShadowsCount;
        this.directLightWithoutShadowsCount = directLightWithoutShadowsCount;
        this.texture = texture;
        this.blendMode = blendMode;
        this.region = region;
        this.specular = specular;
        this.normalMap = normalMap;
        this.perPixel = normalMap;
        this.needUV = normalMap || texture;
        this.directLightCount = directLightWithShadowsCount + directLightWithoutShadowsCount;
    }
    public String toString() {
        return String.format("StandardShaderKey(%d, %d, %d, %s, %d, %d, %d)", this.directLightWithShadowsCount, this.directLightWithoutShadowsCount, this.texture, this.blendMode, this.region, this.specular, this.normalMap);
    }
    public boolean equals(final Object to) {
        if(this == to) {
            return true;
        }
        if(to == null || !(to instanceof StandardShaderKey)) {
            return false;
        }
        final StandardShaderKey o = ((StandardShaderKey)(to));
        return this.directLightWithShadowsCount == o.directLightWithShadowsCount && this.directLightWithoutShadowsCount == o.directLightWithoutShadowsCount && this.texture.equals(o.texture) && this.blendMode == o.blendMode && this.region.equals(o.region) && this.specular.equals(o.specular) && this.normalMap.equals(o.normalMap);
    }
    public int hashCode() {
        int hash = 0;
        hash = hash * 31 + this.directLightWithShadowsCount;
        hash = hash * 31 + this.directLightWithoutShadowsCount;
        hash = hash * 31 + this.texture;
        hash = hash * 31 + this.blendMode.hashCode();
        hash = hash * 31 + this.region;
        hash = hash * 31 + this.specular;
        hash = hash * 31 + this.normalMap;
        return hash;
    }
}