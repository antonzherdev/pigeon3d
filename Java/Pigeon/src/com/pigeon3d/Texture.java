package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.geometry.vec2;
import com.pigeon3d.geometry.Rect;

public abstract class Texture {
    public abstract int id();
    public abstract vec2 size();
    public double scale() {
        return 1.0;
    }
    public vec2 scaledSize() {
        return vec2.divF(this.size(), this.scale());
    }
    @Override
    public void finalize() throws Throwable {
        super.finalize();
        this.deleteTexture();
    }
    public void deleteTexture() {
        Global.context.deleteTextureId(this.id());
    }
    public void saveToFile(final String file) {
        TextureService.egSaveTextureToFileSourceFile(this.id(), file);
    }
    public Rect uv() {
        return Rect.applyXYWidthHeight(((float)(0)), ((float)(0)), ((float)(1)), ((float)(1)));
    }
    public Rect uvRect(final Rect rect) {
        return Rect.divVec2(rect, this.scaledSize());
    }
    public Rect uvXYWidthHeight(final float x, final float y, final float width, final float height) {
        return uvRect(Rect.applyXYWidthHeight(x, y, width, height));
    }
    public TextureRegion regionXYWidthHeight(final float x, final float y, final double width, final float height) {
        return new TextureRegion(this, Rect.divVec2(Rect.applyXYWidthHeight(x, y, ((float)(width)), height), this.scaledSize()));
    }
    public ColorSource colorSource() {
        return ColorSource.applyTexture(this);
    }
    public Texture() {
    }
    public String toString() {
        return "Texture";
    }
}