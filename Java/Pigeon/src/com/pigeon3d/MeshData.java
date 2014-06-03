package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.geometry.vec2;
import com.pigeon3d.geometry.vec3;
import com.pigeon3d.geometry.vec4;
import com.pigeon3d.geometry.mat4;

public class MeshData {
    public vec2 uv;
    public vec3 normal;
    public vec3 position;
    public MeshData mulMat4(final mat4 mat4) {
        return new MeshData(this.uv, vec4.xyz(mat4.mulVec4(vec4.applyVec3W(this.normal, ((float)(0))))), vec4.xyz(mat4.mulVec4(vec4.applyVec3W(this.position, ((float)(1))))));
    }
    public MeshData uvAddVec2(final vec2 vec2) {
        return new MeshData(vec2.addVec2(this.uv, vec2), this.normal, this.position);
    }
    public MeshData(final vec2 uv, final vec3 normal, final vec3 position) {
        this.uv = uv;
        this.normal = normal;
        this.position = position;
    }
    public String toString() {
        return String.format("MeshData(%s, %s, %s)", this.uv, this.normal, this.position);
    }
    public boolean equals(final MeshData to) {
        return this.uv.equals(to.uv) && this.normal.equals(to.normal) && this.position.equals(to.position);
    }
    public int hashCode() {
        int hash = 0;
        hash = hash * 31 + vec2.hashCode(this.uv);
        hash = hash * 31 + vec3.hashCode(this.normal);
        hash = hash * 31 + vec3.hashCode(this.position);
        return hash;
    }
}