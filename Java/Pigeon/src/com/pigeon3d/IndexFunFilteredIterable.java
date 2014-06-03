package com.pigeon3d;

import objd.lang.*;
import objd.collection.Iterator;
import objd.collection.ImIterable_impl;

public class IndexFunFilteredIterable<T> extends ImIterable_impl<T> {
    public final int maxCount;
    public final F<Integer, T> f;
    @Override
    public Iterator<T> iterator() {
        return new IndexFunFilteredIterator<T>(this.maxCount, this.f);
    }
    public IndexFunFilteredIterable(final int maxCount, final F<Integer, T> f) {
        this.maxCount = maxCount;
        this.f = f;
    }
    public String toString() {
        return String.format("IndexFunFilteredIterable(%d)", this.maxCount);
    }
}