package com.pigeon3d;

import objd.lang.*;

public interface Controller extends Updatable {
    void start();
    void stop();
    String toString();
}