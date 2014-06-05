package com.pigeon3d;

import objd.lang.*;
import objd.collection.Int4Buffer;
import android.opengl.GLES20;
import com.pigeon3d.gl.eg;

public class ArrayIndexSource extends IndexSource_impl {
    public final Int4Buffer array;
    public final int mode;
    @Override
    public void draw() {
        Global.context.bindIndexBufferHandle(((int)(0)));
        final int n = this.array.count;
        if(n > 0) {
            GLES20.glDrawElements(this.mode, ((int)(n)), GLES20.GL_UNSIGNED_INT, this.array.bytes);
        }
        eg.egCheckError();
    }
    @Override
    public void drawWithStartCount(final int start, final int count) {
        Global.context.bindIndexBufferHandle(((int)(0)));
        if(count > 0) {
            GLES20.glDrawElements(this.mode, ((int)(count)), GLES20.GL_UNSIGNED_INT, this.array.bytes);
        }
        eg.egCheckError();
    }
    public ArrayIndexSource(final Int4Buffer array, final int mode) {
        this.array = array;
        this.mode = mode;
    }
    public String toString() {
        return String.format("ArrayIndexSource(%s, %d)", this.array, this.mode);
    }
}