#import "PGStandardShaderSystem.h"

#import "CNObserver.h"
#import "PGContext.h"
#import "PGShadow.h"
#import "CNChain.h"
#import "PGTexture.h"
#import "PGPlatformPlat.h"
#import "PGPlatform.h"
#import "PGVertex.h"
#import "GL.h"
#import "PGMatrixModel.h"
#import "PGMat4.h"
@implementation PGStandardShaderSystem
static PGStandardShaderSystem* _PGStandardShaderSystem_instance;
static CNMHashMap* _PGStandardShaderSystem_shaders;
static CNObserver* _PGStandardShaderSystem_settingsChangeObs;
static CNClassType* _PGStandardShaderSystem_type;

+ (instancetype)standardShaderSystem {
    return [[PGStandardShaderSystem alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGStandardShaderSystem class]) {
        _PGStandardShaderSystem_type = [CNClassType classTypeWithCls:[PGStandardShaderSystem class]];
        _PGStandardShaderSystem_instance = [PGStandardShaderSystem standardShaderSystem];
        _PGStandardShaderSystem_shaders = [CNMHashMap hashMap];
        _PGStandardShaderSystem_settingsChangeObs = [PGGlobal.settings.shadowTypeChanged observeF:^void(PGShadowType* _) {
            [_PGStandardShaderSystem_shaders clear];
        }];
    }
}

- (PGShader*)shaderForParam:(PGStandardMaterial*)param renderTarget:(PGRenderTarget*)renderTarget {
    if([renderTarget isKindOfClass:[PGShadowRenderTarget class]]) {
        if([PGShadowShaderSystem isColorShaderForParam:((PGStandardMaterial*)(param)).diffuse]) return ((PGShader*)(PGStandardShadowShader.instanceForColor));
        else return ((PGShader*)(PGStandardShadowShader.instanceForTexture));
    } else {
        NSArray* lights = PGGlobal.context.environment.lights;
        NSUInteger directLightsWithShadowsCount = [[[lights chain] filterWhen:^BOOL(PGLight* _) {
            return [((PGLight*)(_)) isKindOfClass:[PGDirectLight class]] && ((PGLight*)(_)).hasShadows;
        }] count];
        NSUInteger directLightsWithoutShadowsCount = [[[lights chain] filterWhen:^BOOL(PGLight* _) {
            return [((PGLight*)(_)) isKindOfClass:[PGDirectLight class]] && !(((PGLight*)(_)).hasShadows);
        }] count];
        PGTexture* texture = ((PGStandardMaterial*)(param)).diffuse.texture;
        BOOL t = texture != nil;
        BOOL region = t && ((texture != nil) ? [((PGTexture*)(nonnil(texture))) isKindOfClass:[PGTextureRegion class]] : NO);
        BOOL spec = ((PGStandardMaterial*)(param)).specularSize > 0;
        BOOL normalMap = ((PGStandardMaterial*)(param)).normalMap != nil;
        PGStandardShaderKey* key = ((egPlatform().shadows && PGGlobal.context.considerShadows) ? [PGStandardShaderKey standardShaderKeyWithDirectLightWithShadowsCount:directLightsWithShadowsCount directLightWithoutShadowsCount:directLightsWithoutShadowsCount texture:t blendMode:((PGStandardMaterial*)(param)).diffuse.blendMode region:region specular:spec normalMap:normalMap] : [PGStandardShaderKey standardShaderKeyWithDirectLightWithShadowsCount:0 directLightWithoutShadowsCount:directLightsWithShadowsCount + directLightsWithoutShadowsCount texture:t blendMode:((PGStandardMaterial*)(param)).diffuse.blendMode region:region specular:spec normalMap:normalMap]);
        return ((PGShader*)([_PGStandardShaderSystem_shaders applyKey:key orUpdateWith:^PGStandardShader*() {
            return [key shader];
        }]));
    }
}

- (NSString*)description {
    return @"StandardShaderSystem";
}

- (CNClassType*)type {
    return [PGStandardShaderSystem type];
}

+ (PGStandardShaderSystem*)instance {
    return _PGStandardShaderSystem_instance;
}

+ (CNObserver*)settingsChangeObs {
    return _PGStandardShaderSystem_settingsChangeObs;
}

+ (CNClassType*)type {
    return _PGStandardShaderSystem_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGStandardShadowShader
static PGStandardShadowShader* _PGStandardShadowShader_instanceForColor;
static PGStandardShadowShader* _PGStandardShadowShader_instanceForTexture;
static CNClassType* _PGStandardShadowShader_type;
@synthesize shadowShader = _shadowShader;

+ (instancetype)standardShadowShaderWithShadowShader:(PGShadowShader*)shadowShader {
    return [[PGStandardShadowShader alloc] initWithShadowShader:shadowShader];
}

- (instancetype)initWithShadowShader:(PGShadowShader*)shadowShader {
    self = [super initWithProgram:shadowShader.program];
    if(self) _shadowShader = shadowShader;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGStandardShadowShader class]) {
        _PGStandardShadowShader_type = [CNClassType classTypeWithCls:[PGStandardShadowShader class]];
        _PGStandardShadowShader_instanceForColor = [PGStandardShadowShader standardShadowShaderWithShadowShader:PGShadowShader.instanceForColor];
        _PGStandardShadowShader_instanceForTexture = [PGStandardShadowShader standardShadowShaderWithShadowShader:PGShadowShader.instanceForTexture];
    }
}

- (void)loadAttributesVbDesc:(PGVertexBufferDesc*)vbDesc {
    [_shadowShader loadAttributesVbDesc:vbDesc];
}

- (void)loadUniformsParam:(PGStandardMaterial*)param {
    [_shadowShader loadUniformsParam:((PGStandardMaterial*)(param)).diffuse];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"StandardShadowShader(%@)", _shadowShader];
}

- (CNClassType*)type {
    return [PGStandardShadowShader type];
}

+ (PGStandardShadowShader*)instanceForColor {
    return _PGStandardShadowShader_instanceForColor;
}

+ (PGStandardShadowShader*)instanceForTexture {
    return _PGStandardShadowShader_instanceForTexture;
}

+ (CNClassType*)type {
    return _PGStandardShadowShader_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGStandardShaderKey
static CNClassType* _PGStandardShaderKey_type;
@synthesize directLightWithShadowsCount = _directLightWithShadowsCount;
@synthesize directLightWithoutShadowsCount = _directLightWithoutShadowsCount;
@synthesize texture = _texture;
@synthesize blendMode = _blendMode;
@synthesize region = _region;
@synthesize specular = _specular;
@synthesize normalMap = _normalMap;
@synthesize perPixel = _perPixel;
@synthesize needUV = _needUV;
@synthesize directLightCount = _directLightCount;

+ (instancetype)standardShaderKeyWithDirectLightWithShadowsCount:(NSUInteger)directLightWithShadowsCount directLightWithoutShadowsCount:(NSUInteger)directLightWithoutShadowsCount texture:(BOOL)texture blendMode:(PGBlendModeR)blendMode region:(BOOL)region specular:(BOOL)specular normalMap:(BOOL)normalMap {
    return [[PGStandardShaderKey alloc] initWithDirectLightWithShadowsCount:directLightWithShadowsCount directLightWithoutShadowsCount:directLightWithoutShadowsCount texture:texture blendMode:blendMode region:region specular:specular normalMap:normalMap];
}

- (instancetype)initWithDirectLightWithShadowsCount:(NSUInteger)directLightWithShadowsCount directLightWithoutShadowsCount:(NSUInteger)directLightWithoutShadowsCount texture:(BOOL)texture blendMode:(PGBlendModeR)blendMode region:(BOOL)region specular:(BOOL)specular normalMap:(BOOL)normalMap {
    self = [super init];
    if(self) {
        _directLightWithShadowsCount = directLightWithShadowsCount;
        _directLightWithoutShadowsCount = directLightWithoutShadowsCount;
        _texture = texture;
        _blendMode = blendMode;
        _region = region;
        _specular = specular;
        _normalMap = normalMap;
        _perPixel = normalMap;
        _needUV = normalMap || texture;
        _directLightCount = directLightWithShadowsCount + directLightWithoutShadowsCount;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGStandardShaderKey class]) _PGStandardShaderKey_type = [CNClassType classTypeWithCls:[PGStandardShaderKey class]];
}

- (PGStandardShader*)shader {
    NSString* vertexShader = [NSString stringWithFormat:@"%@\n"
        "%@\n"
        "\n"
        "%@ highp vec3 position;\n"
        "uniform highp mat4 mwcp;\n"
        "uniform highp mat4 mwc;\n"
        "%@\n"
        "%@\n"
        "\n"
        "%@\n"
        "%@\n"
        "%@\n"
        "%@\n"
        "\n"
        "void main(void) {\n"
        "%@ eyeDirection = normalize(-(mwc * vec4(position, 1)).xyz);\n"
        "%@\n"
        "   gl_Position = mwcp * vec4(position, 1);\n"
        "%@\n"
        "   %@\n"
        "}", [self vertexHeader], ((!(_normalMap)) ? [NSString stringWithFormat:@"%@ mediump vec3 normal;", [self ain]] : @""), [self ain], ((_region) ? @"uniform mediump vec2 uvShift;\n"
        "uniform mediump vec2 uvScale;" : @""), [self lightsVertexUniform], ((_needUV || _normalMap) ? [NSString stringWithFormat:@"%@ mediump vec2 vertexUV;\n"
        "%@ mediump vec2 UV;", [self ain], [self out]] : @""), ((_perPixel) ? [NSString stringWithFormat:@"%@ mediump vec3 eyeDirection;", [self out]] : @""), ((_perPixel && !(_normalMap)) ? [NSString stringWithFormat:@"   %@ mediump vec3 normalMWC;", [self out]] : @""), [self lightsOut], ((!(_perPixel)) ? @"vec3" : @""), ((!(_normalMap) || !(_perPixel)) ? [NSString stringWithFormat:@"   %@ normalMWC = normalize((mwc * vec4(normal, 0)).xyz);", ((!(_perPixel)) ? @"vec3" : @"")] : @""), ((_needUV && _region) ? @"   UV = uvScale*vertexUV + uvShift;" : [NSString stringWithFormat:@"%@", ((_needUV) ? @"\n"
        "   UV = vertexUV; " : @"")]), [self lightsCalculateVaryings]];
    NSString* fragmentShader = [NSString stringWithFormat:@"%@\n"
        "%@\n"
        "%@\n"
        "%@\n"
        "uniform lowp vec4 diffuseColor;\n"
        "uniform lowp vec4 ambientColor;\n"
        "%@\n"
        "%@\n"
        "%@\n"
        "%@\n"
        "\n"
        "void main(void) {%@\n"
        "   lowp vec4 materialColor = %@;\n"
        "  %@\n"
        "   lowp vec4 color = ambientColor * materialColor;\n"
        "   %@\n"
        "   %@ = color;\n"
        "}", [self fragmentHeader], [self shadowExt], ((_needUV) ? [NSString stringWithFormat:@"%@ mediump vec2 UV;\n"
        "uniform lowp sampler2D diffuseTexture;", [self in]] : @""), ((_normalMap) ? @"uniform lowp sampler2D normalMap;" : @""), ((_specular) ? @"uniform lowp vec4 specularColor;\n"
        "uniform lowp float specularSize;" : @""), ((_perPixel) ? [NSString stringWithFormat:@"%@ mediump vec3 eyeDirection;\n"
        "   %@", [self in], ((_normalMap) ? @"    uniform highp mat4 mwc;\n"
        "   " : [NSString stringWithFormat:@"    %@ mediump vec3 normalMWC;\n"
        "   ", [self in]])] : @""), [self lightsIn], [self lightsFragmentUniform], ((_directLightWithShadowsCount > 0) ? @"\n"
        "   highp float visibility;" : @""), [self blendMode:_blendMode a:@"diffuseColor" b:[NSString stringWithFormat:@"%@(diffuseTexture, UV)", [self texture2D]]], ((_normalMap) ? [NSString stringWithFormat:@"   mediump vec3 normalMWC = normalize((mwc * vec4(2.0*%@(normalMap, UV).xyz - 1.0, 0)).xyz);\n"
        "  ", [self texture2D]] : @""), [self lightsDiffuse], [self fragColor]];
    return [PGStandardShader standardShaderWithKey:self program:[PGShaderProgram applyName:@"Standard" vertex:vertexShader fragment:fragmentShader]];
}

- (NSString*)lightsVertexUniform {
    return [[[uintRange(_directLightCount) chain] mapF:^NSString*(id i) {
        return [NSString stringWithFormat:@"%@\n"
            "%@\n", ((!(_perPixel)) ? [NSString stringWithFormat:@"uniform mediump vec3 dirLightDirection%@;", i] : @""), ((unumi(i) < _directLightWithShadowsCount) ? [NSString stringWithFormat:@"uniform highp mat4 dirLightDepthMwcp%@;", i] : @"")];
    }] toStringDelimiter:@"\n"];
}

- (NSString*)lightsIn {
    return [[[uintRange(_directLightCount) chain] mapF:^NSString*(id i) {
        return [NSString stringWithFormat:@"%@\n"
            "%@\n"
            "%@\n", ((!(_perPixel)) ? [NSString stringWithFormat:@"%@ mediump float dirLightDirectionCos%@;", [self in], i] : @""), ((_specular && !(_perPixel)) ? [NSString stringWithFormat:@"%@ mediump float dirLightDirectionCosA%@;", [self in], i] : @""), ((unumi(i) < _directLightWithShadowsCount) ? [NSString stringWithFormat:@"%@ highp vec3 dirLightShadowCoord%@;", [self in], i] : @"")];
    }] toStringDelimiter:@"\n"];
}

- (NSString*)lightsOut {
    return [[[uintRange(_directLightCount) chain] mapF:^NSString*(id i) {
        return [NSString stringWithFormat:@"%@\n"
            "%@\n"
            "%@\n", ((!(_perPixel)) ? [NSString stringWithFormat:@"%@ mediump float dirLightDirectionCos%@;", [self out], i] : @""), ((_specular && !(_perPixel)) ? [NSString stringWithFormat:@"%@ mediump float dirLightDirectionCosA%@;", [self out], i] : @""), ((unumi(i) < _directLightWithShadowsCount) ? [NSString stringWithFormat:@"%@ highp vec3 dirLightShadowCoord%@;", [self out], i] : @"")];
    }] toStringDelimiter:@"\n"];
}

- (NSString*)lightsCalculateVaryings {
    return [[[uintRange(_directLightCount) chain] mapF:^NSString*(id i) {
        return [NSString stringWithFormat:@"%@\n"
            "%@\n"
            "%@\n", ((!(_perPixel)) ? [NSString stringWithFormat:@"dirLightDirectionCos%@ = max(dot(normalMWC, -dirLightDirection%@), 0.0);", i, i] : @""), ((_specular && !(_perPixel)) ? [NSString stringWithFormat:@"dirLightDirectionCosA%@ = max(dot(eyeDirection, reflect(dirLightDirection%@, normalMWC)), 0.0);", i, i] : @""), ((unumi(i) < _directLightWithShadowsCount) ? [NSString stringWithFormat:@"dirLightShadowCoord%@ = (dirLightDepthMwcp%@ * vec4(position, 1)).xyz;\n"
            "dirLightShadowCoord%@.z -= 0.0005;", i, i, i] : @"")];
    }] toStringDelimiter:@"\n"];
}

- (NSString*)lightsFragmentUniform {
    return [[[uintRange(_directLightCount) chain] mapF:^NSString*(id i) {
        return [NSString stringWithFormat:@"uniform lowp vec4 dirLightColor%@;\n"
            "%@\n"
            "%@", i, ((_perPixel) ? [NSString stringWithFormat:@"uniform mediump vec3 dirLightDirection%@;", i] : @""), ((unumi(i) < _directLightWithShadowsCount) ? [NSString stringWithFormat:@"uniform highp %@ dirLightShadow%@;", [self sampler2DShadow], i] : @"")];
    }] toStringDelimiter:@"\n"];
}

- (NSString*)lightsDiffuse {
    return [[[uintRange(_directLightCount) chain] mapF:^NSString*(id i) {
        return [NSString stringWithFormat:@"\n"
            "%@\n"
            "%@\n"
            "%@\n"
            "%@\n", ((_perPixel) ? [NSString stringWithFormat:@"mediump float dirLightDirectionCos%@ = max(dot(normalMWC, -dirLightDirection%@), 0.0);", i, i] : @""), ((_specular && _perPixel) ? [NSString stringWithFormat:@"mediump float dirLightDirectionCosA%@ = max(dot(eyeDirection, reflect(dirLightDirection%@, normalMWC)), 0.0);", i, i] : @""), ((unumi(i) < _directLightWithShadowsCount) ? [NSString stringWithFormat:@"visibility = %@;\n"
            "color += visibility * dirLightDirectionCos%@ * (materialColor * dirLightColor%@);", [self shadow2DTexture:[NSString stringWithFormat:@"dirLightShadow%@", i] vec3:[NSString stringWithFormat:@"dirLightShadowCoord%@", i]], i, i] : [NSString stringWithFormat:@"color += dirLightDirectionCos%@ * (materialColor * dirLightColor%@);", i, i]), ((_specular && unumi(i) < _directLightWithShadowsCount) ? [NSString stringWithFormat:@"color += max(visibility * specularColor * dirLightColor%@ * pow(dirLightDirectionCosA%@, 5.0/specularSize), vec4(0, 0, 0, 0));", i, i] : [NSString stringWithFormat:@"%@", ((_specular) ? [NSString stringWithFormat:@"color += max(specularColor * dirLightColor%@ * pow(dirLightDirectionCosA%@, 5.0/specularSize), vec4(0, 0, 0, 0));", i, i] : @"")])];
    }] toStringDelimiter:@"\n"];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"StandardShaderKey(%lu, %lu, %d, %@, %d, %d, %d)", (unsigned long)_directLightWithShadowsCount, (unsigned long)_directLightWithoutShadowsCount, _texture, [PGBlendMode value:_blendMode], _region, _specular, _normalMap];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[PGStandardShaderKey class]])) return NO;
    PGStandardShaderKey* o = ((PGStandardShaderKey*)(to));
    return _directLightWithShadowsCount == o.directLightWithShadowsCount && _directLightWithoutShadowsCount == o.directLightWithoutShadowsCount && _texture == o.texture && _blendMode == o.blendMode && _region == o.region && _specular == o.specular && _normalMap == o.normalMap;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + _directLightWithShadowsCount;
    hash = hash * 31 + _directLightWithoutShadowsCount;
    hash = hash * 31 + _texture;
    hash = hash * 31 + [[PGBlendMode value:_blendMode] hash];
    hash = hash * 31 + _region;
    hash = hash * 31 + _specular;
    hash = hash * 31 + _normalMap;
    return hash;
}

- (CNClassType*)type {
    return [PGStandardShaderKey type];
}

+ (CNClassType*)type {
    return _PGStandardShaderKey_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGStandardShader
static CNClassType* _PGStandardShader_type;
@synthesize key = _key;
@synthesize positionSlot = _positionSlot;
@synthesize normalSlot = _normalSlot;
@synthesize uvSlot = _uvSlot;
@synthesize diffuseTexture = _diffuseTexture;
@synthesize normalMap = _normalMap;
@synthesize uvScale = _uvScale;
@synthesize uvShift = _uvShift;
@synthesize ambientColor = _ambientColor;
@synthesize specularColor = _specularColor;
@synthesize specularSize = _specularSize;
@synthesize diffuseColorUniform = _diffuseColorUniform;
@synthesize mwcpUniform = _mwcpUniform;
@synthesize mwcUniform = _mwcUniform;
@synthesize directLightDirections = _directLightDirections;
@synthesize directLightColors = _directLightColors;
@synthesize directLightShadows = _directLightShadows;
@synthesize directLightDepthMwcp = _directLightDepthMwcp;

+ (instancetype)standardShaderWithKey:(PGStandardShaderKey*)key program:(PGShaderProgram*)program {
    return [[PGStandardShader alloc] initWithKey:key program:program];
}

- (instancetype)initWithKey:(PGStandardShaderKey*)key program:(PGShaderProgram*)program {
    self = [super initWithProgram:program];
    if(self) {
        _key = key;
        _positionSlot = [self attributeForName:@"position"];
        _normalSlot = ((key.directLightCount > 0 && !(key.normalMap)) ? [self attributeForName:@"normal"] : nil);
        _uvSlot = ((key.needUV) ? [self attributeForName:@"vertexUV"] : nil);
        _diffuseTexture = ((key.texture) ? [self uniformI4Name:@"diffuseTexture"] : nil);
        _normalMap = ((key.normalMap) ? [self uniformI4Name:@"normalMap"] : nil);
        _uvScale = ((key.region) ? [self uniformVec2Name:@"uvScale"] : nil);
        _uvShift = ((key.region) ? [self uniformVec2Name:@"uvShift"] : nil);
        _ambientColor = [self uniformVec4Name:@"ambientColor"];
        _specularColor = ((key.directLightCount > 0 && key.specular) ? [self uniformVec4Name:@"specularColor"] : nil);
        _specularSize = ((key.directLightCount > 0 && key.specular) ? [self uniformF4Name:@"specularSize"] : nil);
        _diffuseColorUniform = [self uniformVec4OptName:@"diffuseColor"];
        _mwcpUniform = [self uniformMat4Name:@"mwcp"];
        _mwcUniform = ((key.directLightCount > 0) ? [self uniformMat4Name:@"mwc"] : nil);
        _directLightDirections = [[[uintRange(key.directLightCount) chain] mapF:^PGShaderUniformVec3*(id i) {
            return [self uniformVec3Name:[NSString stringWithFormat:@"dirLightDirection%@", i]];
        }] toArray];
        _directLightColors = [[[uintRange(key.directLightCount) chain] mapF:^PGShaderUniformVec4*(id i) {
            return [self uniformVec4Name:[NSString stringWithFormat:@"dirLightColor%@", i]];
        }] toArray];
        _directLightShadows = [[[uintRange(key.directLightWithShadowsCount) chain] mapF:^PGShaderUniformI4*(id i) {
            return [self uniformI4Name:[NSString stringWithFormat:@"dirLightShadow%@", i]];
        }] toArray];
        _directLightDepthMwcp = [[[uintRange(key.directLightWithShadowsCount) chain] mapF:^PGShaderUniformMat4*(id i) {
            return [self uniformMat4Name:[NSString stringWithFormat:@"dirLightDepthMwcp%@", i]];
        }] toArray];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGStandardShader class]) _PGStandardShader_type = [CNClassType classTypeWithCls:[PGStandardShader class]];
}

- (void)loadAttributesVbDesc:(PGVertexBufferDesc*)vbDesc {
    [_positionSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:3 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.position))];
    if(_key.needUV) [((PGShaderAttribute*)(_uvSlot)) setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.uv))];
    if(_key.directLightCount > 0) [((PGShaderAttribute*)(_normalSlot)) setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:3 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.normal))];
}

- (void)loadUniformsParam:(PGStandardMaterial*)param {
    [_mwcpUniform applyMatrix:[[PGGlobal.matrix value] mwcp]];
    if(_key.texture) {
        PGTexture* tex = ((PGStandardMaterial*)(param)).diffuse.texture;
        if(tex != nil) {
            [PGGlobal.context bindTextureTexture:tex];
            [((PGShaderUniformI4*)(_diffuseTexture)) applyI4:0];
            if(_key.region) {
                PGRect r = ((PGTextureRegion*)(tex)).uv;
                [((PGShaderUniformVec2*)(_uvShift)) applyVec2:r.p];
                [((PGShaderUniformVec2*)(_uvScale)) applyVec2:r.size];
            }
        }
    }
    if(_key.normalMap) {
        [((PGShaderUniformI4*)(_normalMap)) applyI4:1];
        {
            PGTexture* _ = ((PGNormalMap*)(((PGStandardMaterial*)(param)).normalMap)).texture;
            if(_ != nil) [PGGlobal.context bindTextureSlot:GL_TEXTURE1 target:GL_TEXTURE_2D texture:_];
        }
    }
    [((PGShaderUniformVec4*)(_diffuseColorUniform)) applyVec4:((PGStandardMaterial*)(param)).diffuse.color];
    PGEnvironment* env = PGGlobal.context.environment;
    [_ambientColor applyVec4:env.ambientColor];
    if(_key.directLightCount > 0) {
        if(_key.specular) {
            [((PGShaderUniformVec4*)(_specularColor)) applyVec4:((PGStandardMaterial*)(param)).specularColor];
            [((PGShaderUniformF4*)(_specularSize)) applyF4:((float)(((PGStandardMaterial*)(param)).specularSize))];
        }
        [((PGShaderUniformMat4*)(_mwcUniform)) applyMatrix:[[PGGlobal.context.matrixStack value] mwc]];
        __block unsigned int i = 0;
        if(_key.directLightWithShadowsCount > 0) for(PGDirectLight* light in env.directLightsWithShadows) {
            PGVec3 dir = pgVec4Xyz([[[PGGlobal.matrix value] wc] mulVec3:((PGDirectLight*)(light)).direction w:0.0]);
            [((PGShaderUniformVec3*)([_directLightDirections applyIndex:i])) applyVec3:pgVec3Normalize(dir)];
            [((PGShaderUniformVec4*)([_directLightColors applyIndex:i])) applyVec4:((PGDirectLight*)(light)).color];
            [((PGShaderUniformMat4*)([_directLightDepthMwcp applyIndex:i])) applyMatrix:[[((PGDirectLight*)(light)) shadowMap].biasDepthCp mulMatrix:[PGGlobal.matrix mw]]];
            [((PGShaderUniformI4*)([_directLightShadows applyIndex:i])) applyI4:((int)(i + 2))];
            [PGGlobal.context bindTextureSlot:GL_TEXTURE0 + i + 2 target:GL_TEXTURE_2D texture:[((PGDirectLight*)(light)) shadowMap].texture];
            i++;
        }
        if(_key.directLightWithoutShadowsCount > 0) for(PGDirectLight* light in ((PGGlobal.context.considerShadows) ? env.directLightsWithoutShadows : env.directLights)) {
            PGVec3 dir = pgVec4Xyz([[[PGGlobal.matrix value] wc] mulVec3:((PGDirectLight*)(light)).direction w:0.0]);
            [((PGShaderUniformVec3*)([_directLightDirections applyIndex:i])) applyVec3:pgVec3Normalize(dir)];
            [((PGShaderUniformVec4*)([_directLightColors applyIndex:i])) applyVec4:((PGDirectLight*)(light)).color];
        }
    }
}

- (NSString*)description {
    return [NSString stringWithFormat:@"StandardShader(%@)", _key];
}

- (CNClassType*)type {
    return [PGStandardShader type];
}

+ (CNClassType*)type {
    return _PGStandardShader_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

