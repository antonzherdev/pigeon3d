#import "objd.h"
#import "PGVec.h"
@class CNChain;
@class PGCollisionBody;
@protocol PGCollisionShape;
@class PGMat4;

@class PGCollision;
@class PGDynamicCollision;
@class PGCrossPoint;
@class PGContact;
@class PGIndexFunFilteredIterable;
@class PGIndexFunFilteredIterator;
@class PGPhysicsBody_impl;
@class PGPhysicsWorld;
@protocol PGPhysicsBody;

@interface PGCollision : NSObject {
@public
    CNPair* _bodies;
    id<CNIterable> _contacts;
}
@property (nonatomic, readonly) CNPair* bodies;
@property (nonatomic, readonly) id<CNIterable> contacts;

+ (instancetype)collisionWithBodies:(CNPair*)bodies contacts:(id<CNIterable>)contacts;
- (instancetype)initWithBodies:(CNPair*)bodies contacts:(id<CNIterable>)contacts;
- (CNClassType*)type;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface PGDynamicCollision : NSObject {
@public
    CNPair* _bodies;
    id<CNIterable> _contacts;
}
@property (nonatomic, readonly) CNPair* bodies;
@property (nonatomic, readonly) id<CNIterable> contacts;

+ (instancetype)dynamicCollisionWithBodies:(CNPair*)bodies contacts:(id<CNIterable>)contacts;
- (instancetype)initWithBodies:(CNPair*)bodies contacts:(id<CNIterable>)contacts;
- (CNClassType*)type;
- (float)impulse;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface PGCrossPoint : NSObject {
@public
    PGCollisionBody* _body;
    PGVec3 _point;
}
@property (nonatomic, readonly) PGCollisionBody* body;
@property (nonatomic, readonly) PGVec3 point;

+ (instancetype)crossPointWithBody:(PGCollisionBody*)body point:(PGVec3)point;
- (instancetype)initWithBody:(PGCollisionBody*)body point:(PGVec3)point;
- (CNClassType*)type;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface PGContact : NSObject {
@public
    PGVec3 _a;
    PGVec3 _b;
    float _distance;
    float _impulse;
    unsigned int _lifeTime;
}
@property (nonatomic, readonly) PGVec3 a;
@property (nonatomic, readonly) PGVec3 b;
@property (nonatomic, readonly) float distance;
@property (nonatomic, readonly) float impulse;
@property (nonatomic, readonly) unsigned int lifeTime;

+ (instancetype)contactWithA:(PGVec3)a b:(PGVec3)b distance:(float)distance impulse:(float)impulse lifeTime:(unsigned int)lifeTime;
- (instancetype)initWithA:(PGVec3)a b:(PGVec3)b distance:(float)distance impulse:(float)impulse lifeTime:(unsigned int)lifeTime;
- (CNClassType*)type;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface PGIndexFunFilteredIterable : CNImIterable_impl {
@public
    NSUInteger _maxCount;
    id(^_f)(NSUInteger);
}
@property (nonatomic, readonly) NSUInteger maxCount;
@property (nonatomic, readonly) id(^f)(NSUInteger);

+ (instancetype)indexFunFilteredIterableWithMaxCount:(NSUInteger)maxCount f:(id(^)(NSUInteger))f;
- (instancetype)initWithMaxCount:(NSUInteger)maxCount f:(id(^)(NSUInteger))f;
- (CNClassType*)type;
- (id<CNIterator>)iterator;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGIndexFunFilteredIterator : CNIterator_impl {
@public
    NSUInteger _maxCount;
    id(^_f)(NSUInteger);
    NSUInteger _i;
    id __next;
}
@property (nonatomic, readonly) NSUInteger maxCount;
@property (nonatomic, readonly) id(^f)(NSUInteger);

+ (instancetype)indexFunFilteredIteratorWithMaxCount:(NSUInteger)maxCount f:(id(^)(NSUInteger))f;
- (instancetype)initWithMaxCount:(NSUInteger)maxCount f:(id(^)(NSUInteger))f;
- (CNClassType*)type;
- (BOOL)hasNext;
- (id)next;
- (NSString*)description;
+ (CNClassType*)type;
@end


@protocol PGPhysicsBody<NSObject>
- (id)data;
- (id<PGCollisionShape>)shape;
- (BOOL)isKinematic;
- (PGMat4*)matrix;
- (void)setMatrix:(PGMat4*)matrix;
- (NSString*)description;
@end


@interface PGPhysicsBody_impl : NSObject<PGPhysicsBody>
+ (instancetype)physicsBody_impl;
- (instancetype)init;
@end


@interface PGPhysicsWorld : NSObject {
@public
    CNMHashMap* __bodiesMap;
    NSArray* __bodies;
}
+ (instancetype)physicsWorld;
- (instancetype)init;
- (CNClassType*)type;
- (void)addBody:(id<PGPhysicsBody>)body;
- (void)_addBody:(id<PGPhysicsBody>)body;
- (void)removeBody:(id<PGPhysicsBody>)body;
- (BOOL)removeItem:(id)item;
- (void)_removeBody:(id<PGPhysicsBody>)body;
- (id<PGPhysicsBody>)bodyForItem:(id)item;
- (void)clear;
- (id<CNIterable>)bodies;
- (NSString*)description;
+ (CNClassType*)type;
@end


