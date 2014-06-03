package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.geometry.mat4;

public final class MMatrixModel extends MatrixModel {
    public mat4 _m;
    public mat4 _w;
    public mat4 _c;
    public mat4 _p;
    private mat4 _mw;
    private mat4 _mwc;
    private mat4 _mwcp;
    @Override
    public mat4 m() {
        return this._m;
    }
    @Override
    public mat4 w() {
        return this._w;
    }
    @Override
    public mat4 c() {
        return this._c;
    }
    @Override
    public mat4 p() {
        return this._p;
    }
    @Override
    public mat4 mw() {
        if(this._mw == null) {
            this._mw = this._w.mulMatrix(this._m);
        }
        if(this._mw == null) {
            throw new NullPointerException();
        }
        return this._mw;
    }
    @Override
    public mat4 mwc() {
        if(this._mwc == null) {
            this._mwc = this._c.mulMatrix(this.mw());
        }
        if(this._mwc == null) {
            throw new NullPointerException();
        }
        return this._mwc;
    }
    @Override
    public mat4 mwcp() {
        if(this._mwcp == null) {
            this._mwcp = this._p.mulMatrix(this.mwc());
        }
        if(this._mwcp == null) {
            throw new NullPointerException();
        }
        return this._mwcp;
    }
    @Override
    public mat4 cp() {
        return this._p.mulMatrix(this._c);
    }
    @Override
    public mat4 wcp() {
        return this._p.mulMatrix(this._c.mulMatrix(this._w));
    }
    @Override
    public mat4 wc() {
        return this._c.mulMatrix(this._w);
    }
    public MMatrixModel copy() {
        return MMatrixModel.applyMWCP(this.m(), this.w(), this.c(), this.p());
    }
    public static MMatrixModel applyMatrixModel(final MatrixModel matrixModel) {
        return matrixModel.mutable();
    }
    public static MMatrixModel applyImMatrixModel(final ImMatrixModel imMatrixModel) {
        return imMatrixModel.mutable();
    }
    public static MMatrixModel applyMWCP(final mat4 m, final mat4 w, final mat4 c, final mat4 p) {
        final MMatrixModel mm = new MMatrixModel();
        mm._m = m;
        mm._w = w;
        mm._c = c;
        mm._p = p;
        return mm;
    }
    @Override
    public MMatrixModel mutable() {
        return this;
    }
    public ImMatrixModel immutable() {
        return new ImMatrixModel(this.m(), this.w(), this.c(), this.p());
    }
    public MMatrixModel modifyM(final F<mat4, mat4> m) {
        this._m = m.apply(this._m);
        this._mw = null;
        this._mwc = null;
        this._mwcp = null;
        return this;
    }
    public MMatrixModel modifyW(final F<mat4, mat4> w) {
        this._w = w.apply(this._w);
        this._mw = null;
        this._mwc = null;
        this._mwcp = null;
        return this;
    }
    public MMatrixModel modifyC(final F<mat4, mat4> c) {
        this._c = c.apply(this._c);
        this._mwc = null;
        this._mwcp = null;
        return this;
    }
    public MMatrixModel modifyP(final F<mat4, mat4> p) {
        this._p = p.apply(this._p);
        this._mwcp = null;
        return this;
    }
    public void clear() {
        this._m = mat4.identity();
        this._w = mat4.identity();
        this._c = mat4.identity();
        this._p = mat4.identity();
        this._mw = null;
        this._mwc = null;
        this._mwcp = null;
    }
    public void setMatrixModel(final MatrixModel matrixModel) {
        this._m = matrixModel.m();
        this._w = matrixModel.w();
        this._c = matrixModel.c();
        this._p = matrixModel.p();
        this._mw = null;
        this._mwc = null;
        this._mwcp = null;
    }
    public MMatrixModel() {
        this._m = mat4.identity();
        this._w = mat4.identity();
        this._c = mat4.identity();
        this._p = mat4.identity();
        this._mw = null;
        this._mwc = null;
        this._mwcp = null;
    }
    public String toString() {
        return "MMatrixModel";
    }
}