package com.pigeon3d;

import objd.lang.*;
import objd.collection.PArray;
import com.pigeon3d.gl.gl;

public class ArrayIndexSource extends IndexSource_impl {
    public final PArray<Integer> array;
    public final int mode;
    @Override
    public void draw() {
        Global.context.bindIndexBufferHandle(((int)(0)));
        final int n = this.array.count;
        if(n > 0) {
            gl.glDrawElementsModeCountTpIndices(this.mode, ((int)(n)), gl.GL_UNSIGNED_INT, this.array.bytes);
        }
        gl.egCheckError();
    }
    @Override
    public void drawWithStartCount(final int start, final int count) {
        Global.context.bindIndexBufferHandle(((int)(0)));
        if(count > 0) {
            gl.glDrawElementsModeCountTpIndices(this.mode, ((int)(count)), gl.GL_UNSIGNED_INT, this.array.bytes + 4 * start);
        }
        gl.egCheckError();
    }
    public ArrayIndexSource(final PArray<Integer> array, final int mode) {
        this.array = array;
        this.mode = mode;
    }
    public String toString() {
        return String.format("ArrayIndexSource(%s, %d)", this.array, this.mode);
    }
}