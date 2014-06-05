package com.pigeon3d;

import objd.lang.*;
import objd.collection.PArray;
import com.pigeon3d.geometry.mat4;
import com.pigeon3d.geometry.vec2;
import com.pigeon3d.geometry.vec3;

public class MeshWriter {
    public final MutableVertexBuffer<MeshData> vbo;
    public final MutableIndexBuffer ibo;
    public final int count;
    public final MeshDataBuffer vertexSample;
    public final PArray<Integer> indexSample;
    private final Pointer vertex;
    private final Pointer index;
    private Pointer _vp;
    private Pointer _ip;
    private int _indexShift;
    public void writeMat4(final mat4 mat4) {
        writeVertexIndexMat4(this.vertexSample, this.indexSample, mat4);
    }
    public void writeVertexMat4(final MeshDataBuffer vertex, final mat4 mat4) {
        writeVertexIndexMat4(vertex, this.indexSample, mat4);
    }
    public void writeVertexIndexMat4(final MeshDataBuffer vertex, final PArray<Integer> index, final mat4 mat4) {
        {
            int __il__0i = 0;
            vertex.bytes.clear();
            while(__il__0i < vertex.count) {
                {
                    final MeshData r = new MeshData(new vec2(vertex.bytes.get(), vertex.bytes.get()), new vec3(vertex.bytes.get(), vertex.bytes.get(), vertex.bytes.get()), new vec3(vertex.bytes.get(), vertex.bytes.get(), vertex.bytes.get()));
                    {
                        ERROR: Unknown *(<MeshWriter#C>self.<fmp>_vp\§^MeshData#S§*\) = MeshData.mulMat4(r, mat4);
                        this._vp++;
                    }
                }
                __il__0i++;
            }
        }
        index.forRefEach(new P<Pointer>() {
            @Override
            public void apply(final Pointer r) {
                ERROR: Unknown *(<MeshWriter#C>self.<fmp>_ip\§^uint4§*\) = ERROR: Unknown *(<l>r\^uint4*\) + MeshWriter.this._indexShift;
                MeshWriter.this._ip++;
            }
        });
        this._indexShift += vertex.count;
    }
    public void writeMap(final F<MeshData, MeshData> map) {
        writeVertexIndexMap(this.vertexSample, this.indexSample, map);
    }
    public void writeVertexMap(final MeshDataBuffer vertex, final F<MeshData, MeshData> map) {
        writeVertexIndexMap(vertex, this.indexSample, map);
    }
    public void writeVertexIndexMap(final MeshDataBuffer vertex, final PArray<Integer> index, final F<MeshData, MeshData> map) {
        {
            int __il__0i = 0;
            vertex.bytes.clear();
            while(__il__0i < vertex.count) {
                {
                    final MeshData r = new MeshData(new vec2(vertex.bytes.get(), vertex.bytes.get()), new vec3(vertex.bytes.get(), vertex.bytes.get(), vertex.bytes.get()), new vec3(vertex.bytes.get(), vertex.bytes.get(), vertex.bytes.get()));
                    {
                        ERROR: Unknown *(<MeshWriter#C>self.<fmp>_vp\§^MeshData#S§*\) = map.apply(r);
                        this._vp++;
                    }
                }
                __il__0i++;
            }
        }
        index.forRefEach(new P<Pointer>() {
            @Override
            public void apply(final Pointer r) {
                ERROR: Unknown *(<MeshWriter#C>self.<fmp>_ip\§^uint4§*\) = ERROR: Unknown *(<l>r\^uint4*\) + MeshWriter.this._indexShift;
                MeshWriter.this._ip++;
            }
        });
        this._indexShift += vertex.count;
    }
    public void flush() {
        this.vbo.setArrayCount(this.vertex, this.vertexSample.count * this.count);
        this.ibo.setArrayCount(this.index, ((int)(this.indexSample.count() * this.count)));
    }
    @Override
    public void finalize() throws Throwable {
        super.finalize();
        Pointer.free(this.vertex);
        Pointer.free(this.index);
    }
    public MeshWriter(final MutableVertexBuffer<MeshData> vbo, final MutableIndexBuffer ibo, final int count, final MeshDataBuffer vertexSample, final PArray<Integer> indexSample) {
        this.vbo = vbo;
        this.ibo = ibo;
        this.count = count;
        this.vertexSample = vertexSample;
        this.indexSample = indexSample;
        this.vertex = new Pointer<MeshData>(MeshData.type, ((int)(vertexSample.count * count)));
        this.index = new Pointer<Integer>(((PType<Integer>)(((PType)(UInt4.type)))), indexSample.count() * count);
        this._vp = this.vertex;
        this._ip = this.index;
        this._indexShift = ((int)(0));
    }
    public String toString() {
        return String.format("MeshWriter(%s, %s, %d, %s, %s)", this.vbo, this.ibo, this.count, this.vertexSample, this.indexSample);
    }
}