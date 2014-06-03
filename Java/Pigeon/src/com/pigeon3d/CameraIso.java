package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.geometry.mat4;
import com.pigeon3d.geometry.vec2;
import com.pigeon3d.gl.gl;
import objd.math;

public class CameraIso extends Camera_impl {
    private static final double ISO;
    public static final mat4 m;
    public static final mat4 w;
    public final vec2 tilesOnScreen;
    public final CameraReserve reserve;
    public final double viewportRatio;
    @Override
    public double viewportRatio() {
        return viewportRatio;
    }
    public final vec2 center;
    private final double ww;
    public final MatrixModel matrixModel;
    @Override
    public MatrixModel matrixModel() {
        return matrixModel;
    }
    public static CameraIso applyTilesOnScreenReserveViewportRatio(final vec2 tilesOnScreen, final CameraReserve reserve, final double viewportRatio) {
        return new CameraIso(tilesOnScreen, reserve, viewportRatio, vec2.divF(vec2.subVec2(tilesOnScreen, new vec2(((float)(1)), ((float)(1)))), 2.0));
    }
    @Override
    public int cullFace() {
        return ((int)(gl.GL_FRONT));
    }
    public vec2 naturalCenter() {
        return vec2.divF(vec2.subVec2(this.tilesOnScreen, new vec2(((float)(1)), ((float)(1)))), 2.0);
    }
    public CameraIso(final vec2 tilesOnScreen, final CameraReserve reserve, final double viewportRatio, final vec2 center) {
        this.tilesOnScreen = tilesOnScreen;
        this.reserve = reserve;
        this.viewportRatio = viewportRatio;
        this.center = center;
        this.ww = ((double)(tilesOnScreen.x + tilesOnScreen.y));
        this.matrixModel = new ImMatrixModel(CameraIso.m, CameraIso.w, r.mulMatrix(t), mat4.orthoLeftRightBottomTopZNearZFar(((float)(-(isoWW2) - reserve.left)), ((float)(isoWW2 + reserve.right)), ((float)(-(isoWW2) * angleSin - reserve.bottom)), ((float)(isoWW2 * angleSin + reserve.top)), ((float)(-1000.0)), ((float)(1000.0))));
    }
    public String toString() {
        return String.format("CameraIso(%s, %s, %f, %s)", this.tilesOnScreen, this.reserve, this.viewportRatio, this.center);
    }
    static {
        ISO = MapSso.ISO;
        m = mat4.identity().rotateAngleXYZ(((float)(90)), ((float)(1)), ((float)(0)), ((float)(0)));
        w = mat4.identity().rotateAngleXYZ(((float)(-90)), ((float)(1)), ((float)(0)), ((float)(0)));
    }
}