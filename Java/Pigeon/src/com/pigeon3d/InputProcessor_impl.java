package com.pigeon3d;

import objd.lang.*;

public abstract class InputProcessor_impl implements InputProcessor {
    public InputProcessor_impl() {
    }
    public boolean isProcessorActive() {
        return !(Director.current().isPaused.value());
    }
}