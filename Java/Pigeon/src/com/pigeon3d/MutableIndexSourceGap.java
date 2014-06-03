package com.pigeon3d;

import objd.lang.*;

public class MutableIndexSourceGap extends IndexSource_impl {
    public final IndexSource source;
    public int start;
    public int count;
    @Override
    public void bind() {
        this.source.bind();
    }
    @Override
    public void draw() {
        if(this.count > 0) {
            this.source.drawWithStartCount(((int)(this.start)), ((int)(this.count)));
        }
    }
    @Override
    public void drawWithStartCount(final int start, final int count) {
        if(count > 0) {
            this.source.drawWithStartCount(((int)(this.start + start)), count);
        }
    }
    public MutableIndexSourceGap(final IndexSource source) {
        this.source = source;
        this.start = ((int)(0));
        this.count = ((int)(0));
    }
    public String toString() {
        return String.format("MutableIndexSourceGap(%s)", this.source);
    }
}