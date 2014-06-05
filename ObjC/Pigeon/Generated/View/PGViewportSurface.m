#import "PGViewportSurface.h"

#import "PGTexture.h"
#import "PGVertex.h"
#import "GL.h"
#import "PGContext.h"
#import "PGMesh.h"
#import "PGIndex.h"
#import "PGVertexArray.h"
#import "PGSurface.h"
#import "CNReact.h"
@implementation PGViewportSurfaceShaderParam
static CNClassType* _PGViewportSurfaceShaderParam_type;
@synthesize texture = _texture;
@synthesize z = _z;

+ (instancetype)viewportSurfaceShaderParamWithTexture:(PGTexture*)texture z:(float)z {
    return [[PGViewportSurfaceShaderParam alloc] initWithTexture:texture z:z];
}

- (instancetype)initWithTexture:(PGTexture*)texture z:(float)z {
    self = [super init];
    if(self) {
        _texture = texture;
        _z = z;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGViewportSurfaceShaderParam class]) _PGViewportSurfaceShaderParam_type = [CNClassType classTypeWithCls:[PGViewportSurfaceShaderParam class]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"ViewportSurfaceShaderParam(%@, %f)", _texture, _z];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[PGViewportSurfaceShaderParam class]])) return NO;
    PGViewportSurfaceShaderParam* o = ((PGViewportSurfaceShaderParam*)(to));
    return [_texture isEqual:o->_texture] && eqf4(_z, o->_z);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [_texture hash];
    hash = hash * 31 + float4Hash(_z);
    return hash;
}

- (CNClassType*)type {
    return [PGViewportSurfaceShaderParam type];
}

+ (CNClassType*)type {
    return _PGViewportSurfaceShaderParam_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGViewportShaderBuilder
static CNClassType* _PGViewportShaderBuilder_type;

+ (instancetype)viewportShaderBuilder {
    return [[PGViewportShaderBuilder alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGViewportShaderBuilder class]) _PGViewportShaderBuilder_type = [CNClassType classTypeWithCls:[PGViewportShaderBuilder class]];
}

- (NSString*)vertex {
    return [NSString stringWithFormat:@"%@\n"
        "\n"
        "%@ highp vec2 position;\n"
        "uniform lowp float z;\n"
        "%@ mediump vec2 UV;\n"
        "\n"
        "void main(void) {\n"
        "    gl_Position = vec4(2.0*position.x - 1.0, 2.0*position.y - 1.0, z, 1);\n"
        "    UV = position;\n"
        "}", [self vertexHeader], [self ain], [self out]];
}

- (NSString*)fragment {
    return [NSString stringWithFormat:@"%@\n"
        "%@ mediump vec2 UV;\n"
        "\n"
        "uniform lowp sampler2D txt;\n"
        "\n"
        "void main(void) {\n"
        "    %@ = %@(txt, UV);\n"
        "}", [self fragmentHeader], [self in], [self fragColor], [self texture2D]];
}

- (PGShaderProgram*)program {
    return [PGShaderProgram applyName:@"Viewport" vertex:[self vertex] fragment:[self fragment]];
}

- (NSString*)description {
    return @"ViewportShaderBuilder";
}

- (CNClassType*)type {
    return [PGViewportShaderBuilder type];
}

+ (CNClassType*)type {
    return _PGViewportShaderBuilder_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGViewportSurfaceShader
static PGViewportSurfaceShader* _PGViewportSurfaceShader_instance;
static CNClassType* _PGViewportSurfaceShader_type;
@synthesize positionSlot = _positionSlot;
@synthesize zUniform = _zUniform;

+ (instancetype)viewportSurfaceShader {
    return [[PGViewportSurfaceShader alloc] init];
}

- (instancetype)init {
    self = [super initWithProgram:[[PGViewportShaderBuilder viewportShaderBuilder] program]];
    if(self) {
        _positionSlot = [self attributeForName:@"position"];
        _zUniform = [self uniformF4Name:@"z"];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGViewportSurfaceShader class]) {
        _PGViewportSurfaceShader_type = [CNClassType classTypeWithCls:[PGViewportSurfaceShader class]];
        _PGViewportSurfaceShader_instance = [PGViewportSurfaceShader viewportSurfaceShader];
    }
}

- (void)loadAttributesVbDesc:(PGVertexBufferDesc*)vbDesc {
    [_positionSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc->_model))];
}

- (void)loadUniformsParam:(PGViewportSurfaceShaderParam*)param {
    [[PGGlobal context] bindTextureTexture:((PGViewportSurfaceShaderParam*)(param))->_texture];
    [_zUniform applyF4:((PGViewportSurfaceShaderParam*)(param))->_z];
}

- (NSString*)description {
    return @"ViewportSurfaceShader";
}

- (CNClassType*)type {
    return [PGViewportSurfaceShader type];
}

+ (PGViewportSurfaceShader*)instance {
    return _PGViewportSurfaceShader_instance;
}

+ (CNClassType*)type {
    return _PGViewportSurfaceShader_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGBaseViewportSurface
static CNLazy* _PGBaseViewportSurface__lazy_fullScreenMesh;
static CNLazy* _PGBaseViewportSurface__lazy_fullScreenVao;
static CNClassType* _PGBaseViewportSurface_type;
@synthesize createRenderTarget = _createRenderTarget;

+ (instancetype)baseViewportSurfaceWithCreateRenderTarget:(PGSurfaceRenderTarget*(^)(PGVec2i))createRenderTarget {
    return [[PGBaseViewportSurface alloc] initWithCreateRenderTarget:createRenderTarget];
}

- (instancetype)initWithCreateRenderTarget:(PGSurfaceRenderTarget*(^)(PGVec2i))createRenderTarget {
    self = [super init];
    if(self) {
        _createRenderTarget = [createRenderTarget copy];
        __surface = nil;
        __renderTarget = nil;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGBaseViewportSurface class]) {
        _PGBaseViewportSurface_type = [CNClassType classTypeWithCls:[PGBaseViewportSurface class]];
        _PGBaseViewportSurface__lazy_fullScreenMesh = [CNLazy lazyWithF:^PGMesh*() {
            return [PGMesh meshWithVertex:[PGVBO vec2Buffer:({
                PGVec2Buffer* b = [PGVec2Buffer vec2BufferWithCount:4];
                if(b->__position >= b->_count) @throw @"Out of bound";
                *(((float*)(b->__pointer))) = 0.0;
                *(((float*)(b->__pointer)) + 1) = 0.0;
                {
                    b->__pointer = ((PGVec2*)(b->__pointer)) + 1;
                    b->__position++;
                }
                if(b->__position >= b->_count) @throw @"Out of bound";
                *(((float*)(b->__pointer))) = 1.0;
                *(((float*)(b->__pointer)) + 1) = 0.0;
                {
                    b->__pointer = ((PGVec2*)(b->__pointer)) + 1;
                    b->__position++;
                }
                if(b->__position >= b->_count) @throw @"Out of bound";
                *(((float*)(b->__pointer))) = 0.0;
                *(((float*)(b->__pointer)) + 1) = 1.0;
                {
                    b->__pointer = ((PGVec2*)(b->__pointer)) + 1;
                    b->__position++;
                }
                if(b->__position >= b->_count) @throw @"Out of bound";
                *(((float*)(b->__pointer))) = 1.0;
                *(((float*)(b->__pointer)) + 1) = 1.0;
                {
                    b->__pointer = ((PGVec2*)(b->__pointer)) + 1;
                    b->__position++;
                }
                b;
            })] index:[PGEmptyIndexSource triangleStrip]];
        }];
        _PGBaseViewportSurface__lazy_fullScreenVao = [CNLazy lazyWithF:^PGVertexArray*() {
            return [[PGBaseViewportSurface fullScreenMesh] vaoShader:[PGViewportSurfaceShader instance]];
        }];
    }
}

+ (PGMesh*)fullScreenMesh {
    return [_PGBaseViewportSurface__lazy_fullScreenMesh get];
}

+ (PGVertexArray*)fullScreenVao {
    return [_PGBaseViewportSurface__lazy_fullScreenVao get];
}

- (PGRenderTargetSurface*)surface {
    return __surface;
}

- (PGSurfaceRenderTarget*)renderTarget {
    if(__renderTarget == nil || !(pgVec2iIsEqualTo(((PGSurfaceRenderTarget*)(__renderTarget))->_size, (uwrap(PGVec2i, [[PGGlobal context]->_viewSize value]))))) __renderTarget = _createRenderTarget((uwrap(PGVec2i, [[PGGlobal context]->_viewSize value])));
    return ((PGSurfaceRenderTarget*)(nonnil(__renderTarget)));
}

- (void)maybeRecreateSurface {
    if([self needRedraw]) __surface = [self createSurface];
}

- (PGRenderTargetSurface*)createSurface {
    @throw @"Method createSurface is abstract";
}

- (PGTexture*)texture {
    return ((PGSurfaceRenderTargetTexture*)([self renderTarget]))->_texture;
}

- (unsigned int)renderBuffer {
    return ((PGSurfaceRenderTargetRenderBuffer*)([self renderTarget]))->_renderBuffer;
}

- (BOOL)needRedraw {
    return __surface == nil || !(pgVec2iIsEqualTo(((PGRenderTargetSurface*)(__surface))->_size, (uwrap(PGVec2i, [[PGGlobal context]->_viewSize value]))));
}

- (void)bind {
    [self maybeRecreateSurface];
    [((PGRenderTargetSurface*)(__surface)) bind];
}

- (void)applyDraw:(void(^)())draw {
    [self bind];
    draw();
    [self unbind];
}

- (void)maybeDraw:(void(^)())draw {
    if([self needRedraw]) {
        [self bind];
        draw();
        [self unbind];
    }
}

- (void)maybeForce:(BOOL)force draw:(void(^)())draw {
    if(force || [self needRedraw]) {
        [self bind];
        draw();
        [self unbind];
    }
}

- (void)unbind {
    [((PGRenderTargetSurface*)(__surface)) unbind];
}

- (NSString*)description {
    return [NSString stringWithFormat:@")"];
}

- (CNClassType*)type {
    return [PGBaseViewportSurface type];
}

+ (CNClassType*)type {
    return _PGBaseViewportSurface_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

