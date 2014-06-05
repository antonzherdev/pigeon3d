package com.pigeon3d;

import objd.lang.*;
import objd.collection.PArray;
import objd.collection.Iterator;
import com.pigeon3d.geometry.mat4;
import objd.collection.Iterable;
import android.opengl.GLES20;

public class MeshUnite {
    public final MeshDataBuffer vertexSample;
    public final PArray<Integer> indexSample;
    public final F<Mesh, VertexArray<Object>> createVao;
    private final MutableVertexBuffer<MeshData> vbo;
    private final MutableIndexBuffer ibo;
    public final Mesh mesh;
    public final VertexArray<Object> vao;
    private int _count;
    public static MeshUnite applyMeshModelCreateVao(final MeshDataModel meshModel, final F<Mesh, VertexArray<Object>> createVao) {
        return new MeshUnite(meshModel.vertex, meshModel.index, ((F<Mesh, VertexArray<Object>>)(((F)(createVao)))));
    }
    public void writeCountF(final int count, final P<MeshWriter> f) {
        final MeshWriter w = writerCount(count);
        f.apply(w);
        w.flush();
    }
    public void writeMat4Array(final Iterable<mat4> mat4Array) {
        final MeshWriter w = writerCount(((int)(mat4Array.count())));
        {
            final Iterator<mat4> __il__1i = mat4Array.iterator();
            while(__il__1i.hasNext()) {
                final mat4 _ = __il__1i.next();
                w.writeMat4(_);
            }
        }
        w.flush();
    }
    public MeshWriter writerCount(final int count) {
        this._count = count;
        return new MeshWriter(this.vbo, this.ibo, count, this.vertexSample, this.indexSample);
    }
    public void draw() {
        if(this._count > 0) {
            {
                final MatrixStack __tmp__il__0t_0self = Global.matrix;
                {
                    __tmp__il__0t_0self.push();
                    __tmp__il__0t_0self.value().clear();
                    this.vao.draw();
                    __tmp__il__0t_0self.pop();
                }
            }
        }
    }
    public MeshUnite(final MeshDataBuffer vertexSample, final PArray<Integer> indexSample, final F<Mesh, VertexArray<Object>> createVao) {
        this.vertexSample = vertexSample;
        this.indexSample = indexSample;
        this.createVao = createVao;
        this.vbo = VBO.mutMeshUsage(GLES20.GL_DYNAMIC_DRAW);
        this.ibo = IBO.mutUsage(GLES20.GL_DYNAMIC_DRAW);
        this.mesh = new Mesh(((VertexBuffer<Object>)(((VertexBuffer)(this.vbo)))), this.ibo);
        this.vao = ((VertexArray<Object>)(((VertexArray)(createVao.apply(this.mesh)))));
        this._count = ((int)(0));
    }
    public String toString() {
        return String.format("MeshUnite(%s, %s)", this.vertexSample, this.indexSample);
    }
}