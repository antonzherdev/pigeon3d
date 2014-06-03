package com.pigeon3d;

import objd.lang.*;

public interface SoundPlayer extends Updatable {
    void start();
    void stop();
    void pause();
    void resume();
    @Override
    void updateWithDelta(final double delta);
    String toString();
}