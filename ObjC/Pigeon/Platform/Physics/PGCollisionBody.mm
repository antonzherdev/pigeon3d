#import "PGCollisionBody.h"

#import "PGMat4.h"

#include "btBulletCollisionCommon.h"
#include "btBox2dShape.h"

NSUInteger pgVec2Hash(PGVec2 self) {
    NSUInteger hash = 0;
    hash = hash * 31 + float4Hash(self.x);
    hash = hash * 31 + float4Hash(self.y);
    return hash;
}
BOOL pgVec2IsEqualTo(PGVec2 self, PGVec2 to) {
    return eqf4(self.x, to.x) && eqf4(self.y, to.y);
}
BOOL pgVec3IsEqualTo(PGVec3 self, PGVec3 to) {
    return eqf4(self.x, to.x) && eqf4(self.y, to.y) && eqf4(self.z, to.z);
}
NSUInteger pgVec3Hash(PGVec3 self) {
    NSUInteger hash = 0;
    hash = hash * 31 + float4Hash(self.x);
    hash = hash * 31 + float4Hash(self.y);
    hash = hash * 31 + float4Hash(self.z);
    return hash;
}


@implementation PGCollisionBody {
    id _data;
    id<PGCollisionShape> _shape;
    BOOL _isKinematic;
    PGMat4 * __matrix;
    btCollisionObject* _obj;
}
@synthesize shape = _shape;
@synthesize isKinematic = _isKinematic;
@synthesize data = _data;
static CNClassType* _PGCollisionBody_type;

- (void*)obj {
    return _obj;
}

+ (id)collisionBodyWithData:(id)data shape:(id<PGCollisionShape>)shape isKinematic:(BOOL)isKinematic {
    return [[PGCollisionBody alloc] initWithData:data shape:shape isKinematic:isKinematic];
}

- (id)initWithData:(id)data shape:(id<PGCollisionShape>)shape isKinematic:(BOOL)isKinematic {
    self = [super init];
    if(self) {
        _data = data;
        _shape = shape;
        _isKinematic = isKinematic;
        _obj = nil;
        __matrix = [PGMat4 identity];
        _obj = new btCollisionObject;
        _obj->setUserPointer((__bridge void *)self);
        if(isKinematic) {
            _obj->setCollisionFlags( _obj->getCollisionFlags() | btCollisionObject::CF_KINEMATIC_OBJECT);
            _obj->setActivationState(DISABLE_DEACTIVATION);
        }
        _obj->setCollisionShape(static_cast<btCollisionShape*>(_shape.shape));
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _PGCollisionBody_type = [CNClassType classTypeWithCls:[PGCollisionBody class]];
}

- (PGMat4 *)matrix {
    return __matrix;
}

- (void)setMatrix:(PGMat4 *)matrix {
    __matrix = matrix;
    _obj->getWorldTransform().setFromOpenGLMatrix(__matrix.array);
}

- (void)translateX:(float)x y:(float)y z:(float)z {
    [self setMatrix:[__matrix translateX:x y:y z:z]];
}

- (void)rotateAngle:(float)angle x:(float)x y:(float)y z:(float)z {
    [self setMatrix:[__matrix rotateAngle:angle x:x y:y z:z]];
}


- (CNClassType*)type {
    return [PGCollisionBody type];
}

+ (CNClassType*)type {
    return _PGCollisionBody_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

- (void)dealloc {
    delete _obj;
}


@end


@implementation PGCollisionBox{
    PGVec3 _size;
    btBoxShape* _box;
}
static CNClassType* _PGCollisionBox_type;
@synthesize size = _size;


+ (id)collisionBoxWithSize:(PGVec3)size {
    return [[PGCollisionBox alloc] initWithSize:size];
}

- (id)initWithSize:(PGVec3)size {
    self = [super init];
    if(self) {
        _size = size;
        _box = new btBoxShape(btVector3(size.x/2, size.y/2, size.z/2));
    }

    return self;
}

+ (PGCollisionBox*)applyX:(float)x y:(float)y z:(float)z {
    return [PGCollisionBox collisionBoxWithSize:PGVec3Make(x, y, z)];
}

- (VoidRef)shape {
    return _box;
}

- (void)dealloc {
    delete _box;
}

+ (void)initialize {
    [super initialize];
    _PGCollisionBox_type = [CNClassType classTypeWithCls:[PGCollisionBox class]];
}

- (CNClassType*)type {
    return [PGCollisionBox type];
}

+ (CNClassType*)type {
    return _PGCollisionBox_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    PGCollisionBox* o = ((PGCollisionBox*)(other));
    return pgVec3IsEqualTo(self.size, o.size);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + pgVec3Hash(self.size);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"size=<%f, %f, %f>", self.size.x, self.size.y, self.size.z];
    [description appendString:@">"];
    return description;
}

@end

@implementation PGCollisionBox2d{
    PGVec2 _size;
    btBox2dShape* _box;
}
static CNClassType* _PGCollisionBox2d_type;
@synthesize size = _size;


+ (id)collisionBox2dWithSize:(PGVec2)size {
    return [[PGCollisionBox2d alloc] initWithSize:size];
}

- (id)initWithSize:(PGVec2)size {
    self = [super init];
    if(self) {
        _size = size;
        _box = new btBox2dShape(btVector3(size.x/2, size.y/2, 0));
    }

    return self;
}

+ (PGCollisionBox2d*)applyX:(float)x y:(float)y{
    return [PGCollisionBox2d collisionBox2dWithSize:PGVec2Make(x, y)];
}

- (VoidRef)shape {
    return _box;
}

- (void)dealloc {
    delete _box;
}

+ (void)initialize {
    [super initialize];
    _PGCollisionBox2d_type = [CNClassType classTypeWithCls:[PGCollisionBox2d class]];
}

- (CNClassType*)type {
    return [PGCollisionBox type];
}

+ (CNClassType*)type {
    return _PGCollisionBox2d_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    PGCollisionBox2d* o = ((PGCollisionBox2d*)(other));
    return pgVec2IsEqualTo(self.size, o.size);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + pgVec2Hash(self.size);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"size=<%f, %f>", self.size.x, self.size.y];
    [description appendString:@">"];
    return description;
}

@end


@implementation PGCollisionPlane{
    PGVec3 _normal;
    float _distance;
    btStaticPlaneShape* _plane;
}
static CNClassType* _PGCollisionPlane_type;
@synthesize normal = _normal;
@synthesize distance = _distance;

+ (id)collisionPlaneWithNormal:(PGVec3)normal distance:(float)distance {
    return [[PGCollisionPlane alloc] initWithNormal:normal distance:distance];
}

- (id)initWithNormal:(PGVec3)normal distance:(float)distance {
    self = [super init];
    if(self) {
        _normal = normal;
        _distance = distance;
        _plane = new btStaticPlaneShape(btVector3(normal.x, normal.y, normal.z), distance);
    }

    return self;
}

- (void)dealloc {
    delete _plane;
}

+ (void)initialize {
    [super initialize];
    _PGCollisionPlane_type = [CNClassType classTypeWithCls:[PGCollisionPlane class]];
}

- (VoidRef)shape {
    return _plane;
}

- (CNClassType*)type {
    return [PGCollisionPlane type];
}

+ (CNClassType*)type {
    return _PGCollisionPlane_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    PGCollisionPlane* o = ((PGCollisionPlane*)(other));
    return pgVec3IsEqualTo(self.normal, o.normal) && eqf4(self.distance, o.distance);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + pgVec3Hash(self.normal);
    hash = hash * 31 + float4Hash(self.distance);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"normal=<%f, %f, %f>", self.normal.x, self.normal.y, self.normal.z];
    [description appendFormat:@", distance=%f", self.distance];
    [description appendString:@">"];
    return description;
}

@end

