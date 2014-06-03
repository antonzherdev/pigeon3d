#import "objd.h"
#import "PGShader.h"
#import "PGVec.h"
#import "PGMaterial.h"
@class PGGlobal;
@class PGContext;
@class PGRenderTarget;
@class PGShadowShaderSystem;
@class PGTexture;
@class PGVertexBufferDesc;
@class PGMatrixStack;
@class PGMMatrixModel;
@class PGTextureRegion;

@class PGSimpleShaderSystem;
@class PGSimpleShaderKey;
@class PGSimpleShader;

@interface PGSimpleShaderSystem : PGShaderSystem
+ (instancetype)simpleShaderSystem;
- (instancetype)init;
- (CNClassType*)type;
+ (PGShader*)colorShader;
- (PGShader*)shaderForParam:(PGColorSource*)param renderTarget:(PGRenderTarget*)renderTarget;
- (NSString*)description;
+ (PGSimpleShaderSystem*)instance;
+ (CNClassType*)type;
@end


@interface PGSimpleShaderKey : PGShaderTextBuilder_impl {
@protected
    BOOL _texture;
    BOOL _region;
    PGBlendModeR _blendMode;
    NSString* _fragment;
}
@property (nonatomic, readonly) BOOL texture;
@property (nonatomic, readonly) BOOL region;
@property (nonatomic, readonly) PGBlendModeR blendMode;
@property (nonatomic, readonly) NSString* fragment;

+ (instancetype)simpleShaderKeyWithTexture:(BOOL)texture region:(BOOL)region blendMode:(PGBlendModeR)blendMode;
- (instancetype)initWithTexture:(BOOL)texture region:(BOOL)region blendMode:(PGBlendModeR)blendMode;
- (CNClassType*)type;
- (NSString*)vertex;
- (PGShaderProgram*)program;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface PGSimpleShader : PGShader {
@protected
    PGSimpleShaderKey* _key;
    PGShaderAttribute* _uvSlot;
    PGShaderAttribute* _positionSlot;
    PGShaderUniformMat4* _mvpUniform;
    PGShaderUniformVec4* _colorUniform;
    PGShaderUniformVec2* _uvScale;
    PGShaderUniformVec2* _uvShift;
}
@property (nonatomic, readonly) PGSimpleShaderKey* key;
@property (nonatomic, readonly) PGShaderAttribute* uvSlot;
@property (nonatomic, readonly) PGShaderAttribute* positionSlot;
@property (nonatomic, readonly) PGShaderUniformMat4* mvpUniform;
@property (nonatomic, readonly) PGShaderUniformVec4* colorUniform;
@property (nonatomic, readonly) PGShaderUniformVec2* uvScale;
@property (nonatomic, readonly) PGShaderUniformVec2* uvShift;

+ (instancetype)simpleShaderWithKey:(PGSimpleShaderKey*)key;
- (instancetype)initWithKey:(PGSimpleShaderKey*)key;
- (CNClassType*)type;
- (void)loadAttributesVbDesc:(PGVertexBufferDesc*)vbDesc;
- (void)loadUniformsParam:(PGColorSource*)param;
- (NSString*)description;
+ (CNClassType*)type;
@end


