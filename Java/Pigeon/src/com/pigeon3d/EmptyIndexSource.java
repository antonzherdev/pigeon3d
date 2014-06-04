package com.pigeon3d;

import objd.lang.*;
import android.opengl.GLES20;
import com.pigeon3d.gl.eg;

public class EmptyIndexSource extends IndexSource_impl {
    public static final EmptyIndexSource triangleStrip;
    public static final EmptyIndexSource triangleFan;
    public static final EmptyIndexSource triangles;
    public static final EmptyIndexSource lines;
    public final int mode;
    @Override
    public void draw() {
        Global.context.draw();
        GLES20.glDrawArrays(this.mode, ((int)(0)), ((int)(Global.context.vertexBufferCount())));
        eg.egCheckError();
    }
    @Override
    public void drawWithStartCount(final int start, final int count) {
        Global.context.draw();
        if(count > 0) {
            GLES20.glDrawArrays(this.mode, ((int)(start)), ((int)(count)));
        }
        eg.egCheckError();
    }
    public EmptyIndexSource(final int mode) {
        this.mode = mode;
    }
    public String toString() {
        return String.format("EmptyIndexSource(%d)", this.mode);
    }
    static {
        triangleStrip = new EmptyIndexSource(GLES20.GL_TRIANGLE_STRIP);
        triangleFan = new EmptyIndexSource(GLES20.GL_TRIANGLE_FAN);
        triangles = new EmptyIndexSource(GLES20.GL_TRIANGLES);
        lines = new EmptyIndexSource(GLES20.GL_LINES);
    }
}