package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.geometry.vec2;
import com.pigeon3d.gl.gl;

public class ShaderUniformVec2 {
    public final int handle;
    private vec2 _last;
    public void applyVec2(final vec2 vec2) {
        if(!(vec2.equals(this._last))) {
            gl.egUniformVec2LocationColor(this.handle, vec2);
            this._last = vec2;
        }
    }
    public ShaderUniformVec2(final int handle) {
        this.handle = handle;
        this._last = new vec2(((float)(0)), ((float)(0)));
    }
    public String toString() {
        return String.format("ShaderUniformVec2(%d)", this.handle);
    }
}