package com.pigeon3d;

import objd.lang.*;
import objd.react.React;
import objd.react.Val;
import objd.react.Var;

public final class EmptyCounter extends Counter {
    public static final EmptyCounter instance;
    @Override
    public React<Boolean> isRunning() {
        return new Val<Boolean>(false);
    }
    @Override
    public Var<Float> time() {
        return Var.<Float>applyInitial(1.0);
    }
    @Override
    public void updateWithDelta(final double delta) {
    }
    @Override
    public void restart() {
    }
    @Override
    public void finish() {
    }
    public EmptyCounter() {
    }
    public String toString() {
        return "EmptyCounter";
    }
    static {
        instance = new EmptyCounter();
    }
}