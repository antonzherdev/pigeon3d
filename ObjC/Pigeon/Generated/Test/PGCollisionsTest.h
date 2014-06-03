#import "objd.h"
#import "TSTestCase.h"
#import "PGVec.h"
@class PGCollisionWorld;
@class PGCollisionBox;
@class PGCollisionBody;
@class PGCollisionBox2d;
@class PGCrossPoint;

@class PGCollisionsTest;

@interface PGCollisionsTest : TSTestCase
+ (instancetype)collisionsTest;
- (instancetype)init;
- (CNClassType*)type;
- (void)testCollisions;
- (void)testCollisions2d;
- (void)testRay;
- (NSString*)description;
+ (CNClassType*)type;
@end


