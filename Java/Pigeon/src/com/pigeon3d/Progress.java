package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.geometry.vec2;
import com.pigeon3d.geometry.vec3;
import com.pigeon3d.geometry.vec4;

public class Progress {
    public static F<Float, Float> progressF4F42(final float f4, final float f42) {
        final float k = f42 - f4;
        if(k == 0) {
            return new F<Float, Float>() {
                @Override
                public Float apply(final Float t) {
                    return f4;
                }
            };
        } else {
            return new F<Float, Float>() {
                @Override
                public Float apply(final Float t) {
                    return k * t + f4;
                }
            };
        }
    }
    public static F<Float, vec2> progressVec2Vec22(final vec2 vec2, final vec2 vec22) {
        final F<Float, Float> x = Progress.progressF4F42(vec2.x, vec22.x);
        final F<Float, Float> y = Progress.progressF4F42(vec2.y, vec22.y);
        return new F<Float, vec2>() {
            @Override
            public vec2 apply(final Float t) {
                return new vec2(x.apply(t), y.apply(t));
            }
        };
    }
    public static F<Float, vec3> progressVec3Vec32(final vec3 vec3, final vec3 vec32) {
        final F<Float, Float> x = Progress.progressF4F42(vec3.x, vec32.x);
        final F<Float, Float> y = Progress.progressF4F42(vec3.y, vec32.y);
        final F<Float, Float> z = Progress.progressF4F42(vec3.z, vec32.z);
        return new F<Float, vec3>() {
            @Override
            public vec3 apply(final Float t) {
                return new vec3(x.apply(t), y.apply(t), z.apply(t));
            }
        };
    }
    public static F<Float, vec4> progressVec4Vec42(final vec4 vec4, final vec4 vec42) {
        final F<Float, Float> x = Progress.progressF4F42(vec4.x, vec42.x);
        final F<Float, Float> y = Progress.progressF4F42(vec4.y, vec42.y);
        final F<Float, Float> z = Progress.progressF4F42(vec4.z, vec42.z);
        final F<Float, Float> w = Progress.progressF4F42(vec4.w, vec42.w);
        return new F<Float, vec4>() {
            @Override
            public vec4 apply(final Float t) {
                return new vec4(x.apply(t), y.apply(t), z.apply(t), w.apply(t));
            }
        };
    }
    public static F<Float, Float> gapOptT1T2(final float t1, final float t2) {
        final float l = t2 - t1;
        return new F<Float, Float>() {
            @Override
            public Float apply(final Float t) {
                if(Float4.between(t, t1, t2)) {
                    return (t - t1) / l;
                } else {
                    return null;
                }
            }
        };
    }
    public static F<Float, Float> gapT1T2(final float t1, final float t2) {
        final float l = t2 - t1;
        return new F<Float, Float>() {
            @Override
            public Float apply(final Float t) {
                if(t <= t1) {
                    return ((float)(0.0));
                } else {
                    if(t >= t2) {
                        return ((float)(1.0));
                    } else {
                        return (t - t1) / l;
                    }
                }
            }
        };
    }
    public static F<Float, Float> trapeziumT1T2(final float t1, final float t2) {
        return new F<Float, Float>() {
            @Override
            public Float apply(final Float t) {
                if(t <= t1) {
                    return t / t1;
                } else {
                    if(t >= t2) {
                        return 1 - (t - t2) / (1 - t2);
                    } else {
                        return ((float)(1));
                    }
                }
            }
        };
    }
    public static F<Float, Float> trapeziumT1(final float t1) {
        return Progress.trapeziumT1T2(t1, ((float)(1.0 - t1)));
    }
    public static F<Float, Float> divOn(final float on) {
        return new F<Float, Float>() {
            @Override
            public Float apply(final Float t) {
                return t / on;
            }
        };
    }
}