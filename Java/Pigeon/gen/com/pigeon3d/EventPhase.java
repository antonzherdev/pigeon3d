package com.pigeon3d;

import objd.lang.*;

public enum EventPhase {
    began(),
    changed(),
    ended(),
    canceled(),
    on();
    private EventPhase() {
    }
}