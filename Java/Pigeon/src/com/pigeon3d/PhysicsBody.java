package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.geometry.mat4;

public interface PhysicsBody<T> {
    T data();
    CollisionShape shape();
    boolean isKinematic();
    mat4 matrix();
    void setMatrix(final mat4 matrix);
    String toString();
}