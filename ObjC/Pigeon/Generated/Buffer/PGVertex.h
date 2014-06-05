#import "objd.h"
#import "PGVec.h"
#import "PGMesh.h"
#import "PGBuffer.h"
@class PGGlobal;
@class PGContext;

@class PGVertexBufferDesc;
@class PGVBO;
@class PGVertexBuffer_impl;
@class PGImmutableVertexBuffer;
@class PGMutableVertexBuffer;
@class PGVertexBufferRing;
@protocol PGVertexBuffer;

@interface PGVertexBufferDesc : NSObject {
@public
    CNPType* _dataType;
    int _position;
    int _uv;
    int _normal;
    int _color;
    int _model;
}
@property (nonatomic, readonly) CNPType* dataType;
@property (nonatomic, readonly) int position;
@property (nonatomic, readonly) int uv;
@property (nonatomic, readonly) int normal;
@property (nonatomic, readonly) int color;
@property (nonatomic, readonly) int model;

+ (instancetype)vertexBufferDescWithDataType:(CNPType*)dataType position:(int)position uv:(int)uv normal:(int)normal color:(int)color model:(int)model;
- (instancetype)initWithDataType:(CNPType*)dataType position:(int)position uv:(int)uv normal:(int)normal color:(int)color model:(int)model;
- (CNClassType*)type;
- (unsigned int)stride;
+ (PGVertexBufferDesc*)Vec2;
+ (PGVertexBufferDesc*)Vec3;
+ (PGVertexBufferDesc*)Vec4;
+ (PGVertexBufferDesc*)mesh;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGVBO : NSObject
- (CNClassType*)type;
+ (id<PGVertexBuffer>)applyDesc:(PGVertexBufferDesc*)desc array:(void*)array count:(unsigned int)count;
+ (id<PGVertexBuffer>)applyDesc:(PGVertexBufferDesc*)desc buffer:(CNBuffer*)buffer;
+ (id<PGVertexBuffer>)vec4Data:(PGVec4Buffer*)data;
+ (id<PGVertexBuffer>)vec3Data:(PGVec3Buffer*)data;
+ (id<PGVertexBuffer>)vec2Data:(PGVec2Buffer*)data;
+ (id<PGVertexBuffer>)meshData:(PGMeshDataBuffer*)data;
+ (PGMutableVertexBuffer*)mutDesc:(PGVertexBufferDesc*)desc usage:(unsigned int)usage;
+ (PGVertexBufferRing*)ringSize:(unsigned int)size desc:(PGVertexBufferDesc*)desc usage:(unsigned int)usage;
+ (PGMutableVertexBuffer*)mutVec2Usage:(unsigned int)usage;
+ (PGMutableVertexBuffer*)mutVec3Usage:(unsigned int)usage;
+ (PGMutableVertexBuffer*)mutVec4Usage:(unsigned int)usage;
+ (PGMutableVertexBuffer*)mutMeshUsage:(unsigned int)usage;
+ (CNClassType*)type;
@end


@protocol PGVertexBuffer<NSObject>
- (PGVertexBufferDesc*)desc;
- (NSUInteger)count;
- (unsigned int)handle;
- (BOOL)isMutable;
- (void)bind;
- (NSString*)description;
@end


@interface PGVertexBuffer_impl : NSObject<PGVertexBuffer>
+ (instancetype)vertexBuffer_impl;
- (instancetype)init;
@end


@interface PGImmutableVertexBuffer : PGGlBuffer<PGVertexBuffer> {
@public
    PGVertexBufferDesc* _desc;
    NSUInteger _length;
    NSUInteger _count;
}
@property (nonatomic, readonly) PGVertexBufferDesc* desc;
@property (nonatomic, readonly) NSUInteger length;
@property (nonatomic, readonly) NSUInteger count;

+ (instancetype)immutableVertexBufferWithDesc:(PGVertexBufferDesc*)desc handle:(unsigned int)handle length:(NSUInteger)length count:(NSUInteger)count;
- (instancetype)initWithDesc:(PGVertexBufferDesc*)desc handle:(unsigned int)handle length:(NSUInteger)length count:(NSUInteger)count;
- (CNClassType*)type;
- (void)bind;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGMutableVertexBuffer : PGMutableGlBuffer<PGVertexBuffer> {
@public
    PGVertexBufferDesc* _desc;
}
@property (nonatomic, readonly) PGVertexBufferDesc* desc;

+ (instancetype)mutableVertexBufferWithDesc:(PGVertexBufferDesc*)desc handle:(unsigned int)handle usage:(unsigned int)usage;
- (instancetype)initWithDesc:(PGVertexBufferDesc*)desc handle:(unsigned int)handle usage:(unsigned int)usage;
- (CNClassType*)type;
- (BOOL)isMutable;
- (void)bind;
- (BOOL)isEmpty;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGVertexBufferRing : PGBufferRing {
@public
    PGVertexBufferDesc* _desc;
    unsigned int _usage;
}
@property (nonatomic, readonly) PGVertexBufferDesc* desc;
@property (nonatomic, readonly) unsigned int usage;

+ (instancetype)vertexBufferRingWithRingSize:(unsigned int)ringSize desc:(PGVertexBufferDesc*)desc usage:(unsigned int)usage;
- (instancetype)initWithRingSize:(unsigned int)ringSize desc:(PGVertexBufferDesc*)desc usage:(unsigned int)usage;
- (CNClassType*)type;
- (NSString*)description;
+ (CNClassType*)type;
@end


