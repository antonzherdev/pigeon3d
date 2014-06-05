package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.geometry.vec4;
import objd.collection.ImArray;
import android.opengl.GLES20;
import com.pigeon3d.geometry.mat4;
import com.pigeon3d.geometry.Vec4Buffer;
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
        ColorSource.applyColor(new vec4(((float)(1)), ((float)(0)), ((float)(0)), ((float)(1)))).drawVertexIndex(((VertexBuffer<Object>)(((VertexBuffer)(this.axisVertexBuffer())))), new ArrayIndexSource(((int[0])(ImArray.fromObjects(0, 1))), GLES20.GL_LINES));
        ColorSource.applyColor(new vec4(((float)(0)), ((float)(1)), ((float)(0)), ((float)(1)))).drawVertexIndex(((VertexBuffer<Object>)(((VertexBuffer)(this.axisVertexBuffer())))), new ArrayIndexSource(((int[0])(ImArray.fromObjects(0, 2))), GLES20.GL_LINES));
        ColorSource.applyColor(new vec4(((float)(0)), ((float)(0)), ((float)(1)), ((float)(1)))).drawVertexIndex(((VertexBuffer<Object>)(((VertexBuffer)(this.axisVertexBuffer())))), new ArrayIndexSource(((int[0])(ImArray.fromObjects(0, 3))), GLES20.GL_LINES));
    }
    public void draw() {
        {
            final CullFace __tmp__il__0self = Global.context.cullFace;
            {
                final int __il__0oldValue = __tmp__il__0self.disable();
                this.planeVao.draw();
                if(__il__0oldValue != GLES20.GL_NONE) {
                    __tmp__il__0self.setValue(__il__0oldValue);
                }
            }
        }
    }
    public MapSsoView(final MapSso map, final Material material) {
        this.map = map;
        this.material = material;
        this._lazy_axisVertexBuffer = new Lazy<VertexBuffer<vec4>>(new F0<VertexBuffer<vec4>>() {
            @Override
            public VertexBuffer<vec4> apply() {
                final mat4 mi = CameraIso.m.inverse();
                final Vec4Buffer b = new Vec4Buffer(((int)(4)));
                final vec4 __tmp__il__1rp0_1v = mi.mulVec4(new vec4(((float)(0)), ((float)(0)), ((float)(0)), ((float)(1))));
                {
                    b.bytes.put(__tmp__il__1rp0_1v.x);
                    b.bytes.put(__tmp__il__1rp0_1v.y);
                    b.bytes.put(__tmp__il__1rp0_1v.z);
                    b.bytes.put(__tmp__il__1rp0_1v.w);
                }
                final vec4 __tmp__il__1rp0_2v = mi.mulVec4(new vec4(((float)(1)), ((float)(0)), ((float)(0)), ((float)(1))));
                {
                    b.bytes.put(__tmp__il__1rp0_2v.x);
                    b.bytes.put(__tmp__il__1rp0_2v.y);
                    b.bytes.put(__tmp__il__1rp0_2v.z);
                    b.bytes.put(__tmp__il__1rp0_2v.w);
                }
                final vec4 __tmp__il__1rp0_3v = mi.mulVec4(new vec4(((float)(0)), ((float)(1)), ((float)(0)), ((float)(1))));
                {
                    b.bytes.put(__tmp__il__1rp0_3v.x);
                    b.bytes.put(__tmp__il__1rp0_3v.y);
                    b.bytes.put(__tmp__il__1rp0_3v.z);
                    b.bytes.put(__tmp__il__1rp0_3v.w);
                }
                final vec4 __tmp__il__1rp0_4v = mi.mulVec4(new vec4(((float)(0)), ((float)(0)), ((float)(1)), ((float)(1))));
                {
                    b.bytes.put(__tmp__il__1rp0_4v.x);
                    b.bytes.put(__tmp__il__1rp0_4v.y);
                    b.bytes.put(__tmp__il__1rp0_4v.z);
                    b.bytes.put(__tmp__il__1rp0_4v.w);
                }
                return VBO.vec4Data(b);
            }
        });
        this.plane = new Mesh(((VertexBuffer<Object>)(((VertexBuffer)(VBO.meshData(buf))))), EmptyIndexSource.triangleStrip);
        this.planeVao = this.plane.<Material>vaoMaterialShadow(material, false);
    }
    public String toString() {
        return String.format("MapSsoView(%s, %s)", this.map, this.material);
    }
}