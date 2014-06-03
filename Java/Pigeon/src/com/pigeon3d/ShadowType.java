package com.pigeon3d;

import objd.lang.*;

public enum ShadowType {
    no(false),
    shadow2d(true),
    sample2d(true);
    private ShadowType(final boolean isOn) {
        this.isOn = isOn;
    }
    public final boolean isOn;
    public boolean isOff() {
        return !(this.isOn);
    }
}