package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.gl.gl;

public class ShaderUniformI4 {
    public final int handle;
    private int _last;
    public void applyI4(final int i4) {
        if(i4 != this._last) {
            gl.glUniform1iLocationF(this.handle, i4);
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