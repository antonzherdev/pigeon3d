package com.pigeon3d;

import objd.lang.*;
import objd.react.Var;
import objd.react.React;

public final class LengthCounter extends Counter {
    public final double length;
    public final Var<Float> time;
    @Override
    public Var<Float> time() {
        return time;
    }
    public final React<Boolean> isRunning;
    @Override
    public React<Boolean> isRunning() {
        return isRunning;
    }
    @Override
    public void updateWithDelta(final double delta) {
        if(this.isRunning.value()) {
            double t = this.time.value();
            t += delta / this.length;
            if(t >= 1.0) {
                this.time.setValue(1.0);
            } else {
                this.time.setValue(t);
            }
        }
    }
    @Override
    public void restart() {
        this.time.setValue(0.0);
    }
    @Override
    public void finish() {
        this.time.setValue(1.0);
    }
    public LengthCounter(final double length) {
        this.length = length;
        this.time = Var.<Float>applyInitial(0.0);
        this.isRunning = this.time.<Boolean>mapF(new F<Float, Boolean>() {
            @Override
            public Boolean apply(final Float _) {
                return _ < 1.0;
            }
        });
    }
    public String toString() {
        return String.format("LengthCounter(%f)", this.length);
    }
}