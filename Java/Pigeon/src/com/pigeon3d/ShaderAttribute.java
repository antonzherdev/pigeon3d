package com.pigeon3d;

import objd.lang.*;
import android.opengl.GLES20;
import com.pigeon3d.gl.eg;

public class ShaderAttribute {
    public final int handle;
    public void setFromBufferWithStrideValuesCountValuesTypeShift(final int stride, final int valuesCount, final int valuesType, final int shift) {
        GLES20.glEnableVertexAttribArray(((int)(this.handle)));
        eg.egVertexAttribPointer(this.handle, ((int)(valuesCount)), valuesType, GLES20.GL_FALSE, ((int)(stride)), ((int)(shift)));
    }
    public ShaderAttribute(final int handle) {
        this.handle = handle;
    }
    public String toString() {
        return String.format("ShaderAttribute(%d)", this.handle);
    }
}