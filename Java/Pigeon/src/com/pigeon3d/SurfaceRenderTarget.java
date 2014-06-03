package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.geometry.vec2i;

public abstract class SurfaceRenderTarget {
    public abstract void link();
    public final vec2i size;
    public SurfaceRenderTarget(final vec2i size) {
        this.size = size;
    }
    public String toString() {
        return String.format("SurfaceRenderTarget(%s)", this.size);
    }
}