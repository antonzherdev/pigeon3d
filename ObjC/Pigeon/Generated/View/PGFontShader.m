#import "PGFontShader.h"

#import "PGTexture.h"
#import "PGVertex.h"
#import "GL.h"
#import "PGContext.h"
#import "PGMatrixModel.h"
#import "PGMat4.h"
@implementation PGFontShaderParam
static CNClassType* _PGFontShaderParam_type;
@synthesize texture = _texture;
@synthesize color = _color;
@synthesize shift = _shift;

+ (instancetype)fontShaderParamWithTexture:(PGTexture*)texture color:(PGVec4)color shift:(PGVec2)shift {
    return [[PGFontShaderParam alloc] initWithTexture:texture color:color shift:shift];
}

- (instancetype)initWithTexture:(PGTexture*)texture color:(PGVec4)color shift:(PGVec2)shift {
    self = [super init];
    if(self) {
        _texture = texture;
        _color = color;
        _shift = shift;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGFontShaderParam class]) _PGFontShaderParam_type = [CNClassType classTypeWithCls:[PGFontShaderParam class]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"FontShaderParam(%@, %@, %@)", _texture, pgVec4Description(_color), pgVec2Description(_shift)];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[PGFontShaderParam class]])) return NO;
    PGFontShaderParam* o = ((PGFontShaderParam*)(to));
    return [_texture isEqual:o.texture] && pgVec4IsEqualTo(_color, o.color) && pgVec2IsEqualTo(_shift, o.shift);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [_texture hash];
    hash = hash * 31 + pgVec4Hash(_color);
    hash = hash * 31 + pgVec2Hash(_shift);
    return hash;
}

- (CNClassType*)type {
    return [PGFontShaderParam type];
}

+ (CNClassType*)type {
    return _PGFontShaderParam_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGFontShaderBuilder
static CNClassType* _PGFontShaderBuilder_type;

+ (instancetype)fontShaderBuilder {
    return [[PGFontShaderBuilder alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGFontShaderBuilder class]) _PGFontShaderBuilder_type = [CNClassType classTypeWithCls:[PGFontShaderBuilder class]];
}

- (NSString*)vertex {
    return [NSString stringWithFormat:@"%@\n"
        "uniform highp vec2 shift;\n"
        "%@ highp vec2 position;\n"
        "%@ mediump vec2 vertexUV;\n"
        "\n"
        "%@ mediump vec2 UV;\n"
        "\n"
        "void main(void) {\n"
        "    gl_Position = vec4(position.x + shift.x, position.y + shift.y, 0, 1);\n"
        "    UV = vertexUV;\n"
        "}", [self vertexHeader], [self ain], [self ain], [self out]];
}

- (NSString*)fragment {
    return [NSString stringWithFormat:@"%@\n"
        "%@ mediump vec2 UV;\n"
        "uniform lowp sampler2D txt;\n"
        "uniform lowp vec4 color;\n"
        "\n"
        "void main(void) {\n"
        "    %@ = color * %@(txt, UV);\n"
        "}", [self fragmentHeader], [self in], [self fragColor], [self texture2D]];
}

- (PGShaderProgram*)program {
    return [PGShaderProgram applyName:@"Font" vertex:[self vertex] fragment:[self fragment]];
}

- (NSString*)description {
    return @"FontShaderBuilder";
}

- (CNClassType*)type {
    return [PGFontShaderBuilder type];
}

+ (CNClassType*)type {
    return _PGFontShaderBuilder_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGFontShader
static PGFontShader* _PGFontShader_instance;
static CNClassType* _PGFontShader_type;
@synthesize uvSlot = _uvSlot;
@synthesize positionSlot = _positionSlot;
@synthesize colorUniform = _colorUniform;
@synthesize shiftSlot = _shiftSlot;

+ (instancetype)fontShader {
    return [[PGFontShader alloc] init];
}

- (instancetype)init {
    self = [super initWithProgram:[[PGFontShaderBuilder fontShaderBuilder] program]];
    if(self) {
        _uvSlot = [self attributeForName:@"vertexUV"];
        _positionSlot = [self attributeForName:@"position"];
        _colorUniform = [self uniformVec4Name:@"color"];
        _shiftSlot = [self uniformVec2Name:@"shift"];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGFontShader class]) {
        _PGFontShader_type = [CNClassType classTypeWithCls:[PGFontShader class]];
        _PGFontShader_instance = [PGFontShader fontShader];
    }
}

- (void)loadAttributesVbDesc:(PGVertexBufferDesc*)vbDesc {
    [_positionSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.position))];
    [_uvSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.uv))];
}

- (void)loadUniformsParam:(PGFontShaderParam*)param {
    [PGGlobal.context bindTextureTexture:((PGFontShaderParam*)(param)).texture];
    [_colorUniform applyVec4:((PGFontShaderParam*)(param)).color];
    [_shiftSlot applyVec2:pgVec4Xy(([[PGGlobal.matrix p] mulVec4:pgVec4ApplyVec2ZW(((PGFontShaderParam*)(param)).shift, 0.0, 0.0)]))];
}

- (NSString*)description {
    return @"FontShader";
}

- (CNClassType*)type {
    return [PGFontShader type];
}

+ (PGFontShader*)instance {
    return _PGFontShader_instance;
}

+ (CNClassType*)type {
    return _PGFontShader_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

