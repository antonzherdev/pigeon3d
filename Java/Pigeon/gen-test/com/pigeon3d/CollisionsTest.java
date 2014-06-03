package com.pigeon3d;

import objd.lang.*;
import objd.test.PackageObjectTest;
import org.junit.Test;
import com.pigeon3d.geometry.Line3;
import com.pigeon3d.geometry.vec3;
import objd.collection.Iterable;
import objd.collection.ImArray;
import objd.test.TestCase;

public class CollisionsTest extends TestCase {
    @Test
    public void testCollisions() {
        final CollisionWorld<Integer> world = new CollisionWorld<Integer>();
        final CollisionBody<Integer> box1 = new CollisionBody<Integer>(1, new CollisionBox(((float)(2)), ((float)(2)), ((float)(2))), true);
        final CollisionBody<Integer> box2 = new CollisionBody<Integer>(2, new CollisionBox(((float)(2)), ((float)(2)), ((float)(2))), false);
        world.addBody(box1);
        world.addBody(box2);
        box1.translateXYZ(((float)(1.8)), ((float)(1.8)), ((float)(0)));
        PackageObjectTest.assertTrueValue(world.detect().count() == 1);
        box1.translateXYZ(((float)(0.1)), ((float)(0.1)), ((float)(0)));
        PackageObjectTest.assertTrueValue(world.detect().count() == 1);
        box1.translateXYZ(((float)(0.2)), ((float)(0.2)), ((float)(0)));
        PackageObjectTest.assertTrueValue(world.detect().isEmpty());
    }
    @Test
    public void testCollisions2d() {
        final CollisionWorld<Integer> world = new CollisionWorld<Integer>();
        final CollisionBody<Integer> box1 = new CollisionBody<Integer>(1, new CollisionBox2d(((float)(2)), ((float)(2))), true);
        final CollisionBody<Integer> box2 = new CollisionBody<Integer>(2, new CollisionBox2d(((float)(2)), ((float)(2))), false);
        world.addBody(box1);
        world.addBody(box2);
        box1.translateXYZ(((float)(1.8)), ((float)(1.8)), ((float)(0)));
        PackageObjectTest.assertTrueValue(world.detect().count() == 1);
        box1.translateXYZ(((float)(0.1)), ((float)(0.1)), ((float)(0)));
        PackageObjectTest.assertTrueValue(world.detect().count() == 1);
        box1.translateXYZ(((float)(0.2)), ((float)(0.2)), ((float)(0)));
        PackageObjectTest.assertTrueValue(world.detect().isEmpty());
    }
    @Test
    public void testRay() {
        final CollisionWorld<Integer> world = new CollisionWorld<Integer>();
        final CollisionBody<Integer> box1 = new CollisionBody<Integer>(1, new CollisionBox2d(((float)(1)), ((float)(1))), false);
        final CollisionBody<Integer> box2 = new CollisionBody<Integer>(2, new CollisionBox2d(((float)(1)), ((float)(1))), true);
        box1.translateXYZ(((float)(2)), ((float)(2)), ((float)(0)));
        world.addBody(box1);
        world.addBody(box2);
        final Line3 segment = new Line3(new vec3(((float)(2)), ((float)(2)), ((float)(2))), new vec3(((float)(0)), ((float)(0)), ((float)(-10))));
        Iterable<CrossPoint<Integer>> r = world.crossPointsWithSegment(segment);
        final CrossPoint<Integer> p1 = new CrossPoint<Integer>(box1, new vec3(((float)(2)), ((float)(2)), ((float)(0))));
        PackageObjectTest.<Iterable<CrossPoint<Integer>>>assertEqualsAB(r, ImArray.fromObjects(p1));
        box2.translateXYZ(((float)(2)), ((float)(2)), ((float)(-1)));
        r = world.crossPointsWithSegment(segment);
        PackageObjectTest.<Iterable<CrossPoint<Integer>>>assertEqualsAB(r, ImArray.fromObjects(p1, new CrossPoint<Integer>(box2, new vec3(((float)(2)), ((float)(2)), ((float)(-1))))));
        final CrossPoint<Integer> __tmp_13p0n = world.closestCrossPointWithSegment(segment);
        if(__tmp_13p0n == null) {
            throw new NullPointerException();
        }
        PackageObjectTest.<CrossPoint<Integer>>assertEqualsAB(__tmp_13p0n, p1);
        box2.translateXYZ(((float)(0)), ((float)(0)), ((float)(-10)));
        r = world.crossPointsWithSegment(segment);
        PackageObjectTest.<Iterable<CrossPoint<Integer>>>assertEqualsAB(r, ImArray.fromObjects(p1));
    }
    public CollisionsTest() {
    }
    public String toString() {
        return "CollisionsTest";
    }
}