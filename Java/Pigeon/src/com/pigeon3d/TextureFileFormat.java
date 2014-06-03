package com.pigeon3d;

import objd.lang.*;

public enum TextureFileFormat {
    PNG("png"),
    JPEG("jpg"),
    compressed("?");
    private TextureFileFormat(final String extension) {
        this.extension = extension;
    }
    public final String extension;
}