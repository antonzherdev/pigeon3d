package com.pigeon3d;

import objd.lang.*;

public abstract class BillboardParticleSystem_impl extends ParticleSystemIndexArray_impl implements BillboardParticleSystem {
    public BillboardParticleSystem_impl() {
    }
    @Override
    public int indexCount() {
        return ((int)(6));
    }
    @Override
    protected Pointer createIndexArray() {
        final Pointer indexPointer = new Pointer<Integer>(((int)(4)), this.indexCount() * this.maxCount());
        Pointer ia = indexPointer;
        int i = 0;
        int j = ((int)(0));
        while(i < this.maxCount()) {
            ERROR: Unknown *((<lm>ia\§^uint4§*\ + 0)) = j;
            ERROR: Unknown *((<lm>ia\§^uint4§*\ + 1)) = j + 1;
            ERROR: Unknown *((<lm>ia\§^uint4§*\ + 2)) = j + 2;
            ERROR: Unknown *((<lm>ia\§^uint4§*\ + 3)) = j + 2;
            ERROR: Unknown *((<lm>ia\§^uint4§*\ + 4)) = j;
            ERROR: Unknown *((<lm>ia\§^uint4§*\ + 5)) = j + 3;
            ia += 6;
            i++;
            j += ((int)(4));
        }
        return indexPointer;
    }
    public int vertexCount() {
        return ((int)(4));
    }
}