package com.pigeon3d.sound;

import objd.lang.*;
import objd.collection.MArray;
import objd.collection.MHashSet;
import objd.concurrent.DispatchQueue;
import objd.collection.Iterator;

public final class ParSound extends Sound {
    public final int limit;
    public final F0<SimpleSound> create;
    private final MArray<SimpleSound> sounds;
    private final MHashSet<Sound> paused;
    @Override
    public void play() {
        DispatchQueue.aDefault.asyncF(new P0() {
            @Override
            public void apply() {
                synchronized(ParSound.this) {
                    {
                        final SimpleSound __tmp_0rp0_0u = ParSound.this.sound();
                        if(__tmp_0rp0_0u != null) {
                            __tmp_0rp0_0u.play();
                        }
                    }
                }
            }
        });
    }
    @Override
    public void playLoops(final int loops) {
        DispatchQueue.aDefault.asyncF(new P0() {
            @Override
            public void apply() {
                synchronized(ParSound.this) {
                    {
                        final SimpleSound __tmp_0rp0_0u = ParSound.this.sound();
                        if(__tmp_0rp0_0u != null) {
                            __tmp_0rp0_0u.playLoops(loops);
                        }
                    }
                }
            }
        });
    }
    @Override
    public void playAlways() {
        DispatchQueue.aDefault.asyncF(new P0() {
            @Override
            public void apply() {
                synchronized(ParSound.this) {
                    {
                        final SimpleSound __tmp_0rp0_0u = ParSound.this.sound();
                        if(__tmp_0rp0_0u != null) {
                            __tmp_0rp0_0u.playAlways();
                        }
                    }
                }
            }
        });
    }
    @Override
    public void pause() {
        DispatchQueue.aDefault.asyncF(new P0() {
            @Override
            public void apply() {
                synchronized(ParSound.this) {
                    {
                        final Iterator<SimpleSound> __il__0rp0_0i = ParSound.this.sounds.iterator();
                        while(__il__0rp0_0i.hasNext()) {
                            final SimpleSound sound = __il__0rp0_0i.next();
                            if(sound.isPlaying()) {
                                sound.pause();
                                ParSound.this.paused.appendItem(sound);
                            }
                        }
                    }
                }
            }
        });
    }
    @Override
    public void resume() {
        DispatchQueue.aDefault.asyncF(new P0() {
            @Override
            public void apply() {
                synchronized(ParSound.this) {
                    {
                        final Iterator<Sound> __il__0rp0_0i = ParSound.this.paused.iterator();
                        while(__il__0rp0_0i.hasNext()) {
                            final Sound _ = __il__0rp0_0i.next();
                            _.resume();
                        }
                    }
                    ParSound.this.paused.clear();
                }
            }
        });
    }
    @Override
    public boolean isPlaying() {
        synchronized(this) {
            return this.sounds.existsWhere(new F<SimpleSound, Boolean>() {
                @Override
                public Boolean apply(final SimpleSound _) {
                    return _.isPlaying();
                }
            });
        }
    }
    @Override
    public void stop() {
        synchronized(this) {
            {
                final Iterator<SimpleSound> __il__0_0i = this.sounds.iterator();
                while(__il__0_0i.hasNext()) {
                    final SimpleSound _ = __il__0_0i.next();
                    _.stop();
                }
            }
        }
    }
    public void playWithVolume(final float volume) {
        DispatchQueue.aDefault.asyncF(new P0() {
            @Override
            public void apply() {
                synchronized(ParSound.this) {
                    {
                        final SimpleSound s = ParSound.this.sound();
                        if(s != null) {
                            s.setVolume(volume);
                            s.play();
                        }
                    }
                }
            }
        });
    }
    private SimpleSound sound() {
        final SimpleSound s = this.sounds.findWhere(new F<SimpleSound, Boolean>() {
            @Override
            public Boolean apply(final SimpleSound _) {
                return !(_.isPlaying());
            }
        });
        if(s != null) {
            return ((SimpleSound)(s));
        } else {
            if(this.sounds.count() >= this.limit) {
                return null;
            } else {
                final SimpleSound newSound = this.create.apply();
                this.sounds.appendItem(newSound);
                return newSound;
            }
        }
    }
    public ParSound(final int limit, final F0<SimpleSound> create) {
        this.limit = limit;
        this.create = create;
        this.sounds = new MArray<SimpleSound>();
        this.paused = new MHashSet<Sound>();
    }
    public String toString() {
        return String.format("ParSound(%d)", this.limit);
    }
}