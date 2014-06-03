package com.pigeon3d;

import objd.lang.*;

public class Global {
    public static final Context context;
    public static final Settings settings;
    public static final MatrixStack matrix;
    public static Texture compressedTextureForFile(final String file) {
        return Global.context.textureForNameFileFormatFormatScaleFilter(file, TextureFileFormat.compressed, TextureFormat.RGBA8, 1.0, TextureFilter.linear);
    }
    public static Texture compressedTextureForFileFilter(final String file, final TextureFilter filter) {
        return Global.context.textureForNameFileFormatFormatScaleFilter(file, TextureFileFormat.compressed, TextureFormat.RGBA8, 1.0, filter);
    }
    public static Texture textureForFileFileFormatFormatFilter(final String file, final TextureFileFormat fileFormat, final TextureFormat format, final TextureFilter filter) {
        return Global.context.textureForNameFileFormatFormatScaleFilter(file, fileFormat, format, 1.0, filter);
    }
    public static Texture textureForFileFileFormatFormat(final String file, final TextureFileFormat fileFormat, final TextureFormat format) {
        return Global.textureForFileFileFormatFormatFilter(file, fileFormat, format, TextureFilter.linear);
    }
    public static Texture textureForFileFileFormatFilter(final String file, final TextureFileFormat fileFormat, final TextureFilter filter) {
        return Global.textureForFileFileFormatFormatFilter(file, fileFormat, TextureFormat.RGBA8, filter);
    }
    public static Texture textureForFileFileFormat(final String file, final TextureFileFormat fileFormat) {
        return Global.textureForFileFileFormatFormatFilter(file, fileFormat, TextureFormat.RGBA8, TextureFilter.linear);
    }
    public static Texture textureForFileFormatFilter(final String file, final TextureFormat format, final TextureFilter filter) {
        return Global.textureForFileFileFormatFormatFilter(file, TextureFileFormat.PNG, format, filter);
    }
    public static Texture textureForFileFormat(final String file, final TextureFormat format) {
        return Global.textureForFileFileFormatFormatFilter(file, TextureFileFormat.PNG, format, TextureFilter.linear);
    }
    public static Texture textureForFileFilter(final String file, final TextureFilter filter) {
        return Global.textureForFileFileFormatFormatFilter(file, TextureFileFormat.PNG, TextureFormat.RGBA8, filter);
    }
    public static Texture textureForFile(final String file) {
        return Global.textureForFileFileFormatFormatFilter(file, TextureFileFormat.PNG, TextureFormat.RGBA8, TextureFilter.linear);
    }
    public static Texture scaledTextureForNameFileFormatFormat(final String name, final TextureFileFormat fileFormat, final TextureFormat format) {
        return Global.context.textureForNameFileFormatFormatScaleFilter(name, fileFormat, format, Director.current().scale(), TextureFilter.nearest);
    }
    public static Texture scaledTextureForNameFileFormat(final String name, final TextureFileFormat fileFormat) {
        return Global.scaledTextureForNameFileFormatFormat(name, fileFormat, TextureFormat.RGBA8);
    }
    public static Texture scaledTextureForNameFormat(final String name, final TextureFormat format) {
        return Global.scaledTextureForNameFileFormatFormat(name, TextureFileFormat.PNG, format);
    }
    public static Texture scaledTextureForName(final String name) {
        return Global.scaledTextureForNameFileFormatFormat(name, TextureFileFormat.PNG, TextureFormat.RGBA8);
    }
    public static Font fontWithName(final String name) {
        return Global.context.fontWithName(name);
    }
    public static Font fontWithNameSize(final String name, final int size) {
        return Global.context.fontWithNameSize(name, size);
    }
    public static Font mainFontWithSize(final int size) {
        return Global.context.mainFontWithSize(size);
    }
    static {
        context = new Context();
        settings = new Settings();
        matrix = Global.context.matrixStack;
    }
}