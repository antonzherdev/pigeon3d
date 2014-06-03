package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.geometry.vec4;
import com.pigeon3d.geometry.vec3;
import com.pigeon3d.geometry.vec2;

public class CircleParam {
    public final vec4 color;
    public final vec4 strokeColor;
    public final vec3 position;
    public final vec2 radius;
    public final vec2 relative;
    public final CircleSegment segment;
    public CircleParam(final vec4 color, final vec4 strokeColor, final vec3 position, final vec2 radius, final vec2 relative, final CircleSegment segment) {
        this.color = color;
        this.strokeColor = strokeColor;
        this.position = position;
        this.radius = radius;
        this.relative = relative;
        this.segment = segment;
    }
    public String toString() {
        return String.format("CircleParam(%s, %s, %s, %s, %s, %s)", this.color, this.strokeColor, this.position, this.radius, this.relative, this.segment);
    }
}