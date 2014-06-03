package com.pigeon3d;

import objd.lang.*;
import objd.collection.ImArray;

public abstract class VertexArray<P> {
    public abstract void drawParamStartEnd(final P param, final int start, final int end);
    public abstract void drawParam(final P param);
    public abstract void draw();
    public abstract void syncWait();
    public abstract void syncSet();
    public abstract void syncF(final P0 f);
    public abstract ImArray<VertexBuffer<Object>> vertexBuffers();
    public abstract IndexSource index();
    public MutableVertexBuffer<Object> mutableVertexBuffer() {
        return _lazy_mutableVertexBuffer.get();
    }
    private final Lazy<MutableVertexBuffer<Object>> _lazy_mutableVertexBuffer;
    public <T> void vertexWriteCountF(final int count, final P<Pointer> f) {
        {
            final MutableVertexBuffer<Object> __tmp_0lu = this.mutableVertexBuffer();
            final MutableVertexBuffer<T> __tmp_0u = ((__tmp_0lu != null) ? (((MutableVertexBuffer<T>)(((MutableVertexBuffer)(__tmp_0lu))))) : (null));
            if(__tmp_0u != null) {
                __tmp_0u.writeCountF(count, f);
            }
        }
    }
    public VertexArray() {
        this._lazy_mutableVertexBuffer = new Lazy(new F0<MutableVertexBuffer<Object>>() {
            @Override
            public MutableVertexBuffer<Object> apply() {
                return ((MutableVertexBuffer<Object>)(((MutableVertexBuffer)(((MutableVertexBuffer<Object>)(((MutableVertexBuffer)(VertexArray.this.vertexBuffers().findWhere(((F<VertexBuffer<Object>, Boolean>)(((F)(new F<VertexBuffer<Object>, Boolean>() {
                    @Override
                    public Boolean apply(final VertexBuffer<Object> _) {
                        return _ instanceof MutableVertexBuffer;
                    }
                })))))))))))));
            }
        });
    }
    public String toString() {
        return "VertexArray";
    }
}