package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.geometry.vec3;
import com.pigeon3d.gl.gl;

public class ShaderUniformVec3 {
    public final int handle;
    private vec3 _last;
    public void applyVec3(final vec3 vec3) {
        if(!(vec3.equals(this._last))) {
            gl.egUniformVec3LocationColor(this.handle, vec3);
            this._last = vec3;
        }
    }
    public ShaderUniformVec3(final int handle) {
        this.handle = handle;
        this._last = new vec3(((float)(0)), ((float)(0)), ((float)(0)));
    }
    public String toString() {
        return String.format("ShaderUniformVec3(%d)", this.handle);
    }
}