package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.geometry.vec2;

public final class Platform {
    public final OS os;
    public final Device device;
    public final String text;
    public final boolean shadows;
    public final boolean touch;
    public final InterfaceIdiom interfaceIdiom;
    public final boolean isPhone;
    public final boolean isPad;
    public final boolean isComputer;
    public vec2 screenSize() {
        return this.device.screenSize;
    }
    public double screenSizeRatio() {
        return ((double)(this.screenSize().x / this.screenSize().y));
    }
    public Platform(final OS os, final Device device, final String text) {
        this.os = os;
        this.device = device;
        this.text = text;
        this.shadows = os.tp.shadows;
        this.touch = os.tp.touch;
        this.interfaceIdiom = device.interfaceIdiom;
        this.isPhone = this.interfaceIdiom.isPhone;
        this.isPad = this.interfaceIdiom.isPad;
        this.isComputer = this.interfaceIdiom.isComputer;
    }
    public String toString() {
        return String.format("Platform(%s, %s, %s)", this.os, this.device, this.text);
    }
    public boolean equals(final Object to) {
        if(this == to) {
            return true;
        }
        if(to == null || !(to instanceof Platform)) {
            return false;
        }
        final Platform o = ((Platform)(to));
        return this.os.equals(o.os) && this.device.equals(o.device) && this.text.equals(o.text);
    }
    public int hashCode() {
        int hash = 0;
        hash = hash * 31 + this.os.hashCode();
        hash = hash * 31 + this.device.hashCode();
        hash = hash * 31 + new StringEx(this.text).hashCode();
        return hash;
    }
}