package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.geometry.Rect;
import com.pigeon3d.geometry.vec2;
import com.pigeon3d.geometry.Line3;
import com.pigeon3d.geometry.Plane;
import com.pigeon3d.geometry.vec3;
import com.pigeon3d.geometry.mat4;
import com.pigeon3d.geometry.vec4;

public class CameraEvent<P> extends Event_impl<P> {
    public final Event<P> event;
    public final MatrixModel matrixModel;
    @Override
    public MatrixModel matrixModel() {
        return matrixModel;
    }
    public final Rect viewport;
    @Override
    public Rect viewport() {
        return viewport;
    }
    public final RecognizerType<Object, P> recognizerType;
    @Override
    public RecognizerType<Object, P> recognizerType() {
        return recognizerType;
    }
    public final vec2 locationInView;
    @Override
    public vec2 locationInView() {
        return locationInView;
    }
    public Line3 segment() {
        return _lazy_segment.get();
    }
    private final Lazy<Line3> _lazy_segment;
    @Override
    public EventPhase phase() {
        return this.event.phase();
    }
    @Override
    public vec2 viewSize() {
        return this.event.viewSize();
    }
    @Override
    public P param() {
        return this.event.param();
    }
    @Override
    public vec2 location() {
        return locationForDepth(((double)(0)));
    }
    @Override
    public vec2 locationInViewport() {
        return vec2.subVec2(vec2.mulI(vec2.divVec2(vec2.subVec2(this.locationInView, this.viewport.p), this.viewport.size), 2), new vec2(((float)(1)), ((float)(1))));
    }
    @Override
    public vec2 locationForDepth(final double depth) {
        return vec3.xy(Line3.rPlane(this.segment(), new Plane(new vec3(((float)(0)), ((float)(0)), ((float)(depth))), new vec3(((float)(0)), ((float)(0)), ((float)(1))))));
    }
    @Override
    public boolean checkViewport() {
        return Rect.containsVec2(this.viewport, this.locationInView);
    }
    public CameraEvent(final Event<P> event, final MatrixModel matrixModel, final Rect viewport) {
        this.event = event;
        this.matrixModel = matrixModel;
        this.viewport = viewport;
        this.recognizerType = ((RecognizerType<Object, P>)(((RecognizerType)(event.recognizerType()))));
        this.locationInView = event.locationInView();
        this._lazy_segment = new Lazy<Line3>(new F0<Line3>() {
            @Override
            public Line3 apply() {
                final vec2 loc = CameraEvent.this.locationInViewport();
                final mat4 mat4 = matrixModel.wcp().inverse();
                final vec4 p0 = mat4.mulVec4(new vec4(loc.x, loc.y, ((float)(-1)), ((float)(1))));
                final vec4 p1 = mat4.mulVec4(new vec4(loc.x, loc.y, ((float)(1)), ((float)(1))));
                return new Line3(vec4.xyz(p0), vec3.subVec3(vec4.xyz(p1), vec4.xyz(p0)));
            }
        });
    }
    public String toString() {
        return String.format("CameraEvent(%s, %s, %s)", this.event, this.matrixModel, this.viewport);
    }
}