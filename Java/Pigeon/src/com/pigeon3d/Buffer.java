package com.pigeon3d;

import objd.lang.*;
import android.opengl.GLES20;

public abstract class Buffer<T> {
    public abstract int length();
    public abstract int count();
    public final PType<T> dataType;
    public final int bufferType;
    public final int handle;
    @Override
    public void finalize() throws Throwable {
        super.finalize();
        Global.context.deleteBufferId(this.handle);
    }
    public void bind() {
        GLES20.glBindBuffer(this.bufferType, this.handle);
    }
    public int stride() {
        return ((int)(this.dataType.size));
    }
    public Buffer(final PType<T> dataType, final int bufferType, final int handle) {
        this.dataType = dataType;
        this.bufferType = bufferType;
        this.handle = handle;
    }
    public String toString() {
        return String.format("Buffer(%s, %d, %d)", this.dataType, this.bufferType, this.handle);
    }
}