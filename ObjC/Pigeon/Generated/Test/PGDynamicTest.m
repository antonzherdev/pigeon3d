#import "PGDynamicTest.h"

#import "PGDynamicWorld.h"
#import "PGCollisionBody.h"
#import "PGMat4.h"
@implementation PGDynamicTest
static CNClassType* _PGDynamicTest_type;

+ (instancetype)dynamicTest {
    return [[PGDynamicTest alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGDynamicTest class]) _PGDynamicTest_type = [CNClassType classTypeWithCls:[PGDynamicTest class]];
}

- (void)runSecondInWorld:(PGDynamicWorld*)world {
    id<CNIterator> __il__0i = [intRange(30) iterator];
    while([__il__0i hasNext]) {
        id _ = [__il__0i next];
        [world updateWithDelta:1.0 / 30.0];
    }
}

- (void)testSimple {
    PGDynamicWorld* world = [PGDynamicWorld dynamicWorldWithGravity:PGVec3Make(0.0, -10.0, 0.0)];
    PGCollisionBox* shape = [PGCollisionBox applyX:1.0 y:1.0 z:1.0];
    PGRigidBody* body = [PGRigidBody dynamicData:@1 shape:shape mass:1.0];
    [world addBody:body];
    body.matrix = [[PGMat4 identity] translateX:0.0 y:5.0 z:0.0];
    PGMat4* m = body.matrix;
    assertTrue((eqf4(m.array[13], 5)));
    PGVec3 v = body.velocity;
    assertEquals((wrap(PGVec3, v)), (wrap(PGVec3, (PGVec3Make(0.0, 0.0, 0.0)))));
    [self runSecondInWorld:world];
    m = body.matrix;
    assertTrue((float4Between(m.array[13], -0.1, 0.1)));
    v = body.velocity;
    assertTrue((eqf4(v.x, 0)));
    assertTrue((float4Between(v.y, -10.01, -9.99)));
    assertTrue((eqf4(v.z, 0)));
}

- (void)testFriction {
    PGDynamicWorld* world = [PGDynamicWorld dynamicWorldWithGravity:PGVec3Make(0.0, -10.0, 0.0)];
    PGRigidBody* plane = [PGRigidBody staticalData:@1 shape:[PGCollisionPlane collisionPlaneWithNormal:PGVec3Make(0.0, 1.0, 0.0) distance:0.0]];
    [world addBody:plane];
    PGRigidBody* body = [PGRigidBody dynamicData:@2 shape:[PGCollisionBox applyX:1.0 y:1.0 z:1.0] mass:1.0];
    [world addBody:body];
    body.matrix = [[PGMat4 identity] translateX:0.0 y:0.5 z:0.0];
    body.velocity = PGVec3Make(10.0, 0.0, 0.0);
    [self runSecondInWorld:world];
    PGVec3 v = body.velocity;
    if(!(float4Between(v.x, 7.4, 7.6))) fail(([NSString stringWithFormat:@"%f is not between 7.4 and 7.6", v.x]));
    assertTrue((float4Between(v.y, -0.1, 0.1)));
    assertTrue((float4Between(v.z, -0.1, 0.1)));
}

- (NSString*)description {
    return @"DynamicTest";
}

- (CNClassType*)type {
    return [PGDynamicTest type];
}

+ (CNClassType*)type {
    return _PGDynamicTest_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

