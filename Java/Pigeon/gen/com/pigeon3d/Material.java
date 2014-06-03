package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.geometry.vec4;

public abstract class Material {
    public abstract ShaderSystem<Material> shaderSystem();
    public void drawMesh(final Mesh<Object> mesh) {
        this.shaderSystem().drawParamVertexIndex(this, ((VertexBuffer<Object>)(((VertexBuffer)(mesh.vertex)))), mesh.index);
    }
    public void drawVertexIndex(final VertexBuffer<Object> vertex, final IndexSource index) {
        this.shaderSystem().drawParamVertexIndex(this, ((VertexBuffer<Object>)(((VertexBuffer)(vertex)))), index);
    }
    public Shader<Material> shader() {
        return ((Shader<Material>)(((Shader)(this.shaderSystem().shaderForParam(this)))));
    }
    public static Material applyColor(final vec4 color) {
        return StandardMaterial.applyDiffuse(ColorSource.applyColor(color));
    }
    public static Material applyTexture(final Texture texture) {
        return StandardMaterial.applyDiffuse(ColorSource.applyTexture(texture));
    }
    public Material() {
    }
    public String toString() {
        return "Material";
    }
}