#import "objd.h"
#import "TSTestCase.h"
#import "PGVec.h"
@class PGDynamicWorld;
@class PGCollisionBox;
@class PGRigidBody;
@class PGMat4;
@class PGCollisionPlane;

@class PGDynamicTest;

@interface PGDynamicTest : TSTestCase
+ (instancetype)dynamicTest;
- (instancetype)init;
- (CNClassType*)type;
- (void)runSecondInWorld:(PGDynamicWorld*)world;
- (void)testSimple;
- (void)testFriction;
- (NSString*)description;
+ (CNClassType*)type;
@end


