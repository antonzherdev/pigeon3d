#import "objd.h"
#import "PGShader.h"
#import "PGMaterial.h"
#import "PGVec.h"
@class CNObserver;
@class PGGlobal;
@class PGSettings;
@class CNSignal;
@class PGRenderTarget;
@class PGShadowShaderSystem;
@class PGContext;
@class PGEnvironment;
@class PGLight;
@class CNChain;
@class PGTexture;
@class PGPlatform;
@class PGShadowShader;
@class PGVertexBufferDesc;
@class PGMatrixStack;
@class PGMMatrixModel;
@class PGTextureRegion;
@class PGDirectLight;
@class PGMat4;
@class PGShadowMap;

@class PGStandardShaderSystem;
@class PGStandardShadowShader;
@class PGStandardShaderKey;
@class PGStandardShader;

@interface PGStandardShaderSystem : PGShaderSystem
+ (instancetype)standardShaderSystem;
- (instancetype)init;
- (CNClassType*)type;
- (PGShader*)shaderForParam:(PGStandardMaterial*)param renderTarget:(PGRenderTarget*)renderTarget;
- (NSString*)description;
+ (PGStandardShaderSystem*)instance;
+ (CNObserver*)settingsChangeObs;
+ (CNClassType*)type;
@end


@interface PGStandardShadowShader : PGShader {
@protected
    PGShadowShader* _shadowShader;
}
@property (nonatomic, readonly) PGShadowShader* shadowShader;

+ (instancetype)standardShadowShaderWithShadowShader:(PGShadowShader*)shadowShader;
- (instancetype)initWithShadowShader:(PGShadowShader*)shadowShader;
- (CNClassType*)type;
- (void)loadAttributesVbDesc:(PGVertexBufferDesc*)vbDesc;
- (void)loadUniformsParam:(PGStandardMaterial*)param;
- (NSString*)description;
+ (PGStandardShadowShader*)instanceForColor;
+ (PGStandardShadowShader*)instanceForTexture;
+ (CNClassType*)type;
@end


@interface PGStandardShaderKey : PGShaderTextBuilder_impl {
@protected
    NSUInteger _directLightWithShadowsCount;
    NSUInteger _directLightWithoutShadowsCount;
    BOOL _texture;
    PGBlendModeR _blendMode;
    BOOL _region;
    BOOL _specular;
    BOOL _normalMap;
    BOOL _perPixel;
    BOOL _needUV;
    NSUInteger _directLightCount;
}
@property (nonatomic, readonly) NSUInteger directLightWithShadowsCount;
@property (nonatomic, readonly) NSUInteger directLightWithoutShadowsCount;
@property (nonatomic, readonly) BOOL texture;
@property (nonatomic, readonly) PGBlendModeR blendMode;
@property (nonatomic, readonly) BOOL region;
@property (nonatomic, readonly) BOOL specular;
@property (nonatomic, readonly) BOOL normalMap;
@property (nonatomic, readonly) BOOL perPixel;
@property (nonatomic, readonly) BOOL needUV;
@property (nonatomic, readonly) NSUInteger directLightCount;

+ (instancetype)standardShaderKeyWithDirectLightWithShadowsCount:(NSUInteger)directLightWithShadowsCount directLightWithoutShadowsCount:(NSUInteger)directLightWithoutShadowsCount texture:(BOOL)texture blendMode:(PGBlendModeR)blendMode region:(BOOL)region specular:(BOOL)specular normalMap:(BOOL)normalMap;
- (instancetype)initWithDirectLightWithShadowsCount:(NSUInteger)directLightWithShadowsCount directLightWithoutShadowsCount:(NSUInteger)directLightWithoutShadowsCount texture:(BOOL)texture blendMode:(PGBlendModeR)blendMode region:(BOOL)region specular:(BOOL)specular normalMap:(BOOL)normalMap;
- (CNClassType*)type;
- (PGStandardShader*)shader;
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


@interface PGStandardShader : PGShader {
@protected
    PGStandardShaderKey* _key;
    PGShaderAttribute* _positionSlot;
    PGShaderAttribute* _normalSlot;
    PGShaderAttribute* _uvSlot;
    PGShaderUniformI4* _diffuseTexture;
    PGShaderUniformI4* _normalMap;
    PGShaderUniformVec2* _uvScale;
    PGShaderUniformVec2* _uvShift;
    PGShaderUniformVec4* _ambientColor;
    PGShaderUniformVec4* _specularColor;
    PGShaderUniformF4* _specularSize;
    PGShaderUniformVec4* _diffuseColorUniform;
    PGShaderUniformMat4* _mwcpUniform;
    PGShaderUniformMat4* _mwcUniform;
    NSArray* _directLightDirections;
    NSArray* _directLightColors;
    NSArray* _directLightShadows;
    NSArray* _directLightDepthMwcp;
}
@property (nonatomic, readonly) PGStandardShaderKey* key;
@property (nonatomic, readonly) PGShaderAttribute* positionSlot;
@property (nonatomic, readonly) PGShaderAttribute* normalSlot;
@property (nonatomic, readonly) PGShaderAttribute* uvSlot;
@property (nonatomic, readonly) PGShaderUniformI4* diffuseTexture;
@property (nonatomic, readonly) PGShaderUniformI4* normalMap;
@property (nonatomic, readonly) PGShaderUniformVec2* uvScale;
@property (nonatomic, readonly) PGShaderUniformVec2* uvShift;
@property (nonatomic, readonly) PGShaderUniformVec4* ambientColor;
@property (nonatomic, readonly) PGShaderUniformVec4* specularColor;
@property (nonatomic, readonly) PGShaderUniformF4* specularSize;
@property (nonatomic, readonly) PGShaderUniformVec4* diffuseColorUniform;
@property (nonatomic, readonly) PGShaderUniformMat4* mwcpUniform;
@property (nonatomic, readonly) PGShaderUniformMat4* mwcUniform;
@property (nonatomic, readonly) NSArray* directLightDirections;
@property (nonatomic, readonly) NSArray* directLightColors;
@property (nonatomic, readonly) NSArray* directLightShadows;
@property (nonatomic, readonly) NSArray* directLightDepthMwcp;

+ (instancetype)standardShaderWithKey:(PGStandardShaderKey*)key program:(PGShaderProgram*)program;
- (instancetype)initWithKey:(PGStandardShaderKey*)key program:(PGShaderProgram*)program;
- (CNClassType*)type;
- (void)loadAttributesVbDesc:(PGVertexBufferDesc*)vbDesc;
- (void)loadUniformsParam:(PGStandardMaterial*)param;
- (NSString*)description;
+ (CNClassType*)type;
@end


