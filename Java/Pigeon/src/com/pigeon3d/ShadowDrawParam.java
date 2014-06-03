package com.pigeon3d;

import objd.lang.*;
import objd.collection.Seq;

public class ShadowDrawParam {
    public final Seq<Float> percents;
    public final ViewportSurface viewportSurface;
    public ShadowDrawParam(final Seq<Float> percents, final ViewportSurface viewportSurface) {
        this.percents = percents;
        this.viewportSurface = viewportSurface;
    }
    public String toString() {
        return String.format("ShadowDrawParam(%s, %s)", this.percents, this.viewportSurface);
    }
}