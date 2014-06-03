package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.geometry.Rect;
import com.pigeon3d.geometry.vec2;

public interface LayerView extends Updatable {
    String name();
    Camera camera();
    void prepare();
    void draw();
    void complete();
    @Override
    void updateWithDelta(final double delta);
    Environment environment();
    void reshapeWithViewport(final Rect viewport);
    Rect viewportWithViewSize(final vec2 viewSize);
    String toString();
}