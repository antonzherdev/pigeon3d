package com.pigeon3d;

import objd.lang.*;

public class ShortRecognizer<P> extends Recognizer<P> {
    public final F<Event<P>, Boolean> on;
    public ShortRecognizer(final RecognizerType<ShortRecognizer, P> tp, final F<Event<P>, Boolean> on) {
        super(((RecognizerType<Object, P>)(((RecognizerType)(tp)))));
        this.on = on;
    }
    public String toString() {
        return String.format(")");
    }
}