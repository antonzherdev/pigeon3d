#import "objd.h"
#import "PGSurface.h"
#import "PGVec.h"
#import "PGViewportSurface.h"
#import "PGShader.h"
#import "PGContext.h"
@class PGMat4;
@class PGTexture;
@class PGEmptyTexture;
@class PGVertexArray;
@class PGMesh;
@class PGDirector;
@class PGColorSource;
@class PGVertexBufferDesc;
@class PGMatrixStack;
@class PGMMatrixModel;
@class PGViewportSurface;
@class CNObserver;
@class CNSignal;
@class CNChain;

@class PGShadowMap;
@class PGShadowSurfaceShaderBuilder;
@class PGShadowSurfaceShader;
@class PGShadowShaderSystem;
@class PGShadowShaderText;
@class PGShadowShader;
@class PGShadowDrawParam;
@class PGShadowDrawShaderSystem;
@class PGShadowDrawShaderKey;
@class PGShadowDrawShader;

@interface PGShadowMap : PGSurface {
@public
    unsigned int _frameBuffer;
    PGMat4* _biasDepthCp;
    PGTexture* _texture;
    CNLazy* __lazy_shader;
    CNLazy* __lazy_vao;
}
@property (nonatomic, readonly) unsigned int frameBuffer;
@property (nonatomic, retain) PGMat4* biasDepthCp;
@property (nonatomic, readonly) PGTexture* texture;

+ (instancetype)shadowMapWithSize:(PGVec2i)size;
- (instancetype)initWithSize:(PGVec2i)size;
- (CNClassType*)type;
- (void)dealloc;
- (void)bind;
- (void)unbind;
- (void)draw;
- (NSString*)description;
+ (PGMat4*)biasMatrix;
+ (CNClassType*)type;
@end


@interface PGShadowSurfaceShaderBuilder : PGViewportShaderBuilder
+ (instancetype)shadowSurfaceShaderBuilder;
- (instancetype)init;
- (CNClassType*)type;
- (NSString*)fragment;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGShadowSurfaceShader : PGShader {
@public
    PGShaderAttribute* _positionSlot;
}
@property (nonatomic, readonly) PGShaderAttribute* positionSlot;

+ (instancetype)shadowSurfaceShader;
- (instancetype)init;
- (CNClassType*)type;
- (void)loadAttributesVbDesc:(PGVertexBufferDesc*)vbDesc;
- (void)loadUniformsParam:(PGColorSource*)param;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGShadowShaderSystem : PGShaderSystem
+ (instancetype)shadowShaderSystem;
- (instancetype)init;
- (CNClassType*)type;
- (PGShadowShader*)shaderForParam:(PGColorSource*)param renderTarget:(PGRenderTarget*)renderTarget;
+ (BOOL)isColorShaderForParam:(PGColorSource*)param;
- (NSString*)description;
+ (PGShadowShaderSystem*)instance;
+ (CNClassType*)type;
@end


@interface PGShadowShaderText : PGShaderTextBuilder_impl {
@public
    BOOL _texture;
}
@property (nonatomic, readonly) BOOL texture;

+ (instancetype)shadowShaderTextWithTexture:(BOOL)texture;
- (instancetype)initWithTexture:(BOOL)texture;
- (CNClassType*)type;
- (NSString*)vertex;
- (NSString*)fragment;
- (PGShaderProgram*)program;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGShadowShader : PGShader {
@public
    BOOL _texture;
    PGShaderAttribute* _uvSlot;
    PGShaderAttribute* _positionSlot;
    PGShaderUniformMat4* _mvpUniform;
    PGShaderUniformF4* _alphaTestLevelUniform;
}
@property (nonatomic, readonly) BOOL texture;
@property (nonatomic, readonly) PGShaderAttribute* uvSlot;
@property (nonatomic, readonly) PGShaderAttribute* positionSlot;
@property (nonatomic, readonly) PGShaderUniformMat4* mvpUniform;
@property (nonatomic, readonly) PGShaderUniformF4* alphaTestLevelUniform;

+ (instancetype)shadowShaderWithTexture:(BOOL)texture program:(PGShaderProgram*)program;
- (instancetype)initWithTexture:(BOOL)texture program:(PGShaderProgram*)program;
- (CNClassType*)type;
- (void)loadAttributesVbDesc:(PGVertexBufferDesc*)vbDesc;
- (void)loadUniformsParam:(PGColorSource*)param;
- (NSString*)description;
+ (PGShadowShader*)instanceForColor;
+ (PGShadowShader*)instanceForTexture;
+ (CNClassType*)type;
@end


@interface PGShadowDrawParam : NSObject {
@public
    id<CNSeq> _percents;
    PGViewportSurface* _viewportSurface;
}
@property (nonatomic, readonly) id<CNSeq> percents;
@property (nonatomic, readonly) PGViewportSurface* viewportSurface;

+ (instancetype)shadowDrawParamWithPercents:(id<CNSeq>)percents viewportSurface:(PGViewportSurface*)viewportSurface;
- (instancetype)initWithPercents:(id<CNSeq>)percents viewportSurface:(PGViewportSurface*)viewportSurface;
- (CNClassType*)type;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGShadowDrawShaderSystem : PGShaderSystem
+ (instancetype)shadowDrawShaderSystem;
- (instancetype)init;
- (CNClassType*)type;
- (PGShadowDrawShader*)shaderForParam:(PGShadowDrawParam*)param renderTarget:(PGRenderTarget*)renderTarget;
- (NSString*)description;
+ (PGShadowDrawShaderSystem*)instance;
+ (CNObserver*)settingsChangeObs;
+ (CNClassType*)type;
@end


@interface PGShadowDrawShaderKey : PGShaderTextBuilder_impl {
@public
    NSUInteger _directLightCount;
    BOOL _viewportSurface;
}
@property (nonatomic, readonly) NSUInteger directLightCount;
@property (nonatomic, readonly) BOOL viewportSurface;

+ (instancetype)shadowDrawShaderKeyWithDirectLightCount:(NSUInteger)directLightCount viewportSurface:(BOOL)viewportSurface;
- (instancetype)initWithDirectLightCount:(NSUInteger)directLightCount viewportSurface:(BOOL)viewportSurface;
- (CNClassType*)type;
- (PGShadowDrawShader*)shader;
- (NSString*)lightsVertexUniform;
- (NSString*)lightsIn;
- (NSString*)lightsOut;
- (NSString*)lightsCalculateVaryings;
- (NSString*)lightsFragmentUniform;
- (NSString*)lightsDiffuse;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface PGShadowDrawShader : PGShader {
@public
    PGShadowDrawShaderKey* _key;
    PGShaderAttribute* _positionSlot;
    PGShaderUniformMat4* _mwcpUniform;
    NSArray* _directLightPercents;
    NSArray* _directLightDepthMwcp;
    NSArray* _directLightShadows;
}
@property (nonatomic, readonly) PGShadowDrawShaderKey* key;
@property (nonatomic, readonly) PGShaderAttribute* positionSlot;
@property (nonatomic, readonly) PGShaderUniformMat4* mwcpUniform;
@property (nonatomic, readonly) NSArray* directLightPercents;
@property (nonatomic, readonly) NSArray* directLightDepthMwcp;
@property (nonatomic, readonly) NSArray* directLightShadows;

+ (instancetype)shadowDrawShaderWithKey:(PGShadowDrawShaderKey*)key program:(PGShaderProgram*)program;
- (instancetype)initWithKey:(PGShadowDrawShaderKey*)key program:(PGShaderProgram*)program;
- (CNClassType*)type;
- (void)loadAttributesVbDesc:(PGVertexBufferDesc*)vbDesc;
- (void)loadUniformsParam:(PGShadowDrawParam*)param;
- (NSString*)description;
+ (CNClassType*)type;
@end


