package com.pigeon3d;

import objd.lang.*;
import objd.react.Observer;
import objd.react.React;
import objd.react.Var;

public final class EventCounter extends Counter {
    public final Counter counter;
    public final double eventTime;
    public final P0 event;
    private boolean executed;
    private final Observer<Float> obs;
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
        this.executed = false;
        this.counter.restart();
    }
    @Override
    public void finish() {
        this.executed = true;
        this.counter.finish();
    }
    public EventCounter(final Counter counter, final double eventTime, final P0 event) {
        this.counter = counter;
        this.eventTime = eventTime;
        this.event = event;
        this.executed = false;
        this.obs = counter.time().observeF(new P<Float>() {
            @Override
            public void apply(final Float time) {
                if(!(EventCounter.this.executed)) {
                    if(counter.time().value() > eventTime) {
                        event.apply();
                        EventCounter.this.executed = true;
                    }
                } else {
                    if(counter.time().value() < eventTime) {
                        EventCounter.this.executed = false;
                    }
                }
            }
        });
    }
    public String toString() {
        return String.format("EventCounter(%s, %f)", this.counter, this.eventTime);
    }
}