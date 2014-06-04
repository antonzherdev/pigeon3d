package com.pigeon3d;

import objd.lang.*;
import android.opengl.GLES20;
import com.pigeon3d.gl.eg;

public class ShaderProgram {
    public static final int version;
    public final String name;
    public final int handle;
    public static ShaderProgram applyNameVertexFragment(final String name, final String vertex, final String fragment) {
        final int vertexShader = ShaderProgram.compileShaderForShaderTypeSource(GLES20.GL_VERTEX_SHADER, vertex);
        final int fragmentShader = ShaderProgram.compileShaderForShaderTypeSource(GLES20.GL_FRAGMENT_SHADER, fragment);
        final ShaderProgram program = ShaderProgram.linkFromShadersNameVertexFragment(name, vertexShader, fragmentShader);
        GLES20.glDeleteShader(vertexShader);
        GLES20.glDeleteShader(fragmentShader);
        return program;
    }
    public static ShaderProgram linkFromShadersNameVertexFragment(final String name, final int vertex, final int fragment) {
        final int handle = GLES20.glCreateProgram();
        GLES20.glAttachShader(handle, vertex);
        GLES20.glAttachShader(handle, fragment);
        GLES20.glLinkProgram(handle);
        {
            final String _ = eg.egGetProgramError(handle);
            if(_ != null) {
                throw new RuntimeException("Error in shader program linking: " + _);
            }
        }
        return new ShaderProgram(name, handle);
    }
    public static int compileShaderForShaderTypeSource(final int shaderType, final String source) {
        final int shader = GLES20.glCreateShader(shaderType);
        eg.egShaderSource(shader, source);
        GLES20.glCompileShader(shader);
        {
            final String _ = eg.egGetShaderError(shader);
            if(_ != null) {
                throw new RuntimeException("Error in shader compiling : " + _ + source);
            }
        }
        return shader;
    }
    public void init() {
    }
    @Override
    public void finalize() throws Throwable {
        super.finalize();
        Global.context.deleteShaderProgramId(this.handle);
    }
    public ShaderAttribute attributeForName(final String name) {
        final int h = GLES20.glGetAttribLocation(this.handle, name);
        if(h < 0) {
            throw new RuntimeException("Could not found attribute for name " + name);
        }
        final ShaderAttribute ret = new ShaderAttribute(((int)(h)));
        return ret;
    }
    public ShaderProgram(final String name, final int handle) {
        this.name = name;
        this.handle = handle;
    }
    public String toString() {
        return String.format("ShaderProgram(%s, %d)", this.name, this.handle);
    }
    static {
        version = ((int)(eg.egGLSLVersion()));
    }
}