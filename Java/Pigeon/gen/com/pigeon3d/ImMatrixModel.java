package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.geometry.mat4;

public final class ImMatrixModel extends MatrixModel {
    public final mat4 m;
    @Override
    public mat4 m() {
        return m;
    }
    public final mat4 w;
    @Override
    public mat4 w() {
        return w;
    }
    public final mat4 c;
    @Override
    public mat4 c() {
        return c;
    }
    public final mat4 p;
    @Override
    public mat4 p() {
        return p;
    }
    @Override
    public MMatrixModel mutable() {
        return MMatrixModel.applyMWCP(this.m, this.w, this.c, this.p);
    }
    @Override
    public mat4 mw() {
        return this.w.mulMatrix(this.m);
    }
    @Override
    public mat4 mwc() {
        return this.c.mulMatrix(this.w.mulMatrix(this.m));
    }
    @Override
    public mat4 mwcp() {
        return this.p.mulMatrix(this.c.mulMatrix(this.w.mulMatrix(this.m)));
    }
    @Override
    public mat4 cp() {
        return this.p.mulMatrix(this.c);
    }
    @Override
    public mat4 wcp() {
        return this.p.mulMatrix(this.c.mulMatrix(this.w));
    }
    @Override
    public mat4 wc() {
        return this.c.mulMatrix(this.w);
    }
    public ImMatrixModel(final mat4 m, final mat4 w, final mat4 c, final mat4 p) {
        this.m = m;
        this.w = w;
        this.c = c;
        this.p = p;
    }
    public String toString() {
        return String.format("ImMatrixModel(%s, %s, %s, %s)", this.m, this.w, this.c, this.p);
    }
}