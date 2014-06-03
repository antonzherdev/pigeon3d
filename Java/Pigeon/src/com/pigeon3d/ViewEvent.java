package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.geometry.vec2;

public class ViewEvent<P> extends Event_impl<P> {
    public final RecognizerType<Object, P> recognizerType;
    @Override
    public RecognizerType<Object, P> recognizerType() {
        return recognizerType;
    }
    public final EventPhase phase;
    @Override
    public EventPhase phase() {
        return phase;
    }
    public final vec2 locationInView;
    @Override
    public vec2 locationInView() {
        return locationInView;
    }
    public final vec2 viewSize;
    @Override
    public vec2 viewSize() {
        return viewSize;
    }
    public final P param;
    @Override
    public P param() {
        return param;
    }
    public ViewEvent(final RecognizerType<Object, P> recognizerType, final EventPhase phase, final vec2 locationInView, final vec2 viewSize, final P param) {
        this.recognizerType = recognizerType;
        this.phase = phase;
        this.locationInView = locationInView;
        this.viewSize = viewSize;
        this.param = param;
    }
    public String toString() {
        return String.format("ViewEvent(%s, %s, %s, %s, %s)", this.recognizerType, this.phase, this.locationInView, this.viewSize, this.param);
    }
}