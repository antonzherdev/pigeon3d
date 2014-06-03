package com.pigeon3d;

import objd.lang.*;

public final class Pinch extends RecognizerType<LongRecognizer, PinchParameter> {
    public Pinch() {
    }
    public String toString() {
        return "Pinch";
    }
    public boolean equals(final Object to) {
        if(this == to) {
            return true;
        }
        if(to == null || !(to instanceof Pinch)) {
            return false;
        }
        return true;
    }
    public int hashCode() {
        return 0;
    }
}