package com.pigeon3d.sound;

import objd.lang.*;

public abstract class SimpleSound extends Sound {
    public abstract float pan();
    public abstract void setPan(final float pan);
    public abstract float volume();
    public abstract void setVolume(final float volume);
    public abstract double time();
    public abstract void setTime(final double time);
    public abstract double duration();
    public final String file;
    public SimpleSound(final String file) {
        this.file = file;
    }
    public String toString() {
        return String.format("SimpleSound(%s)", this.file);
    }
}