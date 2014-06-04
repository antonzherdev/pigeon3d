package com.pigeon3d;

import objd.lang.*;
import objd.react.React;
import com.pigeon3d.geometry.vec3;
import com.pigeon3d.geometry.Rect;
import objd.react.ReactFlag;
import objd.react.Signal;
import com.pigeon3d.geometry.vec2;
import com.pigeon3d.geometry.Quad;
import android.opengl.GLES20;
import com.pigeon3d.geometry.vec4;
import objd.react.Observable;
import objd.collection.ImArray;

public class Sprite {
    public static final VertexBufferDesc<BillboardBufferData> vbDesc;
    public final React<Boolean> visible;
    public final React<ColorSource> material;
    public final React<vec3> position;
    public final React<Rect> rect;
    private final MutableVertexBuffer<BillboardBufferData> vb;
    private VertexArray<ColorSource> vao;
    private ReactFlag _changed;
    private ReactFlag _materialChanged;
    public final Signal<Void> tap;
    public static Sprite applyVisibleMaterialPositionAnchor(final React<Boolean> visible, final React<ColorSource> material, final React<vec3> position, final vec2 anchor) {
        return new Sprite(visible, material, position, Sprite.rectReactMaterialAnchor(material, anchor));
    }
    public static Sprite applyMaterialPositionAnchor(final React<ColorSource> material, final React<vec3> position, final vec2 anchor) {
        return Sprite.applyVisibleMaterialPositionAnchor(React.applyValue(true), material, position, anchor);
    }
    public static React<Rect> rectReactMaterialAnchor(final React<ColorSource> material, final vec2 anchor) {
        return material.<Rect>mapF(new F<ColorSource, Rect>() {
            @Override
            public Rect apply(final ColorSource m) {
                {
                    final Texture __tmpr_0aln = m.texture;
                    if(__tmpr_0aln == null) {
                        throw new NullPointerException();
                    }
                    final vec2 s = vec2.divF(__tmpr_0aln.size(), Director.current().scale());
                    return new Rect(vec2.mulVec2(s, vec2.divI(vec2.addI(anchor, 1), -2)), s);
                }
            }
        });
    }
    public void draw() {
        if(!(this.visible.value())) {
            return ;
        }
        if(this._materialChanged.value()) {
            this.vao = new Mesh(((VertexBuffer<Object>)(((VertexBuffer)(this.vb)))), EmptyIndexSource.triangleStrip).<ColorSource>vaoShaderSystemMaterialShadow(((ShaderSystem<ColorSource>)(((ShaderSystem)(BillboardShaderSystem.projectionSpace)))), this.material.value(), false);
            this._materialChanged.clear();
        }
        if(this._changed.value()) {
            final Pointer vertexes = new Pointer<BillboardBufferData>(BillboardBufferData.type, ((int)(4)));
            final ColorSource m = this.material.value();
            {
                final vec3 __tmp__il__2t_2at = this.position.value();
                final Quad __tmp__il__2t_2quad = Rect.stripQuad(Rect.mulF(Rect.divVec2(this.rect.value(), Global.context.scaledViewSize.value()), ((double)(2))));
                final Texture __tmp_2t_2rp4l = m.texture;
                final Quad __tmp__il__2t_2uv = Rect.upsideDownStripQuad(((__tmp_2t_2rp4l != null) ? (m.texture.uv()) : (Rect.applyXYWidthHeight(((float)(0)), ((float)(0)), ((float)(1)), ((float)(1))))));
                {
                    Pointer __il__2t_2v = vertexes;
                    ERROR: Unknown <lm>__il__2t_2v\BillboardBufferData#S*\-><fIUms>position\vec3#S\ = __tmp__il__2t_2at;
                    ERROR: Unknown <lm>__il__2t_2v\BillboardBufferData#S*\-><fIUms>model\vec2#S\ = __tmp__il__2t_2quad.p0;
                    ERROR: Unknown <lm>__il__2t_2v\BillboardBufferData#S*\-><fIUms>color\vec4#S\ = m.color;
                    ERROR: Unknown <lm>__il__2t_2v\BillboardBufferData#S*\-><fIUms>uv\vec2#S\ = __tmp__il__2t_2uv.p0;
                    __il__2t_2v++;
                    ERROR: Unknown <lm>__il__2t_2v\BillboardBufferData#S*\-><fIUms>position\vec3#S\ = __tmp__il__2t_2at;
                    ERROR: Unknown <lm>__il__2t_2v\BillboardBufferData#S*\-><fIUms>model\vec2#S\ = __tmp__il__2t_2quad.p1;
                    ERROR: Unknown <lm>__il__2t_2v\BillboardBufferData#S*\-><fIUms>color\vec4#S\ = m.color;
                    ERROR: Unknown <lm>__il__2t_2v\BillboardBufferData#S*\-><fIUms>uv\vec2#S\ = __tmp__il__2t_2uv.p1;
                    __il__2t_2v++;
                    ERROR: Unknown <lm>__il__2t_2v\BillboardBufferData#S*\-><fIUms>position\vec3#S\ = __tmp__il__2t_2at;
                    ERROR: Unknown <lm>__il__2t_2v\BillboardBufferData#S*\-><fIUms>model\vec2#S\ = __tmp__il__2t_2quad.p2;
                    ERROR: Unknown <lm>__il__2t_2v\BillboardBufferData#S*\-><fIUms>color\vec4#S\ = m.color;
                    ERROR: Unknown <lm>__il__2t_2v\BillboardBufferData#S*\-><fIUms>uv\vec2#S\ = __tmp__il__2t_2uv.p2;
                    __il__2t_2v++;
                    ERROR: Unknown <lm>__il__2t_2v\BillboardBufferData#S*\-><fIUms>position\vec3#S\ = __tmp__il__2t_2at;
                    ERROR: Unknown <lm>__il__2t_2v\BillboardBufferData#S*\-><fIUms>model\vec2#S\ = __tmp__il__2t_2quad.p3;
                    ERROR: Unknown <lm>__il__2t_2v\BillboardBufferData#S*\-><fIUms>color\vec4#S\ = m.color;
                    ERROR: Unknown <lm>__il__2t_2v\BillboardBufferData#S*\-><fIUms>uv\vec2#S\ = __tmp__il__2t_2uv.p3;
                    return __il__2t_2v + 1;
                }
            }
            this.vb.setArrayCount(vertexes, ((int)(4)));
            Pointer.free(vertexes);
            this._changed.clear();
        }
        {
            final CullFace __tmp__il__3self = Global.context.cullFace;
            {
                final int __il__3oldValue = __tmp__il__3self.disable();
                if(this.vao != null) {
                    this.vao.draw();
                }
                if(__il__3oldValue != GLES20.GL_NONE) {
                    __tmp__il__3self.setValue(__il__3oldValue);
                }
            }
        }
    }
    public Rect rectInViewport() {
        final vec4 pp = Global.matrix.value().wcp().mulVec4(vec4.applyVec3W(this.position.value(), ((float)(1))));
        return Rect.addVec2(Rect.mulF(Rect.divVec2(this.rect.value(), Global.context.scaledViewSize.value()), ((double)(2))), vec4.xy(pp));
    }
    public boolean containsViewportVec2(final vec2 vec2) {
        return this.visible.value() && Rect.containsVec2(this.rectInViewport(), vec2);
    }
    public boolean tapEvent(final Event event) {
        if(containsViewportVec2(event.locationInViewport())) {
            this.tap.post();
            return true;
        } else {
            return false;
        }
    }
    public Recognizer<Void> recognizer() {
        return Recognizer.<Void>applyTpOn(((RecognizerType<ShortRecognizer, Void>)(((RecognizerType)(Tap.apply())))), new F<Event<Void>, Boolean>() {
            @Override
            public Boolean apply(final Event<Void> _) {
                return tapEvent(((Event)(_)));
            }
        });
    }
    public Sprite(final React<Boolean> visible, final React<ColorSource> material, final React<vec3> position, final React<Rect> rect) {
        this.visible = visible;
        this.material = material;
        this.position = position;
        this.rect = rect;
        this.vb = VBO.<BillboardBufferData>mutDescUsage(Sprite.vbDesc, GLES20.GL_DYNAMIC_DRAW);
        this._changed = new ReactFlag(true, ImArray.fromObjects(((Observable<Object>)(((Observable)(((React<Object>)(((React)(material.<Texture>mapF(new F<ColorSource, Texture>() {
            @Override
            public Texture apply(final ColorSource _) {
                return _.texture;
            }
        }))))))))), ((Observable<Object>)(((Observable)(((React<Object>)(((React)(position)))))))), ((Observable<Object>)(((Observable)(((React<Object>)(((React)(rect)))))))), ((Observable<Object>)(((Observable)(((React<Object>)(((React)(Global.context.viewSize))))))))));
        this._materialChanged = new ReactFlag(true, ImArray.fromObjects(((Observable<Object>)(((Observable)(material))))));
        this.tap = new Signal<Void>();
    }
    static public Sprite applyVisibleMaterialPosition(final React<Boolean> visible, final React<ColorSource> material, final React<vec3> position) {
        return new Sprite(visible, material, position, Sprite.rectReactMaterialAnchor(material, new vec2(((float)(0)), ((float)(0)))));
    }
    static public Sprite applyMaterialPositionRect(final React<ColorSource> material, final React<vec3> position, final React<Rect> rect) {
        return new Sprite(React.applyValue(true), material, position, rect);
    }
    static public Sprite applyMaterialPosition(final React<ColorSource> material, final React<vec3> position) {
        return new Sprite(React.applyValue(true), material, position, Sprite.rectReactMaterialAnchor(material, new vec2(((float)(0)), ((float)(0)))));
    }
    public String toString() {
        return String.format("Sprite(%s, %s, %s, %s)", this.visible, this.material, this.position, this.rect);
    }
    static {
        vbDesc = new VertexBufferDesc<BillboardBufferData>(BillboardBufferData.type, ((int)(0)), ((int)(9 * 4)), ((int)(-1)), ((int)(5 * 4)), ((int)(3 * 4)));
    }
}