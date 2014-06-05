package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.geometry.vec3;
import com.pigeon3d.geometry.Rect;
import com.pigeon3d.geometry.Quad;
import android.opengl.GLES20;
import com.pigeon3d.geometry.vec2;
import com.pigeon3d.geometry.vec4;
import com.pigeon3d.geometry.vec2i;
import com.pigeon3d.geometry.Vec2Buffer;

public class D2D {
    private static final Pointer vertexes;
    private static final MutableVertexBuffer<BillboardBufferData> vb;
    private static final VertexArray<ColorSource> vaoForColor;
    private static final VertexArray<ColorSource> vaoForTexture;
    private static final MutableVertexBuffer<MeshData> lineVb;
    private static final Pointer lineVertexes;
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
        {
            Pointer __il__0v = D2D.vertexes;
            ERROR: Unknown <lm>__il__0v\BillboardBufferData#S*\-><fIUms>position\vec3#S\ = at;
            ERROR: Unknown <lm>__il__0v\BillboardBufferData#S*\-><fIUms>model\vec2#S\ = quad.p0;
            ERROR: Unknown <lm>__il__0v\BillboardBufferData#S*\-><fIUms>color\vec4#S\ = material.color;
            ERROR: Unknown <lm>__il__0v\BillboardBufferData#S*\-><fIUms>uv\vec2#S\ = uv.p0;
            __il__0v++;
            ERROR: Unknown <lm>__il__0v\BillboardBufferData#S*\-><fIUms>position\vec3#S\ = at;
            ERROR: Unknown <lm>__il__0v\BillboardBufferData#S*\-><fIUms>model\vec2#S\ = quad.p1;
            ERROR: Unknown <lm>__il__0v\BillboardBufferData#S*\-><fIUms>color\vec4#S\ = material.color;
            ERROR: Unknown <lm>__il__0v\BillboardBufferData#S*\-><fIUms>uv\vec2#S\ = uv.p1;
            __il__0v++;
            ERROR: Unknown <lm>__il__0v\BillboardBufferData#S*\-><fIUms>position\vec3#S\ = at;
            ERROR: Unknown <lm>__il__0v\BillboardBufferData#S*\-><fIUms>model\vec2#S\ = quad.p2;
            ERROR: Unknown <lm>__il__0v\BillboardBufferData#S*\-><fIUms>color\vec4#S\ = material.color;
            ERROR: Unknown <lm>__il__0v\BillboardBufferData#S*\-><fIUms>uv\vec2#S\ = uv.p2;
            __il__0v++;
            ERROR: Unknown <lm>__il__0v\BillboardBufferData#S*\-><fIUms>position\vec3#S\ = at;
            ERROR: Unknown <lm>__il__0v\BillboardBufferData#S*\-><fIUms>model\vec2#S\ = quad.p3;
            ERROR: Unknown <lm>__il__0v\BillboardBufferData#S*\-><fIUms>color\vec4#S\ = material.color;
            ERROR: Unknown <lm>__il__0v\BillboardBufferData#S*\-><fIUms>uv\vec2#S\ = uv.p3;
            return __il__0v + 1;
        }
        D2D.vb.setArrayCount(D2D.vertexes, ((int)(4)));
        {
            final CullFace __tmp__il__2self = Global.context.cullFace;
            {
                final int __il__2oldValue = __tmp__il__2self.disable();
                if(material.texture == null) {
                    D2D.vaoForColor.drawParam(material);
                } else {
                    D2D.vaoForTexture.drawParam(material);
                }
                if(__il__2oldValue != GLES20.GL_NONE) {
                    __tmp__il__2self.setValue(__il__2oldValue);
                }
            }
        }
    }
    public static Pointer writeSpriteInMaterialAtQuadUv(final Pointer in, final ColorSource material, final vec3 at, final Quad quad, final Quad uv) {
        Pointer v = in;
        ERROR: Unknown <lm>v\BillboardBufferData#S*\-><fIUms>position\vec3#S\ = at;
        ERROR: Unknown <lm>v\BillboardBufferData#S*\-><fIUms>model\vec2#S\ = quad.p0;
        ERROR: Unknown <lm>v\BillboardBufferData#S*\-><fIUms>color\vec4#S\ = material.color;
        ERROR: Unknown <lm>v\BillboardBufferData#S*\-><fIUms>uv\vec2#S\ = uv.p0;
        v++;
        ERROR: Unknown <lm>v\BillboardBufferData#S*\-><fIUms>position\vec3#S\ = at;
        ERROR: Unknown <lm>v\BillboardBufferData#S*\-><fIUms>model\vec2#S\ = quad.p1;
        ERROR: Unknown <lm>v\BillboardBufferData#S*\-><fIUms>color\vec4#S\ = material.color;
        ERROR: Unknown <lm>v\BillboardBufferData#S*\-><fIUms>uv\vec2#S\ = uv.p1;
        v++;
        ERROR: Unknown <lm>v\BillboardBufferData#S*\-><fIUms>position\vec3#S\ = at;
        ERROR: Unknown <lm>v\BillboardBufferData#S*\-><fIUms>model\vec2#S\ = quad.p2;
        ERROR: Unknown <lm>v\BillboardBufferData#S*\-><fIUms>color\vec4#S\ = material.color;
        ERROR: Unknown <lm>v\BillboardBufferData#S*\-><fIUms>uv\vec2#S\ = uv.p2;
        v++;
        ERROR: Unknown <lm>v\BillboardBufferData#S*\-><fIUms>position\vec3#S\ = at;
        ERROR: Unknown <lm>v\BillboardBufferData#S*\-><fIUms>model\vec2#S\ = quad.p3;
        ERROR: Unknown <lm>v\BillboardBufferData#S*\-><fIUms>color\vec4#S\ = material.color;
        ERROR: Unknown <lm>v\BillboardBufferData#S*\-><fIUms>uv\vec2#S\ = uv.p3;
        return v + 1;
    }
    public static Pointer writeQuadIndexInI(final Pointer in, final int i) {
        ERROR: Unknown *((<l>in\uint4*\ + 0)) = i;
        ERROR: Unknown *((<l>in\uint4*\ + 1)) = i + 1;
        ERROR: Unknown *((<l>in\uint4*\ + 2)) = i + 2;
        ERROR: Unknown *((<l>in\uint4*\ + 3)) = i + 1;
        ERROR: Unknown *((<l>in\uint4*\ + 4)) = i + 2;
        ERROR: Unknown *((<l>in\uint4*\ + 5)) = i + 3;
        return in + 6;
    }
    public static void drawLineMaterialP0P1(final ColorSource material, final vec2 p0, final vec2 p1) {
        Pointer v = D2D.lineVertexes;
        ERROR: Unknown <lm>v\§^MeshData#S§*\-><fIUms>position\vec3#S\ = vec3.applyVec2Z(p0, ((float)(0)));
        v++;
        ERROR: Unknown <lm>v\§^MeshData#S§*\-><fIUms>position\vec3#S\ = vec3.applyVec2Z(p1, ((float)(0)));
        D2D.lineVb.setArrayCount(D2D.lineVertexes, ((int)(2)));
        {
            final CullFace __tmp__il__5self = Global.context.cullFace;
            {
                final int __il__5oldValue = __tmp__il__5self.disable();
                D2D.lineVao.drawParam(material);
                if(__il__5oldValue != GLES20.GL_NONE) {
                    __tmp__il__5self.setValue(__il__5oldValue);
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
        vertexes = new Pointer<BillboardBufferData>(BillboardBufferData.type, ((int)(4)));
        vb = VBO.<BillboardBufferData>mutDescUsage(Sprite.vbDesc, GLES20.GL_STREAM_DRAW);
        vaoForColor = new Mesh(((VertexBuffer<Object>)(((VertexBuffer)(D2D.vb)))), EmptyIndexSource.triangleStrip).<ColorSource>vaoShader(((Shader<ColorSource>)(((Shader)(BillboardShaderSystem.shaderForKey(new BillboardShaderKey(false, false, false, BillboardShaderSpace.camera)))))));
        vaoForTexture = new Mesh(((VertexBuffer<Object>)(((VertexBuffer)(D2D.vb)))), EmptyIndexSource.triangleStrip).<ColorSource>vaoShader(((Shader<ColorSource>)(((Shader)(BillboardShaderSystem.shaderForKey(new BillboardShaderKey(true, false, false, BillboardShaderSpace.camera)))))));
        lineVb = VBO.mutMeshUsage(GLES20.GL_STREAM_DRAW);
        lineVertexes = pp;
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