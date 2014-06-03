package com.pigeon3d;

import objd.lang.*;
import objd.react.Observer;
import objd.react.React;
import objd.react.Var;

public final class Finisher extends Counter {
    public final Counter counter;
    public final P0 onFinish;
    private final Observer<Boolean> obs;
    @Override
    public React<Boolean> isRunning() {
        return this.counter.isRunning();
    }
    @Override
    public Var<Float> time() {
        return this.counter.time();
    }
    @Override
    public void updateWithDelta(final double delta) {
        this.counter.updateWithDelta(delta);
    }
    @Override
    public void restart() {
        this.counter.restart();
    }
    @Override
    public void finish() {
        this.counter.finish();
    }
    public Finisher(final Counter counter, final P0 onFinish) {
        this.counter = counter;
        this.onFinish = onFinish;
        this.obs = counter.isRunning().observeF(new P<Boolean>() {
            @Override
            public void apply(final Boolean r) {
                if(!(r)) {
                    onFinish.apply();
                }
            }
        });
    }
    public String toString() {
        return String.format("Finisher(%s)", this.counter);
    }
}