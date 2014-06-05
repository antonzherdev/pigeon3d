#import "objd.h"
#import "PGVec.h"
@class PGShaderSystem;
@class PGMesh;
@protocol PGVertexBuffer;
@protocol PGIndexSource;
@class PGShader;
@class PGTexture;
@class PGSimpleShaderSystem;
@class PGStandardShaderSystem;
@class PGGlobal;
@class PGContext;
@class PGEnablingState;

@class PGMaterial;
@class PGColorSource;
@class PGStandardMaterial;
@class PGNormalMap;
@class PGBlendFunction;
@class PGBlendMode;

typedef enum PGBlendModeR {
    PGBlendMode_Nil = 0,
    PGBlendMode_first = 1,
    PGBlendMode_second = 2,
    PGBlendMode_multiply = 3,
    PGBlendMode_darken = 4
} PGBlendModeR;
@interface PGBlendMode : CNEnum
@property (nonatomic, readonly) NSString*(^blend)(NSString*, NSString*);

+ (NSArray*)values;
+ (PGBlendMode*)value:(PGBlendModeR)r;
@end


@interface PGMaterial : NSObject
+ (instancetype)material;
- (instancetype)init;
- (CNClassType*)type;
- (PGShaderSystem*)shaderSystem;
- (void)drawMesh:(PGMesh*)mesh;
- (void)drawVertex:(id<PGVertexBuffer>)vertex index:(id<PGIndexSource>)index;
- (PGShader*)shader;
+ (PGMaterial*)applyColor:(PGVec4)color;
+ (PGMaterial*)applyTexture:(PGTexture*)texture;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGColorSource : PGMaterial {
@public
    PGVec4 _color;
    PGTexture* _texture;
    PGBlendModeR _blendMode;
    float _alphaTestLevel;
}
@property (nonatomic, readonly) PGVec4 color;
@property (nonatomic, readonly) PGTexture* texture;
@property (nonatomic, readonly) PGBlendModeR blendMode;
@property (nonatomic, readonly) float alphaTestLevel;

+ (instancetype)colorSourceWithColor:(PGVec4)color texture:(PGTexture*)texture blendMode:(PGBlendModeR)blendMode alphaTestLevel:(float)alphaTestLevel;
- (instancetype)initWithColor:(PGVec4)color texture:(PGTexture*)texture blendMode:(PGBlendModeR)blendMode alphaTestLevel:(float)alphaTestLevel;
- (CNClassType*)type;
+ (PGColorSource*)applyColor:(PGVec4)color texture:(PGTexture*)texture;
+ (PGColorSource*)applyColor:(PGVec4)color texture:(PGTexture*)texture alphaTestLevel:(float)alphaTestLevel;
+ (PGColorSource*)applyColor:(PGVec4)color texture:(PGTexture*)texture blendMode:(PGBlendModeR)blendMode;
+ (PGColorSource*)applyColor:(PGVec4)color;
+ (PGColorSource*)applyTexture:(PGTexture*)texture;
- (PGShaderSystem*)shaderSystem;
- (PGColorSource*)setColor:(PGVec4)color;
- (PGRect)uv;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGStandardMaterial : PGMaterial {
@public
    PGColorSource* _diffuse;
    PGVec4 _specularColor;
    CGFloat _specularSize;
    PGNormalMap* _normalMap;
}
@property (nonatomic, readonly) PGColorSource* diffuse;
@property (nonatomic, readonly) PGVec4 specularColor;
@property (nonatomic, readonly) CGFloat specularSize;
@property (nonatomic, readonly) PGNormalMap* normalMap;

+ (instancetype)standardMaterialWithDiffuse:(PGColorSource*)diffuse specularColor:(PGVec4)specularColor specularSize:(CGFloat)specularSize normalMap:(PGNormalMap*)normalMap;
- (instancetype)initWithDiffuse:(PGColorSource*)diffuse specularColor:(PGVec4)specularColor specularSize:(CGFloat)specularSize normalMap:(PGNormalMap*)normalMap;
- (CNClassType*)type;
+ (PGStandardMaterial*)applyDiffuse:(PGColorSource*)diffuse;
- (PGShaderSystem*)shaderSystem;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGNormalMap : NSObject {
@public
    PGTexture* _texture;
    BOOL _tangent;
}
@property (nonatomic, readonly) PGTexture* texture;
@property (nonatomic, readonly) BOOL tangent;

+ (instancetype)normalMapWithTexture:(PGTexture*)texture tangent:(BOOL)tangent;
- (instancetype)initWithTexture:(PGTexture*)texture tangent:(BOOL)tangent;
- (CNClassType*)type;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGBlendFunction : NSObject {
@public
    unsigned int _source;
    unsigned int _destination;
}
@property (nonatomic, readonly) unsigned int source;
@property (nonatomic, readonly) unsigned int destination;

+ (instancetype)blendFunctionWithSource:(unsigned int)source destination:(unsigned int)destination;
- (instancetype)initWithSource:(unsigned int)source destination:(unsigned int)destination;
- (CNClassType*)type;
- (void)bind;
- (NSString*)description;
+ (PGBlendFunction*)standard;
+ (PGBlendFunction*)premultiplied;
+ (CNClassType*)type;
@end


