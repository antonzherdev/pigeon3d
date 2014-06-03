package com.pigeon3d;

import objd.lang.*;
import objd.collection.ImArray;
import com.pigeon3d.geometry.Rect;
import com.pigeon3d.geometry.vec2;
import objd.collection.Iterator;
import objd.collection.Set;
import objd.collection.Traversable;

public abstract class Layers {
    public abstract ImArray<Layer> layers();
    public abstract ImArray<Tuple<Layer, Rect>> viewportsWithViewSize(final vec2 viewSize);
    private ImArray<Tuple<Layer, Rect>> _viewports;
    private ImArray<Tuple<Layer, Rect>> _viewportsRevers;
    public static SingleLayer applyLayer(final Layer layer) {
        return new SingleLayer(layer);
    }
    public void prepare() {
        {
            final Iterator<Tuple<Layer, Rect>> __il__0i = this._viewports.iterator();
            while(__il__0i.hasNext()) {
                final Tuple<Layer, Rect> p = __il__0i.next();
                p.a.prepareWithViewport(p.b);
            }
        }
    }
    public void draw() {
        {
            final Iterator<Tuple<Layer, Rect>> __il__0i = this._viewports.iterator();
            while(__il__0i.hasNext()) {
                final Tuple<Layer, Rect> p = __il__0i.next();
                p.a.drawWithViewport(p.b);
            }
        }
    }
    public void complete() {
        {
            final Iterator<Tuple<Layer, Rect>> __il__0i = this._viewports.iterator();
            while(__il__0i.hasNext()) {
                final Tuple<Layer, Rect> p = __il__0i.next();
                p.a.completeWithViewport(p.b);
            }
        }
    }
    public Set<RecognizerType<Object, Object>> recognizersTypes() {
        return ((Set<RecognizerType<Object, Object>>)(((Set)(this.layers().chain().<InputProcessor>mapOptF(((F<Layer, InputProcessor>)(((F)(new F<Layer, InputProcessor>() {
            @Override
            public InputProcessor apply(final Layer _) {
                return _.inputProcessor;
            }
        }))))).<Recognizer<Object>>flatMapF(((F<InputProcessor, Traversable<Recognizer<Object>>>)(((F)(new F<InputProcessor, Traversable<Recognizer<Object>>>() {
            @Override
            public Traversable<Recognizer<Object>> apply(final InputProcessor _) {
                return ((Traversable<Recognizer<Object>>)(((Traversable)(_.recognizers().items))));
            }
        }))))).<RecognizerType<Object, Object>>mapF(((F<Recognizer<Object>, RecognizerType<Object, Object>>)(((F)(new F<Recognizer<Object>, RecognizerType<Object, Object>>() {
            @Override
            public RecognizerType<Object, Object> apply(final Recognizer<Object> _) {
                return _.tp;
            }
        }))))).toSet()))));
    }
    public <P> boolean processEvent(final Event<P> event) {
        boolean r = false;
        {
            final Iterator<Tuple<Layer, Rect>> __il__1i = this._viewportsRevers.iterator();
            while(__il__1i.hasNext()) {
                final Tuple<Layer, Rect> p = __il__1i.next();
                r = r || p.a.<P>processEventViewport(event, p.b);
            }
        }
        return r;
    }
    public void updateWithDelta(final double delta) {
        {
            final Iterator<Layer> __il__0i = this.layers().iterator();
            while(__il__0i.hasNext()) {
                final Layer _ = __il__0i.next();
                _.updateWithDelta(delta);
            }
        }
    }
    public void reshapeWithViewSize(final vec2 viewSize) {
        this._viewports = viewportsWithViewSize(viewSize);
        this._viewportsRevers = this._viewports.chain().reverse().toArray();
        {
            final Iterator<Tuple<Layer, Rect>> __il__2i = this._viewports.iterator();
            while(__il__2i.hasNext()) {
                final Tuple<Layer, Rect> p = __il__2i.next();
                p.a.reshapeWithViewport(p.b);
            }
        }
    }
    public Layers() {
        this._viewports = ImArray.<Tuple<Layer, Rect>>empty();
        this._viewportsRevers = ImArray.<Tuple<Layer, Rect>>empty();
    }
    public String toString() {
        return "Layers";
    }
}