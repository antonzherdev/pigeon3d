package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.geometry.vec3;
import com.pigeon3d.geometry.mat4;
import com.pigeon3d.geometry.vec4;

public class DirectLight extends Light {
    public final vec3 direction;
    public final mat4 shadowsProjectionMatrix;
    public static DirectLight applyColorDirection(final vec4 color, final vec3 direction) {
        return new DirectLight(color, direction, false, mat4.identity());
    }
    public static DirectLight applyColorDirectionShadowsProjectionMatrix(final vec4 color, final vec3 direction, final mat4 shadowsProjectionMatrix) {
        return new DirectLight(color, direction, true, shadowsProjectionMatrix);
    }
    @Override
    public MatrixModel shadowMatrixModel(final MatrixModel model) {
        return model.mutable().modifyC(new F<mat4, mat4>() {
            @Override
            public mat4 apply(final mat4 _) {
                return mat4.lookAtEyeCenterUp(vec3.negate(vec3.normalize(vec4.xyz(model.w().mulVec4(vec4.applyVec3W(DirectLight.this.direction, ((float)(0))))))), new vec3(((float)(0)), ((float)(0)), ((float)(0))), new vec3(((float)(0)), ((float)(1)), ((float)(0))));
            }
        }).modifyP(new F<mat4, mat4>() {
            @Override
            public mat4 apply(final mat4 _) {
                return DirectLight.this.shadowsProjectionMatrix;
            }
        });
    }
    public DirectLight(final vec4 color, final vec3 direction, final boolean hasShadows, final mat4 shadowsProjectionMatrix) {
        super(color, hasShadows);
        this.direction = direction;
        this.shadowsProjectionMatrix = shadowsProjectionMatrix;
    }
    public String toString() {
        return String.format("DirectLight(%s, %s)", this.direction, this.shadowsProjectionMatrix);
    }
}