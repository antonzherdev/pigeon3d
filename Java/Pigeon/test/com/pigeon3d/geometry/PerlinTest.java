package com.pigeon3d.geometry;

import objd.lang.*;
import objd.collection.ImArray;
import objd.collection.Iterator;
import objd.test.PackageObjectTest;
import org.junit.Test;
import objd.test.TestCase;

public class PerlinTest extends TestCase {
    @Test
    public void testMain() {
        final Perlin1 noise = new Perlin1(((int)(2)), ((double)(10)), ((double)(1)));
        final ImArray<Float> a = Int.to(1, 100).chain().<Float>mapF(new F<Integer, Float>() {
            @Override
            public Float apply(final Integer i) {
                return noise.applyX(i / 100.0);
            }
        }).toArray();
        {
            final Iterator<Float> __il__2i = a.iterator();
            while(__il__2i.hasNext()) {
                final Float v = __il__2i.next();
                PackageObjectTest.assertTrueValue(Float.between(v, ((double)(-1)), ((double)(1))));
            }
        }
        final double s = a.chain().<Float>foldStartBy(0.0, new F2<Float, Float, Float>() {
            @Override
            public Float apply(final Float r, final Float i) {
                return r + i;
            }
        });
        PackageObjectTest.assertTrueValue(s != 0);
    }
    public PerlinTest() {
    }
    public String toString() {
        return "PerlinTest";
    }
}