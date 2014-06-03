package com.pigeon3d;

import objd.lang.*;

public abstract class SceneView_impl extends LayerView_impl implements SceneView {
    public SceneView_impl() {
    }
    public void start() {
    }
    public void stop() {
    }
    public boolean isProcessorActive() {
        return !(Director.current().isPaused.value());
    }
}