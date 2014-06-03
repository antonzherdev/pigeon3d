package com.pigeon3d;

import objd.lang.*;
import objd.collection.ImArray;
import com.pigeon3d.geometry.Rect;
import com.pigeon3d.geometry.vec2;

public class SingleLayer extends Layers {
    public final Layer layer;
    public final ImArray<Layer> layers;
    @Override
    public ImArray<Layer> layers() {
        return layers;
    }
    @Override
    public ImArray<Tuple<Layer, Rect>> viewportsWithViewSize(final vec2 viewSize) {
        return ImArray.fromObjects(new Tuple<Layer, Rect>(this.layer, this.layer.view.viewportWithViewSize(viewSize)));
    }
    public SingleLayer(final Layer layer) {
        this.layer = layer;
        this.layers = ImArray.fromObjects(layer);
    }
    public String toString() {
        return String.format("SingleLayer(%s)", this.layer);
    }
}