#import "PGSimpleShaderSystem.h"

#import "PGContext.h"
#import "PGShadow.h"
#import "PGTexture.h"
#import "PGVertex.h"
#import "GL.h"
#import "PGMatrixModel.h"
@implementation PGSimpleShaderSystem
static PGSimpleShaderSystem* _PGSimpleShaderSystem_instance;
static CNMHashMap* _PGSimpleShaderSystem_shaders;
static CNClassType* _PGSimpleShaderSystem_type;

+ (instancetype)simpleShaderSystem {
    return [[PGSimpleShaderSystem alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGSimpleShaderSystem class]) {
        _PGSimpleShaderSystem_type = [CNClassType classTypeWithCls:[PGSimpleShaderSystem class]];
        _PGSimpleShaderSystem_instance = [PGSimpleShaderSystem simpleShaderSystem];
        _PGSimpleShaderSystem_shaders = [CNMHashMap hashMap];
    }
}

+ (PGShader*)colorShader {
    return [_PGSimpleShaderSystem_instance shaderForParam:[PGColorSource applyColor:PGVec4Make(0.0, 0.0, 0.0, 1.0)] renderTarget:[PGGlobal context]->_renderTarget];
}

- (PGShader*)shaderForParam:(PGColorSource*)param renderTarget:(PGRenderTarget*)renderTarget {
    if([renderTarget isKindOfClass:[PGShadowRenderTarget class]]) {
        return [[PGShadowShaderSystem instance] shaderForParam:param];
    } else {
        BOOL t = ((PGColorSource*)(param))->_texture != nil;
        PGSimpleShaderKey* key = [PGSimpleShaderKey simpleShaderKeyWithTexture:t region:t && ({
            PGTexture* __tmpf_1p1b = ((PGColorSource*)(param))->_texture;
            ((__tmpf_1p1b != nil) ? [((PGTexture*)(((PGColorSource*)(param))->_texture)) isKindOfClass:[PGTextureRegion class]] : NO);
        }) blendMode:((PGColorSource*)(param))->_blendMode];
        return ((PGShader*)([_PGSimpleShaderSystem_shaders applyKey:key orUpdateWith:^PGSimpleShader*() {
            return [PGSimpleShader simpleShaderWithKey:key];
        }]));
    }
}

- (NSString*)description {
    return @"SimpleShaderSystem";
}

- (CNClassType*)type {
    return [PGSimpleShaderSystem type];
}

+ (PGSimpleShaderSystem*)instance {
    return _PGSimpleShaderSystem_instance;
}

+ (CNClassType*)type {
    return _PGSimpleShaderSystem_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGSimpleShaderKey
static CNClassType* _PGSimpleShaderKey_type;
@synthesize texture = _texture;
@synthesize region = _region;
@synthesize blendMode = _blendMode;
@synthesize fragment = _fragment;

+ (instancetype)simpleShaderKeyWithTexture:(BOOL)texture region:(BOOL)region blendMode:(PGBlendModeR)blendMode {
    return [[PGSimpleShaderKey alloc] initWithTexture:texture region:region blendMode:blendMode];
}

- (instancetype)initWithTexture:(BOOL)texture region:(BOOL)region blendMode:(PGBlendModeR)blendMode {
    self = [super init];
    if(self) {
        _texture = texture;
        _region = region;
        _blendMode = blendMode;
        _fragment = [NSString stringWithFormat:@"%@\n"
            "%@\n"
            "uniform lowp vec4 color;\n"
            "\n"
            "void main(void) {\n"
            "   %@ = %@;\n"
            "}", [self fragmentHeader], ((texture) ? [NSString stringWithFormat:@"%@ mediump vec2 UV;\n"
            "uniform lowp sampler2D txt;", [self in]] : @""), [self fragColor], [self blendMode:blendMode a:@"color" b:[NSString stringWithFormat:@"%@(txt, UV)", [self texture2D]]]];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGSimpleShaderKey class]) _PGSimpleShaderKey_type = [CNClassType classTypeWithCls:[PGSimpleShaderKey class]];
}

- (NSString*)vertex {
    return [NSString stringWithFormat:@"%@\n"
        "%@ highp vec3 position;\n"
        "uniform mat4 mvp;\n"
        "\n"
        "%@\n"
        "%@\n"
        "\n"
        "void main(void) {\n"
        "    gl_Position = mvp * vec4(position, 1);\n"
        "%@\n"
        "}", [self vertexHeader], [self ain], ((_texture) ? [NSString stringWithFormat:@"%@ mediump vec2 vertexUV;\n"
        "%@ mediump vec2 UV;", [self ain], [self out]] : @""), ((_region) ? @"uniform mediump vec2 uvShift;\n"
        "uniform mediump vec2 uvScale;" : @""), ((_texture && _region) ? @"    UV = uvScale*vertexUV + uvShift;" : [NSString stringWithFormat:@"%@", ((_texture) ? @"\n"
        "    UV = vertexUV; " : @"")])];
}

- (PGShaderProgram*)program {
    return [PGShaderProgram applyName:@"Simple" vertex:[self vertex] fragment:_fragment];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"SimpleShaderKey(%d, %d, %@)", _texture, _region, [PGBlendMode value:_blendMode]];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[PGSimpleShaderKey class]])) return NO;
    PGSimpleShaderKey* o = ((PGSimpleShaderKey*)(to));
    return _texture == o->_texture && _region == o->_region && _blendMode == o->_blendMode;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + _texture;
    hash = hash * 31 + _region;
    hash = hash * 31 + [[PGBlendMode value:_blendMode] hash];
    return hash;
}

- (CNClassType*)type {
    return [PGSimpleShaderKey type];
}

+ (CNClassType*)type {
    return _PGSimpleShaderKey_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGSimpleShader
static CNClassType* _PGSimpleShader_type;
@synthesize key = _key;
@synthesize uvSlot = _uvSlot;
@synthesize positionSlot = _positionSlot;
@synthesize mvpUniform = _mvpUniform;
@synthesize colorUniform = _colorUniform;
@synthesize uvScale = _uvScale;
@synthesize uvShift = _uvShift;

+ (instancetype)simpleShaderWithKey:(PGSimpleShaderKey*)key {
    return [[PGSimpleShader alloc] initWithKey:key];
}

- (instancetype)initWithKey:(PGSimpleShaderKey*)key {
    self = [super initWithProgram:[key program]];
    if(self) {
        _key = key;
        _uvSlot = ((key->_texture) ? [self attributeForName:@"vertexUV"] : nil);
        _positionSlot = [self attributeForName:@"position"];
        _mvpUniform = [self uniformMat4Name:@"mvp"];
        _colorUniform = [self uniformVec4OptName:@"color"];
        _uvScale = ((key->_region) ? [self uniformVec2Name:@"uvScale"] : nil);
        _uvShift = ((key->_region) ? [self uniformVec2Name:@"uvShift"] : nil);
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGSimpleShader class]) _PGSimpleShader_type = [CNClassType classTypeWithCls:[PGSimpleShader class]];
}

- (void)loadAttributesVbDesc:(PGVertexBufferDesc*)vbDesc {
    [_positionSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:3 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc->_position))];
    if(_key->_texture) [((PGShaderAttribute*)(_uvSlot)) setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc->_uv))];
}

- (void)loadUniformsParam:(PGColorSource*)param {
    [_mvpUniform applyMatrix:[[[PGGlobal matrix] value] mwcp]];
    [((PGShaderUniformVec4*)(_colorUniform)) applyVec4:((PGColorSource*)(param))->_color];
    if(_key->_texture) {
        PGTexture* tex = ((PGColorSource*)(param))->_texture;
        if(tex != nil) {
            [[PGGlobal context] bindTextureTexture:tex];
            if(_key->_region) {
                PGRect r = ((PGTextureRegion*)(tex))->_uv;
                [((PGShaderUniformVec2*)(_uvShift)) applyVec2:r.p];
                [((PGShaderUniformVec2*)(_uvScale)) applyVec2:r.size];
            }
        }
    }
}

- (NSString*)description {
    return [NSString stringWithFormat:@"SimpleShader(%@)", _key];
}

- (CNClassType*)type {
    return [PGSimpleShader type];
}

+ (CNClassType*)type {
    return _PGSimpleShader_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

