package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.geometry.vec4;
import objd.collection.ImArray;
import com.pigeon3d.gl.gl;
import com.pigeon3d.geometry.mat4;
import com.pigeon3d.geometry.RectI;
import com.pigeon3d.geometry.vec2;
import com.pigeon3d.geometry.vec3;

public class MapSsoView {
    public final MapSso map;
    public final Material material;
    public VertexBuffer<vec4> axisVertexBuffer() {
        return _lazy_axisVertexBuffer.get();
    }
    private final Lazy<VertexBuffer<vec4>> _lazy_axisVertexBuffer;
    public final Mesh plane;
    private final VertexArray<Material> planeVao;
    public void drawLayout() {
        ColorSource.applyColor(new vec4(((float)(1)), ((float)(0)), ((float)(0)), ((float)(1)))).drawVertexIndex(((VertexBuffer<Object>)(((VertexBuffer)(this.axisVertexBuffer())))), new ArrayIndexSource(((int[0])(ImArray.fromObjects(0, 1))), gl.GL_LINES));
        ColorSource.applyColor(new vec4(((float)(0)), ((float)(1)), ((float)(0)), ((float)(1)))).drawVertexIndex(((VertexBuffer<Object>)(((VertexBuffer)(this.axisVertexBuffer())))), new ArrayIndexSource(((int[0])(ImArray.fromObjects(0, 2))), gl.GL_LINES));
        ColorSource.applyColor(new vec4(((float)(0)), ((float)(0)), ((float)(1)), ((float)(1)))).drawVertexIndex(((VertexBuffer<Object>)(((VertexBuffer)(this.axisVertexBuffer())))), new ArrayIndexSource(((int[0])(ImArray.fromObjects(0, 3))), gl.GL_LINES));
    }
    public void draw() {
        {
            final CullFace __tmp__il__0self = Global.context.cullFace;
            {
                final int __il__0oldValue = __tmp__il__0self.disable();
                this.planeVao.draw();
                if(__il__0oldValue != gl.GL_NONE) {
                    __tmp__il__0self.setValue(__il__0oldValue);
                }
            }
        }
    }
    public MapSsoView(final MapSso map, final Material material) {
        this.map = map;
        this.material = material;
        this._lazy_axisVertexBuffer = new Lazy(new F0<VertexBuffer<vec4>>() {
            @Override
            public VertexBuffer<vec4> apply() {
                final mat4 mi = CameraIso.m.inverse();
                return VBO.vec4Data(((vec4[0])(ImArray.fromObjects(mi.mulVec4(new vec4(((float)(0)), ((float)(0)), ((float)(0)), ((float)(1)))), mi.mulVec4(new vec4(((float)(1)), ((float)(0)), ((float)(0)), ((float)(1)))), mi.mulVec4(new vec4(((float)(0)), ((float)(1)), ((float)(0)), ((float)(1)))), mi.mulVec4(new vec4(((float)(0)), ((float)(0)), ((float)(1)), ((float)(1))))))));
            }
        });
        this.plane = new Mesh(((VertexBuffer<Object>)(((VertexBuffer)(VBO.meshData(((MeshData[0])(ImArray.fromObjects(new MeshData(new vec2(((float)(0)), ((float)(0))), new vec3(((float)(0)), ((float)(1)), ((float)(0))), new vec3(((float)(l)), ((float)(0)), ((float)(b)))), new MeshData(new vec2(((float)(w)), ((float)(0))), new vec3(((float)(0)), ((float)(1)), ((float)(0))), new vec3(((float)(r)), ((float)(0)), ((float)(b)))), new MeshData(new vec2(((float)(0)), ((float)(h))), new vec3(((float)(0)), ((float)(1)), ((float)(0))), new vec3(((float)(l)), ((float)(0)), ((float)(t)))), new MeshData(new vec2(((float)(w)), ((float)(h))), new vec3(((float)(0)), ((float)(1)), ((float)(0))), new vec3(((float)(r)), ((float)(0)), ((float)(t)))))))))))), EmptyIndexSource.triangleStrip);
        this.planeVao = this.plane.<Material>vaoMaterialShadow(material, false);
    }
    public String toString() {
        return String.format("MapSsoView(%s, %s)", this.map, this.material);
    }
}