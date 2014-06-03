package com.pigeon3d;

import objd.lang.*;
import objd.react.Signal;
import com.pigeon3d.geometry.Rect;
import objd.react.React;
import com.pigeon3d.geometry.vec4;
import com.pigeon3d.geometry.vec3;

public class Button {
    public final Sprite sprite;
    public final Text text;
    public Signal<Void> tap() {
        return this.sprite.tap;
    }
    public void draw() {
        this.sprite.draw();
        this.text.draw();
    }
    public boolean tapEvent(final Event event) {
        return this.sprite.tapEvent(event);
    }
    public static Button applyVisibleFontTextTextColorBackgroundMaterialPositionRect(final React<Boolean> visible, final React<Font> font, final React<String> text, final React<vec4> textColor, final React<ColorSource> backgroundMaterial, final React<vec3> position, final React<Rect> rect) {
        return new Button(new Sprite(visible, backgroundMaterial, position, rect), Text.applyVisibleFontTextPositionAlignmentColor(visible, font, text, position, rect.<TextAlignment>mapF(new F<Rect, TextAlignment>() {
            @Override
            public TextAlignment apply(final Rect r) {
                return new TextAlignment(((float)(0)), ((float)(0)), false, Rect.center(r));
            }
        }), textColor));
    }
    public static Button applyFontTextTextColorBackgroundMaterialPositionRect(final React<Font> font, final React<String> text, final React<vec4> textColor, final React<ColorSource> backgroundMaterial, final React<vec3> position, final React<Rect> rect) {
        return Button.applyVisibleFontTextTextColorBackgroundMaterialPositionRect(React.applyValue(true), font, text, textColor, backgroundMaterial, position, rect);
    }
    public Button(final Sprite sprite, final Text text) {
        this.sprite = sprite;
        this.text = text;
    }
    public String toString() {
        return String.format("Button(%s, %s)", this.sprite, this.text);
    }
}