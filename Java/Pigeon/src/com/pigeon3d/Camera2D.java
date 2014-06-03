package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.geometry.vec2;
import com.pigeon3d.geometry.mat4;

public class Camera2D extends Camera_impl {
    public final vec2 size;
    public final double viewportRatio;
    @Override
    public double viewportRatio() {
        return viewportRatio;
    }
    public final MatrixModel matrixModel;
    @Override
    public MatrixModel matrixModel() {
        return matrixModel;
    }
    public Camera2D(final vec2 size) {
        this.size = size;
        this.viewportRatio = ((double)(size.x / size.y));
        this.matrixModel = new ImMatrixModel(mat4.identity(), mat4.identity(), mat4.identity(), mat4.orthoLeftRightBottomTopZNearZFar(((float)(0)), size.x, ((float)(0)), size.y, ((float)(-1)), ((float)(1))));
    }
    public String toString() {
        return String.format("Camera2D(%s)", this.size);
    }
}