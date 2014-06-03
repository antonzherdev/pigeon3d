package com.pigeon3d;

import objd.lang.*;
import objd.collection.ImArray;

public class Recognizer<P> {
    public final RecognizerType<Object, P> tp;
    public static <P> Recognizer<P> applyTpBeganChangedEnded(final RecognizerType<LongRecognizer, P> tp, final F<Event<P>, Boolean> began, final P<Event<P>> changed, final P<Event<P>> ended) {
        return new LongRecognizer<P>(tp, began, changed, ended, new P<Event<P>>() {
            @Override
            public void apply(final Event<P> _) {
            }
        });
    }
    public static <P> Recognizer<P> applyTpBeganChangedEndedCanceled(final RecognizerType<LongRecognizer, P> tp, final F<Event<P>, Boolean> began, final P<Event<P>> changed, final P<Event<P>> ended, final P<Event<P>> canceled) {
        return new LongRecognizer<P>(tp, began, changed, ended, canceled);
    }
    public static <P> ShortRecognizer<P> applyTpOn(final RecognizerType<ShortRecognizer, P> tp, final F<Event<P>, Boolean> on) {
        return new ShortRecognizer<P>(tp, on);
    }
    public Recognizers addRecognizer(final Recognizer<Object> recognizer) {
        return new Recognizers(ImArray.fromObjects(((Recognizer<Object>)(((Recognizer)(((Recognizer<Object>)(((Recognizer)(this)))))))), ((Recognizer<Object>)(((Recognizer)(recognizer))))));
    }
    public Recognizer(final RecognizerType<Object, P> tp) {
        this.tp = tp;
    }
    public String toString() {
        return String.format("Recognizer(%s)", this.tp);
    }
}