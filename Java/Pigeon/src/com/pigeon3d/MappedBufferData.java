package com.pigeon3d;

import objd.lang.*;
import objd.concurrent.ConditionLock;

public class MappedBufferData<T> {
    public final MutableGlBuffer<T> buffer;
    public final Pointer pointer;
    private final ConditionLock lock;
    private boolean finished;
    private boolean updated;
    public boolean wasUpdated() {
        return this.updated;
    }
    public boolean beginWrite() {
        if(this.finished) {
            return false;
        } else {
            this.lock.lock();
            if(this.finished) {
                this.lock.unlock();
                return false;
            } else {
                return true;
            }
        }
    }
    public void endWrite() {
        this.updated = true;
        this.lock.unlockWithCondition(1);
    }
    public void writeF(final P<Pointer> f) {
        if(this.beginWrite()) {
            f.apply(this.pointer);
            this.endWrite();
        }
    }
    public void finish() {
        this.lock.lockWhenCondition(1);
        this.buffer._finishMapping();
        this.finished = true;
        this.lock.unlock();
    }
    public MappedBufferData(final MutableGlBuffer<T> buffer, final Pointer pointer) {
        this.buffer = buffer;
        this.pointer = pointer;
        this.lock = new ConditionLock(0);
        this.finished = false;
        this.updated = false;
    }
    public String toString() {
        return String.format("MappedBufferData(%s, %p)", this.buffer, this.pointer);
    }
}