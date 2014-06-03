package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.gl.gl;

public class ShaderProgram {
    public static final int version;
    public final String name;
    public final int handle;
    public static ShaderProgram loadFromFilesNameVertexFragment(final String name, final String vertex, final String fragment) {
        return ShaderProgram.applyNameVertexFragment(name, Bundle.readToStringResource(vertex), Bundle.readToStringResource(fragment));
    }
    public static ShaderProgram applyNameVertexFragment(final String name, final String vertex, final String fragment) {
        final int vertexShader = ShaderProgram.compileShaderForShaderTypeSource(gl.GL_VERTEX_SHADER, vertex);
        final int fragmentShader = ShaderProgram.compileShaderForShaderTypeSource(gl.GL_FRAGMENT_SHADER, fragment);
        final ShaderProgram program = ShaderProgram.linkFromShadersNameVertexFragment(name, vertexShader, fragmentShader);
        gl.glDeleteShaderShader(vertexShader);
        gl.glDeleteShaderShader(fragmentShader);
        return program;
    }
    public static ShaderProgram linkFromShadersNameVertexFragment(final String name, final int vertex, final int fragment) {
        final int handle = gl.glCreateProgram();
        gl.glAttachShaderProgramShader(handle, vertex);
        gl.glAttachShaderProgramShader(handle, fragment);
        gl.glLinkProgramProgram(handle);
        {
            final String _ = gl.egGetProgramErrorProgram(handle);
            if(_ != null) {
                throw new RuntimeException("Error in shader program linking: " + _);
            }
        }
        return new ShaderProgram(name, handle);
    }
    public static int compileShaderForShaderTypeSource(final int shaderType, final String source) {
        final int shader = gl.glCreateShaderShaderType(shaderType);
        gl.egShaderSourceShaderSource(shader, source);
        gl.glCompileShaderShader(shader);
        {
            final String _ = gl.egGetShaderErrorShader(shader);
            if(_ != null) {
                throw new RuntimeException("Error in shader compiling : " + _ + source);
            }
        }
        return shader;
    }
    public void init() {
        gl.egLabelShaderProgramHandleName(this.handle, this.name);
    }
    @Override
    public void finalize() {
        Global.context.deleteShaderProgramId(this.handle);
    }
    public ShaderAttribute attributeForName(final String name) {
        final int h = gl.egGetAttribLocationProgramName(this.handle, name);
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
        version = ((int)(gl.egGLSLVersion()));
    }
}