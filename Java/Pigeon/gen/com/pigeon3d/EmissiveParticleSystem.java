package com.pigeon3d;

import objd.lang.*;

public abstract class EmissiveParticleSystem<P, D> extends ParticleSystem<P, D> {
    protected int _lifeCount;
    protected final int _particleSize;
    protected int _nextInvalidNumber;
    protected Pointer _nextInvalidRef;
    protected void updateParticlesBy(final F<Pointer, Boolean> by) {
        int i = 0;
        Pointer p = this.particles;
        while(i < this.maxCount) {
            if(ERROR: Unknown *(<lm>p\§P#G§*\.cast<byte*>) != 0) {
                final boolean ch = by.apply(p);
                if(!(ch)) {
                    ERROR: Unknown *(<lm>p\§P#G§*\.cast<byte*>) = 0;
                    this._lifeCount--;
                    this._nextInvalidRef = p;
                    this._nextInvalidNumber = i;
                }
            }
            i++;
            p++;
        }
    }
    protected void emitBy(final P<Pointer> by) {
        if(this._lifeCount < this.maxCount) {
            Pointer p = this._nextInvalidRef;
            boolean round = false;
            while(ERROR: Unknown *(<lm>p\§P#G§*\.cast<byte*>) != 0) {
                this._nextInvalidNumber++;
                if(this._nextInvalidNumber >= this.maxCount) {
                    if(round) {
                        return ;
                    }
                    round = true;
                    this._nextInvalidNumber = 0;
                    p = this.particles;
                } else {
                    p++;
                }
            }
            ERROR: Unknown *(<lm>p\§P#G§*\.cast<byte*>) = 1;
            by.apply(p);
            this._nextInvalidRef = p;
            this._lifeCount++;
        }
    }
    protected int writeParticlesArrayBy(final Pointer array, final F2<Pointer, Pointer, Pointer> by) {
        int i = 0;
        Pointer p = this.particles;
        Pointer a = array;
        while(i < this.maxCount) {
            if(ERROR: Unknown *(<lm>p\§P#G§*\.cast<byte*>) != 0) {
                a = by.apply(a, p);
            }
            i++;
            p++;
        }
        return ((int)(this._lifeCount));
    }
    public EmissiveParticleSystem(final PType<P> particleType, final int maxCount) {
        super(particleType, maxCount);
        this._lifeCount = 0;
        this._particleSize = this.particleSize();
        this._nextInvalidNumber = 0;
        this._nextInvalidRef = this.particles;
    }
    public String toString() {
        return "EmissiveParticleSystem";
    }
}