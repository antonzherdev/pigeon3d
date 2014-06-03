package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.gl.gl;

public class EnablingState {
    public final int tp;
    private boolean _last;
    private boolean _coming;
    public boolean enable() {
        if(!(this._coming)) {
            this._coming = true;
            return true;
        } else {
            return false;
        }
    }
    public boolean disable() {
        if(this._coming) {
            this._coming = false;
            return true;
        } else {
            return false;
        }
    }
    public void draw() {
        if(!(this._last.equals(this._coming))) {
            if(this._coming) {
                gl.glEnable(this.tp);
            } else {
                gl.glDisable(this.tp);
            }
            this._last = this._coming;
        }
    }
    public void clear() {
        this._last = false;
        this._coming = false;
    }
    public void disabledF(final P0 f) {
        final boolean changed = this.disable();
        f.apply();
        if(changed) {
            this.enable();
        }
    }
    public void enabledF(final P0 f) {
        final boolean changed = this.enable();
        f.apply();
        if(changed) {
            this.disable();
        }
    }
    public EnablingState(final int tp) {
        this.tp = tp;
        this._last = false;
        this._coming = false;
    }
    public String toString() {
        return String.format("EnablingState(%d)", this.tp);
    }
}