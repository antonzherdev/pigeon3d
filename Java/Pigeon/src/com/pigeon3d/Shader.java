package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.gl.gl;
import objd.collection.ImArray;

public abstract class Shader<P> {
    public abstract void loadAttributesVbDesc(final VertexBufferDesc<Object> vbDesc);
    public abstract void loadUniformsParam(final P param);
    public final ShaderProgram program;
    public void drawParamVertexIndex(final P param, final VertexBuffer<Object> vertex, final IndexSource index) {
        Global.context.bindShaderProgramProgram(this.program);
        vertex.bind();
        loadAttributesVbDesc(((VertexBufferDesc<Object>)(((VertexBufferDesc)(vertex.desc())))));
        loadUniformsParam(param);
        index.bind();
        index.draw();
    }
    public void drawParamMesh(final P param, final Mesh mesh) {
        drawParamVertexIndex(param, ((VertexBuffer<Object>)(((VertexBuffer)(mesh.vertex)))), mesh.index);
    }
    public void drawParamVao(final P param, final SimpleVertexArray<P> vao) {
        vao.bind();
        Global.context.bindShaderProgramProgram(this.program);
        loadUniformsParam(param);
        vao.index.draw();
        vao.unbind();
    }
    public void drawParamVaoStartEnd(final P param, final SimpleVertexArray<P> vao, final int start, final int end) {
        vao.bind();
        Global.context.bindShaderProgramProgram(this.program);
        loadUniformsParam(param);
        vao.index.drawWithStartCount(start, end);
        vao.unbind();
    }
    private int uniformName(final String name) {
        final int h = gl.egGetUniformLocationProgramName(this.program.handle, name);
        if(h < 0) {
            throw new RuntimeException("Could not found attribute for name " + name);
        }
        return h;
    }
    private Integer uniformOptName(final String name) {
        final int h = gl.egGetUniformLocationProgramName(this.program.handle, name);
        if(h < 0) {
            null;
        }
        return h;
    }
    public ShaderUniformMat4 uniformMat4Name(final String name) {
        return new ShaderUniformMat4(((int)(uniformName(name))));
    }
    public ShaderUniformVec4 uniformVec4Name(final String name) {
        return new ShaderUniformVec4(((int)(uniformName(name))));
    }
    public ShaderUniformVec3 uniformVec3Name(final String name) {
        return new ShaderUniformVec3(((int)(uniformName(name))));
    }
    public ShaderUniformVec2 uniformVec2Name(final String name) {
        return new ShaderUniformVec2(((int)(uniformName(name))));
    }
    public ShaderUniformF4 uniformF4Name(final String name) {
        return new ShaderUniformF4(((int)(uniformName(name))));
    }
    public ShaderUniformI4 uniformI4Name(final String name) {
        return new ShaderUniformI4(((int)(uniformName(name))));
    }
    public ShaderUniformMat4 uniformMat4OptName(final String name) {
        final Integer _ = uniformOptName(name);
        if(_ != null) {
            return new ShaderUniformMat4(_);
        } else {
            return null;
        }
    }
    public ShaderUniformVec4 uniformVec4OptName(final String name) {
        final Integer _ = uniformOptName(name);
        if(_ != null) {
            return new ShaderUniformVec4(_);
        } else {
            return null;
        }
    }
    public ShaderUniformVec3 uniformVec3OptName(final String name) {
        final Integer _ = uniformOptName(name);
        if(_ != null) {
            return new ShaderUniformVec3(_);
        } else {
            return null;
        }
    }
    public ShaderUniformVec2 uniformVec2OptName(final String name) {
        final Integer _ = uniformOptName(name);
        if(_ != null) {
            return new ShaderUniformVec2(_);
        } else {
            return null;
        }
    }
    public ShaderUniformF4 uniformF4OptName(final String name) {
        final Integer _ = uniformOptName(name);
        if(_ != null) {
            return new ShaderUniformF4(_);
        } else {
            return null;
        }
    }
    public ShaderUniformI4 uniformI4OptName(final String name) {
        final Integer _ = uniformOptName(name);
        if(_ != null) {
            return new ShaderUniformI4(_);
        } else {
            return null;
        }
    }
    public ShaderAttribute attributeForName(final String name) {
        return this.program.attributeForName(name);
    }
    public SimpleVertexArray<P> vaoVboIbo(final VertexBuffer<Object> vbo, final IndexSource ibo) {
        final SimpleVertexArray<P> vao = SimpleVertexArray.<P>applyShaderBuffersIndex(this, ImArray.fromObjects(((VertexBuffer<Object>)(((VertexBuffer)(vbo))))), ibo);
        vao.bind();
        vbo.bind();
        ibo.bind();
        loadAttributesVbDesc(((VertexBufferDesc<Object>)(((VertexBufferDesc)(vbo.desc())))));
        vao.unbind();
        return vao;
    }
    public Shader(final ShaderProgram program) {
        this.program = program;
    }
    public String toString() {
        return String.format("Shader(%s)", this.program);
    }
}