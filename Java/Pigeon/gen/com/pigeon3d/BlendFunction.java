package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.gl.gl;

public class BlendFunction {
    public static final BlendFunction standard;
    public static final BlendFunction premultiplied;
    public final int source;
    public final int destination;
    public void applyDraw(final P0 draw) {
        {
            final EnablingState __tmp__il__0self = Global.context.blend;
            {
                final boolean __il__0changed = __tmp__il__0self.enable();
                {
                    Global.context.setBlendFunction(this);
                    draw.apply();
                }
                if(__il__0changed) {
                    __tmp__il__0self.disable();
                }
            }
        }
    }
    public void bind() {
        gl.glBlendFuncSfactorDfactor(this.source, this.destination);
    }
    public BlendFunction(final int source, final int destination) {
        this.source = source;
        this.destination = destination;
    }
    public String toString() {
        return String.format("BlendFunction(%d, %d)", this.source, this.destination);
    }
    static {
        standard = new BlendFunction(gl.GL_SRC_ALPHA, gl.GL_ONE_MINUS_SRC_ALPHA);
        premultiplied = new BlendFunction(gl.GL_ONE, gl.GL_ONE_MINUS_SRC_ALPHA);
    }
}