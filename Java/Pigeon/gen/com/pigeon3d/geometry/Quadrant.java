package com.pigeon3d.geometry;

import objd.lang.*;

public class Quadrant {
    public final Quad[4] quads;
    public Quad rndQuad() {
        return this.quads[UInt.rndMax(((int)(3)))];
    }
    public Quadrant(final Quad[4] quads) {
        this.quads = quads;
    }
    public String toString() {
        return String.format("Quadrant([%s, %s, %s, %s])", this.quads[0], this.quads[1], this.quads[2], this.quads[3]);
    }
    public boolean equals(final Quadrant to) {
        return this.quads.equals(to.quads);
    }
    public int hashCode() {
        int hash = 0;
        hash = hash * 31 + 13 * (13 * (13 * Quad.hashCode(this.quads[0]) + Quad.hashCode(this.quads[1])) + Quad.hashCode(this.quads[2])) + Quad.hashCode(this.quads[3]);
        return hash;
    }
}