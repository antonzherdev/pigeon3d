package com.pigeon3d;

import objd.lang.*;
import objd.collection.Iterator_impl;

public class IndexFunFilteredIterator<T> extends Iterator_impl<T> {
    public final int maxCount;
    public final F<Integer, T> f;
    private int i;
    private T _next;
    @Override
    public boolean hasNext() {
        return this._next != null;
    }
    @Override
    public T next() {
        if(this._next == null) {
            throw new NullPointerException();
        }
        final T ret = this._next;
        this._next = this.roll();
        return ret;
    }
    private T roll() {
        T ret = null;
        while(ret == null && this.i < this.maxCount) {
            ret = this.f.apply(this.i);
            this.i++;
        }
        return ret;
    }
    public IndexFunFilteredIterator(final int maxCount, final F<Integer, T> f) {
        this.maxCount = maxCount;
        this.f = f;
        this.i = ((int)(0));
        this._next = this.roll();
    }
    public String toString() {
        return String.format("IndexFunFilteredIterator(%d)", this.maxCount);
    }
}