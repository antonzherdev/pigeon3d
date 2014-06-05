package com.pigeon3d.gl;

import android.annotation.TargetApi;
import android.opengl.GLES20;

import java.nio.IntBuffer;

import android.os.Build;
import objd.lang.Log;

public class eg {
    public static String egGetProgramError(int program) {
        IntBuffer linkSuccess = IntBuffer.allocate(1);
        GLES20.glGetProgramiv(program, GLES20.GL_LINK_STATUS, linkSuccess);

        if (linkSuccess.get() == GLES20.GL_FALSE) {
            Log.infoText("GLSL Program Error");
            return GLES20.glGetProgramInfoLog(program);
        }
        return null;
    }

    public static void egShaderSource(int shader, String source) {
        GLES20.glShaderSource(shader, source);
    }

    public static String egGetShaderError(int shader) {
        IntBuffer compileSuccess = IntBuffer.allocate(1);
        GLES20.glGetShaderiv(shader, GLES20.GL_COMPILE_STATUS, compileSuccess);

        if (compileSuccess.get() == GLES20.GL_FALSE) {
            Log.infoText("GLSL Program Error");
            return GLES20.glGetShaderInfoLog(shader);
        }
        return null;
    }

    public static int egGLSLVersion() {
        String pVersion = GLES20.glGetString(GLES20.GL_SHADING_LANGUAGE_VERSION);
        if(pVersion == null) return 100;
        if(pVersion.charAt(0) == 'O' && pVersion.charAt(1) == 'p' && pVersion.charAt(2) == 'E') {
            return ((int)pVersion.charAt(18) - '0')*100 + (pVersion.charAt(20) - '0') *10 + (pVersion.charAt(21) == 0 ? 0 : pVersion.charAt(21)  - '0');
        }
        return ((int) pVersion.charAt(0) - '0')*100 + (pVersion.charAt(2) - '0') *10 + pVersion.charAt(3)  - '0';
    }

    public static void egCheckError() {
        int err = GLES20.glGetError();
        if(err != GLES20.GL_NO_ERROR) {
            throw new RuntimeException("OpenGL error: " + err);
        }
    }

    public static int egGenBuffer() {
        IntBuffer r = IntBuffer.allocate(1);
        GLES20.glGenBuffers(1, r);
        return r.get();
    }
}
