package com.pigeon3d.geometry;

import objd.lang.*;
import objd.collection.Pair;

public final class Intersection<T> {
    public final Pair<T> items;
    public final vec2 point;
    public Intersection(final Pair<T> items, final vec2 point) {
        this.items = items;
        this.point = point;
    }
    public String toString() {
        return String.format("Intersection(%s, %s)", this.items, this.point);
    }
    public boolean equals(final Object to) {
        if(this == to) {
            return true;
        }
        if(to == null || !(to instanceof Intersection)) {
            return false;
        }
        final Intersection<T> o = ((Intersection<T>)(((Intersection)(to))));
        return this.items.equals(o.items) && this.point.equals(o.point);
    }
    public int hashCode() {
        int hash = 0;
        hash = hash * 31 + this.items.hashCode();
        hash = hash * 31 + vec2.hashCode(this.point);
        return hash;
    }
}