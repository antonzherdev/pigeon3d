package com.pigeon3d.geometry;

import objd.lang.*;
import objd.collection.Set;
import objd.collection.ImArray;
import objd.collection.Pair;
import objd.test.PackageObjectTest;
import org.junit.Test;
import objd.test.TestCase;

public class BentleyOttmannTest extends TestCase {
    @Test
    public void testMain() {
        final Set<Intersection<Integer>> r = BentleyOttmann.<Integer>intersectionsForSegments(ImArray.fromObjects(new Tuple<Integer, LineSegment>(1, LineSegment.newWithX1Y1X2Y2(((double)(-1)), ((double)(-1)), ((double)(2)), ((double)(2)))), new Tuple<Integer, LineSegment>(2, LineSegment.newWithX1Y1X2Y2(((double)(-2)), ((double)(1)), ((double)(2)), ((double)(1)))), new Tuple<Integer, LineSegment>(3, LineSegment.newWithX1Y1X2Y2(((double)(-2)), ((double)(2)), ((double)(1)), ((double)(-1))))));
        final Set<Intersection<Integer>> e = ImArray.fromObjects(new Intersection<Integer>(new Pair<Integer>(1, 2), new vec2(((float)(1)), ((float)(1)))), new Intersection<Integer>(new Pair<Integer>(1, 3), new vec2(((float)(0)), ((float)(0)))), new Intersection<Integer>(new Pair<Integer>(2, 3), new vec2(((float)(-1)), ((float)(1))))).toSet();
        PackageObjectTest.<Set<Intersection<Integer>>>assertEqualsAB(e, r);
    }
    @Test
    public void testInPoint() {
        Set<Intersection<Integer>> r = BentleyOttmann.<Integer>intersectionsForSegments(ImArray.fromObjects(new Tuple<Integer, LineSegment>(1, LineSegment.newWithX1Y1X2Y2(((double)(-1)), ((double)(-1)), ((double)(2)), ((double)(2)))), new Tuple<Integer, LineSegment>(3, LineSegment.newWithX1Y1X2Y2(((double)(-2)), ((double)(2)), ((double)(0)), ((double)(0))))));
        PackageObjectTest.<Set<Intersection<Integer>>>assertEqualsAB(ImArray.fromObjects(new Intersection<Integer>(new Pair<Integer>(1, 3), new vec2(((float)(0)), ((float)(0))))).toSet(), r);
    }
    @Test
    public void testNoCross() {
        Set<Intersection<Integer>> r = BentleyOttmann.<Integer>intersectionsForSegments(ImArray.fromObjects(new Tuple<Integer, LineSegment>(1, LineSegment.newWithX1Y1X2Y2(((double)(-1)), ((double)(-1)), ((double)(2)), ((double)(2)))), new Tuple<Integer, LineSegment>(3, LineSegment.newWithX1Y1X2Y2(((double)(-1)), ((double)(-1)), ((double)(2)), ((double)(0))))));
        PackageObjectTest.assertTrueValue(r.isEmpty());
    }
    @Test
    public void testVertical() {
        Set<Intersection<Integer>> r = BentleyOttmann.<Integer>intersectionsForSegments(ImArray.fromObjects(new Tuple<Integer, LineSegment>(1, LineSegment.newWithX1Y1X2Y2(((double)(-1)), ((double)(-1)), ((double)(2)), ((double)(2)))), new Tuple<Integer, LineSegment>(2, LineSegment.newWithX1Y1X2Y2(((double)(1)), ((double)(-2)), ((double)(1)), ((double)(2)))), new Tuple<Integer, LineSegment>(3, LineSegment.newWithX1Y1X2Y2(((double)(1)), ((double)(-4)), ((double)(1)), ((double)(0)))), new Tuple<Integer, LineSegment>(4, LineSegment.newWithX1Y1X2Y2(((double)(-1)), ((double)(-1)), ((double)(2)), ((double)(-4)))), new Tuple<Integer, LineSegment>(5, LineSegment.newWithX1Y1X2Y2(((double)(-1)), ((double)(-1)), ((double)(2)), ((double)(-1))))));
        final Set<Intersection<Integer>> e = ImArray.fromObjects(new Intersection<Integer>(new Pair<Integer>(3, 4), new vec2(((float)(1)), ((float)(-3)))), new Intersection<Integer>(new Pair<Integer>(2, 5), new vec2(((float)(1)), ((float)(-1)))), new Intersection<Integer>(new Pair<Integer>(1, 2), new vec2(((float)(1)), ((float)(1)))), new Intersection<Integer>(new Pair<Integer>(3, 5), new vec2(((float)(1)), ((float)(-1))))).toSet();
        PackageObjectTest.<Set<Intersection<Integer>>>assertEqualsAB(e, r);
    }
    @Test
    public void testVerticalInPoint() {
        Set<Intersection<Integer>> r = BentleyOttmann.<Integer>intersectionsForSegments(ImArray.fromObjects(new Tuple<Integer, LineSegment>(1, LineSegment.newWithX1Y1X2Y2(((double)(0)), ((double)(0)), ((double)(0)), ((double)(1)))), new Tuple<Integer, LineSegment>(2, LineSegment.newWithX1Y1X2Y2(((double)(-1)), ((double)(1)), ((double)(1)), ((double)(1)))), new Tuple<Integer, LineSegment>(3, LineSegment.newWithX1Y1X2Y2(((double)(-1)), ((double)(0)), ((double)(1)), ((double)(0))))));
        final Set<Intersection<Integer>> e = ImArray.fromObjects(new Intersection<Integer>(new Pair<Integer>(1, 2), new vec2(((float)(0)), ((float)(1)))), new Intersection<Integer>(new Pair<Integer>(1, 3), new vec2(((float)(0)), ((float)(0))))).toSet();
        PackageObjectTest.<Set<Intersection<Integer>>>assertEqualsAB(e, r);
    }
    @Test
    public void testOneStart() {
        Set<Intersection<Integer>> r = BentleyOttmann.<Integer>intersectionsForSegments(ImArray.fromObjects(new Tuple<Integer, LineSegment>(1, LineSegment.newWithX1Y1X2Y2(((double)(-1)), ((double)(1)), ((double)(1)), ((double)(-1)))), new Tuple<Integer, LineSegment>(2, LineSegment.newWithX1Y1X2Y2(((double)(-1)), ((double)(1)), ((double)(2)), ((double)(1)))), new Tuple<Integer, LineSegment>(3, LineSegment.newWithX1Y1X2Y2(((double)(-1)), ((double)(-1)), ((double)(2)), ((double)(2))))));
        final Set<Intersection<Integer>> e = ImArray.fromObjects(new Intersection<Integer>(new Pair<Integer>(1, 3), new vec2(((float)(0)), ((float)(0)))), new Intersection<Integer>(new Pair<Integer>(2, 3), new vec2(((float)(1)), ((float)(1))))).toSet();
        PackageObjectTest.<Set<Intersection<Integer>>>assertEqualsAB(e, r);
    }
    @Test
    public void testOneEnd() {
        Set<Intersection<Integer>> r = BentleyOttmann.<Integer>intersectionsForSegments(ImArray.fromObjects(new Tuple<Integer, LineSegment>(1, LineSegment.newWithX1Y1X2Y2(((double)(-2)), ((double)(1)), ((double)(1)), ((double)(1)))), new Tuple<Integer, LineSegment>(2, LineSegment.newWithX1Y1X2Y2(((double)(-1)), ((double)(-1)), ((double)(1)), ((double)(1)))), new Tuple<Integer, LineSegment>(3, LineSegment.newWithX1Y1X2Y2(((double)(-2)), ((double)(2)), ((double)(2)), ((double)(-2))))));
        final Set<Intersection<Integer>> e = ImArray.fromObjects(new Intersection<Integer>(new Pair<Integer>(1, 3), new vec2(((float)(-1)), ((float)(1)))), new Intersection<Integer>(new Pair<Integer>(2, 3), new vec2(((float)(0)), ((float)(0))))).toSet();
        PackageObjectTest.<Set<Intersection<Integer>>>assertEqualsAB(e, r);
    }
    @Test
    public void testSameLines() {
        Set<Intersection<Integer>> r = BentleyOttmann.<Integer>intersectionsForSegments(ImArray.fromObjects(new Tuple<Integer, LineSegment>(1, LineSegment.newWithX1Y1X2Y2(((double)(-1)), ((double)(1)), ((double)(1)), ((double)(-1)))), new Tuple<Integer, LineSegment>(2, LineSegment.newWithX1Y1X2Y2(((double)(-1)), ((double)(1)), ((double)(1)), ((double)(-1)))), new Tuple<Integer, LineSegment>(3, LineSegment.newWithX1Y1X2Y2(((double)(-1)), ((double)(-1)), ((double)(2)), ((double)(2))))));
        final Set<Intersection<Integer>> e = ImArray.fromObjects(new Intersection<Integer>(new Pair<Integer>(1, 2), new vec2(((float)(0)), ((float)(0)))), new Intersection<Integer>(new Pair<Integer>(2, 3), new vec2(((float)(0)), ((float)(0)))), new Intersection<Integer>(new Pair<Integer>(1, 3), new vec2(((float)(0)), ((float)(0))))).toSet();
        PackageObjectTest.<Set<Intersection<Integer>>>assertEqualsAB(e, r);
    }
    public BentleyOttmannTest() {
    }
    public String toString() {
        return "BentleyOttmannTest";
    }
}