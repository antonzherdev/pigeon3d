package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.geometry.vec2;

public class FontPrintData {
    public vec2 position;
    public vec2 uv;
    public FontPrintData(final vec2 position, final vec2 uv) {
        this.position = position;
        this.uv = uv;
    }
    public String toString() {
        return String.format("FontPrintData(%s, %s)", this.position, this.uv);
    }
    public boolean equals(final FontPrintData to) {
        return this.position.equals(to.position) && this.uv.equals(to.uv);
    }
    public int hashCode() {
        int hash = 0;
        hash = hash * 31 + vec2.hashCode(this.position);
        hash = hash * 31 + vec2.hashCode(this.uv);
        return hash;
    }
}