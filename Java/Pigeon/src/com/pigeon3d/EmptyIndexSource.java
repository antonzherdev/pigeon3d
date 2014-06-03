package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.gl.gl;

public class EmptyIndexSource extends IndexSource_impl {
    public static final EmptyIndexSource triangleStrip;
    public static final EmptyIndexSource triangleFan;
    public static final EmptyIndexSource triangles;
    public static final EmptyIndexSource lines;
    public final int mode;
    @Override
    public void draw() {
        Global.context.draw();
        gl.glDrawArraysModeFirstCount(this.mode, ((int)(0)), ((int)(Global.context.vertexBufferCount())));
        gl.egCheckError();
    }
    @Override
    public void drawWithStartCount(final int start, final int count) {
        Global.context.draw();
        if(count > 0) {
            gl.glDrawArraysModeFirstCount(this.mode, ((int)(start)), ((int)(count)));
        }
        gl.egCheckError();
    }
    public EmptyIndexSource(final int mode) {
        this.mode = mode;
    }
    public String toString() {
        return String.format("EmptyIndexSource(%d)", this.mode);
    }
    static {
        triangleStrip = new EmptyIndexSource(gl.GL_TRIANGLE_STRIP);
        triangleFan = new EmptyIndexSource(gl.GL_TRIANGLE_FAN);
        triangles = new EmptyIndexSource(gl.GL_TRIANGLES);
        lines = new EmptyIndexSource(gl.GL_LINES);
    }
}