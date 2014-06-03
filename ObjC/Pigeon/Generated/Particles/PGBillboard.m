#import "PGBillboard.h"

NSString* pgBillboardBufferDataDescription(PGBillboardBufferData self) {
    return [NSString stringWithFormat:@"BillboardBufferData(%@, %@, %@, %@)", pgVec3Description(self.position), pgVec2Description(self.model), pgVec4Description(self.color), pgVec2Description(self.uv)];
}
BOOL pgBillboardBufferDataIsEqualTo(PGBillboardBufferData self, PGBillboardBufferData to) {
    return pgVec3IsEqualTo(self.position, to.position) && pgVec2IsEqualTo(self.model, to.model) && pgVec4IsEqualTo(self.color, to.color) && pgVec2IsEqualTo(self.uv, to.uv);
}
NSUInteger pgBillboardBufferDataHash(PGBillboardBufferData self) {
    NSUInteger hash = 0;
    hash = hash * 31 + pgVec3Hash(self.position);
    hash = hash * 31 + pgVec2Hash(self.model);
    hash = hash * 31 + pgVec4Hash(self.color);
    hash = hash * 31 + pgVec2Hash(self.uv);
    return hash;
}
CNPType* pgBillboardBufferDataType() {
    static CNPType* _ret = nil;
    if(_ret == nil) _ret = [CNPType typeWithCls:[PGBillboardBufferDataWrap class] name:@"PGBillboardBufferData" size:sizeof(PGBillboardBufferData) wrap:^id(void* data, NSUInteger i) {
        return wrap(PGBillboardBufferData, ((PGBillboardBufferData*)(data))[i]);
    }];
    return _ret;
}
@implementation PGBillboardBufferDataWrap{
    PGBillboardBufferData _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(PGBillboardBufferData)value {
    return [[PGBillboardBufferDataWrap alloc] initWithValue:value];
}

- (id)initWithValue:(PGBillboardBufferData)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return pgBillboardBufferDataDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    PGBillboardBufferDataWrap* o = ((PGBillboardBufferDataWrap*)(other));
    return pgBillboardBufferDataIsEqualTo(_value, o.value);
}

- (NSUInteger)hash {
    return pgBillboardBufferDataHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


PGBillboardBufferData* pgBillboardParticleWriteToArray(PGBillboardParticle self, PGBillboardBufferData* array) {
    PGBillboardBufferData* pp = array;
    pp->position = self.position;
    pp->model = self.model.p0;
    pp->color = self.color;
    pp->uv = self.uv.p0;
    pp++;
    pp->position = self.position;
    pp->model = self.model.p1;
    pp->color = self.color;
    pp->uv = self.uv.p1;
    pp++;
    pp->position = self.position;
    pp->model = self.model.p2;
    pp->color = self.color;
    pp->uv = self.uv.p2;
    pp++;
    pp->position = self.position;
    pp->model = self.model.p3;
    pp->color = self.color;
    pp->uv = self.uv.p3;
    return pp + 1;
}
NSString* pgBillboardParticleDescription(PGBillboardParticle self) {
    return [NSString stringWithFormat:@"BillboardParticle(%@, %@, %@, %@)", pgVec3Description(self.position), pgQuadDescription(self.uv), pgQuadDescription(self.model), pgVec4Description(self.color)];
}
BOOL pgBillboardParticleIsEqualTo(PGBillboardParticle self, PGBillboardParticle to) {
    return pgVec3IsEqualTo(self.position, to.position) && pgQuadIsEqualTo(self.uv, to.uv) && pgQuadIsEqualTo(self.model, to.model) && pgVec4IsEqualTo(self.color, to.color);
}
NSUInteger pgBillboardParticleHash(PGBillboardParticle self) {
    NSUInteger hash = 0;
    hash = hash * 31 + pgVec3Hash(self.position);
    hash = hash * 31 + pgQuadHash(self.uv);
    hash = hash * 31 + pgQuadHash(self.model);
    hash = hash * 31 + pgVec4Hash(self.color);
    return hash;
}
CNPType* pgBillboardParticleType() {
    static CNPType* _ret = nil;
    if(_ret == nil) _ret = [CNPType typeWithCls:[PGBillboardParticleWrap class] name:@"PGBillboardParticle" size:sizeof(PGBillboardParticle) wrap:^id(void* data, NSUInteger i) {
        return wrap(PGBillboardParticle, ((PGBillboardParticle*)(data))[i]);
    }];
    return _ret;
}
@implementation PGBillboardParticleWrap{
    PGBillboardParticle _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(PGBillboardParticle)value {
    return [[PGBillboardParticleWrap alloc] initWithValue:value];
}

- (id)initWithValue:(PGBillboardParticle)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return pgBillboardParticleDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    PGBillboardParticleWrap* o = ((PGBillboardParticleWrap*)(other));
    return pgBillboardParticleIsEqualTo(_value, o.value);
}

- (NSUInteger)hash {
    return pgBillboardParticleHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


@implementation PGBillboardParticleSystem_impl

+ (instancetype)billboardParticleSystem_impl {
    return [[PGBillboardParticleSystem_impl alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

- (NSUInteger)indexCount {
    return 6;
}

- (unsigned int*)createIndexArray {
    unsigned int* indexPointer = cnPointerApplyBytesCount(4, [self indexCount] * [self maxCount]);
    unsigned int* ia = indexPointer;
    NSInteger i = 0;
    unsigned int j = 0;
    while(i < [self maxCount]) {
        *(ia + 0) = j;
        *(ia + 1) = j + 1;
        *(ia + 2) = j + 2;
        *(ia + 3) = j + 2;
        *(ia + 4) = j;
        *(ia + 5) = j + 3;
        ia += 6;
        i++;
        j += 4;
    }
    return indexPointer;
}

- (unsigned int)vertexCount {
    return 4;
}

- (unsigned int)maxCount {
    @throw @"Method maxCount is abstract";
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

