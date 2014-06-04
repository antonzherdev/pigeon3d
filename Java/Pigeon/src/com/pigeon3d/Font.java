package com.pigeon3d;

import objd.lang.*;
import objd.react.Signal;
import com.pigeon3d.geometry.vec2;
import objd.collection.ImArray;
import objd.collection.Iterator;
import com.pigeon3d.geometry.vec4;
import objd.collection.MArray;
import com.pigeon3d.geometry.Rect;
import com.pigeon3d.geometry.vec3;
import android.opengl.GLES20;

public abstract class Font {
    public abstract Texture texture();
    public abstract int height();
    public abstract int size();
    public abstract FontSymbolDesc symbolOptSmb(final char smb);
    public static final FontSymbolDesc newLineDesc;
    public static final FontSymbolDesc zeroDesc;
    public static final VertexBufferDesc<FontPrintData> vbDesc;
    public final Signal<Void> symbolsChanged;
    public vec2 measureInPointsText(final String text) {
        final Tuple<ImArray<FontSymbolDesc>, Integer> pair = buildSymbolArrayHasGLText(false, text);
        final ImArray<FontSymbolDesc> symbolsArr = pair.a;
        final int newLines = pair.b;
        int fullWidth = 0;
        int lineWidth = 0;
        {
            final Iterator<FontSymbolDesc> __il__5i = symbolsArr.iterator();
            while(__il__5i.hasNext()) {
                final FontSymbolDesc s = __il__5i.next();
                if(s.isNewLine) {
                    if(lineWidth > fullWidth) {
                        fullWidth = lineWidth;
                    }
                    lineWidth = 0;
                } else {
                    lineWidth += ((int)(s.width));
                }
            }
        }
        if(lineWidth > fullWidth) {
            fullWidth = lineWidth;
        }
        return vec2.divF(new vec2(((float)(fullWidth)), ((float)(this.height())) * (newLines + 1)), Director.current().scale());
    }
    public vec2 measurePText(final String text) {
        return vec2.divVec2(vec2.mulF(measureInPointsText(text), 2.0), Global.context.scaledViewSize.value());
    }
    public vec2 measureCText(final String text) {
        return vec4.xy(Global.matrix.p().divBySelfVec4(vec4.applyVec2ZW(measurePText(text), ((float)(0)), ((float)(0)))));
    }
    public boolean resymbolHasGL(final boolean hasGL) {
        return false;
    }
    private Tuple<ImArray<FontSymbolDesc>, Integer> buildSymbolArrayHasGLText(final boolean hasGL, final String text) {
        synchronized(this) {
            final Mut<Integer> newLines = new Mut<Integer>(0);
            ImArray<FontSymbolDesc> symbolsArr = new StringEx(text).chain().<FontSymbolDesc>mapOptF(((F<Character, FontSymbolDesc>)(((F)(new F<Character, FontSymbolDesc>() {
                @Override
                public FontSymbolDesc apply(final Character s) {
                    if(s == 10) {
                        newLines.value++;
                        return Font.newLineDesc;
                    } else {
                        return symbolOptSmb(s);
                    }
                }
            }))))).toArray();
            if(resymbolHasGL(hasGL)) {
                symbolsArr = new StringEx(text).chain().<FontSymbolDesc>mapOptF(((F<Character, FontSymbolDesc>)(((F)(new F<Character, FontSymbolDesc>() {
                    @Override
                    public FontSymbolDesc apply(final Character s) {
                        if(s == 10) {
                            return Font.newLineDesc;
                        } else {
                            return symbolOptSmb(s);
                        }
                    }
                }))))).toArray();
            }
            return new Tuple<ImArray<FontSymbolDesc>, Integer>(symbolsArr, newLines.value);
        }
    }
    public SimpleVertexArray<FontShaderParam> vaoTextAtAlignment(final String text, final vec3 at, final TextAlignment alignment) {
        final vec2 pos = vec2.addVec2(vec4.xy(Global.matrix.wcp().mulVec4(vec4.applyVec3W(at, ((float)(1))))), vec2.mulI(vec2.divVec2(alignment.shift, Global.context.scaledViewSize.value()), 2));
        final Tuple<ImArray<FontSymbolDesc>, Integer> pair = buildSymbolArrayHasGLText(true, text);
        final ImArray<FontSymbolDesc> symbolsArr = pair.a;
        final int newLines = pair.b;
        final int symbolsCount = symbolsArr.count() - newLines;
        final Pointer vertexes = new Pointer<FontPrintData>(FontPrintData.type, symbolsCount * 4);
        final Pointer indexes = new Pointer<Integer>(((PType<Integer>)(((PType)(UInt4.type)))), symbolsCount * 6);
        final vec2 vpSize = vec2i.divF(Global.context.viewport().size, 2.0);
        Pointer vp = vertexes;
        Pointer ip = indexes;
        int n = ((int)(0));
        MArray<Integer> linesWidth = new MArray<Integer>();
        Iterator<Integer> linesWidthIterator;
        float x = pos.x;
        if(alignment.x != -1) {
            int lineWidth = 0;
            {
                final Iterator<FontSymbolDesc> __il__14t_1i = symbolsArr.iterator();
                while(__il__14t_1i.hasNext()) {
                    final FontSymbolDesc s = __il__14t_1i.next();
                    if(s.isNewLine) {
                        linesWidth.appendItem(lineWidth);
                        lineWidth = 0;
                    } else {
                        lineWidth += ((int)(s.width));
                    }
                }
            }
            linesWidth.appendItem(lineWidth);
            linesWidthIterator = linesWidth.iterator();
            if(linesWidthIterator == null) {
                throw new NullPointerException();
            }
            x = pos.x - linesWidthIterator.next() / vpSize.x * (alignment.x / 2 + 0.5);
        }
        final float hh = ((float)(this.height())) / vpSize.y;
        float y = ((alignment.baseline) ? (pos.y + ((float)(this.size())) / vpSize.y) : (pos.y - hh * (newLines + 1) * (alignment.y / 2 - 0.5)));
        {
            final Iterator<FontSymbolDesc> __il__17i = symbolsArr.iterator();
            while(__il__17i.hasNext()) {
                final FontSymbolDesc s = __il__17i.next();
                if(s.isNewLine) {
                    if(linesWidthIterator == null) {
                        throw new NullPointerException();
                    }
                    x = ((alignment.x == -1) ? (pos.x) : (pos.x - linesWidthIterator.next() / vpSize.x * (alignment.x / 2 + 0.5)));
                    y -= hh;
                } else {
                    final vec2 size = vec2.divVec2(s.size, vpSize);
                    final Rect tr = s.textureRect;
                    final vec2 v0 = new vec2(x + s.offset.x / vpSize.x, y - s.offset.y / vpSize.y);
                    ERROR: Unknown <lm>vp\§^FontPrintData#S§*\-><fIUms>position\vec2#S\ = v0;
                    ERROR: Unknown <lm>vp\§^FontPrintData#S§*\-><fIUms>uv\vec2#S\ = tr.p;
                    vp++;
                    ERROR: Unknown <lm>vp\§^FontPrintData#S§*\-><fIUms>position\vec2#S\ = new vec2(v0.x, v0.y - size.y);
                    ERROR: Unknown <lm>vp\§^FontPrintData#S§*\-><fIUms>uv\vec2#S\ = Rect.ph(tr);
                    vp++;
                    ERROR: Unknown <lm>vp\§^FontPrintData#S§*\-><fIUms>position\vec2#S\ = new vec2(v0.x + size.x, v0.y - size.y);
                    ERROR: Unknown <lm>vp\§^FontPrintData#S§*\-><fIUms>uv\vec2#S\ = Rect.phw(tr);
                    vp++;
                    ERROR: Unknown <lm>vp\§^FontPrintData#S§*\-><fIUms>position\vec2#S\ = new vec2(v0.x + size.x, v0.y);
                    ERROR: Unknown <lm>vp\§^FontPrintData#S§*\-><fIUms>uv\vec2#S\ = Rect.pw(tr);
                    vp++;
                    ERROR: Unknown *((<lm>ip\§^uint4§*\ + 0)) = n;
                    ERROR: Unknown *((<lm>ip\§^uint4§*\ + 1)) = n + 1;
                    ERROR: Unknown *((<lm>ip\§^uint4§*\ + 2)) = n + 2;
                    ERROR: Unknown *((<lm>ip\§^uint4§*\ + 3)) = n + 2;
                    ERROR: Unknown *((<lm>ip\§^uint4§*\ + 4)) = n + 3;
                    ERROR: Unknown *((<lm>ip\§^uint4§*\ + 5)) = n;
                    ip += 6;
                    x += s.width / vpSize.x;
                    n += ((int)(4));
                }
            }
        }
        final VertexBuffer<FontPrintData> vb = VBO.<FontPrintData>applyDescArrayCount(Font.vbDesc, vertexes, ((int)(symbolsCount * 4)));
        final ImmutableIndexBuffer ib = IBO.applyPointerCount(indexes, ((int)(symbolsCount * 6)));
        Pointer.free(vertexes);
        Pointer.free(indexes);
        return FontShader.instance.vaoVboIbo(((VertexBuffer<Object>)(((VertexBuffer)(vb)))), ib);
    }
    public void drawTextAtAlignmentColor(final String text, final vec3 at, final TextAlignment alignment, final vec4 color) {
        final SimpleVertexArray<FontShaderParam> vao = vaoTextAtAlignment(text, at, alignment);
        {
            final CullFace __tmp__il__1self = Global.context.cullFace;
            {
                final int __il__1oldValue = __tmp__il__1self.disable();
                vao.drawParam(new FontShaderParam(this.texture(), color, new vec2(((float)(0)), ((float)(0)))));
                if(__il__1oldValue != GLES20.GL_NONE) {
                    __tmp__il__1self.setValue(__il__1oldValue);
                }
            }
        }
    }
    public Font beReadyForText(final String text) {
        new StringEx(text).chain().forEach(new P<Character>() {
            @Override
            public void apply(final Character s) {
                symbolOptSmb(s);
            }
        });
        return this;
    }
    public Font() {
        this.symbolsChanged = new Signal<Void>();
    }
    public String toString() {
        return "Font";
    }
    static {
        newLineDesc = new FontSymbolDesc(((float)(0)), new vec2(((float)(0)), ((float)(0))), new vec2(((float)(0)), ((float)(0))), Rect.applyXYWidthHeight(((float)(0)), ((float)(0)), ((float)(0)), ((float)(0))), true);
        zeroDesc = new FontSymbolDesc(((float)(0)), new vec2(((float)(0)), ((float)(0))), new vec2(((float)(0)), ((float)(0))), Rect.applyXYWidthHeight(((float)(0)), ((float)(0)), ((float)(0)), ((float)(0))), false);
        vbDesc = new VertexBufferDesc<FontPrintData>(FontPrintData.type, ((int)(0)), ((int)(2 * 4)), ((int)(-1)), ((int)(-1)), ((int)(-1)));
    }
}