package com.pigeon3d;

import objd.lang.*;

public class MapTileCutState {
    public final int x;
    public final int y;
    public final int x2;
    public final int y2;
    public MapTileCutState(final int x, final int y, final int x2, final int y2) {
        this.x = x;
        this.y = y;
        this.x2 = x2;
        this.y2 = y2;
    }
    public String toString() {
        return String.format("MapTileCutState(%d, %d, %d, %d)", this.x, this.y, this.x2, this.y2);
    }
    public boolean equals(final MapTileCutState to) {
        return this.x == to.x && this.y == to.y && this.x2 == to.x2 && this.y2 == to.y2;
    }
    public int hashCode() {
        int hash = 0;
        hash = hash * 31 + this.x;
        hash = hash * 31 + this.y;
        hash = hash * 31 + this.x2;
        hash = hash * 31 + this.y2;
        return hash;
    }
}