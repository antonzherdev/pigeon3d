#import "objd.h"
@class PGParticleSystem;
@class PGVertexBufferDesc;
@class PGShader;
@class PGBlendFunction;
@protocol PGIndexSource;
@class PGVertexArrayRing;
@class PGVBO;
@class PGVertexArray;
@class PGMappedBufferData;
@class CNFuture;
@class PGMutableVertexBuffer;
@class PGGlobal;
@class PGContext;
@class PGEnablingState;
@class PGCullFace;
@protocol PGParticleSystemIndexArray;
@class PGIBO;

@class PGParticleSystemView;
@class PGParticleSystemViewIndexArray;

@interface PGParticleSystemView : NSObject {
@protected
    PGParticleSystem* _system;
    PGVertexBufferDesc* _vbDesc;
    PGShader* _shader;
    id _material;
    PGBlendFunction* _blendFunc;
    unsigned int _maxCount;
    unsigned int _vertexCount;
    unsigned int __indexCount;
    id<PGIndexSource> _index;
    PGVertexArrayRing* _vaoRing;
    PGVertexArray* __vao;
    PGMappedBufferData* __data;
    CNFuture* __lastWriteFuture;
}
@property (nonatomic, readonly) PGParticleSystem* system;
@property (nonatomic, readonly) PGVertexBufferDesc* vbDesc;
@property (nonatomic, readonly) PGShader* shader;
@property (nonatomic, readonly) id material;
@property (nonatomic, readonly) PGBlendFunction* blendFunc;
@property (nonatomic, readonly) unsigned int maxCount;
@property (nonatomic, readonly) unsigned int vertexCount;
@property (nonatomic, readonly) id<PGIndexSource> index;
@property (nonatomic, readonly) PGVertexArrayRing* vaoRing;

+ (instancetype)particleSystemViewWithSystem:(PGParticleSystem*)system vbDesc:(PGVertexBufferDesc*)vbDesc shader:(PGShader*)shader material:(id)material blendFunc:(PGBlendFunction*)blendFunc;
- (instancetype)initWithSystem:(PGParticleSystem*)system vbDesc:(PGVertexBufferDesc*)vbDesc shader:(PGShader*)shader material:(id)material blendFunc:(PGBlendFunction*)blendFunc;
- (CNClassType*)type;
- (unsigned int)indexCount;
- (id<PGIndexSource>)createIndexSource;
- (void)prepare;
- (void)draw;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGParticleSystemViewIndexArray : PGParticleSystemView
+ (instancetype)particleSystemViewIndexArrayWithSystem:(PGParticleSystem*)system vbDesc:(PGVertexBufferDesc*)vbDesc shader:(PGShader*)shader material:(id)material blendFunc:(PGBlendFunction*)blendFunc;
- (instancetype)initWithSystem:(PGParticleSystem*)system vbDesc:(PGVertexBufferDesc*)vbDesc shader:(PGShader*)shader material:(id)material blendFunc:(PGBlendFunction*)blendFunc;
- (CNClassType*)type;
- (unsigned int)indexCount;
- (id<PGIndexSource>)createIndexSource;
- (NSString*)description;
+ (CNClassType*)type;
@end


