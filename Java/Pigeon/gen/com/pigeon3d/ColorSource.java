package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.geometry.vec4;
import com.pigeon3d.geometry.Rect;

public class ColorSource extends Material {
    public final vec4 color;
    public final Texture texture;
    public final BlendMode blendMode;
    public final float alphaTestLevel;
    public static ColorSource applyColorTexture(final vec4 color, final Texture texture) {
        return new ColorSource(color, texture, BlendMode.multiply, ((float)(-1)));
    }
    public static ColorSource applyColorTextureAlphaTestLevel(final vec4 color, final Texture texture, final float alphaTestLevel) {
        return new ColorSource(color, texture, BlendMode.multiply, alphaTestLevel);
    }
    public static ColorSource applyColorTextureBlendMode(final vec4 color, final Texture texture, final BlendMode blendMode) {
        return new ColorSource(color, texture, blendMode, ((float)(-1)));
    }
    public static ColorSource applyColor(final vec4 color) {
        return new ColorSource(color, null, BlendMode.first, ((float)(-1)));
    }
    public static ColorSource applyTexture(final Texture texture) {
        return new ColorSource(new vec4(((float)(1)), ((float)(1)), ((float)(1)), ((float)(1))), texture, BlendMode.second, ((float)(-1)));
    }
    @Override
    public ShaderSystem<ColorSource> shaderSystem() {
        return ((ShaderSystem<ColorSource>)(((ShaderSystem)(SimpleShaderSystem.instance))));
    }
    public ColorSource setColor(final vec4 color) {
        return new ColorSource(color, this.texture, this.blendMode, this.alphaTestLevel);
    }
    public Rect uv() {
        if(this.texture != null) {
            if(this.texture == null) {
                throw new NullPointerException();
            }
            return this.texture.uv();
        } else {
            return Rect.applyXYWidthHeight(((float)(0)), ((float)(0)), ((float)(1)), ((float)(1)));
        }
    }
    public ColorSource(final vec4 color, final Texture texture, final BlendMode blendMode, final float alphaTestLevel) {
        this.color = color;
        this.texture = texture;
        this.blendMode = blendMode;
        this.alphaTestLevel = alphaTestLevel;
    }
    public String toString() {
        return String.format("ColorSource(%s, %s, %s, %f)", this.color, this.texture, this.blendMode, this.alphaTestLevel);
    }
}