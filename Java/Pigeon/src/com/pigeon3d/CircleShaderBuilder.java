package com.pigeon3d;

import objd.lang.*;

public class CircleShaderBuilder extends ShaderTextBuilder_impl {
    public final boolean segment;
    public String vertex() {
        return String.format("%s\n%s lowp vec2 model;\n\nuniform highp vec4 position;\nuniform mat4 p;\nuniform lowp vec2 radius;\n%s highp vec2 coord;\n\nvoid main(void) {\n    highp vec4 pos = p*position;\n    pos.xy += model*radius;\n    gl_Position = pos;\n    coord = model;\n}", this.vertexHeader(), this.ain(), this.out());
    }
    public String fragment() {
        return String.format("%s\n\n%s highp vec2 coord;\nuniform lowp vec4 color;\nuniform lowp vec4 strokeColor;\n%s\n\nvoid main(void) {\n    lowp float tg = atan(coord.y, coord.x);\n    highp float dt = dot(coord, coord);\n    lowp float alpha = 0.0;\n   %s\n}", this.fragmentHeader(), this.in(), ((this.segment) ? ("uniform lowp vec4 sectorColor;\nuniform lowp float startTg;\nuniform lowp float endTg;") : ("")), ((this.segment) ? (String.format("    if(endTg < startTg) {\n        alpha = sectorColor.w * clamp(\n            1.0 - smoothstep(0.95, 1.0, dt)\n            - (clamp(smoothstep(endTg - 0.1, endTg, tg) + 1.0 - smoothstep(startTg, startTg + 0.1, tg), 1.0, 2.0) - 1.0)\n            , 0.0, 1.0);\n    } else {\n        alpha = sectorColor.w * clamp(\n            1.0 - smoothstep(0.95, 1.0, dt)\n            - (1.0 - smoothstep(startTg, startTg + 0.1, tg))\n            - (smoothstep(endTg - 0.1, endTg, tg))\n            , 0.0, 1.0);\n    }\n    %s = vec4(mix(\n        mix(color.xyz, sectorColor.xyz, alpha),\n        strokeColor.xyz, strokeColor.w*(smoothstep(0.75, 0.8, dt) - smoothstep(0.95, 1.0, dt))),\n        color.w * (1.0 - smoothstep(0.95, 1.0, dt)));\n   ", this.fragColor())) : (String.format("    %s = vec4(mix(color.xyz, strokeColor.xyz, strokeColor.w*(smoothstep(0.75, 0.8, dt) - smoothstep(0.95, 1.0, dt))),\n        color.w * (1.0 - smoothstep(0.95, 1.0, dt)));\n   ", this.fragColor()))));
    }
    public ShaderProgram program() {
        return ShaderProgram.applyNameVertexFragment("Circle", this.vertex(), this.fragment());
    }
    public CircleShaderBuilder(final boolean segment) {
        this.segment = segment;
    }
    public String toString() {
        return String.format("CircleShaderBuilder(%d)", this.segment);
    }
}