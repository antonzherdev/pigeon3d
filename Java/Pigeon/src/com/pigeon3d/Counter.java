package com.pigeon3d;

import objd.lang.*;
import objd.react.React;
import objd.react.Var;

public abstract class Counter extends Updatable_impl {
    public abstract React<Boolean> isRunning();
    public abstract Var<Float> time();
    public abstract void restart();
    public abstract void finish();
    @Override
    public abstract void updateWithDelta(final double delta);
    public Counter finished() {
        this.finish();
        return this;
    }
    public void forF(final P<Float> f) {
        if(this.isRunning().value()) {
            f.apply(this.time().value());
        }
    }
    public static Counter stoppedLength(final double length) {
        return new LengthCounter(length);
    }
    public static Counter applyLength(final double length) {
        return new LengthCounter(length);
    }
    public static Counter applyLengthFinish(final double length, final P0 finish) {
        return new Finisher(new LengthCounter(length), finish);
    }
    public static Counter apply() {
        return new EmptyCounter();
    }
    public Counter onTimeEvent(final double time, final P0 event) {
        return new EventCounter(this, time, event);
    }
    public Counter onEndEvent(final P0 event) {
        return new Finisher(this, event);
    }
    public Counter() {
    }
    public String toString() {
        return "Counter";
    }
}