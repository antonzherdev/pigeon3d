package com.pigeon3d;

import objd.lang.*;
import objd.collection.MQueue;

public class BufferRing<T, B extends MutableBuffer<T>> {
    public final int ringSize;
    public final F0<B> creator;
    private final MQueue<B> _ring;
    public B next() {
        final B __tmp_0tn = this._ring.dequeue();
        if(__tmp_0tn == null) {
            throw new NullPointerException();
        }
        final B buffer = ((this._ring.count() >= this.ringSize) ? (__tmp_0tn) : (this.creator.apply()));
        this._ring.enqueueItem(buffer);
        return buffer;
    }
    public void writeCountF(final int count, final P<Pointer> f) {
        this.next().writeCountF(count, f);
    }
    public void mapCountAccessF(final int count, final int access, final P<Pointer> f) {
        this.next().mapCountAccessF(count, access, f);
    }
    public BufferRing(final int ringSize, final F0<B> creator) {
        this.ringSize = ringSize;
        this.creator = creator;
        this._ring = new MQueue<B>();
    }
    public String toString() {
        return String.format("BufferRing(%d)", this.ringSize);
    }
}