package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.geometry.vec2;
import com.pigeon3d.geometry.Rect;

public final class FontSymbolDesc {
    public final float width;
    public final vec2 offset;
    public final vec2 size;
    public final Rect textureRect;
    public final boolean isNewLine;
    public FontSymbolDesc(final float width, final vec2 offset, final vec2 size, final Rect textureRect, final boolean isNewLine) {
        this.width = width;
        this.offset = offset;
        this.size = size;
        this.textureRect = textureRect;
        this.isNewLine = isNewLine;
    }
    public String toString() {
        return String.format("FontSymbolDesc(%f, %s, %s, %s, %d)", this.width, this.offset, this.size, this.textureRect, this.isNewLine);
    }
    public boolean equals(final Object to) {
        if(this == to) {
            return true;
        }
        if(to == null || !(to instanceof FontSymbolDesc)) {
            return false;
        }
        final FontSymbolDesc o = ((FontSymbolDesc)(to));
        return this.width.equals(o.width) && this.offset.equals(o.offset) && this.size.equals(o.size) && this.textureRect.equals(o.textureRect) && this.isNewLine.equals(o.isNewLine);
    }
    public int hashCode() {
        int hash = 0;
        hash = hash * 31 + Float4.hashCode(this.width);
        hash = hash * 31 + vec2.hashCode(this.offset);
        hash = hash * 31 + vec2.hashCode(this.size);
        hash = hash * 31 + Rect.hashCode(this.textureRect);
        hash = hash * 31 + this.isNewLine;
        return hash;
    }
}