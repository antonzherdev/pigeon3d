package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.geometry.vec3;

public final class Contact {
    public final vec3 a;
    public final vec3 b;
    public final float distance;
    public final float impulse;
    public final int lifeTime;
    public Contact(final vec3 a, final vec3 b, final float distance, final float impulse, final int lifeTime) {
        this.a = a;
        this.b = b;
        this.distance = distance;
        this.impulse = impulse;
        this.lifeTime = lifeTime;
    }
    public String toString() {
        return String.format("Contact(%s, %s, %f, %f, %d)", this.a, this.b, this.distance, this.impulse, this.lifeTime);
    }
    public boolean equals(final Object to) {
        if(this == to) {
            return true;
        }
        if(to == null || !(to instanceof Contact)) {
            return false;
        }
        final Contact o = ((Contact)(to));
        return this.a.equals(o.a) && this.b.equals(o.b) && this.distance.equals(o.distance) && this.impulse.equals(o.impulse) && this.lifeTime == o.lifeTime;
    }
    public int hashCode() {
        int hash = 0;
        hash = hash * 31 + vec3.hashCode(this.a);
        hash = hash * 31 + vec3.hashCode(this.b);
        hash = hash * 31 + Float4.hashCode(this.distance);
        hash = hash * 31 + Float4.hashCode(this.impulse);
        hash = hash * 31 + this.lifeTime;
        return hash;
    }
}