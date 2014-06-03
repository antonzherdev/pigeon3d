package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.gl.gl;

public abstract class Camera_impl implements Camera {
    public Camera_impl() {
    }
    public int cullFace() {
        return ((int)(gl.GL_NONE));
    }
}