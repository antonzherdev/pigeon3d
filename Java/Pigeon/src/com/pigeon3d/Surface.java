package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.geometry.vec2i;

public abstract class Surface {
    public abstract void bind();
    public abstract void unbind();
    public abstract int frameBuffer();
    public final vec2i size;
    public void applyDraw(final P0 draw) {
        this.bind();
        draw.apply();
        this.unbind();
    }
    public Surface(final vec2i size) {
        this.size = size;
    }
    public String toString() {
        return String.format("Surface(%s)", this.size);
    }
}