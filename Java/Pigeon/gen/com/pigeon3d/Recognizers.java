package com.pigeon3d;

import objd.lang.*;
import objd.collection.ImArray;
import objd.collection.Seq;
import objd.collection.Set;

public class Recognizers {
    public final ImArray<Recognizer<Object>> items;
    public static Recognizers applyRecognizer(final Recognizer<Object> recognizer) {
        return new Recognizers(ImArray.fromObjects(((Recognizer<Object>)(((Recognizer)(recognizer))))));
    }
    public <P> ShortRecognizer<P> onEvent(final Event<P> event) {
        return ((ShortRecognizer<P>)(((ShortRecognizer)(this.items.findWhere(((F<Recognizer<Object>, Boolean>)(((F)(new F<Recognizer<Object>, Boolean>() {
            @Override
            public Boolean apply(final Recognizer<Object> item) {
                return event.recognizerType().equals(item.tp) && ((ShortRecognizer<P>)(((ShortRecognizer)(item)))).on.apply(event);
            }
        })))))))));
    }
    public <P> LongRecognizer beganEvent(final Event<P> event) {
        return ((LongRecognizer)(this.items.findWhere(((F<Recognizer<Object>, Boolean>)(((F)(new F<Recognizer<Object>, Boolean>() {
            @Override
            public Boolean apply(final Recognizer<Object> item) {
                return event.recognizerType().equals(item.tp) && ((LongRecognizer<P>)(((LongRecognizer)(item)))).began.apply(event);
            }
        })))))));
    }
    public Recognizers addRecognizer(final Recognizer<Object> recognizer) {
        return new Recognizers(((ImArray<Recognizer<Object>>)(((ImArray)(this.items.addItem(((Recognizer<Object>)(((Recognizer)(recognizer))))))))));
    }
    public Recognizers addRecognizers(final Recognizers recognizers) {
        return new Recognizers(((ImArray<Recognizer<Object>>)(((ImArray)(this.items.addSeq(((Seq<Recognizer<Object>>)(((Seq)(recognizers.items))))))))));
    }
    public Set<RecognizerType<Object, Object>> types() {
        return ((Set<RecognizerType<Object, Object>>)(((Set)(this.items.chain().<RecognizerType<Object, Object>>mapF(((F<Recognizer<Object>, RecognizerType<Object, Object>>)(((F)(new F<Recognizer<Object>, RecognizerType<Object, Object>>() {
            @Override
            public RecognizerType<Object, Object> apply(final Recognizer<Object> _) {
                return _.tp;
            }
        }))))).toSet()))));
    }
    public Recognizers(final ImArray<Recognizer<Object>> items) {
        this.items = items;
    }
    public String toString() {
        return String.format("Recognizers(%s)", this.items);
    }
}