package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.gl.gl;

public class MutableIndexBuffer extends MutableBuffer<Integer> implements IndexBuffer {
    public final int mode;
    @Override
    public int mode() {
        return mode;
    }
    @Override
    public boolean isMutable() {
        return true;
    }
    @Override
    public void bind() {
        Global.context.bindIndexBufferHandle(this.handle);
    }
    @Override
    public boolean isEmpty() {
        return false;
    }
    public MutableIndexBuffer(final int handle, final int mode, final int usage) {
        super(((PType<Integer>)(((PType)(UInt4.type)))), gl.GL_ELEMENT_ARRAY_BUFFER, handle, usage);
        this.mode = mode;
    }
    public String toString() {
        return String.format("MutableIndexBuffer(%d)", this.mode);
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