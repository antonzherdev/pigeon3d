package com.pigeon3d;

import objd.lang.*;

public final class PinchParameter {
    public final double scale;
    public final double velocity;
    public PinchParameter(final double scale, final double velocity) {
        this.scale = scale;
        this.velocity = velocity;
    }
    public String toString() {
        return String.format("PinchParameter(%f, %f)", this.scale, this.velocity);
    }
    public boolean equals(final Object to) {
        if(this == to) {
            return true;
        }
        if(to == null || !(to instanceof PinchParameter)) {
            return false;
        }
        final PinchParameter o = ((PinchParameter)(to));
        return this.scale.equals(o.scale) && this.velocity.equals(o.velocity);
    }
    public int hashCode() {
        int hash = 0;
        hash = hash * 31 + Float.hashCode(this.scale);
        hash = hash * 31 + Float.hashCode(this.velocity);
        return hash;
    }
}