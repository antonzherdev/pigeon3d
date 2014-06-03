package com.pigeon3d;

import objd.lang.*;
import objd.collection.MHashMap;

public class RecognizersState {
    public final Recognizers recognizers;
    private final MHashMap<RecognizerType<LongRecognizer>, LongRecognizer<Object>> longMap;
    public <P> boolean processEvent(final Event<P> event) {
        if(event.phase() == EventPhase.on) {
            return this.<P>onEvent(event);
        } else {
            if(event.phase() == EventPhase.began) {
                return this.<P>beganEvent(event);
            } else {
                if(event.phase() == EventPhase.ended) {
                    return this.<P>endedEvent(event);
                } else {
                    if(event.phase() == EventPhase.changed) {
                        return this.<P>changedEvent(event);
                    } else {
                        return this.<P>canceledEvent(event);
                    }
                }
            }
        }
    }
    public <P> boolean onEvent(final Event<P> event) {
        return this.recognizers.<P>onEvent(event) != null;
    }
    public <P> boolean beganEvent(final Event<P> event) {
        final RecognizerType<Object, P> tp = event.recognizerType();
        return this.longMap.modifyKeyBy(((RecognizerType<LongRecognizer>)(((RecognizerType)(tp)))), new F<LongRecognizer<Object>, LongRecognizer<Object>>() {
            @Override
            public LongRecognizer<Object> apply(final LongRecognizer<Object> _) {
                return ((LongRecognizer<Object>)(((LongRecognizer)(RecognizersState.this.recognizers.<P>beganEvent(event)))));
            }
        }) != null;
    }
    public <P> boolean changedEvent(final Event<P> event) {
        final Boolean __tmp;
        {
            final LongRecognizer<Object> rec = this.longMap.applyKey(((RecognizerType<LongRecognizer>)(((RecognizerType)(event.recognizerType())))));
            if(rec != null) {
                rec.changed.apply(((Event<Object>)(((Event)(event)))));
                __tmp = true;
            } else {
                __tmp = null;
            }
        }
        if(__tmp != null) {
            return __tmp;
        } else {
            return false;
        }
    }
    public <P> boolean endedEvent(final Event<P> event) {
        final RecognizerType<Object, P> tp = event.recognizerType();
        {
            final LongRecognizer<Object> __tmp_1iu = this.longMap.applyKey(((RecognizerType<LongRecognizer>)(((RecognizerType)(tp)))));
            final P<Event<Object>> __tmp_1u = ((__tmp_1iu != null) ? (__tmp_1iu.ended) : (null));
            if(__tmp_1u != null) {
                __tmp_1u.apply(((Event<Object>)(((Event)(event)))));
            }
        }
        return this.longMap.removeKey(((RecognizerType<LongRecognizer>)(((RecognizerType)(tp))))) != null;
    }
    public <P> boolean canceledEvent(final Event<P> event) {
        final RecognizerType<Object, P> tp = event.recognizerType();
        {
            final LongRecognizer<Object> __tmp_1iu = this.longMap.applyKey(((RecognizerType<LongRecognizer>)(((RecognizerType)(tp)))));
            final P<Event<Object>> __tmp_1u = ((__tmp_1iu != null) ? (__tmp_1iu.canceled) : (null));
            if(__tmp_1u != null) {
                __tmp_1u.apply(((Event<Object>)(((Event)(event)))));
            }
        }
        return this.longMap.removeKey(((RecognizerType<LongRecognizer>)(((RecognizerType)(tp))))) != null;
    }
    public RecognizersState(final Recognizers recognizers) {
        this.recognizers = recognizers;
        this.longMap = ((MHashMap<RecognizerType<LongRecognizer>, LongRecognizer<Object>>)(((MHashMap)(new MHashMap<RecognizerType<LongRecognizer>, LongRecognizer<Object>>()))));
    }
    public String toString() {
        return String.format("RecognizersState(%s)", this.recognizers);
    }
}