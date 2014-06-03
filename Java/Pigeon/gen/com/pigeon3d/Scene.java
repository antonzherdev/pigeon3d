package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.geometry.vec4;
import objd.react.Observer;
import com.pigeon3d.geometry.vec2;
import objd.collection.Set;
import objd.concurrent.Future;

public class Scene {
    public final vec4 backgroundColor;
    public final Controller controller;
    public final Layers layers;
    public final SoundPlayer soundPlayer;
    private final Observer<Boolean> pauseObserve;
    public static Scene applySceneView(final SceneView sceneView) {
        return new Scene(new vec4(((float)(1)), ((float)(1)), ((float)(1)), ((float)(1))), sceneView, Layers.applyLayer(new Layer(sceneView, sceneView)), null);
    }
    public void prepareWithViewSize(final vec2 viewSize) {
        this.layers.prepare();
    }
    public void reshapeWithViewSize(final vec2 viewSize) {
        this.layers.reshapeWithViewSize(viewSize);
    }
    public void drawWithViewSize(final vec2 viewSize) {
        this.layers.draw();
    }
    public void complete() {
        this.layers.complete();
    }
    public Set<RecognizerType> recognizersTypes() {
        return ((Set<RecognizerType>)(((Set)(this.layers.recognizersTypes()))));
    }
    public <P> boolean processEvent(final Event<P> event) {
        return this.layers.<P>processEvent(event);
    }
    public Future<Void> updateWithDelta(final double delta) {
        return Future.<Void>applyF(new F0<Void>() {
            @Override
            public Void apply() {
                Scene.this.controller.updateWithDelta(delta);
                Scene.this.layers.updateWithDelta(delta);
                if(Scene.this.soundPlayer != null) {
                    Scene.this.soundPlayer.updateWithDelta(delta);
                }
                return null;
            }
        });
    }
    public void start() {
        if(this.soundPlayer != null) {
            this.soundPlayer.start();
        }
        this.controller.start();
    }
    public void stop() {
        if(this.soundPlayer != null) {
            this.soundPlayer.stop();
        }
        this.controller.stop();
    }
    public Scene(final vec4 backgroundColor, final Controller controller, final Layers layers, final SoundPlayer soundPlayer) {
        this.backgroundColor = backgroundColor;
        this.controller = controller;
        this.layers = layers;
        this.soundPlayer = soundPlayer;
        this.pauseObserve = Director.current().isPaused.observeF(new P<Boolean>() {
            @Override
            public void apply(final Boolean p) {
                if(p) {
                    if(soundPlayer != null) {
                        soundPlayer.pause();
                    }
                } else {
                    if(soundPlayer != null) {
                        soundPlayer.resume();
                    }
                }
            }
        });
    }
    public String toString() {
        return String.format("Scene(%s, %s, %s, %s)", this.backgroundColor, this.controller, this.layers, this.soundPlayer);
    }
}