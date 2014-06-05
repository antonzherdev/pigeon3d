#import "PGBillboardView.h"

#import "PGContext.h"
#import "PGShadow.h"
#import "PGMaterial.h"
#import "PGTexture.h"
#import "PGVertex.h"
#import "GL.h"
#import "PGMatrixModel.h"
#import "PGSprite.h"
#import "PGParticleSystem.h"
@implementation PGBillboardShaderSystem
static PGBillboardShaderSystem* _PGBillboardShaderSystem_cameraSpace;
static PGBillboardShaderSystem* _PGBillboardShaderSystem_projectionSpace;
static CNMHashMap* _PGBillboardShaderSystem_map;
static CNClassType* _PGBillboardShaderSystem_type;
@synthesize space = _space;

+ (instancetype)billboardShaderSystemWithSpace:(PGBillboardShaderSpaceR)space {
    return [[PGBillboardShaderSystem alloc] initWithSpace:space];
}

- (instancetype)initWithSpace:(PGBillboardShaderSpaceR)space {
    self = [super init];
    if(self) _space = space;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGBillboardShaderSystem class]) {
        _PGBillboardShaderSystem_type = [CNClassType classTypeWithCls:[PGBillboardShaderSystem class]];
        _PGBillboardShaderSystem_cameraSpace = [PGBillboardShaderSystem billboardShaderSystemWithSpace:PGBillboardShaderSpace_camera];
        _PGBillboardShaderSystem_projectionSpace = [PGBillboardShaderSystem billboardShaderSystemWithSpace:PGBillboardShaderSpace_projection];
        _PGBillboardShaderSystem_map = [CNMHashMap hashMap];
    }
}

- (PGBillboardShader*)shaderForParam:(PGColorSource*)param renderTarget:(PGRenderTarget*)renderTarget {
    PGBillboardShaderKey* key = [PGBillboardShaderKey billboardShaderKeyWithTexture:([renderTarget isKindOfClass:[PGShadowRenderTarget class]] && !([PGShadowShaderSystem isColorShaderForParam:param])) || ((PGColorSource*)(param))->_texture != nil alpha:((PGColorSource*)(param))->_alphaTestLevel > -0.1 shadow:[renderTarget isKindOfClass:[PGShadowRenderTarget class]] modelSpace:_space];
    return [_PGBillboardShaderSystem_map applyKey:key orUpdateWith:^PGBillboardShader*() {
        return [key shader];
    }];
}

+ (PGBillboardShader*)shaderForKey:(PGBillboardShaderKey*)key {
    return [_PGBillboardShaderSystem_map applyKey:key orUpdateWith:^PGBillboardShader*() {
        return [key shader];
    }];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"BillboardShaderSystem(%@)", [PGBillboardShaderSpace value:_space]];
}

- (CNClassType*)type {
    return [PGBillboardShaderSystem type];
}

+ (PGBillboardShaderSystem*)cameraSpace {
    return _PGBillboardShaderSystem_cameraSpace;
}

+ (PGBillboardShaderSystem*)projectionSpace {
    return _PGBillboardShaderSystem_projectionSpace;
}

+ (CNClassType*)type {
    return _PGBillboardShaderSystem_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

PGBillboardShaderSpace* PGBillboardShaderSpace_Values[3];
PGBillboardShaderSpace* PGBillboardShaderSpace_camera_Desc;
PGBillboardShaderSpace* PGBillboardShaderSpace_projection_Desc;
@implementation PGBillboardShaderSpace

+ (instancetype)billboardShaderSpaceWithOrdinal:(NSUInteger)ordinal name:(NSString*)name {
    return [[PGBillboardShaderSpace alloc] initWithOrdinal:ordinal name:name];
}

- (instancetype)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name {
    self = [super initWithOrdinal:ordinal name:name];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    PGBillboardShaderSpace_camera_Desc = [PGBillboardShaderSpace billboardShaderSpaceWithOrdinal:0 name:@"camera"];
    PGBillboardShaderSpace_projection_Desc = [PGBillboardShaderSpace billboardShaderSpaceWithOrdinal:1 name:@"projection"];
    PGBillboardShaderSpace_Values[0] = nil;
    PGBillboardShaderSpace_Values[1] = PGBillboardShaderSpace_camera_Desc;
    PGBillboardShaderSpace_Values[2] = PGBillboardShaderSpace_projection_Desc;
}

+ (NSArray*)values {
    return (@[PGBillboardShaderSpace_camera_Desc, PGBillboardShaderSpace_projection_Desc]);
}

+ (PGBillboardShaderSpace*)value:(PGBillboardShaderSpaceR)r {
    return PGBillboardShaderSpace_Values[r];
}

@end

@implementation PGBillboardShaderKey
static CNClassType* _PGBillboardShaderKey_type;
@synthesize texture = _texture;
@synthesize alpha = _alpha;
@synthesize shadow = _shadow;
@synthesize modelSpace = _modelSpace;

+ (instancetype)billboardShaderKeyWithTexture:(BOOL)texture alpha:(BOOL)alpha shadow:(BOOL)shadow modelSpace:(PGBillboardShaderSpaceR)modelSpace {
    return [[PGBillboardShaderKey alloc] initWithTexture:texture alpha:alpha shadow:shadow modelSpace:modelSpace];
}

- (instancetype)initWithTexture:(BOOL)texture alpha:(BOOL)alpha shadow:(BOOL)shadow modelSpace:(PGBillboardShaderSpaceR)modelSpace {
    self = [super init];
    if(self) {
        _texture = texture;
        _alpha = alpha;
        _shadow = shadow;
        _modelSpace = modelSpace;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGBillboardShaderKey class]) _PGBillboardShaderKey_type = [CNClassType classTypeWithCls:[PGBillboardShaderKey class]];
}

- (PGBillboardShader*)shader {
    return [PGBillboardShader billboardShaderWithKey:self program:[[PGBillboardShaderBuilder billboardShaderBuilderWithKey:self] program]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"BillboardShaderKey(%d, %d, %d, %@)", _texture, _alpha, _shadow, [PGBillboardShaderSpace value:_modelSpace]];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[PGBillboardShaderKey class]])) return NO;
    PGBillboardShaderKey* o = ((PGBillboardShaderKey*)(to));
    return _texture == o->_texture && _alpha == o->_alpha && _shadow == o->_shadow && _modelSpace == o->_modelSpace;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + _texture;
    hash = hash * 31 + _alpha;
    hash = hash * 31 + _shadow;
    hash = hash * 31 + [[PGBillboardShaderSpace value:_modelSpace] hash];
    return hash;
}

- (CNClassType*)type {
    return [PGBillboardShaderKey type];
}

+ (CNClassType*)type {
    return _PGBillboardShaderKey_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGBillboardShaderBuilder
static CNClassType* _PGBillboardShaderBuilder_type;
@synthesize key = _key;

+ (instancetype)billboardShaderBuilderWithKey:(PGBillboardShaderKey*)key {
    return [[PGBillboardShaderBuilder alloc] initWithKey:key];
}

- (instancetype)initWithKey:(PGBillboardShaderKey*)key {
    self = [super init];
    if(self) _key = key;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGBillboardShaderBuilder class]) _PGBillboardShaderBuilder_type = [CNClassType classTypeWithCls:[PGBillboardShaderBuilder class]];
}

- (NSString*)vertex {
    return [NSString stringWithFormat:@"%@\n"
        "%@ highp vec3 position;\n"
        "%@ lowp vec2 model;\n"
        "%@\n"
        "%@ lowp vec4 vertexColor;\n"
        "%@\n"
        "%@ vec4 fColor;\n"
        "\n"
        "void main(void) {\n"
        "   %@%@\n"
        "    fColor = vertexColor;\n"
        "}", [self vertexHeader], [self ain], [self ain], ((_key->_texture) ? [NSString stringWithFormat:@"%@ mediump vec2 vertexUV;\n"
        "%@ mediump vec2 UV;", [self ain], [self out]] : @""), [self ain], ((_key->_modelSpace == PGBillboardShaderSpace_camera) ? @"uniform mat4 wc;\n"
        "uniform mat4 p;" : @"uniform mat4 wcp;"), [self out], ((_key->_modelSpace == PGBillboardShaderSpace_camera) ? @"    highp vec4 pos = wc*vec4(position, 1);\n"
        "    pos.x += model.x;\n"
        "    pos.y += model.y;\n"
        "    gl_Position = p*pos;\n"
        "   " : @"    gl_Position = wcp*vec4(position.xy, position.z, 1);\n"
        "    gl_Position.xy += model;\n"
        "   "), ((_key->_texture) ? @"\n"
        "    UV = vertexUV;" : @"")];
}

- (NSString*)fragment {
    return [NSString stringWithFormat:@"%@\n"
        "\n"
        "%@\n"
        "uniform lowp vec4 color;\n"
        "uniform lowp float alphaTestLevel;\n"
        "%@ lowp vec4 fColor;\n"
        "%@\n"
        "\n"
        "void main(void) {%@\n"
        "   %@\n"
        "   %@%@\n"
        "}", [self versionString], ((_key->_texture) ? [NSString stringWithFormat:@"%@ mediump vec2 UV;\n"
        "uniform lowp sampler2D txt;", [self in]] : @""), [self in], ((_key->_shadow && [self version] > 100) ? @"out float depth;" : [NSString stringWithFormat:@"%@", [self fragColorDeclaration]]), ((_key->_shadow && !([self isFragColorDeclared])) ? @"\n"
        "    lowp vec4 fragColor;" : @""), ((_key->_texture) ? [NSString stringWithFormat:@"    %@ = fColor * color * %@(txt, UV);\n"
        "   ", [self fragColor], [self texture2D]] : [NSString stringWithFormat:@"    %@ = fColor * color;\n"
        "   ", [self fragColor]]), ((_key->_alpha) ? [NSString stringWithFormat:@"    if(%@.a < alphaTestLevel) {\n"
        "        discard;\n"
        "    }\n"
        "   ", [self fragColor]] : @""), ((_key->_shadow && [self version] > 100) ? @"\n"
        "    depth = gl_FragCoord.z;" : @"")];
}

- (PGShaderProgram*)program {
    return [PGShaderProgram applyName:@"Billboard" vertex:[self vertex] fragment:[self fragment]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"BillboardShaderBuilder(%@)", _key];
}

- (CNClassType*)type {
    return [PGBillboardShaderBuilder type];
}

+ (CNClassType*)type {
    return _PGBillboardShaderBuilder_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGBillboardShader
static CNClassType* _PGBillboardShader_type;
@synthesize key = _key;
@synthesize positionSlot = _positionSlot;
@synthesize modelSlot = _modelSlot;
@synthesize uvSlot = _uvSlot;
@synthesize colorSlot = _colorSlot;
@synthesize colorUniform = _colorUniform;
@synthesize alphaTestLevelUniform = _alphaTestLevelUniform;
@synthesize wcUniform = _wcUniform;
@synthesize pUniform = _pUniform;
@synthesize wcpUniform = _wcpUniform;

+ (instancetype)billboardShaderWithKey:(PGBillboardShaderKey*)key program:(PGShaderProgram*)program {
    return [[PGBillboardShader alloc] initWithKey:key program:program];
}

- (instancetype)initWithKey:(PGBillboardShaderKey*)key program:(PGShaderProgram*)program {
    self = [super initWithProgram:program];
    if(self) {
        _key = key;
        _positionSlot = [self attributeForName:@"position"];
        _modelSlot = [self attributeForName:@"model"];
        _uvSlot = ((key->_texture) ? [self attributeForName:@"vertexUV"] : nil);
        _colorSlot = [self attributeForName:@"vertexColor"];
        _colorUniform = [self uniformVec4Name:@"color"];
        _alphaTestLevelUniform = ((key->_alpha) ? [self uniformF4Name:@"alphaTestLevel"] : nil);
        _wcUniform = ((key->_modelSpace == PGBillboardShaderSpace_camera) ? [self uniformMat4Name:@"wc"] : nil);
        _pUniform = ((key->_modelSpace == PGBillboardShaderSpace_camera) ? [self uniformMat4Name:@"p"] : nil);
        _wcpUniform = ((key->_modelSpace == PGBillboardShaderSpace_projection) ? [self uniformMat4Name:@"wcp"] : nil);
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGBillboardShader class]) _PGBillboardShader_type = [CNClassType classTypeWithCls:[PGBillboardShader class]];
}

- (void)loadAttributesVbDesc:(PGVertexBufferDesc*)vbDesc {
    [_positionSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:3 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc->_position))];
    [_modelSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc->_model))];
    [_colorSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:4 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc->_color))];
    if(_key->_texture) [((PGShaderAttribute*)(_uvSlot)) setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc->_uv))];
}

- (void)loadUniformsParam:(PGColorSource*)param {
    if(_key->_modelSpace == PGBillboardShaderSpace_camera) {
        [((PGShaderUniformMat4*)(_wcUniform)) applyMatrix:[[[PGGlobal matrix] value] wc]];
        [((PGShaderUniformMat4*)(_pUniform)) applyMatrix:[[[PGGlobal matrix] value] p]];
    } else {
        [((PGShaderUniformMat4*)(_wcpUniform)) applyMatrix:[[[PGGlobal matrix] value] wcp]];
    }
    if(_key->_alpha) [((PGShaderUniformF4*)(_alphaTestLevelUniform)) applyF4:((PGColorSource*)(param))->_alphaTestLevel];
    if(_key->_texture) {
        PGTexture* _ = ((PGColorSource*)(param))->_texture;
        if(_ != nil) [[PGGlobal context] bindTextureTexture:_];
    }
    [_colorUniform applyVec4:((PGColorSource*)(param))->_color];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"BillboardShader(%@)", _key];
}

- (CNClassType*)type {
    return [PGBillboardShader type];
}

+ (CNClassType*)type {
    return _PGBillboardShader_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGBillboardParticleSystemView
static CNClassType* _PGBillboardParticleSystemView_type;

+ (instancetype)billboardParticleSystemViewWithSystem:(PGParticleSystem*)system material:(PGColorSource*)material blendFunc:(PGBlendFunction*)blendFunc {
    return [[PGBillboardParticleSystemView alloc] initWithSystem:system material:material blendFunc:blendFunc];
}

- (instancetype)initWithSystem:(PGParticleSystem*)system material:(PGColorSource*)material blendFunc:(PGBlendFunction*)blendFunc {
    self = [super initWithSystem:system vbDesc:[PGSprite vbDesc] shader:[[PGBillboardShaderSystem cameraSpace] shaderForParam:material] material:material blendFunc:blendFunc];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGBillboardParticleSystemView class]) _PGBillboardParticleSystemView_type = [CNClassType classTypeWithCls:[PGBillboardParticleSystemView class]];
}

+ (PGBillboardParticleSystemView*)applySystem:(PGParticleSystem*)system material:(PGColorSource*)material {
    return [PGBillboardParticleSystemView billboardParticleSystemViewWithSystem:system material:material blendFunc:[PGBlendFunction standard]];
}

- (NSString*)description {
    return @"BillboardParticleSystemView";
}

- (CNClassType*)type {
    return [PGBillboardParticleSystemView type];
}

+ (CNClassType*)type {
    return _PGBillboardParticleSystemView_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

