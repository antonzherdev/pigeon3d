#import "objd.h"
#import "PGVec.h"
#import "PGCollision.h"

@class PGMat4;

@class PGCollisionBody;
@class PGCollisionBox;
@class PGCollisionBox2d;
@class PGCollisionPlane;
@protocol PGCollisionShape;

@interface PGCollisionBody : NSObject <PGPhysicsBody>
@property (nonatomic, readonly) id data;
@property (nonatomic, readonly) id<PGCollisionShape> shape;
@property (nonatomic, readonly) BOOL isKinematic;
@property (nonatomic, readonly) VoidRef obj;

+ (id)collisionBodyWithData:(id)data shape:(id<PGCollisionShape>)shape isKinematic:(BOOL)isKinematic;
- (id)initWithData:(id)data shape:(id<PGCollisionShape>)shape isKinematic:(BOOL)isKinematic;
- (CNClassType*)type;
- (PGMat4 *)matrix;
- (void)setMatrix:(PGMat4 *)matrix;
- (void)translateX:(float)x y:(float)y z:(float)z;
- (void)rotateAngle:(float)angle x:(float)x y:(float)y z:(float)z;
+ (CNClassType*)type;
@end


@protocol PGCollisionShape<NSObject>
- (VoidRef)shape;
@end


@interface PGCollisionBox : NSObject<PGCollisionShape>
@property (nonatomic, readonly) PGVec3 size;

+ (id)collisionBoxWithSize:(PGVec3)size;
- (id)initWithSize:(PGVec3)size;
- (CNClassType*)type;
+ (PGCollisionBox*)applyX:(float)x y:(float)y z:(float)z;
+ (CNClassType*)type;
@end


@interface PGCollisionBox2d : NSObject<PGCollisionShape>
@property (nonatomic, readonly) PGVec2 size;

+ (id)collisionBox2dWithSize:(PGVec2)size;
- (id)initWithSize:(PGVec2)size;
- (CNClassType*)type;
+ (PGCollisionBox2d*)applyX:(float)x y:(float)y;
+ (CNClassType*)type;
@end


@interface PGCollisionPlane : NSObject<PGCollisionShape>
@property (nonatomic, readonly) PGVec3 normal;
@property (nonatomic, readonly) float distance;

+ (id)collisionPlaneWithNormal:(PGVec3)normal distance:(float)distance;
- (id)initWithNormal:(PGVec3)normal distance:(float)distance;
- (CNClassType*)type;
+ (CNClassType*)type;
@end


