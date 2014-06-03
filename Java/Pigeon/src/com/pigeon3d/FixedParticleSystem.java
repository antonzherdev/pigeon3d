package com.pigeon3d;

import objd.lang.*;

public abstract class FixedParticleSystem<P, D> extends ParticleSystem<P, D> {
    protected void forParticlesBy(final P<Pointer> by) {
        int i = 0;
        Pointer p = this.particles;
        while(i < this.maxCount) {
            by.apply(p);
            i++;
            p++;
        }
    }
    protected int writeParticlesArrayBy(final Pointer array, final F2<Pointer, Pointer, Pointer> by) {
        int i = 0;
        Pointer p = this.particles;
        Pointer a = array;
        while(i < this.maxCount) {
            a = by.apply(a, p);
            i++;
            p++;
        }
        return this.maxCount;
    }
    public FixedParticleSystem(final PType<P> particleType, final int maxCount) {
        super(particleType, maxCount);
    }
    public String toString() {
        return "FixedParticleSystem";
    }
}