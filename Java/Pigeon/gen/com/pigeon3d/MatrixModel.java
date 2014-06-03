package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.geometry.mat4;

public abstract class MatrixModel {
    public abstract mat4 m();
    public abstract mat4 w();
    public abstract mat4 c();
    public abstract mat4 p();
    public abstract MMatrixModel mutable();
    public static final MatrixModel identity;
    public mat4 mw() {
        return this.w().mulMatrix(this.m());
    }
    public mat4 mwc() {
        return this.c().mulMatrix(this.w().mulMatrix(this.m()));
    }
    public mat4 mwcp() {
        return this.p().mulMatrix(this.c().mulMatrix(this.w().mulMatrix(this.m())));
    }
    public mat4 cp() {
        return this.p().mulMatrix(this.c());
    }
    public mat4 wcp() {
        return this.p().mulMatrix(this.c().mulMatrix(this.w()));
    }
    public mat4 wc() {
        return this.c().mulMatrix(this.w());
    }
    public MatrixModel() {
    }
    public String toString() {
        return "MatrixModel";
    }
    static {
        identity = new ImMatrixModel(mat4.identity(), mat4.identity(), mat4.identity(), mat4.identity());
    }
}