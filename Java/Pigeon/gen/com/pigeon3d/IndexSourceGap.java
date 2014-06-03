package com.pigeon3d;

import objd.lang.*;

public class IndexSourceGap extends IndexSource_impl {
    public final IndexSource source;
    public final int start;
    public final int count;
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
    public IndexSourceGap(final IndexSource source, final int start, final int count) {
        this.source = source;
        this.start = start;
        this.count = count;
    }
    public String toString() {
        return String.format("IndexSourceGap(%s, %d, %d)", this.source, this.start, this.count);
    }
}