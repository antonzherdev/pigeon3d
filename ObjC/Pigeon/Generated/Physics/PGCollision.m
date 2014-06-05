#import "PGCollision.h"

#import "CNChain.h"
#import "PGCollisionBody.h"
#import "PGMat4.h"
@implementation PGCollision
static CNClassType* _PGCollision_type;
@synthesize bodies = _bodies;
@synthesize contacts = _contacts;

+ (instancetype)collisionWithBodies:(CNPair*)bodies contacts:(id<CNIterable>)contacts {
    return [[PGCollision alloc] initWithBodies:bodies contacts:contacts];
}

- (instancetype)initWithBodies:(CNPair*)bodies contacts:(id<CNIterable>)contacts {
    self = [super init];
    if(self) {
        _bodies = bodies;
        _contacts = contacts;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGCollision class]) _PGCollision_type = [CNClassType classTypeWithCls:[PGCollision class]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Collision(%@, %@)", _bodies, _contacts];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[PGCollision class]])) return NO;
    PGCollision* o = ((PGCollision*)(to));
    return [_bodies isEqual:o->_bodies] && [_contacts isEqual:o->_contacts];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [_bodies hash];
    hash = hash * 31 + [_contacts hash];
    return hash;
}

- (CNClassType*)type {
    return [PGCollision type];
}

+ (CNClassType*)type {
    return _PGCollision_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGDynamicCollision
static CNClassType* _PGDynamicCollision_type;
@synthesize bodies = _bodies;
@synthesize contacts = _contacts;

+ (instancetype)dynamicCollisionWithBodies:(CNPair*)bodies contacts:(id<CNIterable>)contacts {
    return [[PGDynamicCollision alloc] initWithBodies:bodies contacts:contacts];
}

- (instancetype)initWithBodies:(CNPair*)bodies contacts:(id<CNIterable>)contacts {
    self = [super init];
    if(self) {
        _bodies = bodies;
        _contacts = contacts;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGDynamicCollision class]) _PGDynamicCollision_type = [CNClassType classTypeWithCls:[PGDynamicCollision class]];
}

- (float)impulse {
    id __tmp = [[[_contacts chain] mapF:^id(PGContact* _) {
        return numf4(((PGContact*)(_))->_impulse);
    }] max];
    if(__tmp != nil) return unumf4(__tmp);
    else return 0.0;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"DynamicCollision(%@, %@)", _bodies, _contacts];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[PGDynamicCollision class]])) return NO;
    PGDynamicCollision* o = ((PGDynamicCollision*)(to));
    return [_bodies isEqual:o->_bodies] && [_contacts isEqual:o->_contacts];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [_bodies hash];
    hash = hash * 31 + [_contacts hash];
    return hash;
}

- (CNClassType*)type {
    return [PGDynamicCollision type];
}

+ (CNClassType*)type {
    return _PGDynamicCollision_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGCrossPoint
static CNClassType* _PGCrossPoint_type;
@synthesize body = _body;
@synthesize point = _point;

+ (instancetype)crossPointWithBody:(PGCollisionBody*)body point:(PGVec3)point {
    return [[PGCrossPoint alloc] initWithBody:body point:point];
}

- (instancetype)initWithBody:(PGCollisionBody*)body point:(PGVec3)point {
    self = [super init];
    if(self) {
        _body = body;
        _point = point;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGCrossPoint class]) _PGCrossPoint_type = [CNClassType classTypeWithCls:[PGCrossPoint class]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"CrossPoint(%@, %@)", _body, pgVec3Description(_point)];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[PGCrossPoint class]])) return NO;
    PGCrossPoint* o = ((PGCrossPoint*)(to));
    return [_body isEqual:o->_body] && pgVec3IsEqualTo(_point, o->_point);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [_body hash];
    hash = hash * 31 + pgVec3Hash(_point);
    return hash;
}

- (CNClassType*)type {
    return [PGCrossPoint type];
}

+ (CNClassType*)type {
    return _PGCrossPoint_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGContact
static CNClassType* _PGContact_type;
@synthesize a = _a;
@synthesize b = _b;
@synthesize distance = _distance;
@synthesize impulse = _impulse;
@synthesize lifeTime = _lifeTime;

+ (instancetype)contactWithA:(PGVec3)a b:(PGVec3)b distance:(float)distance impulse:(float)impulse lifeTime:(unsigned int)lifeTime {
    return [[PGContact alloc] initWithA:a b:b distance:distance impulse:impulse lifeTime:lifeTime];
}

- (instancetype)initWithA:(PGVec3)a b:(PGVec3)b distance:(float)distance impulse:(float)impulse lifeTime:(unsigned int)lifeTime {
    self = [super init];
    if(self) {
        _a = a;
        _b = b;
        _distance = distance;
        _impulse = impulse;
        _lifeTime = lifeTime;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGContact class]) _PGContact_type = [CNClassType classTypeWithCls:[PGContact class]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Contact(%@, %@, %f, %f, %u)", pgVec3Description(_a), pgVec3Description(_b), _distance, _impulse, _lifeTime];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[PGContact class]])) return NO;
    PGContact* o = ((PGContact*)(to));
    return pgVec3IsEqualTo(_a, o->_a) && pgVec3IsEqualTo(_b, o->_b) && eqf4(_distance, o->_distance) && eqf4(_impulse, o->_impulse) && _lifeTime == o->_lifeTime;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + pgVec3Hash(_a);
    hash = hash * 31 + pgVec3Hash(_b);
    hash = hash * 31 + float4Hash(_distance);
    hash = hash * 31 + float4Hash(_impulse);
    hash = hash * 31 + _lifeTime;
    return hash;
}

- (CNClassType*)type {
    return [PGContact type];
}

+ (CNClassType*)type {
    return _PGContact_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGIndexFunFilteredIterable
static CNClassType* _PGIndexFunFilteredIterable_type;
@synthesize maxCount = _maxCount;
@synthesize f = _f;

+ (instancetype)indexFunFilteredIterableWithMaxCount:(NSUInteger)maxCount f:(id(^)(NSUInteger))f {
    return [[PGIndexFunFilteredIterable alloc] initWithMaxCount:maxCount f:f];
}

- (instancetype)initWithMaxCount:(NSUInteger)maxCount f:(id(^)(NSUInteger))f {
    self = [super init];
    if(self) {
        _maxCount = maxCount;
        _f = [f copy];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGIndexFunFilteredIterable class]) _PGIndexFunFilteredIterable_type = [CNClassType classTypeWithCls:[PGIndexFunFilteredIterable class]];
}

- (id<CNIterator>)iterator {
    return [PGIndexFunFilteredIterator indexFunFilteredIteratorWithMaxCount:_maxCount f:_f];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"IndexFunFilteredIterable(%lu)", (unsigned long)_maxCount];
}

- (CNClassType*)type {
    return [PGIndexFunFilteredIterable type];
}

+ (CNClassType*)type {
    return _PGIndexFunFilteredIterable_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGIndexFunFilteredIterator
static CNClassType* _PGIndexFunFilteredIterator_type;
@synthesize maxCount = _maxCount;
@synthesize f = _f;

+ (instancetype)indexFunFilteredIteratorWithMaxCount:(NSUInteger)maxCount f:(id(^)(NSUInteger))f {
    return [[PGIndexFunFilteredIterator alloc] initWithMaxCount:maxCount f:f];
}

- (instancetype)initWithMaxCount:(NSUInteger)maxCount f:(id(^)(NSUInteger))f {
    self = [super init];
    if(self) {
        _maxCount = maxCount;
        _f = [f copy];
        _i = 0;
        __next = [self roll];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGIndexFunFilteredIterator class]) _PGIndexFunFilteredIterator_type = [CNClassType classTypeWithCls:[PGIndexFunFilteredIterator class]];
}

- (BOOL)hasNext {
    return __next != nil;
}

- (id)next {
    id ret = __next;
    __next = [self roll];
    return ret;
}

- (id)roll {
    id ret = nil;
    while(ret == nil && _i < _maxCount) {
        ret = _f(_i);
        _i++;
    }
    return ret;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"IndexFunFilteredIterator(%lu)", (unsigned long)_maxCount];
}

- (CNClassType*)type {
    return [PGIndexFunFilteredIterator type];
}

+ (CNClassType*)type {
    return _PGIndexFunFilteredIterator_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGPhysicsBody_impl

+ (instancetype)physicsBody_impl {
    return [[PGPhysicsBody_impl alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

- (id)data {
    @throw @"Method data is abstract";
}

- (id<PGCollisionShape>)shape {
    @throw @"Method shape is abstract";
}

- (BOOL)isKinematic {
    @throw @"Method isKinematic is abstract";
}

- (PGMat4*)matrix {
    @throw @"Method matrix is abstract";
}

- (void)setMatrix:(PGMat4*)matrix {
    @throw @"Method set is abstract";
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGPhysicsWorld
static CNClassType* _PGPhysicsWorld_type;

+ (instancetype)physicsWorld {
    return [[PGPhysicsWorld alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) {
        __bodiesMap = [CNMHashMap hashMap];
        __bodies = ((NSArray*)((@[])));
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGPhysicsWorld class]) _PGPhysicsWorld_type = [CNClassType classTypeWithCls:[PGPhysicsWorld class]];
}

- (void)addBody:(id<PGPhysicsBody>)body {
    __bodies = [__bodies addItem:body];
    [__bodiesMap setKey:[body data] value:body];
    [self _addBody:body];
}

- (void)_addBody:(id<PGPhysicsBody>)body {
    @throw @"Method _add is abstract";
}

- (void)removeBody:(id<PGPhysicsBody>)body {
    [self _removeBody:body];
    [__bodiesMap removeKey:[body data]];
    NSArray* bs = __bodies;
    __bodies = [bs subItem:body];
}

- (BOOL)removeItem:(id)item {
    id __tmp_0;
    {
        id<PGPhysicsBody> body = [__bodiesMap removeKey:item];
        if(body != nil) {
            [self removeBody:body];
            __tmp_0 = @YES;
        } else {
            __tmp_0 = nil;
        }
    }
    if(__tmp_0 != nil) return unumb(__tmp_0);
    else return NO;
}

- (void)_removeBody:(id<PGPhysicsBody>)body {
    @throw @"Method _remove is abstract";
}

- (id<PGPhysicsBody>)bodyForItem:(id)item {
    return [__bodiesMap applyKey:item];
}

- (void)clear {
    for(id<PGPhysicsBody> body in __bodies) {
        [self _removeBody:body];
    }
    __bodies = ((NSArray*)((@[])));
    [__bodiesMap clear];
}

- (id<CNIterable>)bodies {
    return __bodies;
}

- (NSString*)description {
    return @"PhysicsWorld";
}

- (CNClassType*)type {
    return [PGPhysicsWorld type];
}

+ (CNClassType*)type {
    return _PGPhysicsWorld_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

