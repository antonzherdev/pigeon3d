#import "objd.h"
#import "PGVec.h"
#import "PGCollision.h"

@class PGCollisionBody;

@class PGCollisionWorld;

@interface PGCollisionWorld : PGPhysicsWorld
+ (id)collisionWorld;
- (id)init;
- (CNClassType*)type;
- (id<CNIterable>)detect;
+ (CNClassType*)type;

- (id <CNImSeq>)crossPointsWithSegment:(PGLine3)line3;
- (id)closestCrossPointWithSegment:(PGLine3)line3;
@end


