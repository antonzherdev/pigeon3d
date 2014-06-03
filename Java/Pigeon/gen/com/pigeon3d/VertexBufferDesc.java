package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.geometry.vec2;
import com.pigeon3d.geometry.vec3;
import com.pigeon3d.geometry.vec4;

public class VertexBufferDesc<T> {
    public final PType<T> dataType;
    public final int position;
    public final int uv;
    public final int normal;
    public final int color;
    public final int model;
    public int stride() {
        return ((int)(this.dataType.size));
    }
    public static VertexBufferDesc<vec2> Vec2() {
        return new VertexBufferDesc<vec2>(vec2.type, ((int)(-1)), ((int)(0)), ((int)(-1)), ((int)(-1)), ((int)(0)));
    }
    public static VertexBufferDesc<vec3> Vec3() {
        return new VertexBufferDesc<vec3>(vec3.type, ((int)(0)), ((int)(0)), ((int)(0)), ((int)(-1)), ((int)(0)));
    }
    public static VertexBufferDesc<vec4> Vec4() {
        return new VertexBufferDesc<vec4>(vec4.type, ((int)(0)), ((int)(0)), ((int)(0)), ((int)(0)), ((int)(0)));
    }
    public static VertexBufferDesc<MeshData> mesh() {
        return new VertexBufferDesc<MeshData>(MeshData.type, ((int)(5 * 4)), ((int)(0)), ((int)(2 * 4)), ((int)(-1)), ((int)(-1)));
    }
    public VertexBufferDesc(final PType<T> dataType, final int position, final int uv, final int normal, final int color, final int model) {
        this.dataType = dataType;
        this.position = position;
        this.uv = uv;
        this.normal = normal;
        this.color = color;
        this.model = model;
    }
    public String toString() {
        return String.format("VertexBufferDesc(%s, %d, %d, %d, %d, %d)", this.dataType, this.position, this.uv, this.normal, this.color, this.model);
    }
}