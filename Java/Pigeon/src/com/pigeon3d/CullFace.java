package com.pigeon3d;

import objd.lang.*;
import android.opengl.GLES20;

public class CullFace {
    private int _lastActiveValue;
    private int _value;
    private int _comingValue;
    public void setValue(final int value) {
        this._comingValue = value;
    }
    public void draw() {
        if(this._value != this._comingValue) {
            if(this._comingValue == GLES20.GL_NONE) {
                GLES20.glDisable(GLES20.GL_CULL_FACE);
                this._value = GLES20.GL_NONE;
            } else {
                if(this._value == GLES20.GL_NONE) {
                    GLES20.glEnable(GLES20.GL_CULL_FACE);
                }
                if(this._lastActiveValue != this._comingValue) {
                    GLES20.glCullFace(this._comingValue);
                    this._lastActiveValue = this._comingValue;
                }
                this._value = this._comingValue;
            }
        }
    }
    public int disable() {
        final int old = this._comingValue;
        this._comingValue = GLES20.GL_NONE;
        return old;
    }
    public void disabledF(final P0 f) {
        final int oldValue = this.disable();
        f.apply();
        if(oldValue != GLES20.GL_NONE) {
            setValue(oldValue);
        }
    }
    public int invert() {
        final int old = this._comingValue;
        this._comingValue = ((old == GLES20.GL_FRONT) ? (GLES20.GL_BACK) : (GLES20.GL_FRONT));
        return old;
    }
    public void invertedF(final P0 f) {
        final int oldValue = this.invert();
        f.apply();
        if(oldValue != GLES20.GL_NONE) {
            setValue(oldValue);
        }
    }
    public CullFace() {
        this._lastActiveValue = GLES20.GL_NONE;
        this._value = GLES20.GL_NONE;
        this._comingValue = GLES20.GL_NONE;
    }
    public String toString() {
        return "CullFace";
    }
}