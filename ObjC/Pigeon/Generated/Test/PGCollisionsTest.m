#import "PGCollisionsTest.h"

#import "PGCollisionWorld.h"
#import "PGCollisionBody.h"
#import "PGCollision.h"
@implementation PGCollisionsTest
static CNClassType* _PGCollisionsTest_type;

+ (instancetype)collisionsTest {
    return [[PGCollisionsTest alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGCollisionsTest class]) _PGCollisionsTest_type = [CNClassType classTypeWithCls:[PGCollisionsTest class]];
}

- (void)testCollisions {
    PGCollisionWorld* world = [PGCollisionWorld collisionWorld];
    PGCollisionBody* box1 = [PGCollisionBody collisionBodyWithData:@1 shape:[PGCollisionBox applyX:2.0 y:2.0 z:2.0] isKinematic:YES];
    PGCollisionBody* box2 = [PGCollisionBody collisionBodyWithData:@2 shape:[PGCollisionBox applyX:2.0 y:2.0 z:2.0] isKinematic:NO];
    [world addBody:box1];
    [world addBody:box2];
    [box1 translateX:1.8 y:1.8 z:0.0];
    assertTrue([[world detect] count] == 1);
    [box1 translateX:0.1 y:0.1 z:0.0];
    assertTrue([[world detect] count] == 1);
    [box1 translateX:0.2 y:0.2 z:0.0];
    assertTrue([[world detect] isEmpty]);
}

- (void)testCollisions2d {
    PGCollisionWorld* world = [PGCollisionWorld collisionWorld];
    PGCollisionBody* box1 = [PGCollisionBody collisionBodyWithData:@1 shape:[PGCollisionBox2d applyX:2.0 y:2.0] isKinematic:YES];
    PGCollisionBody* box2 = [PGCollisionBody collisionBodyWithData:@2 shape:[PGCollisionBox2d applyX:2.0 y:2.0] isKinematic:NO];
    [world addBody:box1];
    [world addBody:box2];
    [box1 translateX:1.8 y:1.8 z:0.0];
    assertTrue([[world detect] count] == 1);
    [box1 translateX:0.1 y:0.1 z:0.0];
    assertTrue([[world detect] count] == 1);
    [box1 translateX:0.2 y:0.2 z:0.0];
    assertTrue([[world detect] isEmpty]);
}

- (void)testRay {
    PGCollisionWorld* world = [PGCollisionWorld collisionWorld];
    PGCollisionBody* box1 = [PGCollisionBody collisionBodyWithData:@1 shape:[PGCollisionBox2d applyX:1.0 y:1.0] isKinematic:NO];
    PGCollisionBody* box2 = [PGCollisionBody collisionBodyWithData:@2 shape:[PGCollisionBox2d applyX:1.0 y:1.0] isKinematic:YES];
    [box1 translateX:2.0 y:2.0 z:0.0];
    [world addBody:box1];
    [world addBody:box2];
    PGLine3 segment = PGLine3Make((PGVec3Make(2.0, 2.0, 2.0)), (PGVec3Make(0.0, 0.0, -10.0)));
    id<CNIterable> r = [world crossPointsWithSegment:segment];
    PGCrossPoint* p1 = [PGCrossPoint crossPointWithBody:box1 point:PGVec3Make(2.0, 2.0, 0.0)];
    assertEquals(r, (@[p1]));
    [box2 translateX:2.0 y:2.0 z:-1.0];
    r = [world crossPointsWithSegment:segment];
    assertEquals(r, ((@[p1, [PGCrossPoint crossPointWithBody:box2 point:PGVec3Make(2.0, 2.0, -1.0)]])));
    assertEquals(((PGCrossPoint*)(nonnil([world closestCrossPointWithSegment:segment]))), p1);
    [box2 translateX:0.0 y:0.0 z:-10.0];
    r = [world crossPointsWithSegment:segment];
    assertEquals(r, (@[p1]));
}

- (NSString*)description {
    return @"CollisionsTest";
}

- (CNClassType*)type {
    return [PGCollisionsTest type];
}

+ (CNClassType*)type {
    return _PGCollisionsTest_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

