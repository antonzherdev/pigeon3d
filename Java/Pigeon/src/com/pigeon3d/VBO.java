package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.gl.gl;
import objd.collection.PArray;
import com.pigeon3d.geometry.vec4;
import com.pigeon3d.geometry.vec3;
import com.pigeon3d.geometry.vec2;

public class VBO {
    public static static <T> VertexBuffer<T> applyDescArrayCount(final VertexBufferDesc<T> desc, final Pointer array, final int count) {
        final int len = count * desc.dataType.size;
        final ImmutableVertexBuffer<T> vb = new ImmutableVertexBuffer<T>(desc, gl.egGenBuffer(), ((int)(len)), ((int)(count)));
        vb.bind();
        gl.glBufferDataTargetSizeDataUsage(gl.GL_ARRAY_BUFFER, ((long)(len)), array, gl.GL_STATIC_DRAW);
        return vb;
    }
    public static static <T> VertexBuffer<T> applyDescData(final VertexBufferDesc<T> desc, final PArray<T> data) {
        final ImmutableVertexBuffer<T> vb = new ImmutableVertexBuffer<T>(desc, gl.egGenBuffer(), data.length, data.count);
        vb.bind();
        gl.glBufferDataTargetSizeDataUsage(gl.GL_ARRAY_BUFFER, ((long)(data.length)), data.bytes, gl.GL_STATIC_DRAW);
        return vb;
    }
    public static static VertexBuffer<vec4> vec4Data(final PArray<vec4> data) {
        return VBO.<vec4>applyDescData(VertexBufferDesc.Vec4(), data);
    }
    public static static VertexBuffer<vec3> vec3Data(final PArray<vec3> data) {
        return VBO.<vec3>applyDescData(VertexBufferDesc.Vec3(), data);
    }
    public static static VertexBuffer<vec2> vec2Data(final PArray<vec2> data) {
        return VBO.<vec2>applyDescData(VertexBufferDesc.Vec2(), data);
    }
    public static static VertexBuffer<MeshData> meshData(final PArray<MeshData> data) {
        return VBO.<MeshData>applyDescData(VertexBufferDesc.mesh(), data);
    }
    public static static <T> MutableVertexBuffer<T> mutDescUsage(final VertexBufferDesc<T> desc, final int usage) {
        return new MutableVertexBuffer<T>(desc, gl.egGenBuffer(), usage);
    }
    public static static <T> VertexBufferRing<T> ringSizeDescUsage(final int size, final VertexBufferDesc<T> desc, final int usage) {
        return new VertexBufferRing<T>(size, desc, usage);
    }
    public static static MutableVertexBuffer<vec2> mutVec2Usage(final int usage) {
        return new MutableVertexBuffer<vec2>(VertexBufferDesc.Vec2(), gl.egGenBuffer(), usage);
    }
    public static static MutableVertexBuffer<vec3> mutVec3Usage(final int usage) {
        return new MutableVertexBuffer<vec3>(VertexBufferDesc.Vec3(), gl.egGenBuffer(), usage);
    }
    public static static MutableVertexBuffer<vec4> mutVec4Usage(final int usage) {
        return new MutableVertexBuffer<vec4>(VertexBufferDesc.Vec4(), gl.egGenBuffer(), usage);
    }
    public static static MutableVertexBuffer<MeshData> mutMeshUsage(final int usage) {
        return new MutableVertexBuffer<MeshData>(VertexBufferDesc.mesh(), gl.egGenBuffer(), usage);
    }
}