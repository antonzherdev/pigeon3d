package com.pigeon3d;

import objd.lang.*;
import objd.react.Var;
import objd.react.React;
import com.pigeon3d.geometry.vec2;
import objd.concurrent.Future;
import objd.concurrent.ConcurrentQueue;
import objd.collection.Iterator;
import com.pigeon3d.geometry.vec2i;
import com.pigeon3d.gl.gl;
import com.pigeon3d.geometry.RectI;
import com.pigeon3d.geometry.Rect;
import com.pigeon3d.sound.SoundDirector;

public abstract class Director {
    public abstract void clearRecognizers();
    public abstract void registerRecognizerType(final RecognizerType<Object> recognizerType);
    public abstract double scale();
    public abstract void lock();
    public abstract void unlock();
    public abstract void redraw();
    static private Director _current;
    private Scene _scene;
    private boolean _isStarted;
    private final Var<Boolean> _isPaused;
    public final React<Boolean> isPaused;
    private F0<Scene> _lazyScene;
    public final Time time;
    private vec2 _lastViewSize;
    private double _timeSpeed;
    private Future<Void> _updateFuture;
    private Stat _stat;
    private final ConcurrentQueue<P0> _defers;
    public static Director current() {
        if(Director._current == null) {
            throw new NullPointerException();
        }
        return Director._current;
    }
    public Scene scene() {
        return this._scene;
    }
    public void setScene(final F0<Scene> scene) {
        this._lazyScene = scene;
        {
            final Scene sc = this._scene;
            if(sc != null) {
                sc.stop();
                this._scene = null;
                this.clearRecognizers();
            }
        }
        if(this._isPaused.value()) {
            this.redraw();
        }
    }
    private void maybeNewScene() {
        {
            final F0<Scene> f = this._lazyScene;
            if(f != null) {
                final Scene sc = f.apply();
                this._lazyScene = null;
                this._scene = sc;
                if(!(this._lastViewSize.equals(new vec2(((float)(0)), ((float)(0)))))) {
                    sc.reshapeWithViewSize(this._lastViewSize);
                }
                {
                    final Iterator<RecognizerType> __il__0_4i = sc.recognizersTypes().iterator();
                    while(__il__0_4i.hasNext()) {
                        final RecognizerType _ = __il__0_4i.next();
                        registerRecognizerType(((RecognizerType<Object>)(((RecognizerType)(_)))));
                    }
                }
                sc.start();
            }
        }
    }
    public void init() {
        Director._current = this;
    }
    public vec2 viewSize() {
        return this._lastViewSize;
    }
    public void reshapeWithSize(final vec2 size) {
        if(!(this._lastViewSize.equals(size))) {
            Global.context.viewSize.setValue(vec2i.applyVec2(size));
            this._lastViewSize = size;
            if(this._scene != null) {
                this._scene.reshapeWithViewSize(size);
            }
        }
    }
    public void drawFrame() {
        this.prepare();
        this.draw();
        this.complete();
    }
    public void processFrame() {
        this.prepare();
        this.draw();
        this.complete();
        this.tick();
    }
    public void prepare() {
        this._updateFuture.waitResultPeriod(1.0);
        this.executeDefers();
        if(this._lastViewSize.x <= 0 || this._lastViewSize.y <= 0) {
            return ;
        }
        this.maybeNewScene();
        {
            final Scene sc = this._scene;
            if(sc != null) {
                gl.egPushGroupMarkerName("Prepare");
                Director._current = this;
                Global.context.clear();
                Global.context.depthTest.enable();
                sc.prepareWithViewSize(this._lastViewSize);
                gl.egCheckError();
                gl.egPopGroupMarker();
            }
        }
    }
    public void draw() {
        if(this._lastViewSize.x <= 0 || this._lastViewSize.y <= 0) {
            return ;
        }
        {
            final Scene sc = this._scene;
            if(sc != null) {
                gl.egPushGroupMarkerName("Draw");
                Global.context.clear();
                Global.context.depthTest.enable();
                Global.context.clearColorColor(sc.backgroundColor);
                Global.context.setViewport(RectI.applyRect(new Rect(new vec2(((float)(0)), ((float)(0))), this._lastViewSize)));
                gl.glClear(gl.GL_COLOR_BUFFER_BIT + gl.GL_DEPTH_BUFFER_BIT);
                sc.drawWithViewSize(this._lastViewSize);
                {
                    final Stat stat = this._stat;
                    if(stat != null) {
                        Global.context.depthTest.disable();
                        stat.draw();
                    }
                }
                gl.egCheckError();
                gl.egPopGroupMarker();
            }
        }
    }
    public void complete() {
        gl.egPushGroupMarkerName("Complete");
        if(this._scene != null) {
            this._scene.complete();
        }
        gl.egCheckError();
        gl.egPopGroupMarker();
    }
    public void processEvent(final Event<Object> event) {
        if(this._scene != null) {
            this._scene.<Object>processEvent(((Event<Object>)(((Event)(event)))));
        }
    }
    public boolean isStarted() {
        return this._isStarted;
    }
    public void start() {
        this._isStarted = true;
        this.time.start();
    }
    public void stop() {
        this._isStarted = false;
    }
    public void pause() {
        this._isPaused.setValue(true);
        this.redraw();
    }
    public void becomeActive() {
    }
    public void resignActive() {
        this._isPaused.setValue(true);
    }
    public void resume() {
        if(this._isPaused.value()) {
            this.time.start();
            this._isPaused.setValue(false);
        }
    }
    public double timeSpeed() {
        return this._timeSpeed;
    }
    public void setTimeSpeed(final double timeSpeed) {
        if(!(this._timeSpeed.equals(timeSpeed))) {
            this._timeSpeed = timeSpeed;
            SoundDirector.instance.setTimeSpeed(this._timeSpeed);
        }
    }
    public void tick() {
        Director._current = this;
        this.time.tick();
        final double dt = this.time.delta * this._timeSpeed;
        {
            final Scene _ = this._scene;
            if(_ != null) {
                _.updateWithDelta(dt);
            }
        }
        if(this._stat != null) {
            this._stat.tickWithDelta(this.time.delta);
        }
    }
    public Stat stat() {
        return this._stat;
    }
    public boolean isDisplayingStats() {
        return this._stat != null;
    }
    public void displayStats() {
        this._stat = new Stat();
    }
    public void cancelDisplayingStats() {
        this._stat = null;
    }
    public void onGLThreadF(final P0 f) {
        this._defers.enqueueItem(f);
    }
    private void executeDefers() {
        while(true) {
            final P0 f = this._defers.dequeue();
            if(f == null) {
                break;
            }
            if(f == null) {
                throw new NullPointerException();
            }
            final P0 ff = f;
            ff.apply();
        }
    }
    public Director() {
        this._scene = null;
        this._isStarted = false;
        this._isPaused = Var.<Boolean>applyInitial(false);
        this.isPaused = this._isPaused;
        this._lazyScene = null;
        this.time = new Time();
        this._lastViewSize = new vec2(((float)(0)), ((float)(0)));
        this._timeSpeed = 1.0;
        this._updateFuture = ((Future<Void>)(((Future)(Future.<Object>successfulResult(null)))));
        this._stat = null;
        this._defers = new ConcurrentQueue<P0>();
    }
    public String toString() {
        return "Director";
    }
}