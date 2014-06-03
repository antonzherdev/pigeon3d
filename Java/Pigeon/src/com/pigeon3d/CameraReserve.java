package com.pigeon3d;

import objd.lang.*;

public class CameraReserve {
    public final float left;
    public final float right;
    public final float top;
    public final float bottom;
    public float width() {
        return this.left + this.right;
    }
    public float height() {
        return this.top + this.bottom;
    }
    public CameraReserve mulF4(final float f4) {
        return new CameraReserve(this.left * f4, this.right * f4, this.top * f4, this.bottom * f4);
    }
    public CameraReserve divF4(final float f4) {
        return new CameraReserve(this.left / f4, this.right / f4, this.top / f4, this.bottom / f4);
    }
    public CameraReserve(final float left, final float right, final float top, final float bottom) {
        this.left = left;
        this.right = right;
        this.top = top;
        this.bottom = bottom;
    }
    public String toString() {
        return String.format("CameraReserve(%f, %f, %f, %f)", this.left, this.right, this.top, this.bottom);
    }
    public boolean equals(final CameraReserve to) {
        return this.left.equals(to.left) && this.right.equals(to.right) && this.top.equals(to.top) && this.bottom.equals(to.bottom);
    }
    public int hashCode() {
        int hash = 0;
        hash = hash * 31 + Float4.hashCode(this.left);
        hash = hash * 31 + Float4.hashCode(this.right);
        hash = hash * 31 + Float4.hashCode(this.top);
        hash = hash * 31 + Float4.hashCode(this.bottom);
        return hash;
    }
}