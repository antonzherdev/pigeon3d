package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.geometry.vec3;

public final class CrossPoint<T> {
    public final CollisionBody<T> body;
    public final vec3 point;
    public CrossPoint(final CollisionBody<T> body, final vec3 point) {
        this.body = body;
        this.point = point;
    }
    public String toString() {
        return String.format("CrossPoint(%s, %s)", this.body, this.point);
    }
    public boolean equals(final Object to) {
        if(this == to) {
            return true;
        }
        if(to == null || !(to instanceof CrossPoint)) {
            return false;
        }
        final CrossPoint<T> o = ((CrossPoint<T>)(((CrossPoint)(to))));
        return this.body.equals(o.body) && this.point.equals(o.point);
    }
    public int hashCode() {
        int hash = 0;
        hash = hash * 31 + this.body.hashCode();
        hash = hash * 31 + vec3.hashCode(this.point);
        return hash;
    }
}