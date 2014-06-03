package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.geometry.vec4;
import com.pigeon3d.geometry.vec2;

public final class FontShaderParam {
    public final Texture texture;
    public final vec4 color;
    public final vec2 shift;
    public FontShaderParam(final Texture texture, final vec4 color, final vec2 shift) {
        this.texture = texture;
        this.color = color;
        this.shift = shift;
    }
    public String toString() {
        return String.format("FontShaderParam(%s, %s, %s)", this.texture, this.color, this.shift);
    }
    public boolean equals(final Object to) {
        if(this == to) {
            return true;
        }
        if(to == null || !(to instanceof FontShaderParam)) {
            return false;
        }
        final FontShaderParam o = ((FontShaderParam)(to));
        return this.texture.equals(o.texture) && this.color.equals(o.color) && this.shift.equals(o.shift);
    }
    public int hashCode() {
        int hash = 0;
        hash = hash * 31 + this.texture.hashCode();
        hash = hash * 31 + vec4.hashCode(this.color);
        hash = hash * 31 + vec2.hashCode(this.shift);
        return hash;
    }
}