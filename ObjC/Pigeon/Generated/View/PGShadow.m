#import "PGShadow.h"

#import "PGMat4.h"
#import "GL.h"
#import "PGTexture.h"
#import "PGTexturePlat.h"
#import "PGVertexArray.h"
#import "PGMesh.h"
#import "PGDirector.h"
#import "PGMaterial.h"
#import "PGVertex.h"
#import "PGMatrixModel.h"
#import "PGMultisamplingSurface.h"
#import "CNObserver.h"
#import "CNChain.h"
@implementation PGShadowMap
static PGMat4* _PGShadowMap_biasMatrix;
static CNClassType* _PGShadowMap_type;
@synthesize frameBuffer = _frameBuffer;
@synthesize biasDepthCp = _biasDepthCp;
@synthesize texture = _texture;

+ (instancetype)shadowMapWithSize:(PGVec2i)size {
    return [[PGShadowMap alloc] initWithSize:size];
}

- (instancetype)initWithSize:(PGVec2i)size {
    self = [super initWithSize:size];
    if(self) {
        _frameBuffer = egGenFrameBuffer();
        _biasDepthCp = [PGMat4 identity];
        _texture = ({
            glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
            PGEmptyTexture* t = [PGEmptyTexture emptyTextureWithSize:pgVec2ApplyVec2i(size)];
            [PGGlobal.context bindTextureTexture:t];
            egInitShadowTexture(size);
            egCheckError();
            egFramebufferTexture(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, t.id, 0);
            int status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
            if(status != GL_FRAMEBUFFER_COMPLETE) @throw [NSString stringWithFormat:@"Error in shadow map frame buffer: %d", status];
            t;
        });
        __lazy_shader = [CNLazy lazyWithF:^PGShadowSurfaceShader*() {
            return [PGShadowSurfaceShader shadowSurfaceShader];
        }];
        __lazy_vao = [CNLazy lazyWithF:^PGVertexArray*() {
            return [[PGBaseViewportSurface fullScreenMesh] vaoShader:[PGShadowSurfaceShader shadowSurfaceShader]];
        }];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGShadowMap class]) {
        _PGShadowMap_type = [CNClassType classTypeWithCls:[PGShadowMap class]];
        _PGShadowMap_biasMatrix = [[[PGMat4 identity] translateX:0.5 y:0.5 z:0.5] scaleX:0.5 y:0.5 z:0.5];
    }
}

- (PGShadowSurfaceShader*)shader {
    return [__lazy_shader get];
}

- (PGVertexArray*)vao {
    return [__lazy_vao get];
}

- (void)dealloc {
    unsigned int fb = _frameBuffer;
    [[PGDirector current] onGLThreadF:^void() {
        egDeleteFrameBuffer(fb);
    }];
}

- (void)bind {
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    [PGGlobal.context setViewport:pgRectIApplyXYWidthHeight(0.0, 0.0, ((float)(self.size.x)), ((float)(self.size.y)))];
}

- (void)unbind {
    egCheckError();
}

- (void)draw {
    PGCullFace* __tmp__il__0self = PGGlobal.context.cullFace;
    {
        unsigned int __il__0oldValue = [__tmp__il__0self disable];
        [[self vao] drawParam:[PGColorSource applyTexture:_texture]];
        if(__il__0oldValue != GL_NONE) [__tmp__il__0self setValue:__il__0oldValue];
    }
}

- (NSString*)description {
    return @"ShadowMap";
}

- (CNClassType*)type {
    return [PGShadowMap type];
}

+ (PGMat4*)biasMatrix {
    return _PGShadowMap_biasMatrix;
}

+ (CNClassType*)type {
    return _PGShadowMap_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGShadowSurfaceShaderBuilder
static CNClassType* _PGShadowSurfaceShaderBuilder_type;

+ (instancetype)shadowSurfaceShaderBuilder {
    return [[PGShadowSurfaceShaderBuilder alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGShadowSurfaceShaderBuilder class]) _PGShadowSurfaceShaderBuilder_type = [CNClassType classTypeWithCls:[PGShadowSurfaceShaderBuilder class]];
}

- (NSString*)fragment {
    return [NSString stringWithFormat:@"%@\n"
        "%@ mediump vec2 UV;\n"
        "\n"
        "uniform mediump sampler2D txt;\n"
        "\n"
        "void main(void) {\n"
        "    lowp vec4 col = %@(txt, UV);\n"
        "    %@ = vec4(col.x, col.x, col.x, 1);\n"
        "}", [self fragmentHeader], [self in], [self texture2D], [self fragColor]];
}

- (NSString*)description {
    return @"ShadowSurfaceShaderBuilder";
}

- (CNClassType*)type {
    return [PGShadowSurfaceShaderBuilder type];
}

+ (CNClassType*)type {
    return _PGShadowSurfaceShaderBuilder_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGShadowSurfaceShader
static CNClassType* _PGShadowSurfaceShader_type;
@synthesize positionSlot = _positionSlot;

+ (instancetype)shadowSurfaceShader {
    return [[PGShadowSurfaceShader alloc] init];
}

- (instancetype)init {
    self = [super initWithProgram:[[PGShadowSurfaceShaderBuilder shadowSurfaceShaderBuilder] program]];
    if(self) _positionSlot = [self.program attributeForName:@"position"];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGShadowSurfaceShader class]) _PGShadowSurfaceShader_type = [CNClassType classTypeWithCls:[PGShadowSurfaceShader class]];
}

- (void)loadAttributesVbDesc:(PGVertexBufferDesc*)vbDesc {
    [_positionSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.model))];
}

- (void)loadUniformsParam:(PGColorSource*)param {
    PGTexture* _ = ((PGColorSource*)(param)).texture;
    if(_ != nil) [PGGlobal.context bindTextureTexture:_];
}

- (NSString*)description {
    return @"ShadowSurfaceShader";
}

- (CNClassType*)type {
    return [PGShadowSurfaceShader type];
}

+ (CNClassType*)type {
    return _PGShadowSurfaceShader_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGShadowShaderSystem
static PGShadowShaderSystem* _PGShadowShaderSystem_instance;
static CNClassType* _PGShadowShaderSystem_type;

+ (instancetype)shadowShaderSystem {
    return [[PGShadowShaderSystem alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGShadowShaderSystem class]) {
        _PGShadowShaderSystem_type = [CNClassType classTypeWithCls:[PGShadowShaderSystem class]];
        _PGShadowShaderSystem_instance = [PGShadowShaderSystem shadowShaderSystem];
    }
}

- (PGShadowShader*)shaderForParam:(PGColorSource*)param renderTarget:(PGRenderTarget*)renderTarget {
    if([PGShadowShaderSystem isColorShaderForParam:param]) return PGShadowShader.instanceForColor;
    else return PGShadowShader.instanceForTexture;
}

+ (BOOL)isColorShaderForParam:(PGColorSource*)param {
    return param.texture == nil || param.alphaTestLevel < 0;
}

- (NSString*)description {
    return @"ShadowShaderSystem";
}

- (CNClassType*)type {
    return [PGShadowShaderSystem type];
}

+ (PGShadowShaderSystem*)instance {
    return _PGShadowShaderSystem_instance;
}

+ (CNClassType*)type {
    return _PGShadowShaderSystem_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGShadowShaderText
static CNClassType* _PGShadowShaderText_type;
@synthesize texture = _texture;

+ (instancetype)shadowShaderTextWithTexture:(BOOL)texture {
    return [[PGShadowShaderText alloc] initWithTexture:texture];
}

- (instancetype)initWithTexture:(BOOL)texture {
    self = [super init];
    if(self) _texture = texture;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGShadowShaderText class]) _PGShadowShaderText_type = [CNClassType classTypeWithCls:[PGShadowShaderText class]];
}

- (NSString*)vertex {
    return [NSString stringWithFormat:@"%@\n"
        "%@\n"
        "%@ highp vec3 position;\n"
        "uniform mat4 mwcp;\n"
        "\n"
        "void main(void) {\n"
        "    gl_Position = mwcp * vec4(position, 1);%@\n"
        "}", [self vertexHeader], ((_texture) ? [NSString stringWithFormat:@"%@ mediump vec2 vertexUV;\n"
        "%@ mediump vec2 UV;", [self ain], [self out]] : @""), [self ain], ((_texture) ? @"\n"
        "    UV = vertexUV;" : @"")];
}

- (NSString*)fragment {
    return [NSString stringWithFormat:@"#version %ld\n"
        "%@\n"
        "%@\n"
        "\n"
        "void main(void) {\n"
        "   %@\n"
        "   %@\n"
        "}", (long)[self version], ((_texture) ? [NSString stringWithFormat:@"%@ mediump vec2 UV;\n"
        "uniform lowp sampler2D txt;\n"
        "uniform lowp float alphaTestLevel;", [self in]] : @""), (([self version] > 100) ? @"out float depth;" : @""), ((_texture) ? [NSString stringWithFormat:@"    if(%@(txt, UV).a < alphaTestLevel) {\n"
        "        discard;\n"
        "    }\n"
        "   ", [self texture2D]] : @""), (([self version] > 100) ? @"    depth = gl_FragCoord.z;\n"
        "   " : @"")];
}

- (PGShaderProgram*)program {
    return [PGShaderProgram applyName:@"Shadow" vertex:[self vertex] fragment:[self fragment]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"ShadowShaderText(%d)", _texture];
}

- (CNClassType*)type {
    return [PGShadowShaderText type];
}

+ (CNClassType*)type {
    return _PGShadowShaderText_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGShadowShader
static PGShadowShader* _PGShadowShader_instanceForColor;
static PGShadowShader* _PGShadowShader_instanceForTexture;
static CNClassType* _PGShadowShader_type;
@synthesize texture = _texture;
@synthesize uvSlot = _uvSlot;
@synthesize positionSlot = _positionSlot;
@synthesize mvpUniform = _mvpUniform;
@synthesize alphaTestLevelUniform = _alphaTestLevelUniform;

+ (instancetype)shadowShaderWithTexture:(BOOL)texture program:(PGShaderProgram*)program {
    return [[PGShadowShader alloc] initWithTexture:texture program:program];
}

- (instancetype)initWithTexture:(BOOL)texture program:(PGShaderProgram*)program {
    self = [super initWithProgram:program];
    if(self) {
        _texture = texture;
        _uvSlot = ((texture) ? [self attributeForName:@"vertexUV"] : nil);
        _positionSlot = [self attributeForName:@"position"];
        _mvpUniform = [self uniformMat4Name:@"mwcp"];
        _alphaTestLevelUniform = ((texture) ? [self uniformF4Name:@"alphaTestLevel"] : nil);
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGShadowShader class]) {
        _PGShadowShader_type = [CNClassType classTypeWithCls:[PGShadowShader class]];
        _PGShadowShader_instanceForColor = [PGShadowShader shadowShaderWithTexture:NO program:[[PGShadowShaderText shadowShaderTextWithTexture:NO] program]];
        _PGShadowShader_instanceForTexture = [PGShadowShader shadowShaderWithTexture:YES program:[[PGShadowShaderText shadowShaderTextWithTexture:YES] program]];
    }
}

- (void)loadAttributesVbDesc:(PGVertexBufferDesc*)vbDesc {
    [_positionSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:3 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.position))];
    if(_texture) [((PGShaderAttribute*)(_uvSlot)) setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.uv))];
}

- (void)loadUniformsParam:(PGColorSource*)param {
    [_mvpUniform applyMatrix:[[PGGlobal.matrix value] mwcp]];
    if(_texture) {
        [((PGShaderUniformF4*)(_alphaTestLevelUniform)) applyF4:((PGColorSource*)(param)).alphaTestLevel];
        {
            PGTexture* _ = ((PGColorSource*)(param)).texture;
            if(_ != nil) [PGGlobal.context bindTextureTexture:_];
        }
    }
}

- (NSString*)description {
    return [NSString stringWithFormat:@"ShadowShader(%d)", _texture];
}

- (CNClassType*)type {
    return [PGShadowShader type];
}

+ (PGShadowShader*)instanceForColor {
    return _PGShadowShader_instanceForColor;
}

+ (PGShadowShader*)instanceForTexture {
    return _PGShadowShader_instanceForTexture;
}

+ (CNClassType*)type {
    return _PGShadowShader_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGShadowDrawParam
static CNClassType* _PGShadowDrawParam_type;
@synthesize percents = _percents;
@synthesize viewportSurface = _viewportSurface;

+ (instancetype)shadowDrawParamWithPercents:(id<CNSeq>)percents viewportSurface:(PGViewportSurface*)viewportSurface {
    return [[PGShadowDrawParam alloc] initWithPercents:percents viewportSurface:viewportSurface];
}

- (instancetype)initWithPercents:(id<CNSeq>)percents viewportSurface:(PGViewportSurface*)viewportSurface {
    self = [super init];
    if(self) {
        _percents = percents;
        _viewportSurface = viewportSurface;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGShadowDrawParam class]) _PGShadowDrawParam_type = [CNClassType classTypeWithCls:[PGShadowDrawParam class]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"ShadowDrawParam(%@, %@)", _percents, _viewportSurface];
}

- (CNClassType*)type {
    return [PGShadowDrawParam type];
}

+ (CNClassType*)type {
    return _PGShadowDrawParam_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGShadowDrawShaderSystem
static PGShadowDrawShaderSystem* _PGShadowDrawShaderSystem_instance;
static CNObserver* _PGShadowDrawShaderSystem_settingsChangeObs;
static CNMHashMap* _PGShadowDrawShaderSystem_shaders;
static CNClassType* _PGShadowDrawShaderSystem_type;

+ (instancetype)shadowDrawShaderSystem {
    return [[PGShadowDrawShaderSystem alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGShadowDrawShaderSystem class]) {
        _PGShadowDrawShaderSystem_type = [CNClassType classTypeWithCls:[PGShadowDrawShaderSystem class]];
        _PGShadowDrawShaderSystem_instance = [PGShadowDrawShaderSystem shadowDrawShaderSystem];
        _PGShadowDrawShaderSystem_settingsChangeObs = [PGGlobal.settings.shadowTypeChanged observeF:^void(PGShadowType* _) {
            [_PGShadowDrawShaderSystem_shaders clear];
        }];
        _PGShadowDrawShaderSystem_shaders = [CNMHashMap hashMap];
    }
}

- (PGShadowDrawShader*)shaderForParam:(PGShadowDrawParam*)param renderTarget:(PGRenderTarget*)renderTarget {
    NSArray* lights = PGGlobal.context.environment.lights;
    NSUInteger directLightsCount = [[[lights chain] filterWhen:^BOOL(PGLight* _) {
        return [((PGLight*)(_)) isKindOfClass:[PGDirectLight class]] && ((PGLight*)(_)).hasShadows;
    }] count];
    PGShadowDrawShaderKey* key = [PGShadowDrawShaderKey shadowDrawShaderKeyWithDirectLightCount:directLightsCount viewportSurface:((PGShadowDrawParam*)(param)).viewportSurface != nil];
    return [_PGShadowDrawShaderSystem_shaders applyKey:key orUpdateWith:^PGShadowDrawShader*() {
        return [key shader];
    }];
}

- (NSString*)description {
    return @"ShadowDrawShaderSystem";
}

- (CNClassType*)type {
    return [PGShadowDrawShaderSystem type];
}

+ (PGShadowDrawShaderSystem*)instance {
    return _PGShadowDrawShaderSystem_instance;
}

+ (CNObserver*)settingsChangeObs {
    return _PGShadowDrawShaderSystem_settingsChangeObs;
}

+ (CNClassType*)type {
    return _PGShadowDrawShaderSystem_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGShadowDrawShaderKey
static CNClassType* _PGShadowDrawShaderKey_type;
@synthesize directLightCount = _directLightCount;
@synthesize viewportSurface = _viewportSurface;

+ (instancetype)shadowDrawShaderKeyWithDirectLightCount:(NSUInteger)directLightCount viewportSurface:(BOOL)viewportSurface {
    return [[PGShadowDrawShaderKey alloc] initWithDirectLightCount:directLightCount viewportSurface:viewportSurface];
}

- (instancetype)initWithDirectLightCount:(NSUInteger)directLightCount viewportSurface:(BOOL)viewportSurface {
    self = [super init];
    if(self) {
        _directLightCount = directLightCount;
        _viewportSurface = viewportSurface;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGShadowDrawShaderKey class]) _PGShadowDrawShaderKey_type = [CNClassType classTypeWithCls:[PGShadowDrawShaderKey class]];
}

- (PGShadowDrawShader*)shader {
    NSString* vertexShader = [NSString stringWithFormat:@"%@\n"
        "%@ highp vec3 position;\n"
        "uniform mat4 mwcp;\n"
        "%@\n"
        "%@\n"
        "%@\n"
        "\n"
        "void main(void) {\n"
        "   gl_Position = mwcp * vec4(position, 1);\n"
        "  %@\n"
        "   %@\n"
        "}", [self vertexHeader], [self ain], [self lightsVertexUniform], [self lightsOut], ((_viewportSurface) ? [NSString stringWithFormat:@"%@ mediump vec2 viewportUV;", [self out]] : @""), ((_viewportSurface) ? @"   viewportUV = gl_Position.xy*0.5 + vec2(0.5, 0.5);\n"
        "  " : @""), [self lightsCalculateVaryings]];
    NSString* fragmentShader = [NSString stringWithFormat:@"%@\n"
        "%@\n"
        "%@\n"
        "%@\n"
        "%@\n"
        "\n"
        "void main(void) {\n"
        "   lowp float visibility;\n"
        "   lowp float a = 0.0;\n"
        "   %@\n"
        "   %@ = vec4(0, 0, 0, a) + (1.0 - a)*%@(viewport, viewportUV);\n"
        "}", [self fragmentHeader], [self shadowExt], ((_viewportSurface) ? [NSString stringWithFormat:@"uniform lowp sampler2D viewport;\n"
        "%@ mediump vec2 viewportUV;", [self in]] : @""), [self lightsIn], [self lightsFragmentUniform], [self lightsDiffuse], [self fragColor], [self texture2D]];
    return [PGShadowDrawShader shadowDrawShaderWithKey:self program:[PGShaderProgram applyName:@"ShadowDraw" vertex:vertexShader fragment:fragmentShader]];
}

- (NSString*)lightsVertexUniform {
    if([[PGShadowType value:[PGGlobal.settings shadowType]] isOff]) return @"";
    else return [[[uintRange(_directLightCount) chain] mapF:^NSString*(id i) {
        return [NSString stringWithFormat:@"uniform mat4 dirLightDepthMwcp%@;", i];
    }] toStringDelimiter:@"\n"];
}

- (NSString*)lightsIn {
    if([[PGShadowType value:[PGGlobal.settings shadowType]] isOff]) return @"";
    else return [[[uintRange(_directLightCount) chain] mapF:^NSString*(id i) {
        return [NSString stringWithFormat:@"%@ mediump vec3 dirLightShadowCoord%@;", [self in], i];
    }] toStringDelimiter:@"\n"];
}

- (NSString*)lightsOut {
    if([[PGShadowType value:[PGGlobal.settings shadowType]] isOff]) return @"";
    else return [[[uintRange(_directLightCount) chain] mapF:^NSString*(id i) {
        return [NSString stringWithFormat:@"%@ mediump vec3 dirLightShadowCoord%@;", [self out], i];
    }] toStringDelimiter:@"\n"];
}

- (NSString*)lightsCalculateVaryings {
    return [[[uintRange(_directLightCount) chain] mapF:^NSString*(id i) {
        if([[PGShadowType value:[PGGlobal.settings shadowType]] isOff]) return @"";
        else return [NSString stringWithFormat:@"dirLightShadowCoord%@ = (dirLightDepthMwcp%@ * vec4(position, 1)).xyz;\n"
            "dirLightShadowCoord%@.z -= 0.005;", i, i, i];
    }] toStringDelimiter:@"\n"];
}

- (NSString*)lightsFragmentUniform {
    if([[PGShadowType value:[PGGlobal.settings shadowType]] isOff]) return @"";
    else return [[[uintRange(_directLightCount) chain] mapF:^NSString*(id i) {
        return [NSString stringWithFormat:@"uniform lowp float dirLightPercent%@;\n"
            "uniform mediump %@ dirLightShadow%@;", i, [self sampler2DShadow], i];
    }] toStringDelimiter:@"\n"];
}

- (NSString*)lightsDiffuse {
    return [[[uintRange(_directLightCount) chain] mapF:^NSString*(id i) {
        return [NSString stringWithFormat:@"a += dirLightPercent%@*(1.0 - %@);", i, [self shadow2DTexture:[NSString stringWithFormat:@"dirLightShadow%@", i] vec3:[NSString stringWithFormat:@"dirLightShadowCoord%@", i]]];
    }] toStringDelimiter:@"\n"];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"ShadowDrawShaderKey(%lu, %d)", (unsigned long)_directLightCount, _viewportSurface];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[PGShadowDrawShaderKey class]])) return NO;
    PGShadowDrawShaderKey* o = ((PGShadowDrawShaderKey*)(to));
    return _directLightCount == o.directLightCount && _viewportSurface == o.viewportSurface;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + _directLightCount;
    hash = hash * 31 + _viewportSurface;
    return hash;
}

- (CNClassType*)type {
    return [PGShadowDrawShaderKey type];
}

+ (CNClassType*)type {
    return _PGShadowDrawShaderKey_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGShadowDrawShader
static CNClassType* _PGShadowDrawShader_type;
@synthesize key = _key;
@synthesize positionSlot = _positionSlot;
@synthesize mwcpUniform = _mwcpUniform;
@synthesize directLightPercents = _directLightPercents;
@synthesize directLightDepthMwcp = _directLightDepthMwcp;
@synthesize directLightShadows = _directLightShadows;

+ (instancetype)shadowDrawShaderWithKey:(PGShadowDrawShaderKey*)key program:(PGShaderProgram*)program {
    return [[PGShadowDrawShader alloc] initWithKey:key program:program];
}

- (instancetype)initWithKey:(PGShadowDrawShaderKey*)key program:(PGShaderProgram*)program {
    self = [super initWithProgram:program];
    if(self) {
        _key = key;
        _positionSlot = [self attributeForName:@"position"];
        _mwcpUniform = [self uniformMat4Name:@"mwcp"];
        _directLightPercents = [[[uintRange(key.directLightCount) chain] mapF:^PGShaderUniformF4*(id i) {
            return [self uniformF4Name:[NSString stringWithFormat:@"dirLightPercent%@", i]];
        }] toArray];
        _directLightDepthMwcp = [[[uintRange(key.directLightCount) chain] mapF:^PGShaderUniformMat4*(id i) {
            return [self uniformMat4Name:[NSString stringWithFormat:@"dirLightDepthMwcp%@", i]];
        }] toArray];
        _directLightShadows = [[[uintRange(key.directLightCount) chain] mapF:^PGShaderUniformI4*(id i) {
            return [self uniformI4Name:[NSString stringWithFormat:@"dirLightShadow%@", i]];
        }] toArray];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGShadowDrawShader class]) _PGShadowDrawShader_type = [CNClassType classTypeWithCls:[PGShadowDrawShader class]];
}

- (void)loadAttributesVbDesc:(PGVertexBufferDesc*)vbDesc {
    [_positionSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:3 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.position))];
}

- (void)loadUniformsParam:(PGShadowDrawParam*)param {
    [_mwcpUniform applyMatrix:[[PGGlobal.matrix value] mwcp]];
    PGEnvironment* env = PGGlobal.context.environment;
    {
        PGViewportSurface* _ = ((PGShadowDrawParam*)(param)).viewportSurface;
        if(_ != nil) [PGGlobal.context bindTextureTexture:[((PGViewportSurface*)(_)) texture]];
    }
    __block unsigned int i = 0;
    [[[env.lights chain] filterWhen:^BOOL(PGLight* _) {
        return [((PGLight*)(_)) isKindOfClass:[PGDirectLight class]] && ((PGLight*)(_)).hasShadows;
    }] forEach:^void(PGLight* light) {
        float p = ((float)(unumf(nonnil([((PGShadowDrawParam*)(param)).percents applyIndex:((NSUInteger)(i))]))));
        [((PGShaderUniformF4*)([_directLightPercents applyIndex:i])) applyF4:p];
        [((PGShaderUniformMat4*)([_directLightDepthMwcp applyIndex:i])) applyMatrix:[[((PGLight*)(light)) shadowMap].biasDepthCp mulMatrix:[PGGlobal.matrix mw]]];
        [((PGShaderUniformI4*)([_directLightShadows applyIndex:i])) applyI4:((int)(i + 1))];
        [PGGlobal.context bindTextureSlot:GL_TEXTURE0 + i + 1 target:GL_TEXTURE_2D texture:[((PGLight*)(light)) shadowMap].texture];
        i++;
    }];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"ShadowDrawShader(%@)", _key];
}

- (CNClassType*)type {
    return [PGShadowDrawShader type];
}

+ (CNClassType*)type {
    return _PGShadowDrawShader_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

