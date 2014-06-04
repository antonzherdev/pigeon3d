package com.pigeon3d;

import objd.lang.*;
import android.opengl.GLES20;

public abstract class Camera_impl implements Camera {
    public Camera_impl() {
    }
    public int cullFace() {
        return ((int)(GLES20.GL_NONE));
    }
}