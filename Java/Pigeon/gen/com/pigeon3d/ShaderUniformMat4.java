package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.geometry.mat4;
import com.pigeon3d.gl.gl;

public class ShaderUniformMat4 {
    public final int handle;
    private mat4 _last;
    public void applyMatrix(final mat4 matrix) {
        if(!(matrix.equals(this._last))) {
            this._last = matrix;
            gl.glUniformMatrix4fvLocationCountTransposeValue(this.handle, ((int)(1)), gl.GL_FALSE, matrix.array);
        }
    }
    public ShaderUniformMat4(final int handle) {
        this.handle = handle;
        this._last = mat4.null();
    }
    public String toString() {
        return String.format("ShaderUniformMat4(%d)", this.handle);
    }
}