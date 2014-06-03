package com.pigeon3d;

import objd.lang.*;

public final class Tap extends RecognizerType<ShortRecognizer, Void> {
    public final int fingers;
    public final int taps;
    public Tap(final int fingers, final int taps) {
        this.fingers = fingers;
        this.taps = taps;
    }
    static public Tap applyFingers(final int fingers) {
        return new Tap(fingers, ((int)(1)));
    }
    static public Tap applyTaps(final int taps) {
        return new Tap(((int)(1)), taps);
    }
    static public Tap apply() {
        return new Tap(((int)(1)), ((int)(1)));
    }
    public String toString() {
        return String.format("Tap(%d, %d)", this.fingers, this.taps);
    }
    public boolean equals(final Object to) {
        if(this == to) {
            return true;
        }
        if(to == null || !(to instanceof Tap)) {
            return false;
        }
        final Tap o = ((Tap)(to));
        return this.fingers == o.fingers && this.taps == o.taps;
    }
    public int hashCode() {
        int hash = 0;
        hash = hash * 31 + this.fingers;
        hash = hash * 31 + this.taps;
        return hash;
    }
}