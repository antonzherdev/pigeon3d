package com.pigeon3d;

import objd.lang.*;

public interface BillboardParticleSystem extends ParticleSystemIndexArray {
    int vertexCount();
    @Override
    int indexCount();
    String toString();
}