package com.pigeon3d.sound;

import objd.lang.*;

public abstract class Sound {
    public abstract void play();
    public abstract void playLoops(final int loops);
    public abstract void playAlways();
    public abstract void stop();
    public abstract boolean isPlaying();
    public abstract void pause();
    public abstract void resume();
    public static SimpleSound applyFile(final String file) {
        return new SimpleSoundPlat(file);
    }
    public static SimpleSound applyFileVolume(final String file, final float volume) {
        final SimpleSoundPlat s = new SimpleSoundPlat(file);
        s.setVolume(volume);
        return s;
    }
    public static ParSound parLimitFileVolume(final int limit, final String file, final float volume) {
        return new ParSound(limit, new F0<SimpleSound>() {
            @Override
            public SimpleSound apply() {
                return Sound.applyFileVolume(file, volume);
            }
        });
    }
    public static ParSound parLimitFile(final int limit, final String file) {
        return Sound.parLimitFileVolume(limit, file, ((float)(1.0)));
    }
    public Sound() {
    }
    public String toString() {
        return "Sound";
    }
}