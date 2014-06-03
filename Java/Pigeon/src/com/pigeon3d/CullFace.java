package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.gl.gl;

public class CullFace {
    private int _lastActiveValue;
    private int _value;
    private int _comingValue;
    public void setValue(final int value) {
        this._comingValue = value;
    }
    public void draw() {
        if(this._value != this._comingValue) {
            if(this._comingValue == gl.GL_NONE) {
                gl.glDisable(gl.GL_CULL_FACE);
                this._value = gl.GL_NONE;
            } else {
                if(this._value == gl.GL_NONE) {
                    gl.glEnable(gl.GL_CULL_FACE);
                }
                if(this._lastActiveValue != this._comingValue) {
                    gl.glCullFace(this._comingValue);
                    this._lastActiveValue = this._comingValue;
                }
                this._value = this._comingValue;
            }
        }
    }
    public int disable() {
        final int old = this._comingValue;
        this._comingValue = gl.GL_NONE;
        return old;
    }
    public void disabledF(final P0 f) {
        final int oldValue = this.disable();
        f.apply();
        if(oldValue != gl.GL_NONE) {
            setValue(oldValue);
        }
    }
    public int invert() {
        final int old = this._comingValue;
        this._comingValue = ((old == gl.GL_FRONT) ? (gl.GL_BACK) : (gl.GL_FRONT));
        return old;
    }
    public void invertedF(final P0 f) {
        final int oldValue = this.invert();
        f.apply();
        if(oldValue != gl.GL_NONE) {
            setValue(oldValue);
        }
    }
    public CullFace() {
        this._lastActiveValue = gl.GL_NONE;
        this._value = gl.GL_NONE;
        this._comingValue = gl.GL_NONE;
    }
    public String toString() {
        return "CullFace";
    }
}