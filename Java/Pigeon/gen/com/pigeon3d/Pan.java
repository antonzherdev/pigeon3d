package com.pigeon3d;

import objd.lang.*;

public final class Pan extends RecognizerType<LongRecognizer, Void> {
    public static final Pan leftMouse;
    public static final Pan rightMouse;
    public final int fingers;
    public static Pan apply() {
        return Pan.leftMouse;
    }
    public Pan(final int fingers) {
        this.fingers = fingers;
    }
    public String toString() {
        return String.format("Pan(%d)", this.fingers);
    }
    public boolean equals(final Object to) {
        if(this == to) {
            return true;
        }
        if(to == null || !(to instanceof Pan)) {
            return false;
        }
        final Pan o = ((Pan)(to));
        return this.fingers == o.fingers;
    }
    public int hashCode() {
        int hash = 0;
        hash = hash * 31 + this.fingers;
        return hash;
    }
    static {
        leftMouse = new Pan(((int)(1)));
        rightMouse = new Pan(((int)(2)));
    }
}