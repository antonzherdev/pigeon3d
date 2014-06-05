package com.pigeon3d;

import objd.lang.*;
import android.opengl.GLES20;
import java.nio.Buffer;
import com.pigeon3d.gl.eg;

public abstract class IndexBuffer_impl extends IndexSource_impl implements IndexBuffer {
    public IndexBuffer_impl() {
    }
    @Override
    public void draw() {
        Global.context.draw();
        final int n = this.count();
        if(n > 0) {
            GLES20.glDrawElements(this.mode(), ((int)(n)), GLES20.GL_UNSIGNED_INT, ((Buffer)(null)));
        }
        eg.egCheckError();
    }
    @Override
    public void drawWithStartCount(final int start, final int count) {
        Global.context.draw();
        if(count > 0) {
            GLES20.glDrawElements(this.mode(), ((int)(count)), GLES20.GL_UNSIGNED_INT, ((Buffer)(((Pointer)(4 * start)))));
        }
        eg.egCheckError();
    }
}