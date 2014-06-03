package com.pigeon3d;

import objd.lang.*;

public class NormalMap {
    public final Texture texture;
    public final boolean tangent;
    public NormalMap(final Texture texture, final boolean tangent) {
        this.texture = texture;
        this.tangent = tangent;
    }
    public String toString() {
        return String.format("NormalMap(%s, %d)", this.texture, this.tangent);
    }
}