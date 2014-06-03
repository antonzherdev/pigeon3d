package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.geometry.vec4;
import com.pigeon3d.geometry.vec2;

public final class TextShadow {
    public final vec4 color;
    public final vec2 shift;
    public TextShadow(final vec4 color, final vec2 shift) {
        this.color = color;
        this.shift = shift;
    }
    public String toString() {
        return String.format("TextShadow(%s, %s)", this.color, this.shift);
    }
    public boolean equals(final Object to) {
        if(this == to) {
            return true;
        }
        if(to == null || !(to instanceof TextShadow)) {
            return false;
        }
        final TextShadow o = ((TextShadow)(to));
        return this.color.equals(o.color) && this.shift.equals(o.shift);
    }
    public int hashCode() {
        int hash = 0;
        hash = hash * 31 + vec4.hashCode(this.color);
        hash = hash * 31 + vec2.hashCode(this.shift);
        return hash;
    }
}