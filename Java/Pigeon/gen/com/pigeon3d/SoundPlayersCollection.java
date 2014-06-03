package com.pigeon3d;

import objd.lang.*;
import objd.collection.ImArray;
import objd.collection.Iterator;

public class SoundPlayersCollection extends SoundPlayer_impl {
    public final ImArray<SoundPlayer> players;
    @Override
    public void start() {
        {
            final Iterator<SoundPlayer> __il__0i = this.players.iterator();
            while(__il__0i.hasNext()) {
                final SoundPlayer _ = __il__0i.next();
                _.start();
            }
        }
    }
    @Override
    public void stop() {
        {
            final Iterator<SoundPlayer> __il__0i = this.players.iterator();
            while(__il__0i.hasNext()) {
                final SoundPlayer _ = __il__0i.next();
                _.stop();
            }
        }
    }
    @Override
    public void pause() {
        {
            final Iterator<SoundPlayer> __il__0i = this.players.iterator();
            while(__il__0i.hasNext()) {
                final SoundPlayer _ = __il__0i.next();
                _.pause();
            }
        }
    }
    @Override
    public void resume() {
        {
            final Iterator<SoundPlayer> __il__0i = this.players.iterator();
            while(__il__0i.hasNext()) {
                final SoundPlayer _ = __il__0i.next();
                _.resume();
            }
        }
    }
    @Override
    public void updateWithDelta(final double delta) {
        {
            final Iterator<SoundPlayer> __il__0i = this.players.iterator();
            while(__il__0i.hasNext()) {
                final SoundPlayer _ = __il__0i.next();
                _.updateWithDelta(delta);
            }
        }
    }
    public SoundPlayersCollection(final ImArray<SoundPlayer> players) {
        this.players = players;
    }
    public String toString() {
        return String.format("SoundPlayersCollection(%s)", this.players);
    }
}