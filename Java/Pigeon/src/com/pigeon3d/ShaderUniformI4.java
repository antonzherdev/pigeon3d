package com.pigeon3d;

import objd.lang.*;
import android.opengl.GLES20;

public class ShaderUniformI4 {
    public final int handle;
    private int _last;
    public void applyI4(final int i4) {
        if(i4 != this._last) {
            GLES20.glUniform1i(this.handle, i4);
            this._last = i4;
        }
    }
    public ShaderUniformI4(final int handle) {
        this.handle = handle;
        this._last = ((int)(0));
    }
    public String toString() {
        return String.format("ShaderUniformI4(%d)", this.handle);
    }
}