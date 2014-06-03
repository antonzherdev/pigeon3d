package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.sound.Sound;

public class SporadicSoundPlayer extends SoundPlayer_impl {
    public final Sound sound;
    public final double secondsBetween;
    private double _timeToNextPlaying;
    private boolean wasPlaying;
    @Override
    public void start() {
        this._timeToNextPlaying = Float.rndMinMax(((double)(0)), this.secondsBetween * 2);
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
    @Override
    public void updateWithDelta(final double delta) {
        if(!(this.sound.isPlaying())) {
            this._timeToNextPlaying -= delta;
            if(this._timeToNextPlaying <= 0) {
                this.sound.play();
                this._timeToNextPlaying = Float.rndMinMax(((double)(0)), this.secondsBetween * 2);
            }
        }
    }
    public SporadicSoundPlayer(final Sound sound, final double secondsBetween) {
        this.sound = sound;
        this.secondsBetween = secondsBetween;
        this._timeToNextPlaying = ((double)(0));
        this.wasPlaying = false;
    }
    public String toString() {
        return String.format("SporadicSoundPlayer(%s, %f)", this.sound, this.secondsBetween);
    }
}