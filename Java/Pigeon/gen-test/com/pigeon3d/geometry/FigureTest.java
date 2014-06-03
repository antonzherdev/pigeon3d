package com.pigeon3d.geometry;

import objd.lang.*;
import objd.test.PackageObjectTest;
import objd.collection.ImArray;
import objd.collection.Set;
import objd.math;
import org.junit.Test;
import objd.test.TestCase;

public class FigureTest extends TestCase {
    @Test
    public void testThickLine() {
        ThickLineSegment l = new ThickLineSegment(new LineSegment(new vec2(((float)(0)), ((float)(0))), new vec2(((float)(1)), ((float)(0)))), ((double)(1)));
        PackageObjectTest.<Rect>assertEqualsAB(l.boundingRect(), Rect.applyXYWidthHeight(((float)(0)), ((float)(-0.5)), ((float)(1)), ((float)(1))));
        Polygon p = new Polygon(ImArray.fromObjects(new vec2(((float)(0)), ((float)(0.5))), new vec2(((float)(0)), ((float)(-0.5))), new vec2(((float)(1)), ((float)(-0.5))), new vec2(((float)(1)), ((float)(0.5)))));
        PackageObjectTest.<Set<LineSegment>>assertEqualsAB(l.segments().toSet(), p.segments.toSet());
        l = new ThickLineSegment(new LineSegment(new vec2(((float)(0)), ((float)(0))), new vec2(((float)(0)), ((float)(1)))), ((double)(1)));
        PackageObjectTest.<Rect>assertEqualsAB(l.boundingRect(), Rect.applyXYWidthHeight(((float)(-0.5)), ((float)(0)), ((float)(1)), ((float)(1))));
        p = new Polygon(ImArray.fromObjects(new vec2(((float)(0.5)), ((float)(0))), new vec2(((float)(-0.5)), ((float)(0))), new vec2(((float)(-0.5)), ((float)(1))), new vec2(((float)(0.5)), ((float)(1)))));
        PackageObjectTest.<Set<LineSegment>>assertEqualsAB(l.segments().toSet(), p.segments.toSet());
        final double s2 = math.sqrt(((double)(2)));
        l = new ThickLineSegment(new LineSegment(new vec2(((float)(0)), ((float)(0))), new vec2(((float)(1)), ((float)(1)))), s2);
        PackageObjectTest.<Rect>assertEqualsAB(l.boundingRect(), Rect.thickenHalfSize(Rect.applyXYWidthHeight(((float)(0)), ((float)(0)), ((float)(1)), ((float)(1))), new vec2(((float)(s2 / 2)), ((float)(s2 / 2)))));
        p = new Polygon(ImArray.fromObjects(new vec2(((float)(-0.5)), ((float)(0.5))), new vec2(((float)(0.5)), ((float)(1.5))), new vec2(((float)(1.5)), ((float)(0.5))), new vec2(((float)(0.5)), ((float)(-0.5)))));
        PackageObjectTest.<Set<LineSegment>>assertEqualsAB(l.segments().toSet(), p.segments.toSet());
    }
    public FigureTest() {
    }
    public String toString() {
        return "FigureTest";
    }
}