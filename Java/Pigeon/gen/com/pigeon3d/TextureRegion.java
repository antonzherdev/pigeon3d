package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.geometry.Rect;
import com.pigeon3d.geometry.vec2;

public final class TextureRegion extends Texture {
    public final Texture texture;
    public final Rect uv;
    @Override
    public Rect uv() {
        return uv;
    }
    public final int id;
    @Override
    public int id() {
        return id;
    }
    public final vec2 size;
    @Override
    public vec2 size() {
        return size;
    }
    public static TextureRegion applyTexture(final Texture texture) {
        return new TextureRegion(texture, Rect.applyXYWidthHeight(((float)(0)), ((float)(0)), ((float)(1)), ((float)(1))));
    }
    @Override
    public double scale() {
        return this.texture.scale();
    }
    @Override
    public void deleteTexture() {
    }
    public TextureRegion(final Texture texture, final Rect uv) {
        this.texture = texture;
        this.uv = uv;
        this.id = texture.id();
        this.size = vec2.mulVec2(texture.size(), uv.size);
    }
    public String toString() {
        return String.format("TextureRegion(%s, %s)", this.texture, this.uv);
    }
    public boolean equals(final Object to) {
        if(this == to) {
            return true;
        }
        if(to == null || !(to instanceof TextureRegion)) {
            return false;
        }
        final TextureRegion o = ((TextureRegion)(to));
        return this.texture.equals(o.texture) && this.uv.equals(o.uv);
    }
    public int hashCode() {
        int hash = 0;
        hash = hash * 31 + this.texture.hashCode();
        hash = hash * 31 + Rect.hashCode(this.uv);
        return hash;
    }
}