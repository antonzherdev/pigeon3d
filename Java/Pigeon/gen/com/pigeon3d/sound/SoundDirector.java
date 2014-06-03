package com.pigeon3d.sound;

import objd.lang.*;
import objd.react.Signal;

public class SoundDirector {
    public static final SoundDirector instance;
    private boolean _enabled;
    public final Signal<Boolean> enabledChanged;
    private double _timeSpeed;
    public final Signal<Float> timeSpeedChanged;
    public boolean enabled() {
        return this._enabled;
    }
    public void setEnabled(final boolean enabled) {
        if(!(this._enabled.equals(enabled))) {
            this._enabled = enabled;
            this.enabledChanged.postData(enabled);
        }
    }
    public double timeSpeed() {
        return this._timeSpeed;
    }
    public void setTimeSpeed(final double timeSpeed) {
        if(!(this._timeSpeed.equals(timeSpeed))) {
            this._timeSpeed = timeSpeed;
            this.timeSpeedChanged.postData(timeSpeed);
        }
    }
    public SoundDirector() {
        this._enabled = true;
        this.enabledChanged = new Signal<Boolean>();
        this._timeSpeed = 1.0;
        this.timeSpeedChanged = new Signal<Float>();
    }
    public String toString() {
        return "SoundDirector";
    }
    static {
        instance = new SoundDirector();
    }
}