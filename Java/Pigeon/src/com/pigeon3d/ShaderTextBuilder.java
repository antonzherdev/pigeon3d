package com.pigeon3d;

import objd.lang.*;

public interface ShaderTextBuilder {
    String versionString();
    String vertexHeader();
    String fragmentHeader();
    String fragColorDeclaration();
    boolean isFragColorDeclared();
    int version();
    String ain();
    String in();
    String out();
    String fragColor();
    String texture2D();
    String shadowExt();
    String sampler2DShadow();
    String shadow2DTextureVec3(final String texture, final String vec3);
    String blendModeAB(final BlendMode mode, final String a, final String b);
    String shadow2DEXT();
    String toString();
}