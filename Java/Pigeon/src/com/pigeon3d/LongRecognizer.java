package com.pigeon3d;

import objd.lang.*;

public class LongRecognizer<P> extends Recognizer<P> {
    public final F<Event<P>, Boolean> began;
    public final P<Event<P>> changed;
    public final P<Event<P>> ended;
    public final P<Event<P>> canceled;
    public LongRecognizer(final RecognizerType<LongRecognizer, P> tp, final F<Event<P>, Boolean> began, final P<Event<P>> changed, final P<Event<P>> ended, final P<Event<P>> canceled) {
        super(((RecognizerType<Object, P>)(((RecognizerType)(tp)))));
        this.began = began;
        this.changed = changed;
        this.ended = ended;
        this.canceled = canceled;
    }
    public String toString() {
        return String.format(")");
    }
}