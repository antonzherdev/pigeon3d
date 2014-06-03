#import "PGDynamicWorld.h"

#import "PGCollisionBody.h"
#import "PGMat4.h"
#include "btBulletDynamicsCommon.h"
#import "PGCollision.h"

@implementation PGDynamicWorld {
    PGVec3 _gravity;
    btDefaultCollisionConfiguration* _collisionConfiguration;
    btCollisionDispatcher* _dispatcher;
    btBroadphaseInterface* _overlappingPairCache;
    btSequentialImpulseConstraintSolver* _solver;
    btDiscreteDynamicsWorld* _world;
}
static CNClassType* _PGDynamicWorld_type;
@synthesize gravity = _gravity;

+ (id)dynamicWorldWithGravity:(PGVec3)gravity {
    return [[PGDynamicWorld alloc] initWithGravity:gravity];
}

- (id)initWithGravity:(PGVec3)gravity {
    self = [super init];
    if(self) {
        _gravity = gravity;
        _collisionConfiguration = new btDefaultCollisionConfiguration();

        ///use the default collision dispatcher. For parallel processing you can use a diffent dispatcher (see Extras/BulletMultiThreaded)
        _dispatcher = new	btCollisionDispatcher(_collisionConfiguration);

        ///btDbvtBroadphase is a good general purpose broadphase. You can also try out btAxis3Sweep.
        _overlappingPairCache = new btDbvtBroadphase();

        ///the default constraint solver. For parallel processing you can use a different solver (see Extras/BulletMultiThreaded)
        _solver = new btSequentialImpulseConstraintSolver;

        _world = new btDiscreteDynamicsWorld(_dispatcher, _overlappingPairCache, _solver, _collisionConfiguration);

        _world->setGravity(btVector3(gravity.x, gravity.y, gravity.z));

    }
    
    return self;
}

- (void)updateWithDelta:(CGFloat)delta {
    _world->stepSimulation((btScalar) (delta), 20);
}

- (void)dealloc {
    [self clear];
    delete _world;
    delete _collisionConfiguration;
    delete _dispatcher;
    delete _overlappingPairCache;
    delete _solver;
}

+ (void)initialize {
    [super initialize];
    _PGDynamicWorld_type = [CNClassType classTypeWithCls:[PGDynamicWorld class]];
}

- (void)_addBody:(PGRigidBody *)body {
    _world->addRigidBody(static_cast<btRigidBody*>(body.obj));
}

- (void)_removeBody:(PGRigidBody *)body {
    _world->removeRigidBody(static_cast<btRigidBody*>(body.obj));
}

- (CNClassType*)type {
    return [PGDynamicWorld type];
}

+ (CNClassType*)type {
    return _PGDynamicWorld_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    PGDynamicWorld * o = ((PGDynamicWorld *)(other));
    return pgVec3IsEqualTo(self.gravity, o.gravity);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + pgVec3Hash(self.gravity);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"gravity=<%f, %f, %f>", self.gravity.x, self.gravity.y, self.gravity.z];
    [description appendString:@">"];
    return description;
}

- (id <CNIterable>)collisions {
    return [self collisionsOnlyNew:NO];
}

- (id <CNIterable>)collisionsOnlyNew:(BOOL)onlyNew {
    return [PGIndexFunFilteredIterable indexFunFilteredIterableWithMaxCount:(NSUInteger) _dispatcher->getNumManifolds() f:^id(NSUInteger i) {
        if(_dispatcher->getNumManifolds() <= i) return nil;
        btPersistentManifold *pManifold = _dispatcher->getManifoldByIndexInternal((int)i);
        if(pManifold->getNumContacts() == 0) return nil;
        PGRigidBody *body0 = (__bridge PGRigidBody *) pManifold->getBody0()->getUserPointer();
        PGRigidBody *body1 = (__bridge PGRigidBody *) pManifold->getBody1()->getUserPointer();
        CNArrayBuilder *builder = [CNArrayBuilder arrayBuilderWithCapacity:(NSUInteger) pManifold->getNumContacts()];
        for(int j = 0; j <  pManifold->getNumContacts(); j ++) {
            btManifoldPoint & p = pManifold->getContactPoint(j);
            if(p.getDistance() < 0.f) {
                if(p.getLifeTime() != 1 && onlyNew) return nil;
                btVector3 const & a = p.getPositionWorldOnA();
                btVector3 const & b = p.getPositionWorldOnB();
                [builder appendItem: [PGContact
                        contactWithA:PGVec3Make(a.x(), a.y(), a.z())
                                   b:PGVec3Make(b.x(), b.y(), b.z())
                            distance:p.getDistance()
                             impulse:p.getAppliedImpulse()
                            lifeTime:(unsigned int) p.getLifeTime()]];
            }
        }
        NSArray *array = [builder build];
        if([array isEmpty]) return nil;

        return [PGDynamicCollision dynamicCollisionWithBodies:[CNPair pairWithA:body0 b:body1] contacts:array];
    }];
}

- (id <CNIterable>)newCollisions {
    return [self collisionsOnlyNew:YES];
}
@end


@implementation PGRigidBody {
    id _data;
    id<PGCollisionShape> _shape;
    BOOL _isKinematic;
    float _mass;
    btRigidBody* _body;
    btDefaultMotionState* _motionState;
    BOOL _isDynamic;
    BOOL _isStatic;
}
static CNClassType* _PGDynamicBody_type;
@synthesize data = _data;
@synthesize shape = _shape;
@synthesize isKinematic = _isKinematic;
@synthesize mass = _mass;
@synthesize isDynamic = _isDynamic;
@synthesize isStatic = _isStatic;

- (VoidRef) obj {
    return _body;
}

+ (id)rigidBodyWithData:(id)data shape:(id <PGCollisionShape>)shape isKinematic:(BOOL)isKinematic mass:(float)mass {
    return [[PGRigidBody alloc] initWithData:data shape:shape isKinematic:isKinematic mass:mass];
}

- (id)initWithData:(id)data shape:(id<PGCollisionShape>)shape isKinematic:(BOOL)isKinematic mass:(float)mass {
    self = [super init];
    if(self) {
        _data = data;
        _shape = shape;
        _isKinematic = isKinematic;
        _mass = mass;
        _isDynamic = !(_isKinematic) && _mass > 0;
        _isStatic = !(_isKinematic) && _mass <= 0;
        btCollisionShape* sh = static_cast<btCollisionShape*>([_shape shape]);
        btVector3 localInertia(0,0,0);
        if (mass > 0.000001) sh->calculateLocalInertia(mass,localInertia);
        btTransform transform;
        transform.setIdentity();
        //using motionstate is recommended, it provides interpolation capabilities, and only synchronizes 'active' objects
        _motionState = new btDefaultMotionState(transform);
        btRigidBody::btRigidBodyConstructionInfo rbInfo(mass, _motionState, sh, localInertia);
        _body = new btRigidBody(rbInfo);
        _body->setUserPointer((__bridge void *)self);
        if(isKinematic) {
            _body->setCollisionFlags(_body->getCollisionFlags() | btCollisionObject::CF_KINEMATIC_OBJECT);
            _body->setActivationState(DISABLE_DEACTIVATION);
        }
    }
    
    return self;
}

+ (PGRigidBody*)kinematicData:(id)data shape:(id<PGCollisionShape>)shape {
    return [PGRigidBody rigidBodyWithData:data shape:shape isKinematic:YES mass:0.0];
}

+ (PGRigidBody*)dynamicData:(id)data shape:(id<PGCollisionShape>)shape mass:(float)mass {
    return [PGRigidBody rigidBodyWithData:data shape:shape isKinematic:NO mass:mass];
}

+ (PGRigidBody*)staticalData:(id)data shape:(id<PGCollisionShape>)shape {
    return [PGRigidBody rigidBodyWithData:data shape:shape isKinematic:NO mass:0.0];
}


-(void) dealloc {
    delete _motionState;
    delete _body;
}

+ (void)initialize {
    [super initialize];
    _PGDynamicBody_type = [CNClassType classTypeWithCls:[PGRigidBody class]];
}

- (PGMat4 *)matrix {
    btTransform trans;
    if(_isKinematic) {
        _motionState->getWorldTransform(trans);
    } else {
        trans = _body->getWorldTransform();
    }
    float matrix[16];
    trans.getOpenGLMatrix(matrix);
    return [PGMat4 mat4WithArray:matrix];
}

- (float)friction {
    return _body->getFriction();
}

- (void)setFriction:(float)friction {
    _body->setFriction(friction);
}

- (float)bounciness {
    return _body->getRestitution();
}

- (void)setBounciness:(float)bounciness {
    _body->setRestitution(bounciness);
}


- (void)setMatrix:(PGMat4 *)matrix {
    btTransform trans;
    trans.setFromOpenGLMatrix(matrix.array);
    if(_isKinematic) {
        _motionState->setWorldTransform(trans);
    } else {
        _body->setWorldTransform(trans);
    }
}

- (PGVec3)velocity {
    btVector3 const & v = _body->getLinearVelocity();
    return PGVec3Make(v.x(), v.y(), v.z());
}

- (void)setVelocity:(PGVec3)vec3 {
    _body->setLinearVelocity(btVector3(vec3.x, vec3.y, vec3.z));
}

- (PGVec3)angularVelocity {
    btVector3 const & v = _body->getAngularVelocity();
    return PGVec3Make(v.x(), v.y(), v.z());
}

- (void)setAngularVelocity:(PGVec3)vec3 {
    _body->setAngularVelocity(btVector3(vec3.x, vec3.y, vec3.z));
}


- (CNClassType*)type {
    return [PGRigidBody type];
}

+ (CNClassType*)type {
    return _PGDynamicBody_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    PGRigidBody * o = ((PGRigidBody *)(other));
    return [self.data isEqual:o.data] && [self.shape isEqual:o.shape] && self.isKinematic == o.isKinematic && eqf4(self.mass, o.mass);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.data hash];
    hash = hash * 31 + [self.shape hash];
    hash = hash * 31 + self.isKinematic;
    hash = hash * 31 + float4Hash(self.mass);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"data=%@", self.data];
    [description appendFormat:@", shape=%@", self.shape];
    [description appendFormat:@", isKinematic=%d", self.isKinematic];
    [description appendFormat:@", mass=%f", self.mass];
    [description appendString:@">"];
    return description;
}

@end


