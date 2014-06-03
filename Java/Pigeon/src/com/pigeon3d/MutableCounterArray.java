package com.pigeon3d;

import objd.lang.*;
import objd.collection.ImArray;
import objd.collection.Iterator;

public class MutableCounterArray<T> extends Updatable_impl {
    private ImArray<CounterData<T>> _counters;
    public ImArray<CounterData<T>> counters() {
        return this._counters;
    }
    public void appendCounter(final CounterData<T> counter) {
        this._counters = this._counters.addItem(counter);
    }
    public void appendCounterData(final Counter counter, final T data) {
        this._counters = this._counters.addItem(new CounterData<T>(counter, data));
    }
    @Override
    public void updateWithDelta(final double delta) {
        boolean hasDied = false;
        {
            final Iterator<CounterData<T>> __il__1i = this._counters.iterator();
            while(__il__1i.hasNext()) {
                final CounterData<T> counter = __il__1i.next();
                {
                    counter.updateWithDelta(delta);
                    if(!(counter.isRunning().value())) {
                        hasDied = true;
                    }
                }
            }
        }
        if(hasDied) {
            this._counters = this._counters.chain().filterWhen(new F<CounterData<T>, Boolean>() {
                @Override
                public Boolean apply(final CounterData<T> _) {
                    return !(_.isRunning().value());
                }
            }).toArray();
        }
    }
    public void forEach(final P<CounterData<T>> each) {
        {
            final Iterator<CounterData<T>> __il__0i = this._counters.iterator();
            while(__il__0i.hasNext()) {
                each.apply(__il__0i.next());
            }
        }
    }
    public MutableCounterArray() {
        this._counters = ImArray.<CounterData<T>>empty();
    }
    public String toString() {
        return "MutableCounterArray";
    }
}