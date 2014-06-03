package com.pigeon3d;

import objd.lang.*;
import objd.collection.MQueue;

public class VertexArrayRing<P> {
    public final int ringSize;
    public final F<Integer, VertexArray<P>> creator;
    private final MQueue<VertexArray<P>> _ring;
    public VertexArray<P> next() {
        final VertexArray<P> __tmp_0tn = this._ring.dequeue();
        if(__tmp_0tn == null) {
            throw new NullPointerException();
        }
        final VertexArray<P> buffer = ((this._ring.count() >= this.ringSize) ? (__tmp_0tn) : (((VertexArray<P>)(((VertexArray)(this.creator.apply(((int)(this._ring.count())))))))));
        this._ring.enqueueItem(buffer);
        return buffer;
    }
    public void syncF(final P<VertexArray<P>> f) {
        final VertexArray<P> vao = this.next();
        this.next().syncF(new P0() {
            @Override
            public void apply() {
                f.apply(vao);
            }
        });
    }
    public VertexArrayRing(final int ringSize, final F<Integer, VertexArray<P>> creator) {
        this.ringSize = ringSize;
        this.creator = creator;
        this._ring = new MQueue<VertexArray<P>>();
    }
    public String toString() {
        return String.format("VertexArrayRing(%d)", this.ringSize);
    }
}