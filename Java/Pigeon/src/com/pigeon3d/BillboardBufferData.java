package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.geometry.vec3;
import com.pigeon3d.geometry.vec2;
import com.pigeon3d.geometry.vec4;

public class BillboardBufferData {
    public vec3 position;
    public vec2 model;
    public vec4 color;
    public vec2 uv;
    public BillboardBufferData(final vec3 position, final vec2 model, final vec4 color, final vec2 uv) {
        this.position = position;
        this.model = model;
        this.color = color;
        this.uv = uv;
    }
    public String toString() {
        return String.format("BillboardBufferData(%s, %s, %s, %s)", this.position, this.model, this.color, this.uv);
    }
    public boolean equals(final BillboardBufferData to) {
        return this.position.equals(to.position) && this.model.equals(to.model) && this.color.equals(to.color) && this.uv.equals(to.uv);
    }
    public int hashCode() {
        int hash = 0;
        hash = hash * 31 + vec3.hashCode(this.position);
        hash = hash * 31 + vec2.hashCode(this.model);
        hash = hash * 31 + vec4.hashCode(this.color);
        hash = hash * 31 + vec2.hashCode(this.uv);
        return hash;
    }
}