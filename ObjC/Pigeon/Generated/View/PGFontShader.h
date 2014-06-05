#import "objd.h"
#import "PGVec.h"
#import "PGShader.h"
@class PGTexture;
@class PGVertexBufferDesc;
@class PGGlobal;
@class PGContext;
@class PGMatrixStack;
@class PGMat4;

@class PGFontShaderParam;
@class PGFontShaderBuilder;
@class PGFontShader;

@interface PGFontShaderParam : NSObject {
@public
    PGTexture* _texture;
    PGVec4 _color;
    PGVec2 _shift;
}
@property (nonatomic, readonly) PGTexture* texture;
@property (nonatomic, readonly) PGVec4 color;
@property (nonatomic, readonly) PGVec2 shift;

+ (instancetype)fontShaderParamWithTexture:(PGTexture*)texture color:(PGVec4)color shift:(PGVec2)shift;
- (instancetype)initWithTexture:(PGTexture*)texture color:(PGVec4)color shift:(PGVec2)shift;
- (CNClassType*)type;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface PGFontShaderBuilder : PGShaderTextBuilder_impl
+ (instancetype)fontShaderBuilder;
- (instancetype)init;
- (CNClassType*)type;
- (NSString*)vertex;
- (NSString*)fragment;
- (PGShaderProgram*)program;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGFontShader : PGShader {
@public
    PGShaderAttribute* _uvSlot;
    PGShaderAttribute* _positionSlot;
    PGShaderUniformVec4* _colorUniform;
    PGShaderUniformVec2* _shiftSlot;
}
@property (nonatomic, readonly) PGShaderAttribute* uvSlot;
@property (nonatomic, readonly) PGShaderAttribute* positionSlot;
@property (nonatomic, readonly) PGShaderUniformVec4* colorUniform;
@property (nonatomic, readonly) PGShaderUniformVec2* shiftSlot;

+ (instancetype)fontShader;
- (instancetype)init;
- (CNClassType*)type;
- (void)loadAttributesVbDesc:(PGVertexBufferDesc*)vbDesc;
- (void)loadUniformsParam:(PGFontShaderParam*)param;
- (NSString*)description;
+ (PGFontShader*)instance;
+ (CNClassType*)type;
@end


