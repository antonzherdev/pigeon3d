package com.pigeon3d;

import objd.lang.*;
import objd.react.Var;
import objd.react.React;
import com.pigeon3d.geometry.vec3;
import com.pigeon3d.geometry.vec4;

public class Stat {
    private double accumDelta;
    private int framesCount;
    private double _frameRate;
    private final Var<String> textVar;
    private final Text text;
    public double frameRate() {
        return this._frameRate;
    }
    public void draw() {
        {
            {
                final EnablingState __il__0__tmp__il__0self = Global.context.blend;
                {
                    final boolean __il__0__il__0changed = __il__0__tmp__il__0self.enable();
                    {
                        Global.context.setBlendFunction(BlendFunction.standard);
                        this.text.draw();
                    }
                    if(__il__0__il__0changed) {
                        __il__0__tmp__il__0self.disable();
                    }
                }
            }
        }
    }
    public void tickWithDelta(final double delta) {
        this.accumDelta += delta;
        this.framesCount++;
        if(this.accumDelta > 1.0) {
            this._frameRate = this.framesCount / this.accumDelta;
            this.textVar.setValue(((String)(Float.round(this._frameRate))));
            this.accumDelta = ((double)(0));
            this.framesCount = ((int)(0));
        }
    }
    public Stat() {
        this.accumDelta = 0.0;
        this.framesCount = ((int)(0));
        this._frameRate = 0.0;
        this.textVar = Var.<String>applyInitial("");
        this.text = Text.applyFontTextPositionAlignmentColor(React.applyValue(Global.mainFontWithSize(((int)(18)))), this.textVar, React.applyValue(new vec3(((float)(-0.98)), ((float)(-0.99)), ((float)(0)))), React.applyValue(TextAlignment.left), React.applyValue(new vec4(((float)(1)), ((float)(1)), ((float)(1)), ((float)(1)))));
    }
    public String toString() {
        return "Stat";
    }
}