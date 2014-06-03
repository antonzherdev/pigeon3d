package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.gl.gl;
import objd.collection.PArray;

public class IBO {
    public static static ImmutableIndexBuffer applyPointerCount(final Pointer pointer, final int count) {
        final ImmutableIndexBuffer ib = new ImmutableIndexBuffer(gl.egGenBuffer(), gl.GL_TRIANGLES, ((int)(count * 4)), ((int)(count)));
        ib.bind();
        gl.glBufferDataTargetSizeDataUsage(gl.GL_ELEMENT_ARRAY_BUFFER, ((long)(count * 4)), pointer, gl.GL_STATIC_DRAW);
        return ib;
    }
    public static static ImmutableIndexBuffer applyData(final PArray<Integer> data) {
        final ImmutableIndexBuffer ib = new ImmutableIndexBuffer(gl.egGenBuffer(), gl.GL_TRIANGLES, data.length, data.count);
        ib.bind();
        gl.glBufferDataTargetSizeDataUsage(gl.GL_ELEMENT_ARRAY_BUFFER, ((long)(data.length)), data.bytes, gl.GL_STATIC_DRAW);
        return ib;
    }
    public static static MutableIndexBuffer mutModeUsage(final int mode, final int usage) {
        return new MutableIndexBuffer(gl.egGenBuffer(), mode, usage);
    }
    public static static MutableIndexBuffer mutUsage(final int usage) {
        return IBO.mutModeUsage(gl.GL_TRIANGLES, usage);
    }
}