package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.geometry.vec4;

public class CircleSegment {
    public final vec4 color;
    public final float start;
    public final float end;
    public CircleSegment(final vec4 color, final float start, final float end) {
        this.color = color;
        this.start = start;
        this.end = end;
    }
    public String toString() {
        return String.format("CircleSegment(%s, %f, %f)", this.color, this.start, this.end);
    }
}