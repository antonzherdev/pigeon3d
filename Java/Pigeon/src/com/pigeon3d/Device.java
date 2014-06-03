package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.geometry.vec2;

public final class Device {
    public final DeviceType tp;
    public final InterfaceIdiom interfaceIdiom;
    public final Version version;
    public final vec2 screenSize;
    public boolean isIPhoneLessVersion(final String version) {
        return this.tp == DeviceType.iPhone && this.version.lessThan(version);
    }
    public boolean isIPodTouchLessVersion(final String version) {
        return this.tp == DeviceType.iPodTouch && this.version.lessThan(version);
    }
    public Device(final DeviceType tp, final InterfaceIdiom interfaceIdiom, final Version version, final vec2 screenSize) {
        this.tp = tp;
        this.interfaceIdiom = interfaceIdiom;
        this.version = version;
        this.screenSize = screenSize;
    }
    public String toString() {
        return String.format("Device(%s, %s, %s, %s)", this.tp, this.interfaceIdiom, this.version, this.screenSize);
    }
    public boolean equals(final Object to) {
        if(this == to) {
            return true;
        }
        if(to == null || !(to instanceof Device)) {
            return false;
        }
        final Device o = ((Device)(to));
        return this.tp == o.tp && this.interfaceIdiom == o.interfaceIdiom && this.version.equals(o.version) && this.screenSize.equals(o.screenSize);
    }
    public int hashCode() {
        int hash = 0;
        hash = hash * 31 + this.tp.hashCode();
        hash = hash * 31 + this.interfaceIdiom.hashCode();
        hash = hash * 31 + this.version.hashCode();
        hash = hash * 31 + vec2.hashCode(this.screenSize);
        return hash;
    }
}