package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.gl.gl;
import com.pigeon3d.geometry.vec4;
import objd.math;

public class CircleShader extends Shader<CircleParam> {
    public static final CircleShader withSegment;
    public static final CircleShader withoutSegment;
    public final boolean segment;
    public final ShaderAttribute model;
    public final ShaderUniformVec4 pos;
    public final ShaderUniformMat4 p;
    public final ShaderUniformVec2 radius;
    public final ShaderUniformVec4 color;
    public final ShaderUniformVec4 strokeColor;
    public final ShaderUniformVec4 sectorColor;
    public final ShaderUniformF4 startTg;
    public final ShaderUniformF4 endTg;
    @Override
    public void loadAttributesVbDesc(final VertexBufferDesc<Object> vbDesc) {
        this.model.setFromBufferWithStrideValuesCountValuesTypeShift(((int)(vbDesc.stride())), ((int)(2)), gl.GL_FLOAT, ((int)(vbDesc.model)));
    }
    @Override
    public void loadUniformsParam(final CircleParam param) {
        this.pos.applyVec4(vec4.addVec2(Global.matrix.value().wc().mulVec4(vec4.applyVec3W(param.position, ((float)(1)))), param.relative));
        this.p.applyMatrix(Global.matrix.value().p());
        this.radius.applyVec2(param.radius);
        this.color.applyVec4(param.color);
        this.strokeColor.applyVec4(param.strokeColor);
        if(this.segment) {
            {
                final CircleSegment sec = param.segment;
                if(sec != null) {
                    if(this.sectorColor != null) {
                        this.sectorColor.applyVec4(sec.color);
                    }
                    if(sec.start < sec.end) {
                        if(this.startTg != null) {
                            this.startTg.applyF4(clampP(sec.start));
                        }
                        if(this.endTg != null) {
                            this.endTg.applyF4(clampP(sec.end));
                        }
                    } else {
                        if(this.startTg != null) {
                            this.startTg.applyF4(clampP(sec.end));
                        }
                        if(this.endTg != null) {
                            this.endTg.applyF4(clampP(sec.start));
                        }
                    }
                }
            }
        }
    }
    private float clampP(final float p) {
        if(p < -(math.M_PI)) {
            return ((float)(2 * math.M_PI + p));
        } else {
            if(p > math.M_PI) {
                return ((float)(-2 * math.M_PI + p));
            } else {
                return p;
            }
        }
    }
    public CircleShader(final boolean segment) {
        super(new CircleShaderBuilder(segment).program());
        this.segment = segment;
        this.model = attributeForName("model");
        this.pos = uniformVec4Name("position");
        this.p = uniformMat4Name("p");
        this.radius = uniformVec2Name("radius");
        this.color = uniformVec4Name("color");
        this.strokeColor = uniformVec4Name("strokeColor");
        this.sectorColor = ((segment) ? (uniformVec4Name("sectorColor")) : (null));
        this.startTg = ((segment) ? (uniformF4Name("startTg")) : (null));
        this.endTg = ((segment) ? (uniformF4Name("endTg")) : (null));
    }
    public String toString() {
        return String.format("CircleShader(%d)", this.segment);
    }
    static {
        withSegment = new CircleShader(true);
        withoutSegment = new CircleShader(false);
    }
}