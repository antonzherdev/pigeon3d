package com.pigeon3d;

import objd.lang.*;

public abstract class ShaderSystem<P> {
    public abstract Shader<Object> shaderForParamRenderTarget(final P param, final RenderTarget renderTarget);
    public void drawParamVertexIndex(final P param, final VertexBuffer<Object> vertex, final IndexSource index) {
        final Shader<Object> shader = shaderForParam(param);
        shader.drawParamVertexIndex(param, ((VertexBuffer<Object>)(((VertexBuffer)(vertex)))), index);
    }
    public void drawParamVao(final P param, final SimpleVertexArray<P> vao) {
        final Shader<Object> shader = shaderForParam(param);
        shader.drawParamVao(param, ((SimpleVertexArray<Object>)(((SimpleVertexArray)(vao)))));
    }
    public void drawParamMesh(final P param, final Mesh mesh) {
        final Shader<Object> shader = shaderForParam(param);
        shader.drawParamMesh(param, mesh);
    }
    public Shader<Object> shaderForParam(final P param) {
        return ((Shader<Object>)(((Shader)(shaderForParamRenderTarget(param, Global.context.renderTarget)))));
    }
    public VertexArray vaoParamVboIbo(final P param, final VertexBuffer<Object> vbo, final IndexSource ibo) {
        return ((VertexArray)(shaderForParam(param).vaoVboIbo(((VertexBuffer<Object>)(((VertexBuffer)(vbo)))), ibo)));
    }
    public ShaderSystem() {
    }
    public String toString() {
        return "ShaderSystem";
    }
}