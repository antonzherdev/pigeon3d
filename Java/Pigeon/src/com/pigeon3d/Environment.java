package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.geometry.vec4;
import objd.collection.ImArray;

public class Environment {
    public static final Environment aDefault;
    public final vec4 ambientColor;
    public final ImArray<Light> lights;
    public final ImArray<DirectLight> directLights;
    public final ImArray<DirectLight> directLightsWithShadows;
    public final ImArray<DirectLight> directLightsWithoutShadows;
    public static Environment applyLights(final ImArray<Light> lights) {
        return new Environment(new vec4(((float)(1)), ((float)(1)), ((float)(1)), ((float)(1))), lights);
    }
    public static Environment applyLight(final Light light) {
        return new Environment(new vec4(((float)(1)), ((float)(1)), ((float)(1)), ((float)(1))), ImArray.fromObjects(light));
    }
    public Environment(final vec4 ambientColor, final ImArray<Light> lights) {
        this.ambientColor = ambientColor;
        this.lights = lights;
        this.directLights = lights.chain().<DirectLight>filterCastTo(DirectLight.type).toArray();
        this.directLightsWithShadows = lights.chain().<DirectLight>filterCastTo(DirectLight.type).filterWhen(new F<DirectLight, Boolean>() {
            @Override
            public Boolean apply(final DirectLight _) {
                return _.hasShadows;
            }
        }).toArray();
        this.directLightsWithoutShadows = lights.chain().<DirectLight>filterCastTo(DirectLight.type).filterWhen(new F<DirectLight, Boolean>() {
            @Override
            public Boolean apply(final DirectLight _) {
                return !(_.hasShadows);
            }
        }).toArray();
    }
    public String toString() {
        return String.format("Environment(%s, %s)", this.ambientColor, this.lights);
    }
    static {
        aDefault = new Environment(new vec4(((float)(1)), ((float)(1)), ((float)(1)), ((float)(1))), ImArray.<Light>empty());
    }
}