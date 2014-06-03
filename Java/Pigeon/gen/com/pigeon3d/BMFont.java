package com.pigeon3d;

import objd.lang.*;
import objd.collection.Map;
import objd.collection.MHashMap;
import com.pigeon3d.geometry.vec2;
import objd.collection.Iterator;
import objd.collection.ImHashMap;
import com.pigeon3d.geometry.vec2i;
import com.pigeon3d.geometry.Rect;
import objd.collection.ImArray;

public final class BMFont extends Font {
    public final String name;
    public final FileTexture texture;
    @Override
    public FileTexture texture() {
        return texture;
    }
    private final Map<Character, FontSymbolDesc> symbols;
    public final int height;
    @Override
    public int height() {
        return height;
    }
    public final int size;
    @Override
    public int size() {
        return size;
    }
    public void init() {
        final MHashMap<Character, FontSymbolDesc> charMap = new MHashMap<Character, FontSymbolDesc>();
        final vec2 ts = this.texture.size();
        this.height = ((int)(1));
        this.size = ((int)(1));
        {
            final Iterator<String> __il__4i = new StringEx(Bundle.readToStringResource(String.format("%s.fnt", this.name))).splitBy("\n").iterator();
            while(__il__4i.hasNext()) {
                final String line = __il__4i.next();
                {
                    final Tuple<String, String> t = new StringEx(line).tupleBy(" ");
                    if(t != null) {
                        final String name = t.a;
                        final ImHashMap<String, String> map = new StringEx(t.b).splitBy(" ").chain().<Tuple<String, String>>mapOptF(((F<String, Tuple<String, String>>)(((F)(new F<String, Tuple<String, String>>() {
                            @Override
                            public Tuple<String, String> apply(final String _) {
                                return new StringEx(_).tupleBy("=");
                            }
                        }))))).<String, String>toMap();
                        if(name.equals("info")) {
                            final String __tmp_4r_2t_0ln = map.applyKey("size");
                            if(__tmp_4r_2t_0ln == null) {
                                throw new NullPointerException();
                            }
                            this.size = new StringEx(__tmp_4r_2t_0ln).toUInt();
                        } else {
                            if(name.equals("common")) {
                                final String __tmp_4r_2ft_0ln = map.applyKey("lineHeight");
                                if(__tmp_4r_2ft_0ln == null) {
                                    throw new NullPointerException();
                                }
                                this.height = new StringEx(__tmp_4r_2ft_0ln).toUInt();
                            } else {
                                if(name.equals("char")) {
                                    final String __tmp_4r_2fft_0lln = map.applyKey("id");
                                    if(__tmp_4r_2fft_0lln == null) {
                                        throw new NullPointerException();
                                    }
                                    final char code = ((char)(new StringEx(__tmp_4r_2fft_0lln).toInt()));
                                    final String __tmp_4r_2fft_1ln = map.applyKey("xadvance");
                                    if(__tmp_4r_2fft_1ln == null) {
                                        throw new NullPointerException();
                                    }
                                    final float width = ((float)(new StringEx(__tmp_4r_2fft_1ln).toFloat()));
                                    final String __tmp_4r_2fft_2p0ln = map.applyKey("xoffset");
                                    if(__tmp_4r_2fft_2p0ln == null) {
                                        throw new NullPointerException();
                                    }
                                    final String __tmp_4r_2fft_2p1ln = map.applyKey("yoffset");
                                    if(__tmp_4r_2fft_2p1ln == null) {
                                        throw new NullPointerException();
                                    }
                                    final vec2i offset = new vec2i(new StringEx(__tmp_4r_2fft_2p0ln).toInt(), new StringEx(__tmp_4r_2fft_2p1ln).toInt());
                                    final String __tmp_4r_2fft_3p0ln = map.applyKey("x");
                                    if(__tmp_4r_2fft_3p0ln == null) {
                                        throw new NullPointerException();
                                    }
                                    final String __tmp_4r_2fft_3p1ln = map.applyKey("y");
                                    if(__tmp_4r_2fft_3p1ln == null) {
                                        throw new NullPointerException();
                                    }
                                    final String __tmp_4r_2fft_3p2ln = map.applyKey("width");
                                    if(__tmp_4r_2fft_3p2ln == null) {
                                        throw new NullPointerException();
                                    }
                                    final String __tmp_4r_2fft_3p3ln = map.applyKey("height");
                                    if(__tmp_4r_2fft_3p3ln == null) {
                                        throw new NullPointerException();
                                    }
                                    final Rect r = Rect.applyXYWidthHeight(((float)(new StringEx(__tmp_4r_2fft_3p0ln).toFloat())), ((float)(new StringEx(__tmp_4r_2fft_3p1ln).toFloat())), ((float)(new StringEx(__tmp_4r_2fft_3p2ln).toFloat())), ((float)(new StringEx(__tmp_4r_2fft_3p3ln).toFloat())));
                                    charMap.setKeyValue(code, new FontSymbolDesc(width, vec2.applyVec2i(offset), r.size, Rect.divVec2(r, ts), false));
                                }
                            }
                        }
                    }
                }
            }
        }
        this.symbols = charMap;
    }
    private Rect parse_rect(final String _rect) {
        final ImArray<String> parts = new StringEx(_rect).splitBy(" ").chain().toArray();
        final double y = new StringEx(parts[1]).toFloat();
        final double h = new StringEx(parts[3]).toFloat();
        return Rect.applyXYWidthHeight(((float)(new StringEx(parts[0]).toFloat())), ((float)(y)), ((float)(new StringEx(parts[2]).toFloat())), ((float)(h)));
    }
    @Override
    public FontSymbolDesc symbolOptSmb(final char smb) {
        return this.symbols.applyKey(smb);
    }
    public BMFont(final String name) {
        this.name = name;
        this.texture = new FileTexture(name, TextureFileFormat.PNG, TextureFormat.RGBA8, 1.0, TextureFilter.nearest);
    }
    public String toString() {
        return String.format("BMFont(%s)", this.name);
    }
    public boolean equals(final Object to) {
        if(this == to) {
            return true;
        }
        if(to == null || !(to instanceof BMFont)) {
            return false;
        }
        final BMFont o = ((BMFont)(to));
        return this.name.equals(o.name);
    }
    public int hashCode() {
        int hash = 0;
        hash = hash * 31 + new StringEx(this.name).hashCode();
        return hash;
    }
}