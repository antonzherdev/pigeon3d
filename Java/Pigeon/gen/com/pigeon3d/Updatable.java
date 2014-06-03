package com.pigeon3d;

import objd.lang.*;

public interface Updatable {
    void updateWithDelta(final double delta);
    String toString();
}