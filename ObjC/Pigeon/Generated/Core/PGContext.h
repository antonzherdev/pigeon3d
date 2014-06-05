#import "objd.h"
#import "PGTexture.h"
#import "PGVec.h"
@class PGMatrixStack;
@class PGDirector;
@class PGFont;
@class CNVar;
@class CNReact;
@class PGBlendFunction;
@class PGBMFont;
@class PGTTFFont;
@class PGShaderProgram;
@protocol PGVertexBuffer;
@class CNChain;
@class PGShadowMap;
@class PGMatrixModel;
@class PGMat4;
@class PGMMatrixModel;
@class CNSignal;

@class PGGlobal;
@class PGContext;
@class PGEnablingState;
@class PGCullFace;
@class PGRenderTarget;
@class PGSceneRenderTarget;
@class PGShadowRenderTarget;
@class PGEnvironment;
@class PGLight;
@class PGDirectLight;
@class PGSettings;
@class PGShadowType;

typedef enum PGShadowTypeR {
    PGShadowType_Nil = 0,
    PGShadowType_no = 1,
    PGShadowType_shadow2d = 2,
    PGShadowType_sample2d = 3
} PGShadowTypeR;
@interface PGShadowType : CNEnum
@property (nonatomic, readonly) BOOL isOn;

- (BOOL)isOff;
+ (NSArray*)values;
+ (PGShadowType*)value:(PGShadowTypeR)r;
@end


@interface PGGlobal : NSObject
- (CNClassType*)type;
+ (PGTexture*)compressedTextureForFile:(NSString*)file;
+ (PGTexture*)compressedTextureForFile:(NSString*)file filter:(PGTextureFilterR)filter;
+ (PGTexture*)textureForFile:(NSString*)file fileFormat:(PGTextureFileFormatR)fileFormat format:(PGTextureFormatR)format filter:(PGTextureFilterR)filter;
+ (PGTexture*)textureForFile:(NSString*)file fileFormat:(PGTextureFileFormatR)fileFormat format:(PGTextureFormatR)format;
+ (PGTexture*)textureForFile:(NSString*)file fileFormat:(PGTextureFileFormatR)fileFormat filter:(PGTextureFilterR)filter;
+ (PGTexture*)textureForFile:(NSString*)file fileFormat:(PGTextureFileFormatR)fileFormat;
+ (PGTexture*)textureForFile:(NSString*)file format:(PGTextureFormatR)format filter:(PGTextureFilterR)filter;
+ (PGTexture*)textureForFile:(NSString*)file format:(PGTextureFormatR)format;
+ (PGTexture*)textureForFile:(NSString*)file filter:(PGTextureFilterR)filter;
+ (PGTexture*)textureForFile:(NSString*)file;
+ (PGTexture*)scaledTextureForName:(NSString*)name fileFormat:(PGTextureFileFormatR)fileFormat format:(PGTextureFormatR)format;
+ (PGTexture*)scaledTextureForName:(NSString*)name fileFormat:(PGTextureFileFormatR)fileFormat;
+ (PGTexture*)scaledTextureForName:(NSString*)name format:(PGTextureFormatR)format;
+ (PGTexture*)scaledTextureForName:(NSString*)name;
+ (PGFont*)fontWithName:(NSString*)name;
+ (PGFont*)fontWithName:(NSString*)name size:(NSUInteger)size;
+ (PGFont*)mainFontWithSize:(NSUInteger)size;
+ (PGContext*)context;
+ (PGSettings*)settings;
+ (PGMatrixStack*)matrix;
+ (CNClassType*)type;
@end


@interface PGContext : NSObject {
@public
    CNVar* _viewSize;
    CNReact* _scaledViewSize;
    BOOL _ttf;
    CNMHashMap* _textureCache;
    CNMHashMap* _fontCache;
    PGEnvironment* _environment;
    PGMatrixStack* _matrixStack;
    PGRenderTarget* _renderTarget;
    BOOL _considerShadows;
    BOOL _redrawShadows;
    BOOL _redrawFrame;
    PGRectI __viewport;
    unsigned int __lastTexture2D;
    CNMHashMap* __lastTextures;
    unsigned int __lastShaderProgram;
    unsigned int __lastRenderBuffer;
    unsigned int __lastVertexBufferId;
    unsigned int __lastVertexBufferCount;
    unsigned int __lastIndexBuffer;
    unsigned int __lastVertexArray;
    unsigned int _defaultVertexArray;
    BOOL __needBindDefaultVertexArray;
    PGCullFace* _cullFace;
    PGEnablingState* _blend;
    PGEnablingState* _depthTest;
    PGVec4 __lastClearColor;
    PGBlendFunction* __blendFunction;
    PGBlendFunction* __blendFunctionComing;
    BOOL __blendFunctionChanged;
}
@property (nonatomic, readonly) CNVar* viewSize;
@property (nonatomic, readonly) CNReact* scaledViewSize;
@property (nonatomic) BOOL ttf;
@property (nonatomic, retain) PGEnvironment* environment;
@property (nonatomic, readonly) PGMatrixStack* matrixStack;
@property (nonatomic, retain) PGRenderTarget* renderTarget;
@property (nonatomic) BOOL considerShadows;
@property (nonatomic) BOOL redrawShadows;
@property (nonatomic) BOOL redrawFrame;
@property (nonatomic) unsigned int defaultVertexArray;
@property (nonatomic, readonly) PGCullFace* cullFace;
@property (nonatomic, readonly) PGEnablingState* blend;
@property (nonatomic, readonly) PGEnablingState* depthTest;

+ (instancetype)context;
- (instancetype)init;
- (CNClassType*)type;
- (PGTexture*)textureForName:(NSString*)name fileFormat:(PGTextureFileFormatR)fileFormat format:(PGTextureFormatR)format scale:(CGFloat)scale filter:(PGTextureFilterR)filter;
- (PGFont*)fontWithName:(NSString*)name;
- (PGFont*)mainFontWithSize:(NSUInteger)size;
- (PGFont*)fontWithName:(NSString*)name size:(NSUInteger)size;
- (void)clear;
- (void)clearCache;
- (PGRectI)viewport;
- (void)setViewport:(PGRectI)viewport;
- (void)bindTextureTextureId:(unsigned int)textureId;
- (void)bindTextureTexture:(PGTexture*)texture;
- (void)bindTextureSlot:(unsigned int)slot target:(unsigned int)target texture:(PGTexture*)texture;
- (void)deleteTextureId:(unsigned int)id;
- (void)bindShaderProgramProgram:(PGShaderProgram*)program;
- (void)deleteShaderProgramId:(unsigned int)id;
- (void)bindRenderBufferId:(unsigned int)id;
- (void)deleteRenderBufferId:(unsigned int)id;
- (void)bindVertexBufferBuffer:(id<PGVertexBuffer>)buffer;
- (unsigned int)vertexBufferCount;
- (void)bindIndexBufferHandle:(unsigned int)handle;
- (void)deleteBufferId:(unsigned int)id;
- (void)bindVertexArrayHandle:(unsigned int)handle vertexCount:(unsigned int)vertexCount mutable:(BOOL)mutable;
- (void)deleteVertexArrayId:(unsigned int)id;
- (void)bindDefaultVertexArray;
- (void)checkBindDefaultVertexArray;
- (void)draw;
- (void)clearColorColor:(PGVec4)color;
- (PGBlendFunction*)blendFunction;
- (void)setBlendFunction:(PGBlendFunction*)blendFunction;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGEnablingState : NSObject {
@public
    unsigned int _tp;
    BOOL __last;
    BOOL __coming;
}
@property (nonatomic, readonly) unsigned int tp;

+ (instancetype)enablingStateWithTp:(unsigned int)tp;
- (instancetype)initWithTp:(unsigned int)tp;
- (CNClassType*)type;
- (BOOL)enable;
- (BOOL)disable;
- (void)draw;
- (void)clear;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGCullFace : NSObject {
@public
    unsigned int __lastActiveValue;
    unsigned int __value;
    unsigned int __comingValue;
}
+ (instancetype)cullFace;
- (instancetype)init;
- (CNClassType*)type;
- (void)setValue:(unsigned int)value;
- (void)draw;
- (unsigned int)disable;
- (unsigned int)invert;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGRenderTarget : NSObject
+ (instancetype)renderTarget;
- (instancetype)init;
- (CNClassType*)type;
- (BOOL)isShadow;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGSceneRenderTarget : PGRenderTarget
+ (instancetype)sceneRenderTarget;
- (instancetype)init;
- (CNClassType*)type;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGShadowRenderTarget : PGRenderTarget {
@public
    PGLight* _shadowLight;
}
@property (nonatomic, readonly) PGLight* shadowLight;

+ (instancetype)shadowRenderTargetWithShadowLight:(PGLight*)shadowLight;
- (instancetype)initWithShadowLight:(PGLight*)shadowLight;
- (CNClassType*)type;
- (BOOL)isShadow;
- (NSString*)description;
+ (PGShadowRenderTarget*)aDefault;
+ (CNClassType*)type;
@end


@interface PGEnvironment : NSObject {
@public
    PGVec4 _ambientColor;
    NSArray* _lights;
    NSArray* _directLights;
    NSArray* _directLightsWithShadows;
    NSArray* _directLightsWithoutShadows;
}
@property (nonatomic, readonly) PGVec4 ambientColor;
@property (nonatomic, readonly) NSArray* lights;
@property (nonatomic, readonly) NSArray* directLights;
@property (nonatomic, readonly) NSArray* directLightsWithShadows;
@property (nonatomic, readonly) NSArray* directLightsWithoutShadows;

+ (instancetype)environmentWithAmbientColor:(PGVec4)ambientColor lights:(NSArray*)lights;
- (instancetype)initWithAmbientColor:(PGVec4)ambientColor lights:(NSArray*)lights;
- (CNClassType*)type;
+ (PGEnvironment*)applyLights:(NSArray*)lights;
+ (PGEnvironment*)applyLight:(PGLight*)light;
- (NSString*)description;
+ (PGEnvironment*)aDefault;
+ (CNClassType*)type;
@end


@interface PGLight : NSObject {
@public
    PGVec4 _color;
    BOOL _hasShadows;
    CNLazy* __lazy_shadowMap;
}
@property (nonatomic, readonly) PGVec4 color;
@property (nonatomic, readonly) BOOL hasShadows;

+ (instancetype)lightWithColor:(PGVec4)color hasShadows:(BOOL)hasShadows;
- (instancetype)initWithColor:(PGVec4)color hasShadows:(BOOL)hasShadows;
- (CNClassType*)type;
- (PGShadowMap*)shadowMap;
- (PGMatrixModel*)shadowMatrixModel:(PGMatrixModel*)model;
- (NSString*)description;
+ (PGLight*)aDefault;
+ (CNClassType*)type;
@end


@interface PGDirectLight : PGLight {
@public
    PGVec3 _direction;
    PGMat4* _shadowsProjectionMatrix;
}
@property (nonatomic, readonly) PGVec3 direction;
@property (nonatomic, readonly) PGMat4* shadowsProjectionMatrix;

+ (instancetype)directLightWithColor:(PGVec4)color direction:(PGVec3)direction hasShadows:(BOOL)hasShadows shadowsProjectionMatrix:(PGMat4*)shadowsProjectionMatrix;
- (instancetype)initWithColor:(PGVec4)color direction:(PGVec3)direction hasShadows:(BOOL)hasShadows shadowsProjectionMatrix:(PGMat4*)shadowsProjectionMatrix;
- (CNClassType*)type;
+ (PGDirectLight*)applyColor:(PGVec4)color direction:(PGVec3)direction;
+ (PGDirectLight*)applyColor:(PGVec4)color direction:(PGVec3)direction shadowsProjectionMatrix:(PGMat4*)shadowsProjectionMatrix;
- (PGMatrixModel*)shadowMatrixModel:(PGMatrixModel*)model;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGSettings : NSObject {
@public
    CNSignal* _shadowTypeChanged;
    PGShadowTypeR __shadowType;
}
@property (nonatomic, readonly) CNSignal* shadowTypeChanged;

+ (instancetype)settings;
- (instancetype)init;
- (CNClassType*)type;
- (PGShadowTypeR)shadowType;
- (void)setShadowType:(PGShadowTypeR)shadowType;
- (NSString*)description;
+ (CNClassType*)type;
@end


