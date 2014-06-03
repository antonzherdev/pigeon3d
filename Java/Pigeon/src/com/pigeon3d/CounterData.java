package com.pigeon3d;

import objd.lang.*;
import objd.react.React;
import objd.react.Var;

public final class CounterData<T> extends Counter {
    public final Counter counter;
    public final T data;
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
    public CounterData(final Counter counter, final T data) {
        this.counter = counter;
        this.data = data;
    }
    public String toString() {
        return String.format("CounterData(%s, %s)", this.counter, this.data);
    }
}