package com.pigeon3d;

import objd.lang.*;
import objd.collection.PArray;
import com.pigeon3d.geometry.vec2;
import com.pigeon3d.geometry.vec4;

public class Mesh {
    public final VertexBuffer<Object> vertex;
    public final IndexSource index;
    public static Mesh vec2VertexDataIndexData(final PArray<vec2> vertexData, final PArray<Integer> indexData) {
        return new Mesh(((VertexBuffer<Object>)(((VertexBuffer)(VBO.vec2Data(vertexData))))), IBO.applyData(indexData));
    }
    public static Mesh applyVertexDataIndexData(final PArray<MeshData> vertexData, final PArray<Integer> indexData) {
        return new Mesh(((VertexBuffer<Object>)(((VertexBuffer)(VBO.meshData(vertexData))))), IBO.applyData(indexData));
    }
    public static <T> Mesh applyDescVertexDataIndexData(final VertexBufferDesc<T> desc, final PArray<T> vertexData, final PArray<Integer> indexData) {
        return new Mesh(((VertexBuffer<Object>)(((VertexBuffer)(VBO.<T>applyDescData(desc, vertexData))))), IBO.applyData(indexData));
    }
    public <N> VertexArray<N> vaoShader(final Shader<N> shader) {
        return shader.vaoVboIbo(((VertexBuffer<Object>)(((VertexBuffer)(this.vertex)))), ((IndexBuffer)(this.index)));
    }
    public VertexArray<ColorSource> vaoShadow() {
        return this.<ColorSource>vaoShaderSystemMaterialShadow(((ShaderSystem<ColorSource>)(((ShaderSystem)(ShadowShaderSystem.instance)))), ColorSource.applyColor(new vec4(((float)(1)), ((float)(1)), ((float)(1)), ((float)(1)))), false);
    }
    public VertexArray<ColorSource> vaoShadowMaterial(final ColorSource material) {
        return this.<ColorSource>vaoShaderSystemMaterialShadow(((ShaderSystem<ColorSource>)(((ShaderSystem)(ShadowShaderSystem.instance)))), material, false);
    }
    public <N extends Material> VertexArray<N> vaoMaterialShadow(final N material, final boolean shadow) {
        final MaterialVertexArray<Material> std = new MaterialVertexArray<Material>(material.shader().vaoVboIbo(((VertexBuffer<Object>)(((VertexBuffer)(this.vertex)))), ((IndexBuffer)(this.index))), material);
        if(shadow && platform.egPlatform().shadows) {
            return ((VertexArray<N>)(((VertexArray)(((VertexArray<Material>)(((VertexArray)(new RouteVertexArray<Material>(std, ((VertexArray<Material>)(((VertexArray)(new MaterialVertexArray<Object>(((VertexArray<Object>)(((VertexArray)(material.shaderSystem().shaderForParamRenderTarget(material, ShadowRenderTarget.aDefault).vaoVboIbo(((VertexBuffer<Object>)(((VertexBuffer)(this.vertex)))), ((IndexBuffer)(this.index))))))), material))))))))))))));
        } else {
            return ((VertexArray<N>)(((VertexArray)(((VertexArray<Material>)(((VertexArray)(std))))))));
        }
    }
    public <N> VertexArray<N> vaoShaderSystemMaterialShadow(final ShaderSystem<N> shaderSystem, final N material, final boolean shadow) {
        final MaterialVertexArray<Object> std = new MaterialVertexArray<Object>(((VertexArray<Object>)(((VertexArray)(shaderSystem.shaderForParam(material).vaoVboIbo(((VertexBuffer<Object>)(((VertexBuffer)(this.vertex)))), ((IndexBuffer)(this.index))))))), material);
        if(shadow && platform.egPlatform().shadows) {
            return ((VertexArray<N>)(((VertexArray)(((VertexArray<Object>)(((VertexArray)(new RouteVertexArray<Object>(((VertexArray<Object>)(((VertexArray)(std)))), ((VertexArray<Object>)(((VertexArray)(new MaterialVertexArray<Object>(((VertexArray<Object>)(((VertexArray)(shaderSystem.shaderForParamRenderTarget(material, ShadowRenderTarget.aDefault).vaoVboIbo(((VertexBuffer<Object>)(((VertexBuffer)(this.vertex)))), ((IndexBuffer)(this.index))))))), material))))))))))))));
        } else {
            return ((VertexArray<N>)(((VertexArray)(((VertexArray<Object>)(((VertexArray)(std))))))));
        }
    }
    public void drawMaterial(final Material material) {
        material.drawMesh(((Mesh<Object>)(((Mesh)(this)))));
    }
    public Mesh(final VertexBuffer<Object> vertex, final IndexSource index) {
        this.vertex = vertex;
        this.index = index;
    }
    public String toString() {
        return String.format("Mesh(%s, %s)", this.vertex, this.index);
    }
}