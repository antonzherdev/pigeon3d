#import "PGContext.h"

#import "PGMatrixModel.h"
#import "PGDirector.h"
#import "PGFont.h"
#import "CNReact.h"
#import "GL.h"
#import "PGMaterial.h"
#import "PGBMFont.h"
#import "PGTTFFont.h"
#import "PGShader.h"
#import "PGVertex.h"
#import "CNChain.h"
#import "PGShadow.h"
#import "PGMat4.h"
#import "CNObserver.h"
@implementation PGGlobal
static PGContext* _PGGlobal_context;
static PGSettings* _PGGlobal_settings;
static PGMatrixStack* _PGGlobal_matrix;
static CNClassType* _PGGlobal_type;

+ (void)initialize {
    [super initialize];
    if(self == [PGGlobal class]) {
        _PGGlobal_type = [CNClassType classTypeWithCls:[PGGlobal class]];
        _PGGlobal_context = [PGContext context];
        _PGGlobal_settings = [PGSettings settings];
        _PGGlobal_matrix = _PGGlobal_context.matrixStack;
    }
}

+ (PGTexture*)compressedTextureForFile:(NSString*)file {
    return [_PGGlobal_context textureForName:file fileFormat:PGTextureFileFormat_compressed format:PGTextureFormat_RGBA8 scale:1.0 filter:PGTextureFilter_linear];
}

+ (PGTexture*)compressedTextureForFile:(NSString*)file filter:(PGTextureFilterR)filter {
    return [_PGGlobal_context textureForName:file fileFormat:PGTextureFileFormat_compressed format:PGTextureFormat_RGBA8 scale:1.0 filter:filter];
}

+ (PGTexture*)textureForFile:(NSString*)file fileFormat:(PGTextureFileFormatR)fileFormat format:(PGTextureFormatR)format filter:(PGTextureFilterR)filter {
    return [_PGGlobal_context textureForName:file fileFormat:fileFormat format:format scale:1.0 filter:filter];
}

+ (PGTexture*)textureForFile:(NSString*)file fileFormat:(PGTextureFileFormatR)fileFormat format:(PGTextureFormatR)format {
    return [PGGlobal textureForFile:file fileFormat:fileFormat format:format filter:PGTextureFilter_linear];
}

+ (PGTexture*)textureForFile:(NSString*)file fileFormat:(PGTextureFileFormatR)fileFormat filter:(PGTextureFilterR)filter {
    return [PGGlobal textureForFile:file fileFormat:fileFormat format:PGTextureFormat_RGBA8 filter:filter];
}

+ (PGTexture*)textureForFile:(NSString*)file fileFormat:(PGTextureFileFormatR)fileFormat {
    return [PGGlobal textureForFile:file fileFormat:fileFormat format:PGTextureFormat_RGBA8 filter:PGTextureFilter_linear];
}

+ (PGTexture*)textureForFile:(NSString*)file format:(PGTextureFormatR)format filter:(PGTextureFilterR)filter {
    return [PGGlobal textureForFile:file fileFormat:PGTextureFileFormat_PNG format:format filter:filter];
}

+ (PGTexture*)textureForFile:(NSString*)file format:(PGTextureFormatR)format {
    return [PGGlobal textureForFile:file fileFormat:PGTextureFileFormat_PNG format:format filter:PGTextureFilter_linear];
}

+ (PGTexture*)textureForFile:(NSString*)file filter:(PGTextureFilterR)filter {
    return [PGGlobal textureForFile:file fileFormat:PGTextureFileFormat_PNG format:PGTextureFormat_RGBA8 filter:filter];
}

+ (PGTexture*)textureForFile:(NSString*)file {
    return [PGGlobal textureForFile:file fileFormat:PGTextureFileFormat_PNG format:PGTextureFormat_RGBA8 filter:PGTextureFilter_linear];
}

+ (PGTexture*)scaledTextureForName:(NSString*)name fileFormat:(PGTextureFileFormatR)fileFormat format:(PGTextureFormatR)format {
    return [_PGGlobal_context textureForName:name fileFormat:fileFormat format:format scale:[[PGDirector current] scale] filter:PGTextureFilter_nearest];
}

+ (PGTexture*)scaledTextureForName:(NSString*)name fileFormat:(PGTextureFileFormatR)fileFormat {
    return [PGGlobal scaledTextureForName:name fileFormat:fileFormat format:PGTextureFormat_RGBA8];
}

+ (PGTexture*)scaledTextureForName:(NSString*)name format:(PGTextureFormatR)format {
    return [PGGlobal scaledTextureForName:name fileFormat:PGTextureFileFormat_PNG format:format];
}

+ (PGTexture*)scaledTextureForName:(NSString*)name {
    return [PGGlobal scaledTextureForName:name fileFormat:PGTextureFileFormat_PNG format:PGTextureFormat_RGBA8];
}

+ (PGFont*)fontWithName:(NSString*)name {
    return [_PGGlobal_context fontWithName:name];
}

+ (PGFont*)fontWithName:(NSString*)name size:(NSUInteger)size {
    return [_PGGlobal_context fontWithName:name size:size];
}

+ (PGFont*)mainFontWithSize:(NSUInteger)size {
    return [_PGGlobal_context mainFontWithSize:size];
}

- (CNClassType*)type {
    return [PGGlobal type];
}

+ (PGContext*)context {
    return _PGGlobal_context;
}

+ (PGSettings*)settings {
    return _PGGlobal_settings;
}

+ (PGMatrixStack*)matrix {
    return _PGGlobal_matrix;
}

+ (CNClassType*)type {
    return _PGGlobal_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGContext
static CNClassType* _PGContext_type;
@synthesize viewSize = _viewSize;
@synthesize scaledViewSize = _scaledViewSize;
@synthesize ttf = _ttf;
@synthesize environment = _environment;
@synthesize matrixStack = _matrixStack;
@synthesize renderTarget = _renderTarget;
@synthesize considerShadows = _considerShadows;
@synthesize redrawShadows = _redrawShadows;
@synthesize redrawFrame = _redrawFrame;
@synthesize defaultVertexArray = _defaultVertexArray;
@synthesize cullFace = _cullFace;
@synthesize blend = _blend;
@synthesize depthTest = _depthTest;

+ (instancetype)context {
    return [[PGContext alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) {
        _viewSize = [CNVar applyInitial:wrap(PGVec2i, (PGVec2iMake(0, 0)))];
        _scaledViewSize = [_viewSize mapF:^id(id _) {
            return wrap(PGVec2, (pgVec2iDivF((uwrap(PGVec2i, _)), [[PGDirector current] scale])));
        }];
        _ttf = YES;
        _textureCache = [CNMHashMap hashMap];
        _fontCache = [CNMHashMap hashMap];
        _environment = PGEnvironment.aDefault;
        _matrixStack = [PGMatrixStack matrixStack];
        _renderTarget = [PGSceneRenderTarget sceneRenderTarget];
        _considerShadows = YES;
        _redrawShadows = YES;
        _redrawFrame = YES;
        __viewport = pgRectIApplyXYWidthHeight(0.0, 0.0, 0.0, 0.0);
        __lastTexture2D = 0;
        __lastTextures = [CNMHashMap hashMap];
        __lastShaderProgram = 0;
        __lastRenderBuffer = 0;
        __lastVertexBufferId = 0;
        __lastVertexBufferCount = 0;
        __lastIndexBuffer = 0;
        __lastVertexArray = 0;
        _defaultVertexArray = 0;
        __needBindDefaultVertexArray = NO;
        _cullFace = [PGCullFace cullFace];
        _blend = [PGEnablingState enablingStateWithTp:GL_BLEND];
        _depthTest = [PGEnablingState enablingStateWithTp:GL_DEPTH_TEST];
        __lastClearColor = PGVec4Make(0.0, 0.0, 0.0, 0.0);
        __blendFunctionChanged = NO;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGContext class]) _PGContext_type = [CNClassType classTypeWithCls:[PGContext class]];
}

- (PGTexture*)textureForName:(NSString*)name fileFormat:(PGTextureFileFormatR)fileFormat format:(PGTextureFormatR)format scale:(CGFloat)scale filter:(PGTextureFilterR)filter {
    return [_textureCache applyKey:name orUpdateWith:^PGFileTexture*() {
        return [PGFileTexture fileTextureWithName:name fileFormat:fileFormat format:format scale:scale filter:filter];
    }];
}

- (PGFont*)fontWithName:(NSString*)name {
    return [_fontCache applyKey:name orUpdateWith:^PGFont*() {
        return [PGBMFont fontWithName:name];
    }];
}

- (PGFont*)mainFontWithSize:(NSUInteger)size {
    return [self fontWithName:@"Helvetica" size:size];
}

- (PGFont*)fontWithName:(NSString*)name size:(NSUInteger)size {
    CGFloat scale = [[PGDirector current] scale];
    NSString* nm = [NSString stringWithFormat:@"%@ %lu", name, (unsigned long)((NSUInteger)(size * scale))];
    if(_ttf) return [_fontCache applyKey:nm orUpdateWith:^PGFont*() {
        return [PGTTFFont fontWithName:name size:((NSUInteger)(size * scale))];
    }];
    else return [self fontWithName:nm];
}

- (void)clear {
    [_matrixStack clear];
    _considerShadows = YES;
    _redrawShadows = YES;
    _redrawFrame = YES;
}

- (void)clearCache {
    [_textureCache clear];
    [_fontCache clear];
}

- (PGRectI)viewport {
    return __viewport;
}

- (void)setViewport:(PGRectI)viewport {
    if(!(pgRectIIsEqualTo(__viewport, viewport))) {
        __viewport = viewport;
        egViewport(viewport);
    }
}

- (void)bindTextureTextureId:(unsigned int)textureId {
    if(__lastTexture2D != textureId) {
        __lastTexture2D = textureId;
        glBindTexture(GL_TEXTURE_2D, textureId);
    }
}

- (void)bindTextureTexture:(PGTexture*)texture {
    unsigned int id = [texture id];
    if(__lastTexture2D != id) {
        __lastTexture2D = id;
        glBindTexture(GL_TEXTURE_2D, id);
    }
}

- (void)bindTextureSlot:(unsigned int)slot target:(unsigned int)target texture:(PGTexture*)texture {
    unsigned int id = [texture id];
    if(slot == GL_TEXTURE0 && target == GL_TEXTURE_2D) {
        if(__lastTexture2D != id) {
            __lastTexture2D = id;
            glBindTexture(target, id);
        }
    } else {
        unsigned int key = slot * 13 + target;
        if(!([__lastTextures isValueEqualKey:numui4(key) value:numui4(id)])) {
            if(slot != GL_TEXTURE0) {
                glActiveTexture(slot);
                glBindTexture(target, id);
                glActiveTexture(GL_TEXTURE0);
            } else {
                glBindTexture(target, id);
            }
            [__lastTextures setKey:numui4(key) value:numui4(id)];
        }
    }
}

- (void)deleteTextureId:(unsigned int)id {
    [[PGDirector current] onGLThreadF:^void() {
        egDeleteTexture(id);
        if(__lastTexture2D == id) __lastTexture2D = 0;
        [__lastTextures clear];
    }];
}

- (void)bindShaderProgramProgram:(PGShaderProgram*)program {
    unsigned int id = program.handle;
    if(id != __lastShaderProgram) {
        __lastShaderProgram = id;
        glUseProgram(id);
    }
}

- (void)deleteShaderProgramId:(unsigned int)id {
    glDeleteProgram(id);
    if(id == __lastShaderProgram) __lastShaderProgram = 0;
}

- (void)bindRenderBufferId:(unsigned int)id {
    if(id != __lastRenderBuffer) {
        __lastRenderBuffer = id;
        glBindRenderbuffer(GL_RENDERBUFFER, id);
    }
}

- (void)deleteRenderBufferId:(unsigned int)id {
    [[PGDirector current] onGLThreadF:^void() {
        egDeleteRenderBuffer(id);
        if(id == __lastRenderBuffer) __lastRenderBuffer = 0;
    }];
}

- (void)bindVertexBufferBuffer:(id<PGVertexBuffer>)buffer {
    unsigned int handle = [buffer handle];
    if(handle != __lastVertexBufferId) {
        [self checkBindDefaultVertexArray];
        __lastVertexBufferId = handle;
        __lastVertexBufferCount = ((unsigned int)([buffer count]));
        glBindBuffer(GL_ARRAY_BUFFER, handle);
    }
}

- (unsigned int)vertexBufferCount {
    return __lastVertexBufferCount;
}

- (void)bindIndexBufferHandle:(unsigned int)handle {
    if(handle != __lastIndexBuffer) {
        [self checkBindDefaultVertexArray];
        __lastIndexBuffer = handle;
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, handle);
    }
}

- (void)deleteBufferId:(unsigned int)id {
    [[PGDirector current] onGLThreadF:^void() {
        egDeleteBuffer(id);
        if(id == __lastVertexBufferId) {
            __lastVertexBufferId = 0;
            __lastVertexBufferCount = 0;
        }
        if(id == __lastIndexBuffer) __lastIndexBuffer = 0;
    }];
}

- (void)bindVertexArrayHandle:(unsigned int)handle vertexCount:(unsigned int)vertexCount mutable:(BOOL)mutable {
    if(handle != __lastVertexArray || mutable) {
        __lastVertexArray = handle;
        __lastIndexBuffer = 0;
        egBindVertexArray(handle);
    }
    __needBindDefaultVertexArray = NO;
    __lastVertexBufferCount = vertexCount;
}

- (void)deleteVertexArrayId:(unsigned int)id {
    [[PGDirector current] onGLThreadF:^void() {
        egDeleteVertexArray(id);
        if(id == __lastVertexArray) __lastVertexArray = 0;
    }];
}

- (void)bindDefaultVertexArray {
    __needBindDefaultVertexArray = YES;
}

- (void)checkBindDefaultVertexArray {
    if(__needBindDefaultVertexArray) {
        __lastIndexBuffer = 0;
        __lastVertexBufferCount = 0;
        __lastVertexBufferId = 0;
        egBindVertexArray(_defaultVertexArray);
        __needBindDefaultVertexArray = NO;
    }
}

- (void)draw {
    [_cullFace draw];
    [_depthTest draw];
    if(__blendFunctionChanged) {
        [((PGBlendFunction*)(nonnil(__blendFunctionComing))) bind];
        __blendFunctionChanged = NO;
        __blendFunction = __blendFunctionComing;
    }
    [_blend draw];
}

- (void)clearColorColor:(PGVec4)color {
    if(!(pgVec4IsEqualTo(__lastClearColor, color))) {
        __lastClearColor = color;
        glClearColor(color.x, color.y, color.z, color.w);
    }
}

- (PGBlendFunction*)blendFunction {
    return __blendFunction;
}

- (void)setBlendFunction:(PGBlendFunction*)blendFunction {
    __blendFunctionComing = blendFunction;
    __blendFunctionChanged = __blendFunction == nil || !([__blendFunction isEqual:blendFunction]);
}

- (NSString*)description {
    return @"Context";
}

- (CNClassType*)type {
    return [PGContext type];
}

+ (CNClassType*)type {
    return _PGContext_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGEnablingState
static CNClassType* _PGEnablingState_type;
@synthesize tp = _tp;

+ (instancetype)enablingStateWithTp:(unsigned int)tp {
    return [[PGEnablingState alloc] initWithTp:tp];
}

- (instancetype)initWithTp:(unsigned int)tp {
    self = [super init];
    if(self) {
        _tp = tp;
        __last = NO;
        __coming = NO;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGEnablingState class]) _PGEnablingState_type = [CNClassType classTypeWithCls:[PGEnablingState class]];
}

- (BOOL)enable {
    if(!(__coming)) {
        __coming = YES;
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)disable {
    if(__coming) {
        __coming = NO;
        return YES;
    } else {
        return NO;
    }
}

- (void)draw {
    if(__last != __coming) {
        if(__coming) glEnable(_tp);
        else glDisable(_tp);
        __last = __coming;
    }
}

- (void)clear {
    __last = NO;
    __coming = NO;
}

- (void)disabledF:(void(^)())f {
    BOOL changed = [self disable];
    f();
    if(changed) [self enable];
}

- (void)enabledF:(void(^)())f {
    BOOL changed = [self enable];
    f();
    if(changed) [self disable];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"EnablingState(%u)", _tp];
}

- (CNClassType*)type {
    return [PGEnablingState type];
}

+ (CNClassType*)type {
    return _PGEnablingState_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGCullFace
static CNClassType* _PGCullFace_type;

+ (instancetype)cullFace {
    return [[PGCullFace alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) {
        __lastActiveValue = GL_NONE;
        __value = GL_NONE;
        __comingValue = GL_NONE;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGCullFace class]) _PGCullFace_type = [CNClassType classTypeWithCls:[PGCullFace class]];
}

- (void)setValue:(unsigned int)value {
    __comingValue = value;
}

- (void)draw {
    if(__value != __comingValue) {
        if(__comingValue == GL_NONE) {
            glDisable(GL_CULL_FACE);
            __value = GL_NONE;
        } else {
            if(__value == GL_NONE) glEnable(GL_CULL_FACE);
            if(__lastActiveValue != __comingValue) {
                glCullFace(__comingValue);
                __lastActiveValue = __comingValue;
            }
            __value = __comingValue;
        }
    }
}

- (unsigned int)disable {
    unsigned int old = __comingValue;
    __comingValue = GL_NONE;
    return old;
}

- (void)disabledF:(void(^)())f {
    unsigned int oldValue = [self disable];
    f();
    if(oldValue != GL_NONE) [self setValue:oldValue];
}

- (unsigned int)invert {
    unsigned int old = __comingValue;
    __comingValue = ((old == GL_FRONT) ? GL_BACK : GL_FRONT);
    return old;
}

- (void)invertedF:(void(^)())f {
    unsigned int oldValue = [self invert];
    f();
    if(oldValue != GL_NONE) [self setValue:oldValue];
}

- (NSString*)description {
    return @"CullFace";
}

- (CNClassType*)type {
    return [PGCullFace type];
}

+ (CNClassType*)type {
    return _PGCullFace_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGRenderTarget
static CNClassType* _PGRenderTarget_type;

+ (instancetype)renderTarget {
    return [[PGRenderTarget alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGRenderTarget class]) _PGRenderTarget_type = [CNClassType classTypeWithCls:[PGRenderTarget class]];
}

- (BOOL)isShadow {
    return NO;
}

- (NSString*)description {
    return @"RenderTarget";
}

- (CNClassType*)type {
    return [PGRenderTarget type];
}

+ (CNClassType*)type {
    return _PGRenderTarget_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGSceneRenderTarget
static CNClassType* _PGSceneRenderTarget_type;

+ (instancetype)sceneRenderTarget {
    return [[PGSceneRenderTarget alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGSceneRenderTarget class]) _PGSceneRenderTarget_type = [CNClassType classTypeWithCls:[PGSceneRenderTarget class]];
}

- (NSString*)description {
    return @"SceneRenderTarget";
}

- (CNClassType*)type {
    return [PGSceneRenderTarget type];
}

+ (CNClassType*)type {
    return _PGSceneRenderTarget_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGShadowRenderTarget
static PGShadowRenderTarget* _PGShadowRenderTarget_default;
static CNClassType* _PGShadowRenderTarget_type;
@synthesize shadowLight = _shadowLight;

+ (instancetype)shadowRenderTargetWithShadowLight:(PGLight*)shadowLight {
    return [[PGShadowRenderTarget alloc] initWithShadowLight:shadowLight];
}

- (instancetype)initWithShadowLight:(PGLight*)shadowLight {
    self = [super init];
    if(self) _shadowLight = shadowLight;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGShadowRenderTarget class]) {
        _PGShadowRenderTarget_type = [CNClassType classTypeWithCls:[PGShadowRenderTarget class]];
        _PGShadowRenderTarget_default = [PGShadowRenderTarget shadowRenderTargetWithShadowLight:PGLight.aDefault];
    }
}

- (BOOL)isShadow {
    return YES;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"ShadowRenderTarget(%@)", _shadowLight];
}

- (CNClassType*)type {
    return [PGShadowRenderTarget type];
}

+ (PGShadowRenderTarget*)aDefault {
    return _PGShadowRenderTarget_default;
}

+ (CNClassType*)type {
    return _PGShadowRenderTarget_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGEnvironment
static PGEnvironment* _PGEnvironment_default;
static CNClassType* _PGEnvironment_type;
@synthesize ambientColor = _ambientColor;
@synthesize lights = _lights;
@synthesize directLights = _directLights;
@synthesize directLightsWithShadows = _directLightsWithShadows;
@synthesize directLightsWithoutShadows = _directLightsWithoutShadows;

+ (instancetype)environmentWithAmbientColor:(PGVec4)ambientColor lights:(NSArray*)lights {
    return [[PGEnvironment alloc] initWithAmbientColor:ambientColor lights:lights];
}

- (instancetype)initWithAmbientColor:(PGVec4)ambientColor lights:(NSArray*)lights {
    self = [super init];
    if(self) {
        _ambientColor = ambientColor;
        _lights = lights;
        _directLights = [[[lights chain] filterCastTo:PGDirectLight.type] toArray];
        _directLightsWithShadows = [[[[lights chain] filterCastTo:PGDirectLight.type] filterWhen:^BOOL(PGDirectLight* _) {
            return ((PGDirectLight*)(_)).hasShadows;
        }] toArray];
        _directLightsWithoutShadows = [[[[lights chain] filterCastTo:PGDirectLight.type] filterWhen:^BOOL(PGDirectLight* _) {
            return !(((PGDirectLight*)(_)).hasShadows);
        }] toArray];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGEnvironment class]) {
        _PGEnvironment_type = [CNClassType classTypeWithCls:[PGEnvironment class]];
        _PGEnvironment_default = [PGEnvironment environmentWithAmbientColor:PGVec4Make(1.0, 1.0, 1.0, 1.0) lights:((NSArray*)((@[])))];
    }
}

+ (PGEnvironment*)applyLights:(NSArray*)lights {
    return [PGEnvironment environmentWithAmbientColor:PGVec4Make(1.0, 1.0, 1.0, 1.0) lights:lights];
}

+ (PGEnvironment*)applyLight:(PGLight*)light {
    return [PGEnvironment environmentWithAmbientColor:PGVec4Make(1.0, 1.0, 1.0, 1.0) lights:(@[light])];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Environment(%@, %@)", pgVec4Description(_ambientColor), _lights];
}

- (CNClassType*)type {
    return [PGEnvironment type];
}

+ (PGEnvironment*)aDefault {
    return _PGEnvironment_default;
}

+ (CNClassType*)type {
    return _PGEnvironment_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGLight
static PGLight* _PGLight_default;
static CNClassType* _PGLight_type;
@synthesize color = _color;
@synthesize hasShadows = _hasShadows;

+ (instancetype)lightWithColor:(PGVec4)color hasShadows:(BOOL)hasShadows {
    return [[PGLight alloc] initWithColor:color hasShadows:hasShadows];
}

- (instancetype)initWithColor:(PGVec4)color hasShadows:(BOOL)hasShadows {
    self = [super init];
    if(self) {
        _color = color;
        _hasShadows = hasShadows;
        __lazy_shadowMap = [CNLazy lazyWithF:^PGShadowMap*() {
            return [PGShadowMap shadowMapWithSize:pgVec2iApplyVec2((PGVec2Make(2048.0, 2048.0)))];
        }];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGLight class]) {
        _PGLight_type = [CNClassType classTypeWithCls:[PGLight class]];
        _PGLight_default = [PGLight lightWithColor:PGVec4Make(1.0, 1.0, 1.0, 1.0) hasShadows:YES];
    }
}

- (PGShadowMap*)shadowMap {
    return [__lazy_shadowMap get];
}

- (PGMatrixModel*)shadowMatrixModel:(PGMatrixModel*)model {
    @throw [NSString stringWithFormat:@"Shadows are not supported for %@", _PGLight_type];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Light(%@, %d)", pgVec4Description(_color), _hasShadows];
}

- (CNClassType*)type {
    return [PGLight type];
}

+ (PGLight*)aDefault {
    return _PGLight_default;
}

+ (CNClassType*)type {
    return _PGLight_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGDirectLight
static CNClassType* _PGDirectLight_type;
@synthesize direction = _direction;
@synthesize shadowsProjectionMatrix = _shadowsProjectionMatrix;

+ (instancetype)directLightWithColor:(PGVec4)color direction:(PGVec3)direction hasShadows:(BOOL)hasShadows shadowsProjectionMatrix:(PGMat4*)shadowsProjectionMatrix {
    return [[PGDirectLight alloc] initWithColor:color direction:direction hasShadows:hasShadows shadowsProjectionMatrix:shadowsProjectionMatrix];
}

- (instancetype)initWithColor:(PGVec4)color direction:(PGVec3)direction hasShadows:(BOOL)hasShadows shadowsProjectionMatrix:(PGMat4*)shadowsProjectionMatrix {
    self = [super initWithColor:color hasShadows:hasShadows];
    if(self) {
        _direction = direction;
        _shadowsProjectionMatrix = shadowsProjectionMatrix;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGDirectLight class]) _PGDirectLight_type = [CNClassType classTypeWithCls:[PGDirectLight class]];
}

+ (PGDirectLight*)applyColor:(PGVec4)color direction:(PGVec3)direction {
    return [PGDirectLight directLightWithColor:color direction:direction hasShadows:NO shadowsProjectionMatrix:[PGMat4 identity]];
}

+ (PGDirectLight*)applyColor:(PGVec4)color direction:(PGVec3)direction shadowsProjectionMatrix:(PGMat4*)shadowsProjectionMatrix {
    return [PGDirectLight directLightWithColor:color direction:direction hasShadows:YES shadowsProjectionMatrix:shadowsProjectionMatrix];
}

- (PGMatrixModel*)shadowMatrixModel:(PGMatrixModel*)model {
    return [[[model mutable] modifyC:^PGMat4*(PGMat4* _) {
        return [PGMat4 lookAtEye:pgVec3Negate((pgVec3Normalize((pgVec4Xyz(([[model w] mulVec4:pgVec4ApplyVec3W(_direction, 0.0)])))))) center:PGVec3Make(0.0, 0.0, 0.0) up:PGVec3Make(0.0, 1.0, 0.0)];
    }] modifyP:^PGMat4*(PGMat4* _) {
        return _shadowsProjectionMatrix;
    }];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"DirectLight(%@, %@)", pgVec3Description(_direction), _shadowsProjectionMatrix];
}

- (CNClassType*)type {
    return [PGDirectLight type];
}

+ (CNClassType*)type {
    return _PGDirectLight_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

PGShadowType* PGShadowType_Values[4];
PGShadowType* PGShadowType_no_Desc;
PGShadowType* PGShadowType_shadow2d_Desc;
PGShadowType* PGShadowType_sample2d_Desc;
@implementation PGShadowType{
    BOOL _isOn;
}
@synthesize isOn = _isOn;

+ (instancetype)shadowTypeWithOrdinal:(NSUInteger)ordinal name:(NSString*)name isOn:(BOOL)isOn {
    return [[PGShadowType alloc] initWithOrdinal:ordinal name:name isOn:isOn];
}

- (instancetype)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name isOn:(BOOL)isOn {
    self = [super initWithOrdinal:ordinal name:name];
    if(self) _isOn = isOn;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    PGShadowType_no_Desc = [PGShadowType shadowTypeWithOrdinal:0 name:@"no" isOn:NO];
    PGShadowType_shadow2d_Desc = [PGShadowType shadowTypeWithOrdinal:1 name:@"shadow2d" isOn:YES];
    PGShadowType_sample2d_Desc = [PGShadowType shadowTypeWithOrdinal:2 name:@"sample2d" isOn:YES];
    PGShadowType_Values[0] = nil;
    PGShadowType_Values[1] = PGShadowType_no_Desc;
    PGShadowType_Values[2] = PGShadowType_shadow2d_Desc;
    PGShadowType_Values[3] = PGShadowType_sample2d_Desc;
}

- (BOOL)isOff {
    return !(_isOn);
}

+ (NSArray*)values {
    return (@[PGShadowType_no_Desc, PGShadowType_shadow2d_Desc, PGShadowType_sample2d_Desc]);
}

+ (PGShadowType*)value:(PGShadowTypeR)r {
    return PGShadowType_Values[r];
}

@end

@implementation PGSettings
static CNClassType* _PGSettings_type;
@synthesize shadowTypeChanged = _shadowTypeChanged;

+ (instancetype)settings {
    return [[PGSettings alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) {
        _shadowTypeChanged = [CNSignal signal];
        __shadowType = PGShadowType_sample2d;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGSettings class]) _PGSettings_type = [CNClassType classTypeWithCls:[PGSettings class]];
}

- (PGShadowTypeR)shadowType {
    return __shadowType;
}

- (void)setShadowType:(PGShadowTypeR)shadowType {
    if(__shadowType != shadowType) {
        __shadowType = shadowType;
        [_shadowTypeChanged postData:[PGShadowType value:shadowType]];
    }
}

- (NSString*)description {
    return @"Settings";
}

- (CNClassType*)type {
    return [PGSettings type];
}

+ (CNClassType*)type {
    return _PGSettings_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

