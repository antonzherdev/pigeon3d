package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.geometry.Rect;
import com.pigeon3d.geometry.vec2;
import com.pigeon3d.geometry.Line3;
import com.pigeon3d.geometry.vec3;

public abstract class Event_impl<P> implements Event<P> {
    public Event_impl() {
    }
    public MatrixModel matrixModel() {
        return MatrixModel.identity;
    }
    public Rect viewport() {
        return Rect.applyXYWidthHeight(((float)(0)), ((float)(0)), ((float)(1)), ((float)(1)));
    }
    public vec2 locationInViewport() {
        return this.locationInView();
    }
    public vec2 location() {
        return this.locationInView();
    }
    public vec2 locationForDepth(final double depth) {
        return this.locationInView();
    }
    public Line3 segment() {
        return new Line3(vec3.applyVec2Z(this.locationInView(), ((float)(0))), new vec3(((float)(0)), ((float)(0)), ((float)(1000))));
    }
    public boolean checkViewport() {
        return true;
    }
}