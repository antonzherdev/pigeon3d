package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.geometry.vec2;
import com.pigeon3d.gl.eg;

public final class EmptyTexture extends Texture {
    public final vec2 size;
    @Override
    public vec2 size() {
        return size;
    }
    public final int id;
    @Override
    public int id() {
        return id;
    }
    public EmptyTexture(final vec2 size) {
        this.size = size;
        this.id = eg.egGenTexture();
    }
    public String toString() {
        return String.format("EmptyTexture(%s)", this.size);
    }
    public boolean equals(final Object to) {
        if(this == to) {
            return true;
        }
        if(to == null || !(to instanceof EmptyTexture)) {
            return false;
        }
        final EmptyTexture o = ((EmptyTexture)(to));
        return this.size.equals(o.size);
    }
    public int hashCode() {
        int hash = 0;
        hash = hash * 31 + vec2.hashCode(this.size);
        return hash;
    }
}