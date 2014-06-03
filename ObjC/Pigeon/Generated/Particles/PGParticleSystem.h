#import "objd.h"
#import "CNActor.h"
@class CNFuture;
@class PGMappedBufferData;

@class PGParticleSystem;
@class PGParticleSystemIndexArray_impl;
@class PGFixedParticleSystem;
@class PGEmissiveParticleSystem;
@protocol PGParticleSystemIndexArray;

@interface PGParticleSystem : CNActor {
@protected
    CNPType* _particleType;
    unsigned int _maxCount;
    void* _particles;
}
@property (nonatomic, readonly) CNPType* particleType;
@property (nonatomic, readonly) unsigned int maxCount;
@property (nonatomic, readonly) void* particles;

+ (instancetype)particleSystemWithParticleType:(CNPType*)particleType maxCount:(unsigned int)maxCount;
- (instancetype)initWithParticleType:(CNPType*)particleType maxCount:(unsigned int)maxCount;
- (CNClassType*)type;
- (unsigned int)vertexCount;
- (unsigned int)particleSize;
- (void)dealloc;
- (CNFuture*)updateWithDelta:(CGFloat)delta;
- (void)doUpdateWithDelta:(CGFloat)delta;
- (CNFuture*)writeToArray:(PGMappedBufferData*)array;
- (unsigned int)doWriteToArray:(void*)array;
- (NSString*)description;
+ (CNClassType*)type;
@end


@protocol PGParticleSystemIndexArray<NSObject>
- (unsigned int)indexCount;
- (unsigned int)maxCount;
- (unsigned int*)createIndexArray;
- (NSString*)description;
@end


@interface PGParticleSystemIndexArray_impl : NSObject<PGParticleSystemIndexArray>
+ (instancetype)particleSystemIndexArray_impl;
- (instancetype)init;
@end


@interface PGFixedParticleSystem : PGParticleSystem
+ (instancetype)fixedParticleSystemWithParticleType:(CNPType*)particleType maxCount:(unsigned int)maxCount;
- (instancetype)initWithParticleType:(CNPType*)particleType maxCount:(unsigned int)maxCount;
- (CNClassType*)type;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGEmissiveParticleSystem : PGParticleSystem {
@protected
    NSInteger __lifeCount;
    unsigned int __particleSize;
    NSInteger __nextInvalidNumber;
    void* __nextInvalidRef;
}
@property (nonatomic) NSInteger _lifeCount;
@property (nonatomic, readonly) unsigned int _particleSize;
@property (nonatomic) NSInteger _nextInvalidNumber;
@property (nonatomic) void* _nextInvalidRef;

+ (instancetype)emissiveParticleSystemWithParticleType:(CNPType*)particleType maxCount:(unsigned int)maxCount;
- (instancetype)initWithParticleType:(CNPType*)particleType maxCount:(unsigned int)maxCount;
- (CNClassType*)type;
- (NSString*)description;
+ (CNClassType*)type;
@end


