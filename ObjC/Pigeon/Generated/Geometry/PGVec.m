#import "PGVec.h"

#import "math.h"
#import "PGMat4.h"
#import "CNChain.h"
#import "CNSortBuilder.h"
PGVec2 pgVec2ApplyVec2i(PGVec2i vec2i) {
    return PGVec2Make(((float)(vec2i.x)), ((float)(vec2i.y)));
}
PGVec2 pgVec2ApplyF(CGFloat f) {
    return PGVec2Make(((float)(f)), ((float)(f)));
}
PGVec2 pgVec2ApplyF4(float f4) {
    return PGVec2Make(f4, f4);
}
PGVec2 pgVec2Min() {
    return PGVec2Make(cnFloat4Min(), cnFloat4Min());
}
PGVec2 pgVec2Max() {
    return PGVec2Make(cnFloat4Max(), cnFloat4Max());
}
PGVec2 pgVec2AddVec2(PGVec2 self, PGVec2 vec2) {
    return PGVec2Make(self.x + vec2.x, self.y + vec2.y);
}
PGVec2 pgVec2AddF4(PGVec2 self, float f4) {
    return PGVec2Make(self.x + f4, self.y + f4);
}
PGVec2 pgVec2AddF(PGVec2 self, CGFloat f) {
    return PGVec2Make(self.x + f, self.y + f);
}
PGVec2 pgVec2AddI(PGVec2 self, NSInteger i) {
    return PGVec2Make(self.x + i, self.y + i);
}
PGVec2 pgVec2SubVec2(PGVec2 self, PGVec2 vec2) {
    return PGVec2Make(self.x - vec2.x, self.y - vec2.y);
}
PGVec2 pgVec2SubF4(PGVec2 self, float f4) {
    return PGVec2Make(self.x - f4, self.y - f4);
}
PGVec2 pgVec2SubF(PGVec2 self, CGFloat f) {
    return PGVec2Make(self.x - f, self.y - f);
}
PGVec2 pgVec2SubI(PGVec2 self, NSInteger i) {
    return PGVec2Make(self.x - i, self.y - i);
}
PGVec2 pgVec2MulVec2(PGVec2 self, PGVec2 vec2) {
    return PGVec2Make(self.x * vec2.x, self.y * vec2.y);
}
PGVec2 pgVec2MulF4(PGVec2 self, float f4) {
    return PGVec2Make(self.x * f4, self.y * f4);
}
PGVec2 pgVec2MulF(PGVec2 self, CGFloat f) {
    return PGVec2Make(self.x * f, self.y * f);
}
PGVec2 pgVec2MulI(PGVec2 self, NSInteger i) {
    return PGVec2Make(self.x * i, self.y * i);
}
PGVec2 pgVec2DivVec2(PGVec2 self, PGVec2 vec2) {
    return PGVec2Make(self.x / vec2.x, self.y / vec2.y);
}
PGVec2 pgVec2DivF4(PGVec2 self, float f4) {
    return PGVec2Make(self.x / f4, self.y / f4);
}
PGVec2 pgVec2DivF(PGVec2 self, CGFloat f) {
    return PGVec2Make(self.x / f, self.y / f);
}
PGVec2 pgVec2DivI(PGVec2 self, NSInteger i) {
    return PGVec2Make(self.x / i, self.y / i);
}
PGVec2 pgVec2Negate(PGVec2 self) {
    return PGVec2Make(-self.x, -self.y);
}
float pgVec2DegreeAngle(PGVec2 self) {
    return ((float)(180.0 / M_PI * atan2(((CGFloat)(self.y)), ((CGFloat)(self.x)))));
}
float pgVec2Angle(PGVec2 self) {
    return ((float)(atan2(((CGFloat)(self.y)), ((CGFloat)(self.x)))));
}
float pgVec2DotVec2(PGVec2 self, PGVec2 vec2) {
    return self.x * vec2.x + self.y * vec2.y;
}
float pgVec2CrossVec2(PGVec2 self, PGVec2 vec2) {
    return self.x * vec2.y - vec2.x * self.y;
}
float pgVec2LengthSquare(PGVec2 self) {
    return pgVec2DotVec2(self, self);
}
float pgVec2Length(PGVec2 self) {
    return ((float)(sqrt(((CGFloat)(pgVec2LengthSquare(self))))));
}
PGVec2 pgVec2MidVec2(PGVec2 self, PGVec2 vec2) {
    return pgVec2MulF((pgVec2AddVec2(self, vec2)), 0.5);
}
float pgVec2DistanceToVec2(PGVec2 self, PGVec2 vec2) {
    return pgVec2Length((pgVec2SubVec2(self, vec2)));
}
PGVec2 pgVec2SetLength(PGVec2 self, float length) {
    return pgVec2MulF4(self, length / pgVec2Length(self));
}
PGVec2 pgVec2Normalize(PGVec2 self) {
    return pgVec2SetLength(self, 1.0);
}
NSInteger pgVec2CompareTo(PGVec2 self, PGVec2 to) {
    NSInteger dX = float4CompareTo(self.x, to.x);
    if(dX != 0) return dX;
    else return float4CompareTo(self.y, to.y);
}
PGRect pgVec2RectToVec2(PGVec2 self, PGVec2 vec2) {
    return PGRectMake(self, (pgVec2SubVec2(vec2, self)));
}
PGRect pgVec2RectInCenterWithSize(PGVec2 self, PGVec2 size) {
    return PGRectMake((pgVec2MulF((pgVec2SubVec2(size, self)), 0.5)), self);
}
PGVec2 pgVec2Rnd() {
    return PGVec2Make(cnFloat4Rnd() - 0.5, cnFloat4Rnd() - 0.5);
}
BOOL pgVec2IsEmpty(PGVec2 self) {
    return eqf4(self.x, 0) && eqf4(self.y, 0);
}
PGVec2i pgVec2Round(PGVec2 self) {
    return PGVec2iMake(float4Round(self.x), float4Round(self.y));
}
PGVec2 pgVec2MinVec2(PGVec2 self, PGVec2 vec2) {
    return PGVec2Make((float4MinB(self.x, vec2.x)), (float4MinB(self.y, vec2.y)));
}
PGVec2 pgVec2MaxVec2(PGVec2 self, PGVec2 vec2) {
    return PGVec2Make((float4MaxB(self.x, vec2.x)), (float4MaxB(self.y, vec2.y)));
}
PGVec2 pgVec2Abs(PGVec2 self) {
    return PGVec2Make(float4Abs(self.x), float4Abs(self.y));
}
float pgVec2Ratio(PGVec2 self) {
    return self.x / self.y;
}
NSString* pgVec2Description(PGVec2 self) {
    return [NSString stringWithFormat:@"vec2(%f, %f)", self.x, self.y];
}
BOOL pgVec2IsEqualTo(PGVec2 self, PGVec2 to) {
    return eqf4(self.x, to.x) && eqf4(self.y, to.y);
}
NSUInteger pgVec2Hash(PGVec2 self) {
    NSUInteger hash = 0;
    hash = hash * 31 + float4Hash(self.x);
    hash = hash * 31 + float4Hash(self.y);
    return hash;
}
CNPType* pgVec2Type() {
    static CNPType* _ret = nil;
    if(_ret == nil) _ret = [CNPType typeWithCls:[PGVec2Wrap class] name:@"PGVec2" size:sizeof(PGVec2) wrap:^id(void* data, NSUInteger i) {
        return wrap(PGVec2, ((PGVec2*)(data))[i]);
    }];
    return _ret;
}
@implementation PGVec2Wrap{
    PGVec2 _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(PGVec2)value {
    return [[PGVec2Wrap alloc] initWithValue:value];
}

- (id)initWithValue:(PGVec2)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return pgVec2Description(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    PGVec2Wrap* o = ((PGVec2Wrap*)(other));
    return pgVec2IsEqualTo(_value, o.value);
}

- (NSUInteger)hash {
    return pgVec2Hash(_value);
}

- (NSInteger)compareTo:(PGVec2Wrap*)to {
    return pgVec2CompareTo(_value, to.value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


@implementation PGVec2Buffer
static CNClassType* _PGVec2Buffer_type;

+ (instancetype)vec2BufferWithCount:(NSUInteger)count {
    return [[PGVec2Buffer alloc] initWithCount:count];
}

- (instancetype)initWithCount:(NSUInteger)count {
    self = [super initWithTp:pgVec2Type() count:((unsigned int)(count))];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGVec2Buffer class]) _PGVec2Buffer_type = [CNClassType classTypeWithCls:[PGVec2Buffer class]];
}

- (PGVec2)get {
    if(__position >= _count) @throw @"Out of bound";
    PGVec2 __il_r = *(((PGVec2*)(__pointer)));
    __pointer = ((PGVec2*)(__pointer)) + 1;
    __position++;
    return __il_r;
}

- (void)setX:(float)x y:(float)y {
    if(__position >= _count) @throw @"Out of bound";
    *(((float*)(self._pointer))) = x;
    *(((float*)(self._pointer)) + 1) = y;
    {
        __pointer = ((PGVec2*)(__pointer)) + 1;
        __position++;
    }
}

- (void)setV:(PGVec2)v {
    if(__position >= _count) @throw @"Out of bound";
    *(((PGVec2*)(__pointer))) = v;
    __pointer = ((PGVec2*)(__pointer)) + 1;
    __position++;
}

- (NSString*)description {
    return @"Vec2Buffer";
}

- (CNClassType*)type {
    return [PGVec2Buffer type];
}

+ (CNClassType*)type {
    return _PGVec2Buffer_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

PGVec2i pgVec2iApplyVec2(PGVec2 vec2) {
    return PGVec2iMake(float4Round(vec2.x), float4Round(vec2.y));
}
PGVec2 pgVec2iAddVec2(PGVec2i self, PGVec2 vec2) {
    return PGVec2Make(self.x + vec2.x, self.y + vec2.y);
}
PGVec2i pgVec2iAddVec2i(PGVec2i self, PGVec2i vec2i) {
    return PGVec2iMake(self.x + vec2i.x, self.y + vec2i.y);
}
PGVec2 pgVec2iSubVec2(PGVec2i self, PGVec2 vec2) {
    return PGVec2Make(self.x - vec2.x, self.y - vec2.y);
}
PGVec2i pgVec2iSubVec2i(PGVec2i self, PGVec2i vec2i) {
    return PGVec2iMake(self.x - vec2i.x, self.y - vec2i.y);
}
PGVec2i pgVec2iMulI(PGVec2i self, NSInteger i) {
    return PGVec2iMake(self.x * i, self.y * i);
}
PGVec2 pgVec2iMulF(PGVec2i self, CGFloat f) {
    return PGVec2Make(((float)(self.x)) * f, ((float)(self.y)) * f);
}
PGVec2 pgVec2iMulF4(PGVec2i self, float f4) {
    return PGVec2Make(((float)(self.x)) * f4, ((float)(self.y)) * f4);
}
PGVec2 pgVec2iDivF4(PGVec2i self, float f4) {
    return PGVec2Make(((float)(self.x)) / f4, ((float)(self.y)) / f4);
}
PGVec2 pgVec2iDivF(PGVec2i self, CGFloat f) {
    return PGVec2Make(((float)(self.x)) / f, ((float)(self.y)) / f);
}
PGVec2i pgVec2iDivI(PGVec2i self, NSInteger i) {
    return PGVec2iMake(self.x / i, self.y / i);
}
PGVec2i pgVec2iNegate(PGVec2i self) {
    return PGVec2iMake(-self.x, -self.y);
}
NSInteger pgVec2iCompareTo(PGVec2i self, PGVec2i to) {
    NSInteger dX = intCompareTo(self.x, to.x);
    if(dX != 0) return dX;
    else return intCompareTo(self.y, to.y);
}
PGRectI pgVec2iRectToVec2i(PGVec2i self, PGVec2i vec2i) {
    return PGRectIMake(self, (pgVec2iSubVec2i(vec2i, self)));
}
NSInteger pgVec2iDotVec2i(PGVec2i self, PGVec2i vec2i) {
    return self.x * vec2i.x + self.y * vec2i.y;
}
NSInteger pgVec2iLengthSquare(PGVec2i self) {
    return pgVec2iDotVec2i(self, self);
}
float pgVec2iLength(PGVec2i self) {
    return ((float)(sqrt(((CGFloat)(pgVec2iLengthSquare(self))))));
}
float pgVec2iRatio(PGVec2i self) {
    return ((float)(self.x)) / ((float)(self.y));
}
NSString* pgVec2iDescription(PGVec2i self) {
    return [NSString stringWithFormat:@"vec2i(%ld, %ld)", (long)self.x, (long)self.y];
}
BOOL pgVec2iIsEqualTo(PGVec2i self, PGVec2i to) {
    return self.x == to.x && self.y == to.y;
}
NSUInteger pgVec2iHash(PGVec2i self) {
    NSUInteger hash = 0;
    hash = hash * 31 + self.x;
    hash = hash * 31 + self.y;
    return hash;
}
CNPType* pgVec2iType() {
    static CNPType* _ret = nil;
    if(_ret == nil) _ret = [CNPType typeWithCls:[PGVec2iWrap class] name:@"PGVec2i" size:sizeof(PGVec2i) wrap:^id(void* data, NSUInteger i) {
        return wrap(PGVec2i, ((PGVec2i*)(data))[i]);
    }];
    return _ret;
}
@implementation PGVec2iWrap{
    PGVec2i _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(PGVec2i)value {
    return [[PGVec2iWrap alloc] initWithValue:value];
}

- (id)initWithValue:(PGVec2i)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return pgVec2iDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    PGVec2iWrap* o = ((PGVec2iWrap*)(other));
    return pgVec2iIsEqualTo(_value, o.value);
}

- (NSUInteger)hash {
    return pgVec2iHash(_value);
}

- (NSInteger)compareTo:(PGVec2iWrap*)to {
    return pgVec2iCompareTo(_value, to.value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


PGVec3 pgVec3ApplyVec2(PGVec2 vec2) {
    return PGVec3Make(vec2.x, vec2.y, 0.0);
}
PGVec3 pgVec3ApplyVec2Z(PGVec2 vec2, float z) {
    return PGVec3Make(vec2.x, vec2.y, z);
}
PGVec3 pgVec3ApplyVec2iZ(PGVec2i vec2i, float z) {
    return PGVec3Make(((float)(vec2i.x)), ((float)(vec2i.y)), z);
}
PGVec3 pgVec3ApplyF4(float f4) {
    return PGVec3Make(f4, f4, f4);
}
PGVec3 pgVec3ApplyF(CGFloat f) {
    return PGVec3Make(((float)(f)), ((float)(f)), ((float)(f)));
}
PGVec3 pgVec3AddVec3(PGVec3 self, PGVec3 vec3) {
    return PGVec3Make(self.x + vec3.x, self.y + vec3.y, self.z + vec3.z);
}
PGVec3 pgVec3SubVec3(PGVec3 self, PGVec3 vec3) {
    return PGVec3Make(self.x - vec3.x, self.y - vec3.y, self.z - vec3.z);
}
PGVec3 pgVec3Sqr(PGVec3 self) {
    return pgVec3MulK(self, ((float)(pgVec3Length(self))));
}
PGVec3 pgVec3Negate(PGVec3 self) {
    return PGVec3Make(-self.x, -self.y, -self.z);
}
PGVec3 pgVec3MulK(PGVec3 self, float k) {
    return PGVec3Make(k * self.x, k * self.y, k * self.z);
}
float pgVec3DotVec3(PGVec3 self, PGVec3 vec3) {
    return self.x * vec3.x + self.y * vec3.y + self.z * vec3.z;
}
PGVec3 pgVec3CrossVec3(PGVec3 self, PGVec3 vec3) {
    return PGVec3Make(self.y * vec3.z - self.z * vec3.y, self.x * vec3.z - vec3.x * self.z, self.x * vec3.y - vec3.x * self.y);
}
float pgVec3LengthSquare(PGVec3 self) {
    return self.x * self.x + self.y * self.y + self.z * self.z;
}
CGFloat pgVec3Length(PGVec3 self) {
    return sqrt(((CGFloat)(pgVec3LengthSquare(self))));
}
PGVec3 pgVec3SetLength(PGVec3 self, float length) {
    return pgVec3MulK(self, length / pgVec3Length(self));
}
PGVec3 pgVec3Normalize(PGVec3 self) {
    return pgVec3SetLength(self, 1.0);
}
PGVec2 pgVec3Xy(PGVec3 self) {
    return PGVec2Make(self.x, self.y);
}
PGVec3 pgVec3Rnd() {
    return PGVec3Make(cnFloat4Rnd() - 0.5, cnFloat4Rnd() - 0.5, cnFloat4Rnd() - 0.5);
}
BOOL pgVec3IsEmpty(PGVec3 self) {
    return eqf4(self.x, 0) && eqf4(self.y, 0) && eqf4(self.z, 0);
}
NSString* pgVec3Description(PGVec3 self) {
    return [NSString stringWithFormat:@"vec3(%f, %f, %f)", self.x, self.y, self.z];
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
CNPType* pgVec3Type() {
    static CNPType* _ret = nil;
    if(_ret == nil) _ret = [CNPType typeWithCls:[PGVec3Wrap class] name:@"PGVec3" size:sizeof(PGVec3) wrap:^id(void* data, NSUInteger i) {
        return wrap(PGVec3, ((PGVec3*)(data))[i]);
    }];
    return _ret;
}
@implementation PGVec3Wrap{
    PGVec3 _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(PGVec3)value {
    return [[PGVec3Wrap alloc] initWithValue:value];
}

- (id)initWithValue:(PGVec3)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return pgVec3Description(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    PGVec3Wrap* o = ((PGVec3Wrap*)(other));
    return pgVec3IsEqualTo(_value, o.value);
}

- (NSUInteger)hash {
    return pgVec3Hash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


PGVec4 pgVec4ApplyF(CGFloat f) {
    return PGVec4Make(((float)(f)), ((float)(f)), ((float)(f)), ((float)(f)));
}
PGVec4 pgVec4ApplyF4(float f4) {
    return PGVec4Make(f4, f4, f4, f4);
}
PGVec4 pgVec4ApplyVec3W(PGVec3 vec3, float w) {
    return PGVec4Make(vec3.x, vec3.y, vec3.z, w);
}
PGVec4 pgVec4ApplyVec2ZW(PGVec2 vec2, float z, float w) {
    return PGVec4Make(vec2.x, vec2.y, z, w);
}
PGVec4 pgVec4AddVec2(PGVec4 self, PGVec2 vec2) {
    return PGVec4Make(self.x + vec2.x, self.y + vec2.y, self.z, self.w);
}
PGVec4 pgVec4AddVec3(PGVec4 self, PGVec3 vec3) {
    return PGVec4Make(self.x + vec3.x, self.y + vec3.y, self.z + vec3.z, self.w);
}
PGVec4 pgVec4AddVec4(PGVec4 self, PGVec4 vec4) {
    return PGVec4Make(self.x + vec4.x, self.y + vec4.y, self.z + vec4.z, self.w + vec4.w);
}
PGVec3 pgVec4Xyz(PGVec4 self) {
    return PGVec3Make(self.x, self.y, self.z);
}
PGVec2 pgVec4Xy(PGVec4 self) {
    return PGVec2Make(self.x, self.y);
}
PGVec4 pgVec4MulK(PGVec4 self, float k) {
    return PGVec4Make(k * self.x, k * self.y, k * self.z, k * self.w);
}
PGVec4 pgVec4DivMat4(PGVec4 self, PGMat4* mat4) {
    return [mat4 divBySelfVec4:self];
}
PGVec4 pgVec4DivF4(PGVec4 self, float f4) {
    return PGVec4Make(self.x / f4, self.y / f4, self.z / f4, self.w / f4);
}
PGVec4 pgVec4DivF(PGVec4 self, CGFloat f) {
    return PGVec4Make(self.x / f, self.y / f, self.z / f, self.w / f);
}
PGVec4 pgVec4DivI(PGVec4 self, NSInteger i) {
    return PGVec4Make(self.x / i, self.y / i, self.z / i, self.w / i);
}
float pgVec4LengthSquare(PGVec4 self) {
    return self.x * self.x + self.y * self.y + self.z * self.z + self.w * self.w;
}
CGFloat pgVec4Length(PGVec4 self) {
    return sqrt(((CGFloat)(pgVec4LengthSquare(self))));
}
PGVec4 pgVec4SetLength(PGVec4 self, float length) {
    return pgVec4MulK(self, length / pgVec4Length(self));
}
PGVec4 pgVec4Normalize(PGVec4 self) {
    return pgVec4SetLength(self, 1.0);
}
NSString* pgVec4Description(PGVec4 self) {
    return [NSString stringWithFormat:@"vec4(%f, %f, %f, %f)", self.x, self.y, self.z, self.w];
}
BOOL pgVec4IsEqualTo(PGVec4 self, PGVec4 to) {
    return eqf4(self.x, to.x) && eqf4(self.y, to.y) && eqf4(self.z, to.z) && eqf4(self.w, to.w);
}
NSUInteger pgVec4Hash(PGVec4 self) {
    NSUInteger hash = 0;
    hash = hash * 31 + float4Hash(self.x);
    hash = hash * 31 + float4Hash(self.y);
    hash = hash * 31 + float4Hash(self.z);
    hash = hash * 31 + float4Hash(self.w);
    return hash;
}
CNPType* pgVec4Type() {
    static CNPType* _ret = nil;
    if(_ret == nil) _ret = [CNPType typeWithCls:[PGVec4Wrap class] name:@"PGVec4" size:sizeof(PGVec4) wrap:^id(void* data, NSUInteger i) {
        return wrap(PGVec4, ((PGVec4*)(data))[i]);
    }];
    return _ret;
}
@implementation PGVec4Wrap{
    PGVec4 _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(PGVec4)value {
    return [[PGVec4Wrap alloc] initWithValue:value];
}

- (id)initWithValue:(PGVec4)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return pgVec4Description(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    PGVec4Wrap* o = ((PGVec4Wrap*)(other));
    return pgVec4IsEqualTo(_value, o.value);
}

- (NSUInteger)hash {
    return pgVec4Hash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


BOOL pgTriangleContainsVec2(PGTriangle self, PGVec2 vec2) {
    PGVec2 r0 = pgVec2SubVec2(self.p0, vec2);
    PGVec2 r1 = pgVec2SubVec2(self.p1, vec2);
    PGVec2 r2 = pgVec2SubVec2(self.p2, vec2);
    float c0 = pgVec2CrossVec2(r0, r1);
    float c1 = pgVec2CrossVec2(r1, r2);
    float c2 = pgVec2CrossVec2(r2, r0);
    return (c0 > 0 && c1 > 0 && c2 > 0) || (c0 < 0 && c1 < 0 && c2 < 0);
}
NSString* pgTriangleDescription(PGTriangle self) {
    return [NSString stringWithFormat:@"Triangle(%@, %@, %@)", pgVec2Description(self.p0), pgVec2Description(self.p1), pgVec2Description(self.p2)];
}
BOOL pgTriangleIsEqualTo(PGTriangle self, PGTriangle to) {
    return pgVec2IsEqualTo(self.p0, to.p0) && pgVec2IsEqualTo(self.p1, to.p1) && pgVec2IsEqualTo(self.p2, to.p2);
}
NSUInteger pgTriangleHash(PGTriangle self) {
    NSUInteger hash = 0;
    hash = hash * 31 + pgVec2Hash(self.p0);
    hash = hash * 31 + pgVec2Hash(self.p1);
    hash = hash * 31 + pgVec2Hash(self.p2);
    return hash;
}
CNPType* pgTriangleType() {
    static CNPType* _ret = nil;
    if(_ret == nil) _ret = [CNPType typeWithCls:[PGTriangleWrap class] name:@"PGTriangle" size:sizeof(PGTriangle) wrap:^id(void* data, NSUInteger i) {
        return wrap(PGTriangle, ((PGTriangle*)(data))[i]);
    }];
    return _ret;
}
@implementation PGTriangleWrap{
    PGTriangle _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(PGTriangle)value {
    return [[PGTriangleWrap alloc] initWithValue:value];
}

- (id)initWithValue:(PGTriangle)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return pgTriangleDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    PGTriangleWrap* o = ((PGTriangleWrap*)(other));
    return pgTriangleIsEqualTo(_value, o.value);
}

- (NSUInteger)hash {
    return pgTriangleHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


PGQuad pgQuadApplySize(float size) {
    return PGQuadMake((PGVec2Make(-size, -size)), (PGVec2Make(size, -size)), (PGVec2Make(size, size)), (PGVec2Make(-size, size)));
}
PGQuad pgQuadAddVec2(PGQuad self, PGVec2 vec2) {
    return PGQuadMake((pgVec2AddVec2(self.p0, vec2)), (pgVec2AddVec2(self.p1, vec2)), (pgVec2AddVec2(self.p2, vec2)), (pgVec2AddVec2(self.p3, vec2)));
}
PGQuad pgQuadAddXY(PGQuad self, float x, float y) {
    return pgQuadAddVec2(self, (PGVec2Make(x, y)));
}
PGQuad pgQuadMulValue(PGQuad self, float value) {
    return PGQuadMake((pgVec2MulF4(self.p0, value)), (pgVec2MulF4(self.p1, value)), (pgVec2MulF4(self.p2, value)), (pgVec2MulF4(self.p3, value)));
}
PGQuad pgQuadMulMat3(PGQuad self, PGMat3* mat3) {
    return PGQuadMake([mat3 mulVec2:self.p0], [mat3 mulVec2:self.p1], [mat3 mulVec2:self.p2], [mat3 mulVec2:self.p3]);
}
PGQuadrant pgQuadQuadrant(PGQuad self) {
    float x = (self.p1.x - self.p0.x) / 2;
    float y = (self.p3.y - self.p0.y) / 2;
    PGQuad q = pgQuadAddVec2((pgQuadMulValue(self, 0.5)), self.p0);
    return PGQuadrantMake(((PGQuad[]){q, pgQuadAddXY(q, x, 0.0), pgQuadAddXY(q, x, y), pgQuadAddXY(q, 0.0, y)}));
}
PGVec2 pgQuadApplyIndex(PGQuad self, NSUInteger index) {
    if(index == 0) {
        return self.p0;
    } else {
        if(index == 1) {
            return self.p1;
        } else {
            if(index == 2) {
                return self.p2;
            } else {
                if(index == 3) return self.p3;
                else @throw @"Incorrect quad index";
            }
        }
    }
}
PGRect pgQuadBoundingRect(PGQuad self) {
    CGFloat minX = cnFloatMax();
    CGFloat maxX = cnFloatMin();
    CGFloat minY = cnFloatMax();
    CGFloat maxY = cnFloatMin();
    NSInteger i = 0;
    while(i < 4) {
        PGVec2 pp = pgQuadApplyIndex(self, ((NSUInteger)(i)));
        if(pp.x < minX) minX = ((CGFloat)(pp.x));
        if(pp.x > maxX) maxX = ((CGFloat)(pp.x));
        if(pp.y < minY) minY = ((CGFloat)(pp.y));
        if(pp.y > maxY) maxY = ((CGFloat)(pp.y));
        i++;
    }
    return pgVec2RectToVec2((PGVec2Make(((float)(minX)), ((float)(minY)))), (PGVec2Make(((float)(maxX)), ((float)(maxY)))));
}
NSArray* pgQuadLines(PGQuad self) {
    return (@[wrap(PGLine2, (pgLine2ApplyP0P1(self.p0, self.p1))), wrap(PGLine2, (pgLine2ApplyP0P1(self.p1, self.p2))), wrap(PGLine2, (pgLine2ApplyP0P1(self.p2, self.p3))), wrap(PGLine2, (pgLine2ApplyP0P1(self.p3, self.p0)))]);
}
NSArray* pgQuadPs(PGQuad self) {
    return (@[wrap(PGVec2, self.p0), wrap(PGVec2, self.p1), wrap(PGVec2, self.p2), wrap(PGVec2, self.p3)]);
}
PGVec2 pgQuadClosestPointForVec2(PGQuad self, PGVec2 vec2) {
    if(pgQuadContainsVec2(self, vec2)) {
        return vec2;
    } else {
        NSArray* projs = [[[pgQuadLines(self) chain] mapOptF:^id(id _) {
            return pgLine2ProjectionOnSegmentVec2((uwrap(PGLine2, _)), vec2);
        }] toArray];
        if([projs isEmpty]) projs = pgQuadPs(self);
        {
            id __tmp_0f_2 = [[[[[projs chain] sortBy] ascBy:^id(id _) {
                return numf4((pgVec2LengthSquare((pgVec2SubVec2((uwrap(PGVec2, _)), vec2)))));
            }] endSort] head];
            if(__tmp_0f_2 != nil) return uwrap(PGVec2, __tmp_0f_2);
            else return self.p0;
        }
    }
}
BOOL pgQuadContainsVec2(PGQuad self, PGVec2 vec2) {
    return pgRectContainsVec2(pgQuadBoundingRect(self), vec2) && (pgTriangleContainsVec2((PGTriangleMake(self.p0, self.p1, self.p2)), vec2) || pgTriangleContainsVec2((PGTriangleMake(self.p2, self.p3, self.p0)), vec2));
}
PGQuad pgQuadMapF(PGQuad self, PGVec2(^f)(PGVec2)) {
    return PGQuadMake(f(self.p0), f(self.p1), f(self.p2), f(self.p3));
}
PGVec2 pgQuadCenter(PGQuad self) {
    id __tmp;
    {
        id __tmp_e1 = pgLine2CrossPointLine2((pgLine2ApplyP0P1(self.p0, self.p2)), (pgLine2ApplyP0P1(self.p1, self.p3)));
        if(__tmp_e1 != nil) __tmp = __tmp_e1;
        else __tmp = pgLine2CrossPointLine2((pgLine2ApplyP0P1(self.p0, self.p1)), (pgLine2ApplyP0P1(self.p2, self.p3)));
    }
    if(__tmp != nil) return uwrap(PGVec2, __tmp);
    else return self.p0;
}
NSString* pgQuadDescription(PGQuad self) {
    return [NSString stringWithFormat:@"Quad(%@, %@, %@, %@)", pgVec2Description(self.p0), pgVec2Description(self.p1), pgVec2Description(self.p2), pgVec2Description(self.p3)];
}
BOOL pgQuadIsEqualTo(PGQuad self, PGQuad to) {
    return pgVec2IsEqualTo(self.p0, to.p0) && pgVec2IsEqualTo(self.p1, to.p1) && pgVec2IsEqualTo(self.p2, to.p2) && pgVec2IsEqualTo(self.p3, to.p3);
}
NSUInteger pgQuadHash(PGQuad self) {
    NSUInteger hash = 0;
    hash = hash * 31 + pgVec2Hash(self.p0);
    hash = hash * 31 + pgVec2Hash(self.p1);
    hash = hash * 31 + pgVec2Hash(self.p2);
    hash = hash * 31 + pgVec2Hash(self.p3);
    return hash;
}
PGQuad pgQuadIdentity() {
    static PGQuad _ret = (PGQuad){{0.0, 0.0}, {1.0, 0.0}, {1.0, 1.0}, {0.0, 1.0}};
    return _ret;
}
CNPType* pgQuadType() {
    static CNPType* _ret = nil;
    if(_ret == nil) _ret = [CNPType typeWithCls:[PGQuadWrap class] name:@"PGQuad" size:sizeof(PGQuad) wrap:^id(void* data, NSUInteger i) {
        return wrap(PGQuad, ((PGQuad*)(data))[i]);
    }];
    return _ret;
}
@implementation PGQuadWrap{
    PGQuad _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(PGQuad)value {
    return [[PGQuadWrap alloc] initWithValue:value];
}

- (id)initWithValue:(PGQuad)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return pgQuadDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    PGQuadWrap* o = ((PGQuadWrap*)(other));
    return pgQuadIsEqualTo(_value, o.value);
}

- (NSUInteger)hash {
    return pgQuadHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


PGQuad pgQuadrantRndQuad(PGQuadrant self) {
    return self.quads[cnuIntRndMax(3)];
}
NSString* pgQuadrantDescription(PGQuadrant self) {
    return [NSString stringWithFormat:@"Quadrant([%@, %@, %@, %@])", pgQuadDescription(self.quads[0]), pgQuadDescription(self.quads[1]), pgQuadDescription(self.quads[2]), pgQuadDescription(self.quads[3])];
}
BOOL pgQuadrantIsEqualTo(PGQuadrant self, PGQuadrant to) {
    return self.quads == to.quads;
}
NSUInteger pgQuadrantHash(PGQuadrant self) {
    NSUInteger hash = 0;
    hash = hash * 31 + 13 * (13 * (13 * pgQuadHash(self.quads[0]) + pgQuadHash(self.quads[1])) + pgQuadHash(self.quads[2])) + pgQuadHash(self.quads[3]);
    return hash;
}
CNPType* pgQuadrantType() {
    static CNPType* _ret = nil;
    if(_ret == nil) _ret = [CNPType typeWithCls:[PGQuadrantWrap class] name:@"PGQuadrant" size:sizeof(PGQuadrant) wrap:^id(void* data, NSUInteger i) {
        return wrap(PGQuadrant, ((PGQuadrant*)(data))[i]);
    }];
    return _ret;
}
@implementation PGQuadrantWrap{
    PGQuadrant _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(PGQuadrant)value {
    return [[PGQuadrantWrap alloc] initWithValue:value];
}

- (id)initWithValue:(PGQuadrant)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return pgQuadrantDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    PGQuadrantWrap* o = ((PGQuadrantWrap*)(other));
    return pgQuadrantIsEqualTo(_value, o.value);
}

- (NSUInteger)hash {
    return pgQuadrantHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


PGRect pgRectApplyXYWidthHeight(float x, float y, float width, float height) {
    return PGRectMake((PGVec2Make(x, y)), (PGVec2Make(width, height)));
}
PGRect pgRectApplyXYSize(float x, float y, PGVec2 size) {
    return PGRectMake((PGVec2Make(x, y)), size);
}
PGRect pgRectApplyRectI(PGRectI rectI) {
    return PGRectMake(pgVec2ApplyVec2i(rectI.p), pgVec2ApplyVec2i(rectI.size));
}
float pgRectX(PGRect self) {
    return self.p.x;
}
float pgRectY(PGRect self) {
    return self.p.y;
}
float pgRectX2(PGRect self) {
    return self.p.x + self.size.x;
}
float pgRectY2(PGRect self) {
    return self.p.y + self.size.y;
}
float pgRectWidth(PGRect self) {
    return self.size.x;
}
float pgRectHeight(PGRect self) {
    return self.size.y;
}
BOOL pgRectContainsVec2(PGRect self, PGVec2 vec2) {
    return self.p.x <= vec2.x && vec2.x <= self.p.x + self.size.x && self.p.y <= vec2.y && vec2.y <= self.p.y + self.size.y;
}
PGRect pgRectAddVec2(PGRect self, PGVec2 vec2) {
    return PGRectMake((pgVec2AddVec2(self.p, vec2)), self.size);
}
PGRect pgRectSubVec2(PGRect self, PGVec2 vec2) {
    return PGRectMake((pgVec2SubVec2(self.p, vec2)), self.size);
}
PGRect pgRectMulF(PGRect self, CGFloat f) {
    return PGRectMake((pgVec2MulF(self.p, f)), (pgVec2MulF(self.size, f)));
}
PGRect pgRectMulVec2(PGRect self, PGVec2 vec2) {
    return PGRectMake((pgVec2MulVec2(self.p, vec2)), (pgVec2MulVec2(self.size, vec2)));
}
BOOL pgRectIntersectsRect(PGRect self, PGRect rect) {
    return self.p.x <= pgRectX2(rect) && pgRectX2(self) >= rect.p.x && self.p.y <= pgRectY2(rect) && pgRectY2(self) >= rect.p.y;
}
PGRect pgRectThickenHalfSize(PGRect self, PGVec2 halfSize) {
    return PGRectMake((pgVec2SubVec2(self.p, halfSize)), (pgVec2AddVec2(self.size, (pgVec2MulI(halfSize, 2)))));
}
PGRect pgRectDivVec2(PGRect self, PGVec2 vec2) {
    return PGRectMake((pgVec2DivVec2(self.p, vec2)), (pgVec2DivVec2(self.size, vec2)));
}
PGRect pgRectDivF(PGRect self, CGFloat f) {
    return PGRectMake((pgVec2DivF(self.p, f)), (pgVec2DivF(self.size, f)));
}
PGRect pgRectDivF4(PGRect self, float f4) {
    return PGRectMake((pgVec2DivF4(self.p, f4)), (pgVec2DivF4(self.size, f4)));
}
PGVec2 pgRectPh(PGRect self) {
    return PGVec2Make(self.p.x, self.p.y + self.size.y);
}
PGVec2 pgRectPw(PGRect self) {
    return PGVec2Make(self.p.x + self.size.x, self.p.y);
}
PGVec2 pgRectPhw(PGRect self) {
    return PGVec2Make(self.p.x + self.size.x, self.p.y + self.size.y);
}
PGRect pgRectMoveToCenterForSize(PGRect self, PGVec2 size) {
    return PGRectMake((pgVec2MulF((pgVec2SubVec2(size, self.size)), 0.5)), self.size);
}
PGQuad pgRectQuad(PGRect self) {
    return PGQuadMake(self.p, pgRectPh(self), pgRectPhw(self), pgRectPw(self));
}
PGQuad pgRectStripQuad(PGRect self) {
    return PGQuadMake(self.p, pgRectPh(self), pgRectPw(self), pgRectPhw(self));
}
PGQuad pgRectUpsideDownStripQuad(PGRect self) {
    return PGQuadMake(pgRectPh(self), self.p, pgRectPhw(self), pgRectPw(self));
}
PGRect pgRectCenterX(PGRect self) {
    return PGRectMake((PGVec2Make(self.p.x - self.size.x / 2, self.p.y)), self.size);
}
PGRect pgRectCenterY(PGRect self) {
    return PGRectMake((PGVec2Make(self.p.x, self.p.y - self.size.y / 2)), self.size);
}
PGVec2 pgRectCenter(PGRect self) {
    return pgVec2AddVec2(self.p, (pgVec2DivI(self.size, 2)));
}
PGVec2 pgRectClosestPointForVec2(PGRect self, PGVec2 vec2) {
    return pgVec2MaxVec2((pgVec2MinVec2(vec2, pgRectPhw(self))), self.p);
}
PGVec2 pgRectPXY(PGRect self, float x, float y) {
    return PGVec2Make(self.p.x + self.size.x * x, self.p.y + self.size.y * y);
}
NSString* pgRectDescription(PGRect self) {
    return [NSString stringWithFormat:@"Rect(%@, %@)", pgVec2Description(self.p), pgVec2Description(self.size)];
}
BOOL pgRectIsEqualTo(PGRect self, PGRect to) {
    return pgVec2IsEqualTo(self.p, to.p) && pgVec2IsEqualTo(self.size, to.size);
}
NSUInteger pgRectHash(PGRect self) {
    NSUInteger hash = 0;
    hash = hash * 31 + pgVec2Hash(self.p);
    hash = hash * 31 + pgVec2Hash(self.size);
    return hash;
}
CNPType* pgRectType() {
    static CNPType* _ret = nil;
    if(_ret == nil) _ret = [CNPType typeWithCls:[PGRectWrap class] name:@"PGRect" size:sizeof(PGRect) wrap:^id(void* data, NSUInteger i) {
        return wrap(PGRect, ((PGRect*)(data))[i]);
    }];
    return _ret;
}
@implementation PGRectWrap{
    PGRect _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(PGRect)value {
    return [[PGRectWrap alloc] initWithValue:value];
}

- (id)initWithValue:(PGRect)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return pgRectDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    PGRectWrap* o = ((PGRectWrap*)(other));
    return pgRectIsEqualTo(_value, o.value);
}

- (NSUInteger)hash {
    return pgRectHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


PGRectI pgRectIApplyXYWidthHeight(float x, float y, float width, float height) {
    return PGRectIMake((pgVec2iApplyVec2((PGVec2Make(x, y)))), (pgVec2iApplyVec2((PGVec2Make(width, height)))));
}
PGRectI pgRectIApplyRect(PGRect rect) {
    return PGRectIMake(pgVec2iApplyVec2(rect.p), pgVec2iApplyVec2(rect.size));
}
NSInteger pgRectIX(PGRectI self) {
    return self.p.x;
}
NSInteger pgRectIY(PGRectI self) {
    return self.p.y;
}
NSInteger pgRectIX2(PGRectI self) {
    return self.p.x + self.size.x;
}
NSInteger pgRectIY2(PGRectI self) {
    return self.p.y + self.size.y;
}
NSInteger pgRectIWidth(PGRectI self) {
    return self.size.x;
}
NSInteger pgRectIHeight(PGRectI self) {
    return self.size.y;
}
PGRectI pgRectIMoveToCenterForSize(PGRectI self, PGVec2 size) {
    return PGRectIMake((pgVec2iApplyVec2((pgVec2MulF((pgVec2SubVec2(size, pgVec2ApplyVec2i(self.size))), 0.5)))), self.size);
}
NSString* pgRectIDescription(PGRectI self) {
    return [NSString stringWithFormat:@"RectI(%@, %@)", pgVec2iDescription(self.p), pgVec2iDescription(self.size)];
}
BOOL pgRectIIsEqualTo(PGRectI self, PGRectI to) {
    return pgVec2iIsEqualTo(self.p, to.p) && pgVec2iIsEqualTo(self.size, to.size);
}
NSUInteger pgRectIHash(PGRectI self) {
    NSUInteger hash = 0;
    hash = hash * 31 + pgVec2iHash(self.p);
    hash = hash * 31 + pgVec2iHash(self.size);
    return hash;
}
CNPType* pgRectIType() {
    static CNPType* _ret = nil;
    if(_ret == nil) _ret = [CNPType typeWithCls:[PGRectIWrap class] name:@"PGRectI" size:sizeof(PGRectI) wrap:^id(void* data, NSUInteger i) {
        return wrap(PGRectI, ((PGRectI*)(data))[i]);
    }];
    return _ret;
}
@implementation PGRectIWrap{
    PGRectI _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(PGRectI)value {
    return [[PGRectIWrap alloc] initWithValue:value];
}

- (id)initWithValue:(PGRectI)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return pgRectIDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    PGRectIWrap* o = ((PGRectIWrap*)(other));
    return pgRectIIsEqualTo(_value, o.value);
}

- (NSUInteger)hash {
    return pgRectIHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


PGLine2 pgLine2ApplyP0P1(PGVec2 p0, PGVec2 p1) {
    return PGLine2Make(p0, (pgVec2SubVec2(p1, p0)));
}
PGVec2 pgLine2RT(PGLine2 self, float t) {
    return pgVec2AddVec2(self.p0, (pgVec2MulF4(self.u, t)));
}
id pgLine2CrossPointLine2(PGLine2 self, PGLine2 line2) {
    float dot = pgVec2DotVec2(pgLine2N(line2), self.u);
    if(eqf4(dot, 0)) return nil;
    else return wrap(PGVec2, (pgVec2AddVec2(self.p0, (pgVec2MulF4(self.u, (pgVec2DotVec2(pgLine2N(line2), (pgVec2SubVec2(line2.p0, self.p0))) / dot))))));
}
float pgLine2Angle(PGLine2 self) {
    return pgVec2Angle(self.u);
}
float pgLine2DegreeAngle(PGLine2 self) {
    return pgVec2DegreeAngle(self.u);
}
PGLine2 pgLine2SetLength(PGLine2 self, float length) {
    return PGLine2Make(self.p0, (pgVec2SetLength(self.u, length)));
}
PGLine2 pgLine2Normalize(PGLine2 self) {
    return PGLine2Make(self.p0, pgVec2Normalize(self.u));
}
PGVec2 pgLine2Mid(PGLine2 self) {
    return pgVec2AddVec2(self.p0, (pgVec2DivI(self.u, 2)));
}
PGVec2 pgLine2P1(PGLine2 self) {
    return pgVec2AddVec2(self.p0, self.u);
}
PGLine2 pgLine2AddVec2(PGLine2 self, PGVec2 vec2) {
    return PGLine2Make((pgVec2AddVec2(self.p0, vec2)), self.u);
}
PGLine2 pgLine2SubVec2(PGLine2 self, PGVec2 vec2) {
    return PGLine2Make((pgVec2SubVec2(self.p0, vec2)), self.u);
}
PGVec2 pgLine2N(PGLine2 self) {
    return pgVec2Normalize((PGVec2Make(-self.u.y, self.u.x)));
}
PGVec2 pgLine2ProjectionVec2(PGLine2 self, PGVec2 vec2) {
    return uwrap(PGVec2, (nonnil((pgLine2CrossPointLine2(self, (PGLine2Make(vec2, pgLine2N(self))))))));
}
id pgLine2ProjectionOnSegmentVec2(PGLine2 self, PGVec2 vec2) {
    id p = pgLine2CrossPointLine2(self, (PGLine2Make(vec2, pgLine2N(self))));
    if(p != nil) {
        if(pgRectContainsVec2(pgLine2BoundingRect(self), (uwrap(PGVec2, p)))) return ((id)(p));
        else return nil;
    } else {
        return nil;
    }
}
PGRect pgLine2BoundingRect(PGLine2 self) {
    return pgRectApplyXYSize(((self.u.x > 0) ? self.p0.x : self.p0.x + self.u.x), ((self.u.y > 0) ? self.p0.y : self.p0.y + self.u.y), pgVec2Abs(self.u));
}
PGLine2 pgLine2Positive(PGLine2 self) {
    if(self.u.x < 0 || (eqf4(self.u.x, 0) && self.u.y < 0)) return PGLine2Make(pgLine2P1(self), pgVec2Negate(self.u));
    else return self;
}
NSString* pgLine2Description(PGLine2 self) {
    return [NSString stringWithFormat:@"Line2(%@, %@)", pgVec2Description(self.p0), pgVec2Description(self.u)];
}
BOOL pgLine2IsEqualTo(PGLine2 self, PGLine2 to) {
    return pgVec2IsEqualTo(self.p0, to.p0) && pgVec2IsEqualTo(self.u, to.u);
}
NSUInteger pgLine2Hash(PGLine2 self) {
    NSUInteger hash = 0;
    hash = hash * 31 + pgVec2Hash(self.p0);
    hash = hash * 31 + pgVec2Hash(self.u);
    return hash;
}
CNPType* pgLine2Type() {
    static CNPType* _ret = nil;
    if(_ret == nil) _ret = [CNPType typeWithCls:[PGLine2Wrap class] name:@"PGLine2" size:sizeof(PGLine2) wrap:^id(void* data, NSUInteger i) {
        return wrap(PGLine2, ((PGLine2*)(data))[i]);
    }];
    return _ret;
}
@implementation PGLine2Wrap{
    PGLine2 _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(PGLine2)value {
    return [[PGLine2Wrap alloc] initWithValue:value];
}

- (id)initWithValue:(PGLine2)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return pgLine2Description(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    PGLine2Wrap* o = ((PGLine2Wrap*)(other));
    return pgLine2IsEqualTo(_value, o.value);
}

- (NSUInteger)hash {
    return pgLine2Hash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


PGVec3 pgLine3RT(PGLine3 self, float t) {
    return pgVec3AddVec3(self.r0, (pgVec3MulK(self.u, t)));
}
PGVec3 pgLine3RPlane(PGLine3 self, PGPlane plane) {
    return pgVec3AddVec3(self.r0, (pgVec3MulK(self.u, (pgVec3DotVec3(plane.n, (pgVec3SubVec3(plane.p0, self.r0))) / pgVec3DotVec3(plane.n, self.u)))));
}
NSString* pgLine3Description(PGLine3 self) {
    return [NSString stringWithFormat:@"Line3(%@, %@)", pgVec3Description(self.r0), pgVec3Description(self.u)];
}
BOOL pgLine3IsEqualTo(PGLine3 self, PGLine3 to) {
    return pgVec3IsEqualTo(self.r0, to.r0) && pgVec3IsEqualTo(self.u, to.u);
}
NSUInteger pgLine3Hash(PGLine3 self) {
    NSUInteger hash = 0;
    hash = hash * 31 + pgVec3Hash(self.r0);
    hash = hash * 31 + pgVec3Hash(self.u);
    return hash;
}
CNPType* pgLine3Type() {
    static CNPType* _ret = nil;
    if(_ret == nil) _ret = [CNPType typeWithCls:[PGLine3Wrap class] name:@"PGLine3" size:sizeof(PGLine3) wrap:^id(void* data, NSUInteger i) {
        return wrap(PGLine3, ((PGLine3*)(data))[i]);
    }];
    return _ret;
}
@implementation PGLine3Wrap{
    PGLine3 _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(PGLine3)value {
    return [[PGLine3Wrap alloc] initWithValue:value];
}

- (id)initWithValue:(PGLine3)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return pgLine3Description(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    PGLine3Wrap* o = ((PGLine3Wrap*)(other));
    return pgLine3IsEqualTo(_value, o.value);
}

- (NSUInteger)hash {
    return pgLine3Hash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


BOOL pgPlaneContainsVec3(PGPlane self, PGVec3 vec3) {
    return eqf4((pgVec3DotVec3(self.n, (pgVec3SubVec3(vec3, self.p0)))), 0);
}
PGPlane pgPlaneAddVec3(PGPlane self, PGVec3 vec3) {
    return PGPlaneMake((pgVec3AddVec3(self.p0, vec3)), self.n);
}
PGPlane pgPlaneMulMat4(PGPlane self, PGMat4* mat4) {
    return PGPlaneMake([mat4 mulVec3:self.p0], pgVec4Xyz([mat4 mulVec3:self.n w:0.0]));
}
NSString* pgPlaneDescription(PGPlane self) {
    return [NSString stringWithFormat:@"Plane(%@, %@)", pgVec3Description(self.p0), pgVec3Description(self.n)];
}
BOOL pgPlaneIsEqualTo(PGPlane self, PGPlane to) {
    return pgVec3IsEqualTo(self.p0, to.p0) && pgVec3IsEqualTo(self.n, to.n);
}
NSUInteger pgPlaneHash(PGPlane self) {
    NSUInteger hash = 0;
    hash = hash * 31 + pgVec3Hash(self.p0);
    hash = hash * 31 + pgVec3Hash(self.n);
    return hash;
}
CNPType* pgPlaneType() {
    static CNPType* _ret = nil;
    if(_ret == nil) _ret = [CNPType typeWithCls:[PGPlaneWrap class] name:@"PGPlane" size:sizeof(PGPlane) wrap:^id(void* data, NSUInteger i) {
        return wrap(PGPlane, ((PGPlane*)(data))[i]);
    }];
    return _ret;
}
@implementation PGPlaneWrap{
    PGPlane _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(PGPlane)value {
    return [[PGPlaneWrap alloc] initWithValue:value];
}

- (id)initWithValue:(PGPlane)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return pgPlaneDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    PGPlaneWrap* o = ((PGPlaneWrap*)(other));
    return pgPlaneIsEqualTo(_value, o.value);
}

- (NSUInteger)hash {
    return pgPlaneHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


PGPlaneCoord pgPlaneCoordApplyPlaneX(PGPlane plane, PGVec3 x) {
    return PGPlaneCoordMake(plane, x, (pgVec3CrossVec3(x, plane.n)));
}
PGVec3 pgPlaneCoordPVec2(PGPlaneCoord self, PGVec2 vec2) {
    return pgVec3AddVec3((pgVec3AddVec3(self.plane.p0, (pgVec3MulK(self.x, vec2.x)))), (pgVec3MulK(self.y, vec2.y)));
}
PGPlaneCoord pgPlaneCoordAddVec3(PGPlaneCoord self, PGVec3 vec3) {
    return PGPlaneCoordMake((pgPlaneAddVec3(self.plane, vec3)), self.x, self.y);
}
PGPlaneCoord pgPlaneCoordSetX(PGPlaneCoord self, PGVec3 x) {
    return PGPlaneCoordMake(self.plane, x, self.y);
}
PGPlaneCoord pgPlaneCoordSetY(PGPlaneCoord self, PGVec3 y) {
    return PGPlaneCoordMake(self.plane, self.x, y);
}
PGPlaneCoord pgPlaneCoordMulMat4(PGPlaneCoord self, PGMat4* mat4) {
    return PGPlaneCoordMake((pgPlaneMulMat4(self.plane, mat4)), [mat4 mulVec3:self.x], [mat4 mulVec3:self.y]);
}
NSString* pgPlaneCoordDescription(PGPlaneCoord self) {
    return [NSString stringWithFormat:@"PlaneCoord(%@, %@, %@)", pgPlaneDescription(self.plane), pgVec3Description(self.x), pgVec3Description(self.y)];
}
BOOL pgPlaneCoordIsEqualTo(PGPlaneCoord self, PGPlaneCoord to) {
    return pgPlaneIsEqualTo(self.plane, to.plane) && pgVec3IsEqualTo(self.x, to.x) && pgVec3IsEqualTo(self.y, to.y);
}
NSUInteger pgPlaneCoordHash(PGPlaneCoord self) {
    NSUInteger hash = 0;
    hash = hash * 31 + pgPlaneHash(self.plane);
    hash = hash * 31 + pgVec3Hash(self.x);
    hash = hash * 31 + pgVec3Hash(self.y);
    return hash;
}
CNPType* pgPlaneCoordType() {
    static CNPType* _ret = nil;
    if(_ret == nil) _ret = [CNPType typeWithCls:[PGPlaneCoordWrap class] name:@"PGPlaneCoord" size:sizeof(PGPlaneCoord) wrap:^id(void* data, NSUInteger i) {
        return wrap(PGPlaneCoord, ((PGPlaneCoord*)(data))[i]);
    }];
    return _ret;
}
@implementation PGPlaneCoordWrap{
    PGPlaneCoord _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(PGPlaneCoord)value {
    return [[PGPlaneCoordWrap alloc] initWithValue:value];
}

- (id)initWithValue:(PGPlaneCoord)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return pgPlaneCoordDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    PGPlaneCoordWrap* o = ((PGPlaneCoordWrap*)(other));
    return pgPlaneCoordIsEqualTo(_value, o.value);
}

- (NSUInteger)hash {
    return pgPlaneCoordHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


PGVec3 pgQuad3P0(PGQuad3 self) {
    return pgPlaneCoordPVec2(self.planeCoord, self.quad.p0);
}
PGVec3 pgQuad3P1(PGQuad3 self) {
    return pgPlaneCoordPVec2(self.planeCoord, self.quad.p1);
}
PGVec3 pgQuad3P2(PGQuad3 self) {
    return pgPlaneCoordPVec2(self.planeCoord, self.quad.p2);
}
PGVec3 pgQuad3P3(PGQuad3 self) {
    return pgPlaneCoordPVec2(self.planeCoord, self.quad.p3);
}
NSArray* pgQuad3Ps(PGQuad3 self) {
    return (@[wrap(PGVec3, pgQuad3P0(self)), wrap(PGVec3, pgQuad3P1(self)), wrap(PGVec3, pgQuad3P2(self)), wrap(PGVec3, pgQuad3P3(self))]);
}
PGQuad3 pgQuad3MulMat4(PGQuad3 self, PGMat4* mat4) {
    return PGQuad3Make((pgPlaneCoordMulMat4(self.planeCoord, mat4)), self.quad);
}
NSString* pgQuad3Description(PGQuad3 self) {
    return [NSString stringWithFormat:@"Quad3(%@, %@)", pgPlaneCoordDescription(self.planeCoord), pgQuadDescription(self.quad)];
}
BOOL pgQuad3IsEqualTo(PGQuad3 self, PGQuad3 to) {
    return pgPlaneCoordIsEqualTo(self.planeCoord, to.planeCoord) && pgQuadIsEqualTo(self.quad, to.quad);
}
NSUInteger pgQuad3Hash(PGQuad3 self) {
    NSUInteger hash = 0;
    hash = hash * 31 + pgPlaneCoordHash(self.planeCoord);
    hash = hash * 31 + pgQuadHash(self.quad);
    return hash;
}
CNPType* pgQuad3Type() {
    static CNPType* _ret = nil;
    if(_ret == nil) _ret = [CNPType typeWithCls:[PGQuad3Wrap class] name:@"PGQuad3" size:sizeof(PGQuad3) wrap:^id(void* data, NSUInteger i) {
        return wrap(PGQuad3, ((PGQuad3*)(data))[i]);
    }];
    return _ret;
}
@implementation PGQuad3Wrap{
    PGQuad3 _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(PGQuad3)value {
    return [[PGQuad3Wrap alloc] initWithValue:value];
}

- (id)initWithValue:(PGQuad3)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return pgQuad3Description(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    PGQuad3Wrap* o = ((PGQuad3Wrap*)(other));
    return pgQuad3IsEqualTo(_value, o.value);
}

- (NSUInteger)hash {
    return pgQuad3Hash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


