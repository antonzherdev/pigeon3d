package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.geometry.vec2;
import com.pigeon3d.geometry.Rect;
import com.pigeon3d.geometry.Line3;

public interface Event<P> {
    RecognizerType<Object, P> recognizerType();
    EventPhase phase();
    vec2 locationInView();
    vec2 viewSize();
    P param();
    MatrixModel matrixModel();
    Rect viewport();
    vec2 locationInViewport();
    vec2 location();
    vec2 locationForDepth(final double depth);
    Line3 segment();
    boolean checkViewport();
    String toString();
}