package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.sound.SimpleSound;

public class BackgroundSoundPlayer extends SoundPlayer_impl {
    public final SimpleSound sound;
    @Override
    public void start() {
        this.sound.playAlways();
    }
    @Override
    public void stop() {
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
    public BackgroundSoundPlayer(final SimpleSound sound) {
        this.sound = sound;
    }
    public String toString() {
        return String.format("BackgroundSoundPlayer(%s)", this.sound);
    }
}