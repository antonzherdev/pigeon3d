package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.geometry.vec2;
import com.pigeon3d.gl.eg;

public final class FileTexture extends Texture {
    public final String name;
    public final TextureFileFormat fileFormat;
    public final TextureFormat format;
    public final double scale;
    @Override
    public double scale() {
        return scale;
    }
    public final TextureFilter filter;
    public final int id;
    @Override
    public int id() {
        return id;
    }
    private vec2 _size;
    public void init() {
        this._size = TextureService.egLoadTextureFromFileTargetFileFileFormatScaleFormatFilter(this.id, this.name, this.fileFormat, this.scale, this.format, this.filter);
    }
    @Override
    public vec2 size() {
        return this._size;
    }
    public FileTexture(final String name, final TextureFileFormat fileFormat, final TextureFormat format, final double scale, final TextureFilter filter) {
        this.name = name;
        this.fileFormat = fileFormat;
        this.format = format;
        this.scale = scale;
        this.filter = filter;
        this.id = eg.egGenTexture();
    }
    public String toString() {
        return String.format("FileTexture(%s, %s, %s, %f, %s)", this.name, this.fileFormat, this.format, this.scale, this.filter);
    }
    public boolean equals(final Object to) {
        if(this == to) {
            return true;
        }
        if(to == null || !(to instanceof FileTexture)) {
            return false;
        }
        final FileTexture o = ((FileTexture)(to));
        return this.name.equals(o.name) && this.fileFormat == o.fileFormat && this.format == o.format && this.scale.equals(o.scale) && this.filter == o.filter;
    }
    public int hashCode() {
        int hash = 0;
        hash = hash * 31 + new StringEx(this.name).hashCode();
        hash = hash * 31 + this.fileFormat.hashCode();
        hash = hash * 31 + this.format.hashCode();
        hash = hash * 31 + Float.hashCode(this.scale);
        hash = hash * 31 + this.filter.hashCode();
        return hash;
    }
}