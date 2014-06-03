package com.pigeon3d.geometry;

import objd.lang.*;

public abstract class BentleyOttmannEvent<T> {
    public abstract vec2 point();
    public boolean isIntersection() {
        return false;
    }
    public boolean isStart() {
        return false;
    }
    public boolean isEnd() {
        return false;
    }
    public BentleyOttmannEvent() {
    }
    public String toString() {
        return "BentleyOttmannEvent";
    }
}