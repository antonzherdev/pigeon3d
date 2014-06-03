package com.pigeon3d;

import objd.lang.*;

public enum OSType {
    MacOS(true, false),
    iOS(true, true);
    private OSType(final boolean shadows, final boolean touch) {
        this.shadows = shadows;
        this.touch = touch;
    }
    public final boolean shadows;
    public final boolean touch;
}