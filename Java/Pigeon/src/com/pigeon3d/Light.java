package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.geometry.vec4;
import com.pigeon3d.geometry.vec2i;
import com.pigeon3d.geometry.vec2;

public class Light {
    public static final Light aDefault;
    public final vec4 color;
    public final boolean hasShadows;
    public ShadowMap shadowMap() {
        return _lazy_shadowMap.get();
    }
    private final Lazy<ShadowMap> _lazy_shadowMap;
    public MatrixModel shadowMatrixModel(final MatrixModel model) {
        throw new RuntimeException(String.format("Shadows are not supported for %s", Light.type));
    }
    public Light(final vec4 color, final boolean hasShadows) {
        this.color = color;
        this.hasShadows = hasShadows;
        this._lazy_shadowMap = new Lazy<ShadowMap>(new F0<ShadowMap>() {
            @Override
            public ShadowMap apply() {
                return new ShadowMap(vec2i.applyVec2(new vec2(((float)(2048)), ((float)(2048)))));
            }
        });
    }
    public String toString() {
        return String.format("Light(%s, %d)", this.color, this.hasShadows);
    }
    static {
        aDefault = new Light(new vec4(((float)(1)), ((float)(1)), ((float)(1)), ((float)(1))), true);
    }
}