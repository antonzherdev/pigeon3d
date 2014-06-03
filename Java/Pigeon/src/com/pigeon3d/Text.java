package com.pigeon3d;

import objd.lang.*;
import objd.react.React;
import com.pigeon3d.geometry.vec3;
import com.pigeon3d.geometry.vec4;
import objd.react.ReactFlag;
import objd.react.Observer;
import com.pigeon3d.geometry.vec2;
import objd.react.Observable;
import objd.collection.ImArray;
import objd.concurrent.DispatchQueue;

public class Text {
    public final React<Boolean> visible;
    public final React<Font> font;
    public final React<String> text;
    public final React<vec3> position;
    public final React<TextAlignment> alignment;
    public final React<vec4> color;
    public final React<TextShadow> shadow;
    private final ReactFlag _changed;
    private final React<Observer<Void>> fontObserver;
    private SimpleVertexArray<FontShaderParam> _vao;
    private final React<Boolean> isEmpty;
    public React<vec2> sizeInPoints() {
        return _lazy_sizeInPoints.get();
    }
    private final Lazy<React<vec2>> _lazy_sizeInPoints;
    public React<vec2> sizeInP() {
        return _lazy_sizeInP.get();
    }
    private final Lazy<React<vec2>> _lazy_sizeInP;
    public void draw() {
        if(!(this.visible.value()) || this.isEmpty.value()) {
            return ;
        }
        if(this._changed.value()) {
            this._vao = this.font.value().vaoTextAtAlignment(this.text.value(), this.position.value(), this.alignment.value());
            this._changed.clear();
        }
        {
            final TextShadow sh = this.shadow.value();
            if(sh != null) {
                if(this._vao != null) {
                    this._vao.drawParam(new FontShaderParam(this.font.value().texture(), vec4.mulK(sh.color, this.color.value().w), sh.shift));
                }
            }
        }
        if(this._vao != null) {
            this._vao.drawParam(new FontShaderParam(this.font.value().texture(), this.color.value(), new vec2(((float)(0)), ((float)(0)))));
        }
    }
    public vec2 measureInPoints() {
        return this.font.value().measureInPointsText(this.text.value());
    }
    public vec2 measureP() {
        return this.font.value().measurePText(this.text.value());
    }
    public vec2 measureC() {
        return this.font.value().measureCText(this.text.value());
    }
    public Text(final React<Boolean> visible, final React<Font> font, final React<String> text, final React<vec3> position, final React<TextAlignment> alignment, final React<vec4> color, final React<TextShadow> shadow) {
        this.visible = visible;
        this.font = font;
        this.text = text;
        this.position = position;
        this.alignment = alignment;
        this.color = color;
        this.shadow = shadow;
        this._changed = new ReactFlag(true, ImArray.fromObjects(((Observable<Object>)(((Observable)(((React<Object>)(((React)(font)))))))), ((Observable<Object>)(((Observable)(((React<Object>)(((React)(text)))))))), ((Observable<Object>)(((Observable)(((React<Object>)(((React)(position)))))))), ((Observable<Object>)(((Observable)(((React<Object>)(((React)(alignment)))))))), ((Observable<Object>)(((Observable)(((React<Object>)(((React)(shadow)))))))), ((Observable<Object>)(((Observable)(((React<Object>)(((React)(Global.context.viewSize))))))))));
        this.fontObserver = font.<Observer<Void>>mapF(new F<Font, Observer<Void>>() {
            @Override
            public Observer<Void> apply(final Font newFont) {
                return newFont.symbolsChanged.observeF(new P<Void>() {
                    @Override
                    public void apply(final Void _) {
                        Text.this._changed.set();
                    }
                });
            }
        });
        this.isEmpty = text.<Boolean>mapF(new F<String, Boolean>() {
            @Override
            public Boolean apply(final String _) {
                return new StringEx(_).isEmpty();
            }
        });
        this._lazy_sizeInPoints = new Lazy(new F0<React<vec2>>() {
            @Override
            public React<vec2> apply() {
                return React.<Font, String, vec2>asyncQueueABF(DispatchQueue.mainThread, font, text, new F2<Font, String, vec2>() {
                    @Override
                    public vec2 apply(final Font f, final String t) {
                        return f.measureInPointsText(t);
                    }
                });
            }
        });
        this._lazy_sizeInP = new Lazy(new F0<React<vec2>>() {
            @Override
            public React<vec2> apply() {
                return React.<vec2, vec2, vec2>asyncQueueABF(DispatchQueue.mainThread, Text.this.sizeInPoints(), Global.context.scaledViewSize, new F2<vec2, vec2, vec2>() {
                    @Override
                    public vec2 apply(final vec2 s, final vec2 vs) {
                        return vec2.divVec2(vec2.mulI(s, 2), vs);
                    }
                });
            }
        });
    }
    static public Text applyVisibleFontTextPositionAlignmentColor(final React<Boolean> visible, final React<Font> font, final React<String> text, final React<vec3> position, final React<TextAlignment> alignment, final React<vec4> color) {
        return new Text(visible, font, text, position, alignment, color, React.applyValue(null));
    }
    static public Text applyFontTextPositionAlignmentColorShadow(final React<Font> font, final React<String> text, final React<vec3> position, final React<TextAlignment> alignment, final React<vec4> color, final React<TextShadow> shadow) {
        return new Text(React.applyValue(true), font, text, position, alignment, color, shadow);
    }
    static public Text applyFontTextPositionAlignmentColor(final React<Font> font, final React<String> text, final React<vec3> position, final React<TextAlignment> alignment, final React<vec4> color) {
        return new Text(React.applyValue(true), font, text, position, alignment, color, React.applyValue(null));
    }
    public String toString() {
        return String.format("Text(%s, %s, %s, %s, %s, %s, %s)", this.visible, this.font, this.text, this.position, this.alignment, this.color, this.shadow);
    }
}