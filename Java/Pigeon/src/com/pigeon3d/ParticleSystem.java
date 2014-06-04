package com.pigeon3d;

import objd.lang.*;
import objd.concurrent.Future;
import objd.actor.Actor;

public abstract class ParticleSystem<P, D> extends Actor {
    public abstract int vertexCount();
    protected abstract void doUpdateWithDelta(final double delta);
    protected abstract int doWriteToArray(final Pointer array);
    public final PType<P> particleType;
    public final int maxCount;
    public final Pointer particles;
    public int particleSize() {
        return ((int)(this.particleType.size));
    }
    @Override
    public void finalize() throws Throwable {
        super.finalize();
        Pointer.free(this.particles);
    }
    public Future<Void> updateWithDelta(final double delta) {
        return this.<Void>futureF(new F0<Void>() {
            @Override
            public Void apply() {
                doUpdateWithDelta(delta);
                return null;
            }
        });
    }
    public Future<Integer> writeToArray(final MappedBufferData<D> array) {
        return this.<Integer>futureF(new F0<Integer>() {
            @Override
            public Integer apply() {
                int ret = ((int)(0));
                {
                    if(array.beginWrite()) {
                        {
                            final Pointer p = array.pointer;
                            ret = doWriteToArray(p);
                        }
                        array.endWrite();
                    }
                }
                return ret;
            }
        });
    }
    public ParticleSystem(final PType<P> particleType, final int maxCount) {
        this.particleType = particleType;
        this.maxCount = maxCount;
        this.particles = new Pointer<P>(((int)(this.particleSize())), ((int)(maxCount)));
    }
    public String toString() {
        return String.format("ParticleSystem(%s, %d)", this.particleType, this.maxCount);
    }
}