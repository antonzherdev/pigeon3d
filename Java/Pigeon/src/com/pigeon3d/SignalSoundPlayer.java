package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.sound.Sound;
import objd.react.ObservableBase;
import objd.react.Observer;

public class SignalSoundPlayer<T> extends SoundPlayer_impl {
    public final Sound sound;
    public final ObservableBase<T> signal;
    public final F<T, Boolean> condition;
    private Observer<T> obs;
    @Override
    public void start() {
        this.obs = this.signal.observeF(new P<T>() {
            @Override
            public void apply(final T data) {
                if(SignalSoundPlayer.this.condition.apply(data)) {
                    SignalSoundPlayer.this.sound.play();
                }
            }
        });
    }
    @Override
    public void stop() {
        if(this.obs != null) {
            this.obs.detach();
        }
        this.obs = null;
        this.sound.stop();
    }
    @Override
    public void pause() {
        this.sound.pause();
    }
    @Override
    public void resume() {
        this.sound.resume();
    }
    public SignalSoundPlayer(final Sound sound, final ObservableBase<T> signal, final F<T, Boolean> condition) {
        this.sound = sound;
        this.signal = signal;
        this.condition = condition;
    }
    static public <T> SignalSoundPlayer<T> applySoundSignal(final Sound sound, final ObservableBase<T> signal) {
        return new SignalSoundPlayer<T>(sound, signal, new F<T, Boolean>() {
            @Override
            public Boolean apply(final T _) {
                return true;
            }
        });
    }
    public String toString() {
        return String.format("SignalSoundPlayer(%s, %s)", this.sound, this.signal);
    }
}