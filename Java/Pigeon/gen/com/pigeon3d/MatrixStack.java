package com.pigeon3d;

import objd.lang.*;
import objd.collection.ImList;
import com.pigeon3d.geometry.mat4;

public class MatrixStack {
    private ImList<ImMatrixModel> stack;
    private final MMatrixModel _value;
    public MMatrixModel value() {
        return this._value;
    }
    public void setValue(final MatrixModel value) {
        this._value.setMatrixModel(value);
    }
    public void clear() {
        this._value.clear();
        this.stack = ImList.<ImMatrixModel>apply();
    }
    public void push() {
        this.stack = ImList.<ImMatrixModel>applyItemTail(this._value.immutable(), this.stack);
    }
    public void pop() {
        final ImMatrixModel __tmp_0rp0n = this.stack.head();
        if(__tmp_0rp0n == null) {
            throw new NullPointerException();
        }
        this._value.setMatrixModel(__tmp_0rp0n);
        this.stack = this.stack.tail();
    }
    public void applyModifyF(final P<MMatrixModel> modify, final P0 f) {
        this.push();
        modify.apply(this.value());
        f.apply();
        this.pop();
    }
    public void identityF(final P0 f) {
        this.push();
        this.value().clear();
        f.apply();
        this.pop();
    }
    public mat4 m() {
        return this._value.m();
    }
    public mat4 w() {
        return this._value.w();
    }
    public mat4 c() {
        return this._value.c();
    }
    public mat4 p() {
        return this._value.p();
    }
    public mat4 mw() {
        return this._value.mw();
    }
    public mat4 mwc() {
        return this._value.mwc();
    }
    public mat4 mwcp() {
        return this._value.mwcp();
    }
    public mat4 wc() {
        return this._value.wc();
    }
    public mat4 wcp() {
        return this._value.wcp();
    }
    public mat4 cp() {
        return this._value.cp();
    }
    public MatrixStack() {
        this.stack = ImList.<ImMatrixModel>apply();
        this._value = new MMatrixModel();
    }
    public String toString() {
        return "MatrixStack";
    }
}