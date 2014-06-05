package com.pigeon3d;

import objd.lang.*;
import android.opengl.GLES20;
import com.pigeon3d.gl.eg;
import objd.collection.Buffer;

public abstract class MutableGlBuffer<T> extends GlBuffer<T> {
    public final int usage;
    private int _length;
    private int _count;
    private MappedBufferData<T> mappedData;
    @Override
    public int length() {
        return this._length;
    }
    @Override
    public int count() {
        return this._count;
    }
    public boolean isEmpty() {
        return this._count > 0;
    }
    public MutableGlBuffer<T> setData(final Buffer<T> data) {
        this.bind();
        GLES20.glBufferData(this.bufferType, ((long)(data.length)), data.bytes(), this.usage);
        eg.egCheckError();
        this._length = ((int)(data.length));
        this._count = ((int)(data.count));
        return this;
    }
    public MutableGlBuffer<T> setArrayCount(final Pointer array, final int count) {
        this.bind();
        this._length = ((int)(count * this.dataType.size));
        GLES20.glBufferData(this.bufferType, ((long)(this._length)), array, this.usage);
        eg.egCheckError();
        this._count = ((int)(count));
        return this;
    }
    public void writeCountF(final int count, final P<Pointer> f) {
        mapCountAccessF(count, GLES20.GL_WRITE_ONLY, f);
    }
    public void mapCountAccessF(final int count, final int access, final P<Pointer> f) {
        if(this.mappedData != null) {
            return ;
        }
        this.bind();
        this._count = ((int)(count));
        this._length = ((int)(count * this.dataType.size));
        GLES20.glBufferData(this.bufferType, ((long)(this._length)), null, this.usage);
        {
            final Pointer _ = eg.<T>egMapBuffer(this.bufferType, access);
            if(_ != null) {
                f.apply(_);
            }
        }
        eg.egUnmapBuffer(this.bufferType);
        eg.egCheckError();
    }
    public MappedBufferData<T> beginWriteCount(final int count) {
        return mapCountAccess(count, GLES20.GL_WRITE_ONLY);
    }
    public MappedBufferData<T> mapCountAccess(final int count, final int access) {
        if(this.mappedData != null) {
            return null;
        }
        this.bind();
        this._count = ((int)(count));
        this._length = ((int)(count * this.dataType.size));
        GLES20.glBufferData(this.bufferType, ((long)(this._length)), null, this.usage);
        {
            final Pointer _ = eg.<T>egMapBuffer(this.bufferType, access);
            if(_ != null) {
                this.mappedData = new MappedBufferData<T>(this, _);
            } else {
                this.mappedData = null;
            }
        }
        eg.egCheckError();
        return this.mappedData;
    }
    public void _finishMapping() {
        this.bind();
        eg.egUnmapBuffer(this.bufferType);
        eg.egCheckError();
        this.mappedData = null;
    }
    public MutableGlBuffer(final PType<T> dataType, final int bufferType, final int handle, final int usage) {
        super(dataType, bufferType, handle);
        this.usage = usage;
        this._length = ((int)(0));
        this._count = ((int)(0));
    }
    public String toString() {
        return String.format("MutableGlBuffer(%d)", this.usage);
    }
}