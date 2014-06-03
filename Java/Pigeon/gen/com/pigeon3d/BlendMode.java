package com.pigeon3d;

import objd.lang.*;

public enum BlendMode {
    first(new F2<String, String, String>() {
        @Override
        public String apply(final String a, final String b) {
            return a;
        }
    }),
    second(new F2<String, String, String>() {
        @Override
        public String apply(final String a, final String b) {
            return b;
        }
    }),
    multiply(new F2<String, String, String>() {
        @Override
        public String apply(final String a, final String b) {
            return String.format("%s * %s", a, b);
        }
    }),
    darken(new F2<String, String, String>() {
        @Override
        public String apply(final String a, final String b) {
            return String.format("min(%s, %s)", a, b);
        }
    });
    private BlendMode(final F2<String, String, String> blend) {
        this.blend = blend;
    }
    public final F2<String, String, String> blend;
}