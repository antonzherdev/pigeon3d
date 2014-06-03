package com.pigeon3d;

import objd.lang.*;

public final class ViewportSurfaceShaderParam {
    public final Texture texture;
    public final float z;
    public ViewportSurfaceShaderParam(final Texture texture, final float z) {
        this.texture = texture;
        this.z = z;
    }
    public String toString() {
        return String.format("ViewportSurfaceShaderParam(%s, %f)", this.texture, this.z);
    }
    public boolean equals(final Object to) {
        if(this == to) {
            return true;
        }
        if(to == null || !(to instanceof ViewportSurfaceShaderParam)) {
            return false;
        }
        final ViewportSurfaceShaderParam o = ((ViewportSurfaceShaderParam)(to));
        return this.texture.equals(o.texture) && this.z.equals(o.z);
    }
    public int hashCode() {
        int hash = 0;
        hash = hash * 31 + this.texture.hashCode();
        hash = hash * 31 + Float4.hashCode(this.z);
        return hash;
    }
}