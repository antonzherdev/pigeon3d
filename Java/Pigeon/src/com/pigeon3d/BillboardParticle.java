package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.geometry.vec3;
import com.pigeon3d.geometry.Quad;
import com.pigeon3d.geometry.vec4;

public class BillboardParticle {
    public vec3 position;
    public Quad uv;
    public Quad model;
    public vec4 color;
    public Pointer writeToArray(final Pointer array) {
        Pointer pp = array;
        ERROR: Unknown <lm>pp\BillboardBufferData#S*\-><fIUms>position\vec3#S\ = this.position;
        ERROR: Unknown <lm>pp\BillboardBufferData#S*\-><fIUms>model\vec2#S\ = this.model.p0;
        ERROR: Unknown <lm>pp\BillboardBufferData#S*\-><fIUms>color\vec4#S\ = this.color;
        ERROR: Unknown <lm>pp\BillboardBufferData#S*\-><fIUms>uv\vec2#S\ = this.uv.p0;
        pp++;
        ERROR: Unknown <lm>pp\BillboardBufferData#S*\-><fIUms>position\vec3#S\ = this.position;
        ERROR: Unknown <lm>pp\BillboardBufferData#S*\-><fIUms>model\vec2#S\ = this.model.p1;
        ERROR: Unknown <lm>pp\BillboardBufferData#S*\-><fIUms>color\vec4#S\ = this.color;
        ERROR: Unknown <lm>pp\BillboardBufferData#S*\-><fIUms>uv\vec2#S\ = this.uv.p1;
        pp++;
        ERROR: Unknown <lm>pp\BillboardBufferData#S*\-><fIUms>position\vec3#S\ = this.position;
        ERROR: Unknown <lm>pp\BillboardBufferData#S*\-><fIUms>model\vec2#S\ = this.model.p2;
        ERROR: Unknown <lm>pp\BillboardBufferData#S*\-><fIUms>color\vec4#S\ = this.color;
        ERROR: Unknown <lm>pp\BillboardBufferData#S*\-><fIUms>uv\vec2#S\ = this.uv.p2;
        pp++;
        ERROR: Unknown <lm>pp\BillboardBufferData#S*\-><fIUms>position\vec3#S\ = this.position;
        ERROR: Unknown <lm>pp\BillboardBufferData#S*\-><fIUms>model\vec2#S\ = this.model.p3;
        ERROR: Unknown <lm>pp\BillboardBufferData#S*\-><fIUms>color\vec4#S\ = this.color;
        ERROR: Unknown <lm>pp\BillboardBufferData#S*\-><fIUms>uv\vec2#S\ = this.uv.p3;
        return pp + 1;
    }
    public BillboardParticle(final vec3 position, final Quad uv, final Quad model, final vec4 color) {
        this.position = position;
        this.uv = uv;
        this.model = model;
        this.color = color;
    }
    public String toString() {
        return String.format("BillboardParticle(%s, %s, %s, %s)", this.position, this.uv, this.model, this.color);
    }
    public boolean equals(final BillboardParticle to) {
        return this.position.equals(to.position) && this.uv.equals(to.uv) && this.model.equals(to.model) && this.color.equals(to.color);
    }
    public int hashCode() {
        int hash = 0;
        hash = hash * 31 + vec3.hashCode(this.position);
        hash = hash * 31 + Quad.hashCode(this.uv);
        hash = hash * 31 + Quad.hashCode(this.model);
        hash = hash * 31 + vec4.hashCode(this.color);
        return hash;
    }
}