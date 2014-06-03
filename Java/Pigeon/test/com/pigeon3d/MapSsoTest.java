package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.geometry.vec2i;
import objd.test.PackageObjectTest;
import org.junit.Test;
import objd.collection.Set;
import objd.collection.ImArray;
import objd.test.TestCase;

public class MapSsoTest extends TestCase {
    @Test
    public void testFullPartialTile() {
        final MapSso map = new MapSso(new vec2i(2, 3));
        PackageObjectTest.assertTrueValue(map.isFullTile(new vec2i(0, 2)));
        PackageObjectTest.assertTrueValue(map.isFullTile(new vec2i(1, 0)));
        PackageObjectTest.assertTrueValue(map.isFullTile(new vec2i(-1, 1)));
        PackageObjectTest.assertFalseValue(map.isFullTile(new vec2i(-1, 0)));
        PackageObjectTest.assertTrueValue(map.isPartialTile(new vec2i(-1, 0)));
        PackageObjectTest.assertFalseValue(map.isFullTile(new vec2i(-2, 1)));
        PackageObjectTest.assertTrueValue(map.isPartialTile(new vec2i(-2, 1)));
        PackageObjectTest.assertFalseValue(map.isFullTile(new vec2i(-3, 1)));
        PackageObjectTest.assertFalseValue(map.isPartialTile(new vec2i(-3, 1)));
    }
    @Test
    public void testFullTiles() {
        final MapSso map = new MapSso(new vec2i(2, 3));
        final Set<Tuple<Integer, Integer>> exp = ImArray.fromObjects(new Tuple<Integer, Integer>(-1, 1), new Tuple<Integer, Integer>(0, 0), new Tuple<Integer, Integer>(0, 1), new Tuple<Integer, Integer>(0, 2), new Tuple<Integer, Integer>(1, 0), new Tuple<Integer, Integer>(1, 1), new Tuple<Integer, Integer>(1, 2), new Tuple<Integer, Integer>(2, 1)).chain().toSet();
        final Set<Tuple<Integer, Integer>> tiles = map.fullTiles.chain().<Tuple<Integer, Integer>>mapF(new F<vec2i, Tuple<Integer, Integer>>() {
            @Override
            public Tuple<Integer, Integer> apply(final vec2i v) {
                return new Tuple<Integer, Integer>(v.x, v.y);
            }
        }).toSet();
        PackageObjectTest.<Set<Tuple<Integer, Integer>>>assertEqualsAB(exp, tiles);
    }
    @Test
    public void testPartialTiles() {
        final MapSso map = new MapSso(new vec2i(2, 3));
        final Set<Tuple<Integer, Integer>> exp = ImArray.fromObjects(new Tuple<Integer, Integer>(-2, 1), new Tuple<Integer, Integer>(-1, 0), new Tuple<Integer, Integer>(-1, 2), new Tuple<Integer, Integer>(0, -1), new Tuple<Integer, Integer>(0, 3), new Tuple<Integer, Integer>(1, -1), new Tuple<Integer, Integer>(1, 3), new Tuple<Integer, Integer>(2, 0), new Tuple<Integer, Integer>(2, 2), new Tuple<Integer, Integer>(3, 1)).chain().toSet();
        final Set<Tuple<Integer, Integer>> tiles = map.partialTiles.chain().<Tuple<Integer, Integer>>mapF(new F<vec2i, Tuple<Integer, Integer>>() {
            @Override
            public Tuple<Integer, Integer> apply(final vec2i v) {
                return new Tuple<Integer, Integer>(v.x, v.y);
            }
        }).toSet();
        PackageObjectTest.<Set<Tuple<Integer, Integer>>>assertEqualsAB(exp, tiles);
    }
    public MapSsoTest() {
    }
    public String toString() {
        return "MapSsoTest";
    }
}