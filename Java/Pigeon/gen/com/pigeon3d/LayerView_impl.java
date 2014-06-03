package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.geometry.Rect;
import com.pigeon3d.geometry.vec2;

public abstract class LayerView_impl extends Updatable_impl implements LayerView {
    public LayerView_impl() {
    }
    @Override
    public void updateWithDelta(final double delta) {
    }
    public void prepare() {
    }
    public void complete() {
    }
    public Environment environment() {
        return Environment.aDefault;
    }
    public void reshapeWithViewport(final Rect viewport) {
    }
    public Rect viewportWithViewSize(final vec2 viewSize) {
        return Layer.viewportWithViewSizeViewportLayoutViewportRatio(viewSize, Rect.applyXYWidthHeight(((float)(0)), ((float)(0)), ((float)(1)), ((float)(1))), ((float)(this.camera().viewportRatio())));
    }
}