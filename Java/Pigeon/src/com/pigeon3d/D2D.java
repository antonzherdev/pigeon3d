package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.geometry.vec3;
import com.pigeon3d.geometry.Rect;
import com.pigeon3d.geometry.Quad;
import objd.collection.Buffer;
import android.opengl.GLES20;
import objd.collection.Int4Buffer;
import com.pigeon3d.geometry.vec2;
import com.pigeon3d.geometry.vec4;
import com.pigeon3d.geometry.vec2i;
import com.pigeon3d.geometry.Vec2Buffer;

public class D2D {
    private static final BillboardBufferDataBuffer vertexes;
    private static final MutableVertexBuffer<BillboardBufferData> vb;
    private static final VertexArray<ColorSource> vaoForColor;
    private static final VertexArray<ColorSource> vaoForTexture;
    private static final MutableVertexBuffer<MeshData> lineVb;
    private static final MeshDataBuffer lineVertexes;
    private static final VertexArray<ColorSource> lineVao;
    private static VertexArray<CircleParam> circleVaoWithSegment() {
        return _lazy_circleVaoWithSegment.get();
    }
    private static final Lazy<VertexArray<CircleParam>> _lazy_circleVaoWithSegment;
    private static VertexArray<CircleParam> circleVaoWithoutSegment() {
        return _lazy_circleVaoWithoutSegment.get();
    }
    private static final Lazy<VertexArray<CircleParam>> _lazy_circleVaoWithoutSegment;
    public static void install() {
    }
    public static void drawSpriteMaterialAtRect(final ColorSource material, final vec3 at, final Rect rect) {
        D2D.drawSpriteMaterialAtQuad(material, at, Rect.stripQuad(rect));
    }
    public static void drawSpriteMaterialAtQuad(final ColorSource material, final vec3 at, final Quad quad) {
        final Texture __tmp_0p3l = material.texture;
        D2D.drawSpriteMaterialAtQuadUv(material, at, quad, Rect.upsideDownStripQuad(((__tmp_0p3l != null) ? (material.texture.uv()) : (Rect.applyXYWidthHeight(((float)(0)), ((float)(0)), ((float)(1)), ((float)(1)))))));
    }
    public static void drawSpriteMaterialAtQuadUv(final ColorSource material, final vec3 at, final Quad quad, final Quad uv) {
        D2D.vertexes.reset();
        {
            {
                final BillboardBufferData __il__1__tmp__il__0v = new BillboardBufferData(at, quad.p0, material.color, uv.p0);
                {
                    D2D.vertexes.bytes.put(__il__1__tmp__il__0v.position.x);
                    D2D.vertexes.bytes.put(__il__1__tmp__il__0v.position.y);
                    D2D.vertexes.bytes.put(__il__1__tmp__il__0v.position.z);
                    D2D.vertexes.bytes.put(__il__1__tmp__il__0v.model.x);
                    D2D.vertexes.bytes.put(__il__1__tmp__il__0v.model.y);
                    D2D.vertexes.bytes.put(__il__1__tmp__il__0v.color.x);
                    D2D.vertexes.bytes.put(__il__1__tmp__il__0v.color.y);
                    D2D.vertexes.bytes.put(__il__1__tmp__il__0v.color.z);
                    D2D.vertexes.bytes.put(__il__1__tmp__il__0v.color.w);
                    D2D.vertexes.bytes.put(__il__1__tmp__il__0v.uv.x);
                    D2D.vertexes.bytes.put(__il__1__tmp__il__0v.uv.y);
                }
            }
            {
                final BillboardBufferData __il__1__tmp__il__1v = new BillboardBufferData(at, quad.p1, material.color, uv.p1);
                {
                    D2D.vertexes.bytes.put(__il__1__tmp__il__1v.position.x);
                    D2D.vertexes.bytes.put(__il__1__tmp__il__1v.position.y);
                    D2D.vertexes.bytes.put(__il__1__tmp__il__1v.position.z);
                    D2D.vertexes.bytes.put(__il__1__tmp__il__1v.model.x);
                    D2D.vertexes.bytes.put(__il__1__tmp__il__1v.model.y);
                    D2D.vertexes.bytes.put(__il__1__tmp__il__1v.color.x);
                    D2D.vertexes.bytes.put(__il__1__tmp__il__1v.color.y);
                    D2D.vertexes.bytes.put(__il__1__tmp__il__1v.color.z);
                    D2D.vertexes.bytes.put(__il__1__tmp__il__1v.color.w);
                    D2D.vertexes.bytes.put(__il__1__tmp__il__1v.uv.x);
                    D2D.vertexes.bytes.put(__il__1__tmp__il__1v.uv.y);
                }
            }
            {
                final BillboardBufferData __il__1__tmp__il__2v = new BillboardBufferData(at, quad.p2, material.color, uv.p2);
                {
                    D2D.vertexes.bytes.put(__il__1__tmp__il__2v.position.x);
                    D2D.vertexes.bytes.put(__il__1__tmp__il__2v.position.y);
                    D2D.vertexes.bytes.put(__il__1__tmp__il__2v.position.z);
                    D2D.vertexes.bytes.put(__il__1__tmp__il__2v.model.x);
                    D2D.vertexes.bytes.put(__il__1__tmp__il__2v.model.y);
                    D2D.vertexes.bytes.put(__il__1__tmp__il__2v.color.x);
                    D2D.vertexes.bytes.put(__il__1__tmp__il__2v.color.y);
                    D2D.vertexes.bytes.put(__il__1__tmp__il__2v.color.z);
                    D2D.vertexes.bytes.put(__il__1__tmp__il__2v.color.w);
                    D2D.vertexes.bytes.put(__il__1__tmp__il__2v.uv.x);
                    D2D.vertexes.bytes.put(__il__1__tmp__il__2v.uv.y);
                }
            }
            {
                final BillboardBufferData __il__1__tmp__il__3v = new BillboardBufferData(at, quad.p3, material.color, uv.p3);
                {
                    D2D.vertexes.bytes.put(__il__1__tmp__il__3v.position.x);
                    D2D.vertexes.bytes.put(__il__1__tmp__il__3v.position.y);
                    D2D.vertexes.bytes.put(__il__1__tmp__il__3v.position.z);
                    D2D.vertexes.bytes.put(__il__1__tmp__il__3v.model.x);
                    D2D.vertexes.bytes.put(__il__1__tmp__il__3v.model.y);
                    D2D.vertexes.bytes.put(__il__1__tmp__il__3v.color.x);
                    D2D.vertexes.bytes.put(__il__1__tmp__il__3v.color.y);
                    D2D.vertexes.bytes.put(__il__1__tmp__il__3v.color.z);
                    D2D.vertexes.bytes.put(__il__1__tmp__il__3v.color.w);
                    D2D.vertexes.bytes.put(__il__1__tmp__il__3v.uv.x);
                    D2D.vertexes.bytes.put(__il__1__tmp__il__3v.uv.y);
                }
            }
        }
        D2D.vb.setData(((Buffer<BillboardBufferData>)(((Buffer)(D2D.vertexes)))));
        {
            final CullFace __tmp__il__3self = Global.context.cullFace;
            {
                final int __il__3oldValue = __tmp__il__3self.disable();
                if(material.texture == null) {
                    D2D.vaoForColor.drawParam(material);
                } else {
                    D2D.vaoForTexture.drawParam(material);
                }
                if(__il__3oldValue != GLES20.GL_NONE) {
                    __tmp__il__3self.setValue(__il__3oldValue);
                }
            }
        }
    }
    public static void writeSpriteInMaterialAtQuadUv(final BillboardBufferDataBuffer in, final ColorSource material, final vec3 at, final Quad quad, final Quad uv) {
        {
            final BillboardBufferData __tmp__il__0v = new BillboardBufferData(at, quad.p0, material.color, uv.p0);
            {
                in.bytes.put(__tmp__il__0v.position.x);
                in.bytes.put(__tmp__il__0v.position.y);
                in.bytes.put(__tmp__il__0v.position.z);
                in.bytes.put(__tmp__il__0v.model.x);
                in.bytes.put(__tmp__il__0v.model.y);
                in.bytes.put(__tmp__il__0v.color.x);
                in.bytes.put(__tmp__il__0v.color.y);
                in.bytes.put(__tmp__il__0v.color.z);
                in.bytes.put(__tmp__il__0v.color.w);
                in.bytes.put(__tmp__il__0v.uv.x);
                in.bytes.put(__tmp__il__0v.uv.y);
            }
        }
        {
            final BillboardBufferData __tmp__il__1v = new BillboardBufferData(at, quad.p1, material.color, uv.p1);
            {
                in.bytes.put(__tmp__il__1v.position.x);
                in.bytes.put(__tmp__il__1v.position.y);
                in.bytes.put(__tmp__il__1v.position.z);
                in.bytes.put(__tmp__il__1v.model.x);
                in.bytes.put(__tmp__il__1v.model.y);
                in.bytes.put(__tmp__il__1v.color.x);
                in.bytes.put(__tmp__il__1v.color.y);
                in.bytes.put(__tmp__il__1v.color.z);
                in.bytes.put(__tmp__il__1v.color.w);
                in.bytes.put(__tmp__il__1v.uv.x);
                in.bytes.put(__tmp__il__1v.uv.y);
            }
        }
        {
            final BillboardBufferData __tmp__il__2v = new BillboardBufferData(at, quad.p2, material.color, uv.p2);
            {
                in.bytes.put(__tmp__il__2v.position.x);
                in.bytes.put(__tmp__il__2v.position.y);
                in.bytes.put(__tmp__il__2v.position.z);
                in.bytes.put(__tmp__il__2v.model.x);
                in.bytes.put(__tmp__il__2v.model.y);
                in.bytes.put(__tmp__il__2v.color.x);
                in.bytes.put(__tmp__il__2v.color.y);
                in.bytes.put(__tmp__il__2v.color.z);
                in.bytes.put(__tmp__il__2v.color.w);
                in.bytes.put(__tmp__il__2v.uv.x);
                in.bytes.put(__tmp__il__2v.uv.y);
            }
        }
        {
            final BillboardBufferData __tmp__il__3v = new BillboardBufferData(at, quad.p3, material.color, uv.p3);
            {
                in.bytes.put(__tmp__il__3v.position.x);
                in.bytes.put(__tmp__il__3v.position.y);
                in.bytes.put(__tmp__il__3v.position.z);
                in.bytes.put(__tmp__il__3v.model.x);
                in.bytes.put(__tmp__il__3v.model.y);
                in.bytes.put(__tmp__il__3v.color.x);
                in.bytes.put(__tmp__il__3v.color.y);
                in.bytes.put(__tmp__il__3v.color.z);
                in.bytes.put(__tmp__il__3v.color.w);
                in.bytes.put(__tmp__il__3v.uv.x);
                in.bytes.put(__tmp__il__3v.uv.y);
            }
        }
    }
    public static void writeQuadIndexInI(final Int4Buffer in, final int i) {
        in.bytes.put(((int)(i)));
        in.bytes.put(((int)(i + 1)));
        in.bytes.put(((int)(i + 2)));
        in.bytes.put(((int)(i + 1)));
        in.bytes.put(((int)(i + 2)));
        in.bytes.put(((int)(i + 3)));
    }
    public static void drawLineMaterialP0P1(final ColorSource material, final vec2 p0, final vec2 p1) {
        D2D.lineVertexes.reset();
        {
            final MeshData __tmp__il__1v = new MeshData(new vec2(((float)(0)), ((float)(0))), new vec3(((float)(0)), ((float)(0)), ((float)(1))), vec3.applyVec2Z(p0, ((float)(0))));
            {
                D2D.lineVertexes.bytes.put(__tmp__il__1v.uv.x);
                D2D.lineVertexes.bytes.put(__tmp__il__1v.uv.y);
                D2D.lineVertexes.bytes.put(__tmp__il__1v.normal.x);
                D2D.lineVertexes.bytes.put(__tmp__il__1v.normal.y);
                D2D.lineVertexes.bytes.put(__tmp__il__1v.normal.z);
                D2D.lineVertexes.bytes.put(__tmp__il__1v.position.x);
                D2D.lineVertexes.bytes.put(__tmp__il__1v.position.y);
                D2D.lineVertexes.bytes.put(__tmp__il__1v.position.z);
            }
        }
        {
            final MeshData __tmp__il__2v = new MeshData(new vec2(((float)(1)), ((float)(1))), new vec3(((float)(0)), ((float)(0)), ((float)(1))), vec3.applyVec2Z(p1, ((float)(0))));
            {
                D2D.lineVertexes.bytes.put(__tmp__il__2v.uv.x);
                D2D.lineVertexes.bytes.put(__tmp__il__2v.uv.y);
                D2D.lineVertexes.bytes.put(__tmp__il__2v.normal.x);
                D2D.lineVertexes.bytes.put(__tmp__il__2v.normal.y);
                D2D.lineVertexes.bytes.put(__tmp__il__2v.normal.z);
                D2D.lineVertexes.bytes.put(__tmp__il__2v.position.x);
                D2D.lineVertexes.bytes.put(__tmp__il__2v.position.y);
                D2D.lineVertexes.bytes.put(__tmp__il__2v.position.z);
            }
        }
        D2D.lineVb.setData(((Buffer<MeshData>)(((Buffer)(D2D.lineVertexes)))));
        {
            final CullFace __tmp__il__4self = Global.context.cullFace;
            {
                final int __il__4oldValue = __tmp__il__4self.disable();
                D2D.lineVao.drawParam(material);
                if(__il__4oldValue != GLES20.GL_NONE) {
                    __tmp__il__4self.setValue(__il__4oldValue);
                }
            }
        }
    }
    public static void drawCircleBackColorStrokeColorAtRadiusRelativeSegmentColorStartEnd(final vec4 backColor, final vec4 strokeColor, final vec3 at, final float radius, final vec2 relative, final vec4 segmentColor, final double start, final double end) {
        {
            final CullFace __tmp__il__0self = Global.context.cullFace;
            {
                final int __il__0oldValue = __tmp__il__0self.disable();
                D2D.circleVaoWithSegment().drawParam(new CircleParam(backColor, strokeColor, at, D2D.radiusPR(radius), relative, new CircleSegment(segmentColor, ((float)(start)), ((float)(end)))));
                if(__il__0oldValue != GLES20.GL_NONE) {
                    __tmp__il__0self.setValue(__il__0oldValue);
                }
            }
        }
    }
    public static void drawCircleBackColorStrokeColorAtRadiusRelative(final vec4 backColor, final vec4 strokeColor, final vec3 at, final float radius, final vec2 relative) {
        {
            final CullFace __tmp__il__0self = Global.context.cullFace;
            {
                final int __il__0oldValue = __tmp__il__0self.disable();
                D2D.circleVaoWithoutSegment().drawParam(new CircleParam(backColor, strokeColor, at, D2D.radiusPR(radius), relative, null));
                if(__il__0oldValue != GLES20.GL_NONE) {
                    __tmp__il__0self.setValue(__il__0oldValue);
                }
            }
        }
    }
    private static vec2 radiusPR(final float r) {
        final float l = vec2.length(vec4.xy(Global.matrix.value().wcp().mulVec4(new vec4(r, ((float)(0)), ((float)(0)), ((float)(0))))));
        final vec2i vps = Global.context.viewport().size;
        if(vps.y <= vps.x) {
            return new vec2((l * vps.y) / vps.x, l);
        } else {
            return new vec2(l, (l * vps.x) / vps.y);
        }
    }
    static {
        vertexes = new BillboardBufferDataBuffer(((int)(4)));
        vb = VBO.<BillboardBufferData>mutDescUsage(Sprite.vbDesc, GLES20.GL_STREAM_DRAW);
        vaoForColor = new Mesh(((VertexBuffer<Object>)(((VertexBuffer)(D2D.vb)))), EmptyIndexSource.triangleStrip).<ColorSource>vaoShader(((Shader<ColorSource>)(((Shader)(BillboardShaderSystem.shaderForKey(new BillboardShaderKey(false, false, false, BillboardShaderSpace.camera)))))));
        vaoForTexture = new Mesh(((VertexBuffer<Object>)(((VertexBuffer)(D2D.vb)))), EmptyIndexSource.triangleStrip).<ColorSource>vaoShader(((Shader<ColorSource>)(((Shader)(BillboardShaderSystem.shaderForKey(new BillboardShaderKey(true, false, false, BillboardShaderSpace.camera)))))));
        lineVb = VBO.mutMeshUsage(GLES20.GL_STREAM_DRAW);
        lineVertexes = new MeshDataBuffer(((int)(2)));
        lineVao = new Mesh(((VertexBuffer<Object>)(((VertexBuffer)(D2D.lineVb)))), EmptyIndexSource.lines).<ColorSource>vaoShader(SimpleShaderSystem.colorShader());
        _lazy_circleVaoWithSegment = new Lazy<VertexArray<CircleParam>>(new F0<VertexArray<CircleParam>>() {
            @Override
            public VertexArray<CircleParam> apply() {
                final Vec2Buffer b = new Vec2Buffer(((int)(4)));
                b.bytes.put(((float)(-1)));
                b.bytes.put(((float)(-1)));
                b.bytes.put(((float)(-1)));
                b.bytes.put(((float)(1)));
                b.bytes.put(((float)(1)));
                b.bytes.put(((float)(-1)));
                b.bytes.put(((float)(1)));
                b.bytes.put(((float)(1)));
                return new Mesh(((VertexBuffer<Object>)(((VertexBuffer)(VBO.vec2Data(b))))), EmptyIndexSource.triangleStrip).<CircleParam>vaoShader(((Shader<CircleParam>)(((Shader)(CircleShader.withSegment)))));
            }
        });
        _lazy_circleVaoWithoutSegment = new Lazy<VertexArray<CircleParam>>(new F0<VertexArray<CircleParam>>() {
            @Override
            public VertexArray<CircleParam> apply() {
                final Vec2Buffer b = new Vec2Buffer(((int)(4)));
                b.bytes.put(((float)(-1)));
                b.bytes.put(((float)(-1)));
                b.bytes.put(((float)(-1)));
                b.bytes.put(((float)(1)));
                b.bytes.put(((float)(1)));
                b.bytes.put(((float)(-1)));
                b.bytes.put(((float)(1)));
                b.bytes.put(((float)(1)));
                return new Mesh(((VertexBuffer<Object>)(((VertexBuffer)(VBO.vec2Data(b))))), EmptyIndexSource.triangleStrip).<CircleParam>vaoShader(((Shader<CircleParam>)(((Shader)(CircleShader.withoutSegment)))));
            }
        });
    }
}