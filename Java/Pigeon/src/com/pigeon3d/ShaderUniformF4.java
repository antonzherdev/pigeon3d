package com.pigeon3d;

import objd.lang.*;
import android.opengl.GLES20;

public class ShaderUniformF4 {
    public final int handle;
    private float _last;
    public void applyF4(final float f4) {
        if(!(f4.equals(this._last))) {
            GLES20.glUniform1f(this.handle, f4);
            this._last = f4;
        }
    }
    public ShaderUniformF4(final int handle) {
        this.handle = handle;
        this._last = ((float)(0));
    }
    public String toString() {
        return String.format("ShaderUniformF4(%d)", this.handle);
    }
}