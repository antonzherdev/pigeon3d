package com.pigeon3d;

import objd.lang.*;
import objd.collection.Iterator;
import com.pigeon3d.geometry.vec3;
import com.pigeon3d.geometry.mat4;
import objd.test.PackageObjectTest;
import org.junit.Test;
import objd.test.TestCase;

public class DynamicTest extends TestCase {
    public void runSecondInWorld(final DynamicWorld<Object> world) {
        {
            final Iterator<Integer> __il__0i = Int.range(30).iterator();
            while(__il__0i.hasNext()) {
                final Integer _ = __il__0i.next();
                world.updateWithDelta(1.0 / 30.0);
            }
        }
    }
    @Test
    public void testSimple() {
        final DynamicWorld<Integer> world = new DynamicWorld<Integer>(new vec3(((float)(0)), ((float)(-10)), ((float)(0))));
        final CollisionBox shape = new CollisionBox(((float)(1)), ((float)(1)), ((float)(1)));
        final RigidBody<Integer> body = RigidBody.<Integer>dynamicDataShapeMass(1, shape, ((float)(1)));
        world.addBody(body);
        body.matrix = mat4.identity().translateXYZ(((float)(0)), ((float)(5)), ((float)(0)));
        mat4 m = body.matrix;
        PackageObjectTest.assertTrueValue(m.array[13] == 5);
        vec3 v = body.velocity;
        PackageObjectTest.<vec3>assertEqualsAB(v, new vec3(((float)(0)), ((float)(0)), ((float)(0))));
        runSecondInWorld(((DynamicWorld<Object>)(((DynamicWorld)(world)))));
        m = body.matrix;
        PackageObjectTest.assertTrueValue(Float4.between(m.array[13], ((float)(-0.1)), ((float)(0.1))));
        v = body.velocity;
        PackageObjectTest.assertTrueValue(v.x == 0);
        PackageObjectTest.assertTrueValue(Float4.between(v.y, ((float)(-10.01)), ((float)(-9.99))));
        PackageObjectTest.assertTrueValue(v.z == 0);
    }
    @Test
    public void testFriction() {
        final DynamicWorld<Integer> world = new DynamicWorld<Integer>(new vec3(((float)(0)), ((float)(-10)), ((float)(0))));
        final RigidBody<Integer> plane = RigidBody.<Integer>staticalDataShape(1, new CollisionPlane(new vec3(((float)(0)), ((float)(1)), ((float)(0))), ((float)(0))));
        world.addBody(plane);
        final RigidBody<Integer> body = RigidBody.<Integer>dynamicDataShapeMass(2, new CollisionBox(((float)(1)), ((float)(1)), ((float)(1))), ((float)(1)));
        world.addBody(body);
        body.matrix = mat4.identity().translateXYZ(((float)(0)), ((float)(0.5)), ((float)(0)));
        body.velocity = new vec3(((float)(10)), ((float)(0)), ((float)(0)));
        runSecondInWorld(((DynamicWorld<Object>)(((DynamicWorld)(world)))));
        final vec3 v = body.velocity;
        if(!(Float4.between(v.x, ((float)(7.4)), ((float)(7.6))))) {
            PackageObjectTest.failText(String.format("%f is not between 7.4 and 7.6", v.x));
        }
        PackageObjectTest.assertTrueValue(Float4.between(v.y, ((float)(-0.1)), ((float)(0.1))));
        PackageObjectTest.assertTrueValue(Float4.between(v.z, ((float)(-0.1)), ((float)(0.1))));
    }
    public DynamicTest() {
    }
    public String toString() {
        return "DynamicTest";
    }
}