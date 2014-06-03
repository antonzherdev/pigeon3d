#import "PGCollisionWorld.h"

#import "PGCollisionBody.h"

#include "btBulletCollisionCommon.h"
#import "PGCollision.h"

@implementation PGCollisionWorld {
    btCollisionWorld * _world;
    btDefaultCollisionConfiguration* _configuration;
    btCollisionDispatcher* _dispatcher;
    btSimpleBroadphase*	_broadphase;
}
static CNClassType* _PGCollisionWorld_type;

+ (id)collisionWorld {
    return [[PGCollisionWorld alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        _configuration = new btDefaultCollisionConfiguration();
        _dispatcher = new btCollisionDispatcher(_configuration);
        _broadphase = new btSimpleBroadphase;
        _world = new btCollisionWorld(_dispatcher, _broadphase, _configuration);
    }
    return self;
}

- (void)dealloc {
    [self clear];
    delete _world;
    delete _broadphase;
    delete _dispatcher;
    delete _configuration;
}

+ (void)initialize {
    [super initialize];
    _PGCollisionWorld_type = [CNClassType classTypeWithCls:[PGCollisionWorld class]];
}

- (void)_addBody:(PGCollisionBody *)body {
    _world->addCollisionObject(static_cast<btCollisionObject*>(body.obj));
}

- (void)_removeBody:(PGCollisionBody *)body {
    _world->removeCollisionObject(static_cast<btCollisionObject*>(body.obj));
}

- (id<CNIterable>)detect {
    _world->performDiscreteCollisionDetection();
    return [PGIndexFunFilteredIterable indexFunFilteredIterableWithMaxCount:(NSUInteger) _dispatcher->getNumManifolds() f:^id(NSUInteger i) {
        btPersistentManifold *pManifold = _dispatcher->getManifoldByIndexInternal((int)i);
        if(pManifold->getNumContacts() == 0) return nil;
        PGCollisionBody *body0 = (__bridge PGCollisionBody *) pManifold->getBody0()->getUserPointer();
        PGCollisionBody *body1 = (__bridge PGCollisionBody *) pManifold->getBody1()->getUserPointer();
        return [PGCollision
                collisionWithBodies:[CNPair pairWithA:body0 b:body1]
                           contacts:[CNIndexFunSeq indexFunSeqWithCount:(NSUInteger) pManifold->getNumContacts() f:^id(NSUInteger i) {
                               btManifoldPoint & p = pManifold->getContactPoint((int)i);
                               btVector3 const & a = p.getPositionWorldOnA();
                               btVector3 const & b = p.getPositionWorldOnB();
                               return [PGContact contactWithA:PGVec3Make(a.x(), a.y(), a.z())
                                                            b:PGVec3Make(b.x(), b.y(), b.z())
                                                     distance:p.getDistance()
                                                      impulse:p.getAppliedImpulse()
                                                     lifeTime:(unsigned int) p.getLifeTime()];
                           }]];
    }];
}

- (CNClassType*)type {
    return [PGCollisionWorld type];
}

+ (CNClassType*)type {
    return _PGCollisionWorld_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    return YES;
}

- (NSUInteger)hash {
    return 0;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

- (id <CNImSeq>)crossPointsWithSegment:(PGLine3)line3 {
    btVector3 from = btVector3(line3.r0.x, line3.r0.y, line3.r0.z);
    btVector3 to = btVector3(line3.r0.x + line3.u.x, line3.r0.y + line3.u.y, line3.r0.z + line3.u.z);
    btCollisionWorld::AllHitsRayResultCallback results(from, to);
    _world->rayTest(from, to, results);
    
    return [CNIndexFunSeq indexFunSeqWithCount:(NSUInteger) results.m_collisionObjects.size() f:^id(NSUInteger i) {
        PGCollisionBody *body = (__bridge PGCollisionBody *) results.m_collisionObjects.at((int)i)->getUserPointer();
        const btVector3 & p = results.m_hitPointWorld.at((int)i);
        return [PGCrossPoint crossPointWithBody:body point:(PGVec3){p.x(), p.y(), p.z()}];
    }];
}

- (id)closestCrossPointWithSegment:(PGLine3)line3 {
    btVector3 from = btVector3(line3.r0.x, line3.r0.y, line3.r0.z);
    btVector3 to = btVector3(line3.r0.x + line3.u.x, line3.r0.y + line3.u.y, line3.r0.z + line3.u.z);
    btCollisionWorld::ClosestRayResultCallback results(from, to);
    _world->rayTest(from, to, results);
    if(results.m_collisionObject == nil) return nil;
    PGCollisionBody *body = (__bridge PGCollisionBody *) results.m_collisionObject->getUserPointer();
    const btVector3 & p = results.m_hitPointWorld;
    return [PGCrossPoint crossPointWithBody:body point:(PGVec3) {p.x(), p.y(), p.z()}];
}
@end


