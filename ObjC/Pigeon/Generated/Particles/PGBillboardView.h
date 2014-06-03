#import "objd.h"
#import "PGShader.h"
#import "PGParticleSystemView.h"
@class PGRenderTarget;
@class PGShadowShaderSystem;
@class PGColorSource;
@class PGTexture;
@class PGVertexBufferDesc;
@class PGGlobal;
@class PGMatrixStack;
@class PGMMatrixModel;
@class PGContext;
@class PGSprite;
@class PGParticleSystem;
@class PGBlendFunction;

@class PGBillboardShaderSystem;
@class PGBillboardShaderKey;
@class PGBillboardShaderBuilder;
@class PGBillboardShader;
@class PGBillboardParticleSystemView;
@class PGBillboardShaderSpace;

typedef enum PGBillboardShaderSpaceR {
    PGBillboardShaderSpace_Nil = 0,
    PGBillboardShaderSpace_camera = 1,
    PGBillboardShaderSpace_projection = 2
} PGBillboardShaderSpaceR;
@interface PGBillboardShaderSpace : CNEnum
+ (NSArray*)values;
+ (PGBillboardShaderSpace*)value:(PGBillboardShaderSpaceR)r;
@end


@interface PGBillboardShaderSystem : PGShaderSystem {
@protected
    PGBillboardShaderSpaceR _space;
}
@property (nonatomic, readonly) PGBillboardShaderSpaceR space;

+ (instancetype)billboardShaderSystemWithSpace:(PGBillboardShaderSpaceR)space;
- (instancetype)initWithSpace:(PGBillboardShaderSpaceR)space;
- (CNClassType*)type;
- (PGBillboardShader*)shaderForParam:(PGColorSource*)param renderTarget:(PGRenderTarget*)renderTarget;
+ (PGBillboardShader*)shaderForKey:(PGBillboardShaderKey*)key;
- (NSString*)description;
+ (PGBillboardShaderSystem*)cameraSpace;
+ (PGBillboardShaderSystem*)projectionSpace;
+ (CNClassType*)type;
@end


@interface PGBillboardShaderKey : NSObject {
@protected
    BOOL _texture;
    BOOL _alpha;
    BOOL _shadow;
    PGBillboardShaderSpaceR _modelSpace;
}
@property (nonatomic, readonly) BOOL texture;
@property (nonatomic, readonly) BOOL alpha;
@property (nonatomic, readonly) BOOL shadow;
@property (nonatomic, readonly) PGBillboardShaderSpaceR modelSpace;

+ (instancetype)billboardShaderKeyWithTexture:(BOOL)texture alpha:(BOOL)alpha shadow:(BOOL)shadow modelSpace:(PGBillboardShaderSpaceR)modelSpace;
- (instancetype)initWithTexture:(BOOL)texture alpha:(BOOL)alpha shadow:(BOOL)shadow modelSpace:(PGBillboardShaderSpaceR)modelSpace;
- (CNClassType*)type;
- (PGBillboardShader*)shader;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface PGBillboardShaderBuilder : PGShaderTextBuilder_impl {
@protected
    PGBillboardShaderKey* _key;
}
@property (nonatomic, readonly) PGBillboardShaderKey* key;

+ (instancetype)billboardShaderBuilderWithKey:(PGBillboardShaderKey*)key;
- (instancetype)initWithKey:(PGBillboardShaderKey*)key;
- (CNClassType*)type;
- (NSString*)vertex;
- (NSString*)fragment;
- (PGShaderProgram*)program;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGBillboardShader : PGShader {
@protected
    PGBillboardShaderKey* _key;
    PGShaderAttribute* _positionSlot;
    PGShaderAttribute* _modelSlot;
    PGShaderAttribute* _uvSlot;
    PGShaderAttribute* _colorSlot;
    PGShaderUniformVec4* _colorUniform;
    PGShaderUniformF4* _alphaTestLevelUniform;
    PGShaderUniformMat4* _wcUniform;
    PGShaderUniformMat4* _pUniform;
    PGShaderUniformMat4* _wcpUniform;
}
@property (nonatomic, readonly) PGBillboardShaderKey* key;
@property (nonatomic, readonly) PGShaderAttribute* positionSlot;
@property (nonatomic, readonly) PGShaderAttribute* modelSlot;
@property (nonatomic, readonly) PGShaderAttribute* uvSlot;
@property (nonatomic, readonly) PGShaderAttribute* colorSlot;
@property (nonatomic, readonly) PGShaderUniformVec4* colorUniform;
@property (nonatomic, readonly) PGShaderUniformF4* alphaTestLevelUniform;
@property (nonatomic, readonly) PGShaderUniformMat4* wcUniform;
@property (nonatomic, readonly) PGShaderUniformMat4* pUniform;
@property (nonatomic, readonly) PGShaderUniformMat4* wcpUniform;

+ (instancetype)billboardShaderWithKey:(PGBillboardShaderKey*)key program:(PGShaderProgram*)program;
- (instancetype)initWithKey:(PGBillboardShaderKey*)key program:(PGShaderProgram*)program;
- (CNClassType*)type;
- (void)loadAttributesVbDesc:(PGVertexBufferDesc*)vbDesc;
- (void)loadUniformsParam:(PGColorSource*)param;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGBillboardParticleSystemView : PGParticleSystemViewIndexArray
+ (instancetype)billboardParticleSystemViewWithSystem:(PGParticleSystem*)system material:(PGColorSource*)material blendFunc:(PGBlendFunction*)blendFunc;
- (instancetype)initWithSystem:(PGParticleSystem*)system material:(PGColorSource*)material blendFunc:(PGBlendFunction*)blendFunc;
- (CNClassType*)type;
+ (PGBillboardParticleSystemView*)applySystem:(PGParticleSystem*)system material:(PGColorSource*)material;
- (NSString*)description;
+ (CNClassType*)type;
@end


