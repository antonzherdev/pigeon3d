#import "objd.h"
#import "PGShader.h"
#import "PGVec.h"
@class PGTexture;
@class PGVertexBufferDesc;
@class PGGlobal;
@class PGContext;
@class PGMesh;
@class PGVBO;
@class PGEmptyIndexSource;
@class PGVertexArray;
@class PGRenderTargetSurface;
@class PGSurfaceRenderTarget;
@class CNVar;
@class PGSurfaceRenderTargetTexture;
@class PGSurfaceRenderTargetRenderBuffer;

@class PGViewportSurfaceShaderParam;
@class PGViewportShaderBuilder;
@class PGViewportSurfaceShader;
@class PGBaseViewportSurface;

@interface PGViewportSurfaceShaderParam : NSObject {
@protected
    PGTexture* _texture;
    float _z;
}
@property (nonatomic, readonly) PGTexture* texture;
@property (nonatomic, readonly) float z;

+ (instancetype)viewportSurfaceShaderParamWithTexture:(PGTexture*)texture z:(float)z;
- (instancetype)initWithTexture:(PGTexture*)texture z:(float)z;
- (CNClassType*)type;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface PGViewportShaderBuilder : PGShaderTextBuilder_impl
+ (instancetype)viewportShaderBuilder;
- (instancetype)init;
- (CNClassType*)type;
- (NSString*)vertex;
- (NSString*)fragment;
- (PGShaderProgram*)program;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGViewportSurfaceShader : PGShader {
@protected
    PGShaderAttribute* _positionSlot;
    PGShaderUniformF4* _zUniform;
}
@property (nonatomic, readonly) PGShaderAttribute* positionSlot;
@property (nonatomic, readonly) PGShaderUniformF4* zUniform;

+ (instancetype)viewportSurfaceShader;
- (instancetype)init;
- (CNClassType*)type;
- (void)loadAttributesVbDesc:(PGVertexBufferDesc*)vbDesc;
- (void)loadUniformsParam:(PGViewportSurfaceShaderParam*)param;
- (NSString*)description;
+ (PGViewportSurfaceShader*)instance;
+ (CNClassType*)type;
@end


@interface PGBaseViewportSurface : NSObject {
@protected
    PGSurfaceRenderTarget*(^_createRenderTarget)(PGVec2i);
    PGRenderTargetSurface* __surface;
    PGSurfaceRenderTarget* __renderTarget;
}
@property (nonatomic, readonly) PGSurfaceRenderTarget*(^createRenderTarget)(PGVec2i);

+ (instancetype)baseViewportSurfaceWithCreateRenderTarget:(PGSurfaceRenderTarget*(^)(PGVec2i))createRenderTarget;
- (instancetype)initWithCreateRenderTarget:(PGSurfaceRenderTarget*(^)(PGVec2i))createRenderTarget;
- (CNClassType*)type;
+ (PGMesh*)fullScreenMesh;
+ (PGVertexArray*)fullScreenVao;
- (PGRenderTargetSurface*)surface;
- (PGSurfaceRenderTarget*)renderTarget;
- (PGRenderTargetSurface*)createSurface;
- (PGTexture*)texture;
- (unsigned int)renderBuffer;
- (BOOL)needRedraw;
- (void)bind;
- (void)unbind;
- (NSString*)description;
+ (CNClassType*)type;
@end


