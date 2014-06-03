package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.gl.gl;

public abstract class IndexBuffer_impl extends IndexSource_impl implements IndexBuffer {
    public IndexBuffer_impl() {
    }
    @Override
    public void draw() {
        Global.context.draw();
        final int n = this.count();
        if(n > 0) {
            gl.glDrawElementsModeCountTpIndices(this.mode(), ((int)(n)), gl.GL_UNSIGNED_INT, ERROR: Unknown null<uint4>);
        }
        gl.egCheckError();
    }
    @Override
    public void drawWithStartCount(final int start, final int count) {
        Global.context.draw();
        if(count > 0) {
            gl.glDrawElementsModeCountTpIndices(this.mode(), ((int)(count)), gl.GL_UNSIGNED_INT, ((Pointer)(4 * start)));
        }
        gl.egCheckError();
    }
}