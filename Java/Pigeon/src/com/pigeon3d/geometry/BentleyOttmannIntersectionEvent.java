package com.pigeon3d.geometry;

import objd.lang.*;

public final class BentleyOttmannIntersectionEvent<T> extends BentleyOttmannEvent<T> {
    public final vec2 point;
    @Override
    public vec2 point() {
        return point;
    }
    @Override
    public boolean isIntersection() {
        return true;
    }
    public BentleyOttmannIntersectionEvent(final vec2 point) {
        this.point = point;
    }
    public String toString() {
        return String.format("BentleyOttmannIntersectionEvent(%s)", this.point);
    }
}