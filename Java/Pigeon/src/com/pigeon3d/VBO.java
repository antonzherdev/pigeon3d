package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.gl.eg;
import android.opengl.GLES20;
import objd.collection.Buffer;
import com.pigeon3d.geometry.vec4;
import com.pigeon3d.geometry.Vec4Buffer;
import com.pigeon3d.geometry.vec3;
import com.pigeon3d.geometry.Vec3Buffer;
import com.pigeon3d.geometry.vec2;
import com.pigeon3d.geometry.Vec2Buffer;

public class VBO {
    public static <T> VertexBuffer<T> applyDescArrayCount(final VertexBufferDesc<T> desc, final Pointer array, final int count) {
        final int len = count * desc.dataType.size;
        final ImmutableVertexBuffer<T> vb = new ImmutableVertexBuffer<T>(desc, eg.egGenBuffer(), ((int)(len)), ((int)(count)));
        vb.bind();
        GLES20.glBufferData(GLES20.GL_ARRAY_BUFFER, ((long)(len)), array, GLES20.GL_STATIC_DRAW);
        return vb;
    }
    public static <T> VertexBuffer<T> applyDescBuffer(final VertexBufferDesc<T> desc, final Buffer<T> buffer) {
        final ImmutableVertexBuffer<T> vb = new ImmutableVertexBuffer<T>(desc, eg.egGenBuffer(), ((int)(buffer.length)), ((int)(buffer.count)));
        vb.bind();
        GLES20.glBufferData(GLES20.GL_ARRAY_BUFFER, ((long)(buffer.length)), buffer.bytes(), GLES20.GL_STATIC_DRAW);
        return vb;
    }
    public static VertexBuffer<vec4> vec4Data(final Vec4Buffer data) {
        return VBO.<vec4>applyDescBuffer(VertexBufferDesc.Vec4(), ((Buffer<vec4>)(((Buffer)(data)))));
    }
    public static VertexBuffer<vec3> vec3Data(final Vec3Buffer data) {
        return VBO.<vec3>applyDescBuffer(VertexBufferDesc.Vec3(), ((Buffer<vec3>)(((Buffer)(data)))));
    }
    public static VertexBuffer<vec2> vec2Data(final Vec2Buffer data) {
        return VBO.<vec2>applyDescBuffer(VertexBufferDesc.Vec2(), ((Buffer<vec2>)(((Buffer)(data)))));
    }
    public static VertexBuffer<MeshData> meshData(final MeshDataBuffer data) {
        return VBO.<MeshData>applyDescBuffer(VertexBufferDesc.mesh(), ((Buffer<MeshData>)(((Buffer)(data)))));
    }
    public static <T> MutableVertexBuffer<T> mutDescUsage(final VertexBufferDesc<T> desc, final int usage) {
        return new MutableVertexBuffer<T>(desc, eg.egGenBuffer(), usage);
    }
    public static <T> VertexBufferRing<T> ringSizeDescUsage(final int size, final VertexBufferDesc<T> desc, final int usage) {
        return new VertexBufferRing<T>(size, desc, usage);
    }
    public static MutableVertexBuffer<vec2> mutVec2Usage(final int usage) {
        return new MutableVertexBuffer<vec2>(VertexBufferDesc.Vec2(), eg.egGenBuffer(), usage);
    }
    public static MutableVertexBuffer<vec3> mutVec3Usage(final int usage) {
        return new MutableVertexBuffer<vec3>(VertexBufferDesc.Vec3(), eg.egGenBuffer(), usage);
    }
    public static MutableVertexBuffer<vec4> mutVec4Usage(final int usage) {
        return new MutableVertexBuffer<vec4>(VertexBufferDesc.Vec4(), eg.egGenBuffer(), usage);
    }
    public static MutableVertexBuffer<MeshData> mutMeshUsage(final int usage) {
        return new MutableVertexBuffer<MeshData>(VertexBufferDesc.mesh(), eg.egGenBuffer(), usage);
    }
}