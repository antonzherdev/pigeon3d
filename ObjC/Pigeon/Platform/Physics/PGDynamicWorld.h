#import "objd.h"
#import "PGScene.h"
#import "PGVec.h"
#import "PGCollision.h"

@protocol PGCollisionShape;
@class PGMat4;

@class PGDynamicWorld;
@class PGRigidBody;

@interface PGDynamicWorld : PGPhysicsWorld<PGUpdatable>
@property (nonatomic, readonly) PGVec3 gravity;

+ (id)dynamicWorldWithGravity:(PGVec3)gravity;
- (id)initWithGravity:(PGVec3)gravity;
- (CNClassType*)type;
+ (CNClassType*)type;
- (id <CNIterable>)collisions;
- (id <CNIterable>)newCollisions;
@end


@interface PGRigidBody : NSObject<PGPhysicsBody>
@property (nonatomic, readonly) id data;
@property (nonatomic, readonly) id<PGCollisionShape> shape;
@property (nonatomic, readonly) BOOL isKinematic;
@property (nonatomic, readonly) float mass;
@property (nonatomic, readonly) BOOL isDynamic;
@property (nonatomic, readonly) BOOL isStatic;
@property (nonatomic, readonly) VoidRef obj;
@property(nonatomic) float friction;
@property(nonatomic) float bounciness;
@property(nonatomic) PGVec3 angularVelocity;

+ (id)rigidBodyWithData:(id)data shape:(id<PGCollisionShape>)shape isKinematic:(BOOL)isKinematic mass:(float)mass;
- (id)initWithData:(id)data shape:(id<PGCollisionShape>)shape isKinematic:(BOOL)isKinematic mass:(float)mass;
- (CNClassType*)type;
+ (PGRigidBody*)kinematicData:(id)data shape:(id<PGCollisionShape>)shape;
+ (PGRigidBody*)dynamicData:(id)data shape:(id<PGCollisionShape>)shape mass:(float)mass;
+ (PGRigidBody*)staticalData:(id)data shape:(id<PGCollisionShape>)shape;
- (PGMat4 *)matrix;
- (void)setMatrix:(PGMat4 *)matrix;
- (PGVec3)velocity;
- (void)setVelocity:(PGVec3)velocity;
+ (CNClassType*)type;
@end


