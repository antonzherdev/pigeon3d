package com.pigeon3d;

import objd.lang.*;
import objd.collection.ImArray;
import com.pigeon3d.gl.eg;

public class SimpleVertexArray<P> extends VertexArray<P> {
    public final int handle;
    public final Shader<P> shader;
    public final ImArray<VertexBuffer<Object>> vertexBuffers;
    @Override
    public ImArray<VertexBuffer<Object>> vertexBuffers() {
        return vertexBuffers;
    }
    public final IndexSource index;
    @Override
    public IndexSource index() {
        return index;
    }
    public final boolean isMutable;
    private final Fence fence;
    public static <P> SimpleVertexArray<P> applyShaderBuffersIndex(final Shader<P> shader, final ImArray<VertexBuffer<Object>> buffers, final IndexSource index) {
        return new SimpleVertexArray<P>(eg.egGenVertexArray(), shader, ((ImArray<VertexBuffer<Object>>)(((ImArray)(buffers)))), index);
    }
    public void bind() {
        final VertexBuffer<Object> __tmp_0rp1 = this.vertexBuffers.head();
        Global.context.bindVertexArrayHandleVertexCountMutable(this.handle, ((__tmp_0rp1 != null) ? (((int)(this.vertexBuffers.head().count()))) : (((int)(((int)(0)))))), this.isMutable);
    }
    public void unbind() {
        Global.context.bindDefaultVertexArray();
    }
    @Override
    public void finalize() throws Throwable {
        super.finalize();
        Global.context.deleteVertexArrayId(this.handle);
    }
    public int count() {
        final VertexBuffer<Object> __tmp = this.vertexBuffers.head();
        if(__tmp != null) {
            return this.vertexBuffers.head().count();
        } else {
            return ((int)(0));
        }
    }
    @Override
    public void drawParam(final P param) {
        if(!(this.index.isEmpty())) {
            this.shader.drawParamVao(param, this);
        }
    }
    @Override
    public void drawParamStartEnd(final P param, final int start, final int end) {
        if(!(this.index.isEmpty())) {
            this.shader.drawParamVaoStartEnd(param, this, start, end);
        }
    }
    @Override
    public void draw() {
        throw new RuntimeException("No default material");
    }
    @Override
    public void syncF(final P0 f) {
        this.fence.syncF(f);
    }
    @Override
    public void syncWait() {
        this.fence.clientWait();
    }
    @Override
    public void syncSet() {
        this.fence.set();
    }
    public SimpleVertexArray(final int handle, final Shader<P> shader, final ImArray<VertexBuffer<Object>> vertexBuffers, final IndexSource index) {
        this.handle = handle;
        this.shader = shader;
        this.vertexBuffers = vertexBuffers;
        this.index = index;
        this.isMutable = index.isMutable() || vertexBuffers.chain().findWhere(((F<VertexBuffer<Object>, Boolean>)(((F)(new F<VertexBuffer<Object>, Boolean>() {
            @Override
            public Boolean apply(final VertexBuffer<Object> _) {
                return _.isMutable();
            }
        }))))) != null;
        this.fence = new Fence("VAO");
    }
    public String toString() {
        return String.format("SimpleVertexArray(%d, %s, %s, %s)", this.handle, this.shader, this.vertexBuffers, this.index);
    }
}