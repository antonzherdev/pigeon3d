package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.geometry.vec4;

public class StandardMaterial extends Material {
    public final ColorSource diffuse;
    public final vec4 specularColor;
    public final double specularSize;
    public final NormalMap normalMap;
    public static StandardMaterial applyDiffuse(final ColorSource diffuse) {
        return new StandardMaterial(diffuse, new vec4(((float)(0)), ((float)(0)), ((float)(0)), ((float)(1))), ((double)(0)), null);
    }
    @Override
    public ShaderSystem<StandardMaterial> shaderSystem() {
        return ((ShaderSystem<StandardMaterial>)(((ShaderSystem)(StandardShaderSystem.instance))));
    }
    public StandardMaterial(final ColorSource diffuse, final vec4 specularColor, final double specularSize, final NormalMap normalMap) {
        this.diffuse = diffuse;
        this.specularColor = specularColor;
        this.specularSize = specularSize;
        this.normalMap = normalMap;
    }
    public String toString() {
        return String.format("StandardMaterial(%s, %s, %f, %s)", this.diffuse, this.specularColor, this.specularSize, this.normalMap);
    }
}