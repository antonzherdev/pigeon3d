package com.pigeon3d;

import objd.lang.*;

public enum DeviceType {
    iPhone(),
    iPad(),
    iPodTouch(),
    Simulator(),
    Mac();
    private DeviceType() {
    }
}