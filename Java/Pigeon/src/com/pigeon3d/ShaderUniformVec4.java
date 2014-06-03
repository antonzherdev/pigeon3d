package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.geometry.vec4;
import com.pigeon3d.gl.gl;

public class ShaderUniformVec4 {
    public final int handle;
    private vec4 _last;
    public void applyVec4(final vec4 vec4) {
        if(!(vec4.equals(this._last))) {
            gl.egUniformVec4LocationColor(this.handle, vec4);
            this._last = vec4;
        }
    }
    public ShaderUniformVec4(final int handle) {
        this.handle = handle;
        this._last = new vec4(((float)(0)), ((float)(0)), ((float)(0)), ((float)(0)));
    }
    public String toString() {
        return String.format("ShaderUniformVec4(%d)", this.handle);
    }
}