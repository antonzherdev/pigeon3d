#import "objd.h"
#import "PGVec.h"
#import "PGParticleSystem.h"

@class PGBillboardBufferDataBuffer;
@class PGBillboardParticleSystem_impl;
@protocol PGBillboardParticleSystem;
typedef struct PGBillboardBufferData PGBillboardBufferData;
typedef struct PGBillboardParticle PGBillboardParticle;

struct PGBillboardBufferData {
    PGVec3 position;
    PGVec2 model;
    PGVec4 color;
    PGVec2 uv;
};
static inline PGBillboardBufferData PGBillboardBufferDataMake(PGVec3 position, PGVec2 model, PGVec4 color, PGVec2 uv) {
    return (PGBillboardBufferData){position, model, color, uv};
}
NSString* pgBillboardBufferDataDescription(PGBillboardBufferData self);
BOOL pgBillboardBufferDataIsEqualTo(PGBillboardBufferData self, PGBillboardBufferData to);
NSUInteger pgBillboardBufferDataHash(PGBillboardBufferData self);
CNPType* pgBillboardBufferDataType();
@interface PGBillboardBufferDataWrap : NSObject
@property (readonly, nonatomic) PGBillboardBufferData value;

+ (id)wrapWithValue:(PGBillboardBufferData)value;
- (id)initWithValue:(PGBillboardBufferData)value;
@end



@interface PGBillboardBufferDataBuffer : CNUBuffer
+ (instancetype)billboardBufferDataBufferWithCount:(unsigned int)count;
- (instancetype)initWithCount:(unsigned int)count;
- (CNClassType*)type;
- (NSString*)description;
+ (CNClassType*)type;
@end


struct PGBillboardParticle {
    PGVec3 position;
    PGQuad uv;
    PGQuad model;
    PGVec4 color;
};
static inline PGBillboardParticle PGBillboardParticleMake(PGVec3 position, PGQuad uv, PGQuad model, PGVec4 color) {
    return (PGBillboardParticle){position, uv, model, color};
}
PGBillboardBufferData* pgBillboardParticleWriteToArray(PGBillboardParticle self, PGBillboardBufferData* array);
NSString* pgBillboardParticleDescription(PGBillboardParticle self);
BOOL pgBillboardParticleIsEqualTo(PGBillboardParticle self, PGBillboardParticle to);
NSUInteger pgBillboardParticleHash(PGBillboardParticle self);
CNPType* pgBillboardParticleType();
@interface PGBillboardParticleWrap : NSObject
@property (readonly, nonatomic) PGBillboardParticle value;

+ (id)wrapWithValue:(PGBillboardParticle)value;
- (id)initWithValue:(PGBillboardParticle)value;
@end



@protocol PGBillboardParticleSystem<PGParticleSystemIndexArray>
- (unsigned int)vertexCount;
- (NSUInteger)indexCount;
- (unsigned int*)createIndexArray;
- (NSString*)description;
@end


@interface PGBillboardParticleSystem_impl : PGParticleSystemIndexArray_impl<PGBillboardParticleSystem>
+ (instancetype)billboardParticleSystem_impl;
- (instancetype)init;
- (NSUInteger)indexCount;
- (unsigned int*)createIndexArray;
@end


