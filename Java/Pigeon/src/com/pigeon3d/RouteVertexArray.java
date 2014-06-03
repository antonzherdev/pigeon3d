package com.pigeon3d;

import objd.lang.*;
import objd.collection.ImArray;

public class RouteVertexArray<P> extends VertexArray<P> {
    public final VertexArray<P> standard;
    public final VertexArray<P> shadow;
    public VertexArray<P> mesh() {
        if(Global.context.renderTarget instanceof ShadowRenderTarget) {
            return this.shadow;
        } else {
            return this.standard;
        }
    }
    @Override
    public void drawParam(final P param) {
        this.mesh().drawParam(param);
    }
    @Override
    public void drawParamStartEnd(final P param, final int start, final int end) {
        this.mesh().drawParamStartEnd(param, start, end);
    }
    @Override
    public void draw() {
        this.mesh().draw();
    }
    @Override
    public void syncF(final P0 f) {
        this.mesh().syncF(f);
    }
    @Override
    public void syncWait() {
        this.mesh().syncWait();
    }
    @Override
    public void syncSet() {
        this.mesh().syncSet();
    }
    @Override
    public ImArray<VertexBuffer<Object>> vertexBuffers() {
        return ((ImArray<VertexBuffer<Object>>)(((ImArray)(this.mesh().vertexBuffers()))));
    }
    @Override
    public IndexSource index() {
        return this.mesh().index();
    }
    public RouteVertexArray(final VertexArray<P> standard, final VertexArray<P> shadow) {
        this.standard = standard;
        this.shadow = shadow;
    }
    public String toString() {
        return String.format("RouteVertexArray(%s, %s)", this.standard, this.shadow);
    }
}