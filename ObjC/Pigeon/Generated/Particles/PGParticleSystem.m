#import "PGParticleSystem.h"

#import "CNFuture.h"
#import "PGBuffer.h"
@implementation PGParticleSystem
static CNClassType* _PGParticleSystem_type;
@synthesize particleType = _particleType;
@synthesize maxCount = _maxCount;
@synthesize particles = _particles;

+ (instancetype)particleSystemWithParticleType:(CNPType*)particleType maxCount:(unsigned int)maxCount {
    return [[PGParticleSystem alloc] initWithParticleType:particleType maxCount:maxCount];
}

- (instancetype)initWithParticleType:(CNPType*)particleType maxCount:(unsigned int)maxCount {
    self = [super init];
    if(self) {
        _particleType = particleType;
        _maxCount = maxCount;
        _particles = cnPointerApplyBytesCount(((NSUInteger)([self particleSize])), ((NSUInteger)(maxCount)));
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGParticleSystem class]) _PGParticleSystem_type = [CNClassType classTypeWithCls:[PGParticleSystem class]];
}

- (unsigned int)vertexCount {
    @throw @"Method vertexCount is abstract";
}

- (unsigned int)particleSize {
    return ((unsigned int)(_particleType.size));
}

- (void)dealloc {
    cnPointerFree(_particles);
}

- (CNFuture*)updateWithDelta:(CGFloat)delta {
    return [self futureF:^id() {
        [self doUpdateWithDelta:delta];
        return nil;
    }];
}

- (void)doUpdateWithDelta:(CGFloat)delta {
    @throw @"Method doUpdateWith is abstract";
}

- (CNFuture*)writeToArray:(PGMappedBufferData*)array {
    return [self futureF:^id() {
        unsigned int ret = 0;
        if([array beginWrite]) {
            {
                void* p = array->_pointer;
                ret = [self doWriteToArray:p];
            }
            [array endWrite];
        }
        return numui4(ret);
    }];
}

- (unsigned int)doWriteToArray:(void*)array {
    @throw @"Method doWriteTo is abstract";
}

- (NSString*)description {
    return [NSString stringWithFormat:@"ParticleSystem(%@, %u)", _particleType, _maxCount];
}

- (CNClassType*)type {
    return [PGParticleSystem type];
}

+ (CNClassType*)type {
    return _PGParticleSystem_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGParticleSystemIndexArray_impl

+ (instancetype)particleSystemIndexArray_impl {
    return [[PGParticleSystemIndexArray_impl alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

- (unsigned int)indexCount {
    @throw @"Method indexCount is abstract";
}

- (unsigned int)maxCount {
    @throw @"Method maxCount is abstract";
}

- (unsigned int*)createIndexArray {
    @throw @"Method createIndexArray is abstract";
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGFixedParticleSystem
static CNClassType* _PGFixedParticleSystem_type;

+ (instancetype)fixedParticleSystemWithParticleType:(CNPType*)particleType maxCount:(unsigned int)maxCount {
    return [[PGFixedParticleSystem alloc] initWithParticleType:particleType maxCount:maxCount];
}

- (instancetype)initWithParticleType:(CNPType*)particleType maxCount:(unsigned int)maxCount {
    self = [super initWithParticleType:particleType maxCount:maxCount];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGFixedParticleSystem class]) _PGFixedParticleSystem_type = [CNClassType classTypeWithCls:[PGFixedParticleSystem class]];
}

- (NSString*)description {
    return @"FixedParticleSystem";
}

- (CNClassType*)type {
    return [PGFixedParticleSystem type];
}

+ (CNClassType*)type {
    return _PGFixedParticleSystem_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGEmissiveParticleSystem
static CNClassType* _PGEmissiveParticleSystem_type;
@synthesize _lifeCount = __lifeCount;
@synthesize _particleSize = __particleSize;
@synthesize _nextInvalidNumber = __nextInvalidNumber;
@synthesize _nextInvalidRef = __nextInvalidRef;

+ (instancetype)emissiveParticleSystemWithParticleType:(CNPType*)particleType maxCount:(unsigned int)maxCount {
    return [[PGEmissiveParticleSystem alloc] initWithParticleType:particleType maxCount:maxCount];
}

- (instancetype)initWithParticleType:(CNPType*)particleType maxCount:(unsigned int)maxCount {
    self = [super initWithParticleType:particleType maxCount:maxCount];
    if(self) {
        __lifeCount = 0;
        __particleSize = [self particleSize];
        __nextInvalidNumber = 0;
        __nextInvalidRef = self.particles;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGEmissiveParticleSystem class]) _PGEmissiveParticleSystem_type = [CNClassType classTypeWithCls:[PGEmissiveParticleSystem class]];
}

- (NSString*)description {
    return @"EmissiveParticleSystem";
}

- (CNClassType*)type {
    return [PGEmissiveParticleSystem type];
}

+ (CNClassType*)type {
    return _PGEmissiveParticleSystem_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

