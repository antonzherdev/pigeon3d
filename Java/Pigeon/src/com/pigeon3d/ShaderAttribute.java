package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.gl.gl;

public class ShaderAttribute {
    public final int handle;
    public void setFromBufferWithStrideValuesCountValuesTypeShift(final int stride, final int valuesCount, final int valuesType, final int shift) {
        gl.glEnableVertexAttribArrayHandle(((int)(this.handle)));
        gl.egVertexAttribPointerSlotSizeTpNormalizedStrideShift(this.handle, ((int)(valuesCount)), valuesType, gl.GL_FALSE, ((int)(stride)), ((int)(shift)));
    }
    public ShaderAttribute(final int handle) {
        this.handle = handle;
    }
    public String toString() {
        return String.format("ShaderAttribute(%d)", this.handle);
    }
}