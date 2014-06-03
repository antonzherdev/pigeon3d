package com.pigeon3d;

import objd.lang.*;
import objd.collection.ImArray;

public class MaterialVertexArray<P> extends VertexArray<P> {
    public final VertexArray<P> vao;
    public final P material;
    @Override
    public void draw() {
        this.vao.drawParam(this.material);
    }
    @Override
    public void drawParam(final P param) {
        this.vao.drawParam(param);
    }
    @Override
    public void drawParamStartEnd(final P param, final int start, final int end) {
        this.vao.drawParamStartEnd(param, start, end);
    }
    @Override
    public void syncF(final P0 f) {
        this.vao.syncF(f);
    }
    @Override
    public void syncWait() {
        this.vao.syncWait();
    }
    @Override
    public void syncSet() {
        this.vao.syncSet();
    }
    @Override
    public ImArray<VertexBuffer<Object>> vertexBuffers() {
        return ((ImArray<VertexBuffer<Object>>)(((ImArray)(this.vao.vertexBuffers()))));
    }
    @Override
    public IndexSource index() {
        return this.vao.index();
    }
    public MaterialVertexArray(final VertexArray<P> vao, final P material) {
        this.vao = vao;
        this.material = material;
    }
    public String toString() {
        return String.format("MaterialVertexArray(%s, %s)", this.vao, this.material);
    }
}