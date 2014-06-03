#import "PGMultisamplingSurface.h"

#import "PGTexture.h"
#import "PGContext.h"
#import "PGMesh.h"
#import "PGVertexArray.h"

@implementation PGFirstMultisamplingSurface {
    BOOL _depth;
    GLuint _frameBuffer;
    GLuint _renderBuffer;
    GLuint _depthRenderBuffer;
}
static CNClassType* _EGFirstMultisamplingSurface_type;
@synthesize depth = _depth;
@synthesize frameBuffer = _frameBuffer;

+ (id)firstMultisamplingSurfaceWithSize:(PGVec2i)size depth:(BOOL)depth {
    return [[PGFirstMultisamplingSurface alloc] initWithSize:size depth:depth];
}

- (id)initWithSize:(PGVec2i)size depth:(BOOL)depth {
    self = [super initWithSize:size];
    if(self) {
        _depth = depth;
        _frameBuffer = egGenFrameBuffer();
        _renderBuffer = egGenRenderBuffer();
        _depthRenderBuffer = ((_depth) ? egGenRenderBuffer() : 0);
        glGenFramebuffers(1, &_frameBuffer);
        glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);

        [[PGGlobal context] bindRenderBufferId:_renderBuffer];
        glRenderbufferStorageMultisampleAPPLE(GL_RENDERBUFFER, 4, GL_RGBA8_OES, self.size.x, self.size.y);
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _renderBuffer);

        egCheckError();
        NSInteger status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
        if(status != GL_FRAMEBUFFER_COMPLETE) @throw [NSString stringWithFormat:@"Error in frame buffer color attachment: %ld", (long)status];
        if(depth) {
            glGenRenderbuffers(1, &_depthRenderBuffer);
            [[PGGlobal context] bindRenderBufferId:_depthRenderBuffer];
            glRenderbufferStorageMultisampleAPPLE(GL_RENDERBUFFER, 4, GL_DEPTH_COMPONENT16,  self.size.x, self.size.y);
            glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthRenderBuffer);
            egCheckError();
            status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
            if(status != GL_FRAMEBUFFER_COMPLETE) @throw [NSString stringWithFormat:@"Error in frame buffer depth attachment: %ld", (long)status];
        }
    }

    return self;
}

+ (void)initialize {
    [super initialize];
    _EGFirstMultisamplingSurface_type = [CNClassType classTypeWithCls:[PGFirstMultisamplingSurface class]];
}

- (void)dealloc {
    egDeleteFrameBuffer(_frameBuffer);
    [[PGGlobal context] deleteRenderBufferId:_renderBuffer];
    if(_depth) [[PGGlobal context] deleteRenderBufferId:_depthRenderBuffer];
}

- (void)bind {
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    [PGGlobal.context setViewport:pgRectIApplyXYWidthHeight(0.0, 0.0, ((float)(self.size.x)), ((float)(self.size.y)))];
}

- (void)unbind {
}

- (CNClassType*)type {
    return [PGFirstMultisamplingSurface type];
}

+ (CNClassType*)type {
    return _EGFirstMultisamplingSurface_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    PGFirstMultisamplingSurface * o = ((PGFirstMultisamplingSurface *)(other));
    return pgVec2iIsEqualTo(self.size, o.size) && self.depth == o.depth;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + pgVec2iHash(self.size);
    hash = hash * 31 + self.depth;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"size=%@", pgVec2iDescription(self.size)];
    [description appendFormat:@", depth=%d", self.depth];
    [description appendString:@">"];
    return description;
}

@end


@implementation PGMultisamplingSurface {
    BOOL _depth;
    PGFirstMultisamplingSurface * _multisampling;
    PGSimpleSurface* _simple;
}
static CNClassType* _EGMultisamplingSurface_type;
@synthesize depth = _depth;

+ (id)multisamplingSurfaceWithRenderTarget:(PGSurfaceRenderTarget*)renderTarget depth:(BOOL)depth{
    return [[PGMultisamplingSurface alloc] initWithRenderTarget:renderTarget depth:depth];
}

- (id)initWithRenderTarget:(PGSurfaceRenderTarget*)renderTarget depth:(BOOL)depth {
    self = [super initWithRenderTarget:renderTarget];
    if(self) {
        _depth = depth;
        _multisampling = [PGFirstMultisamplingSurface firstMultisamplingSurfaceWithSize:self.size depth:_depth];
        _simple = [PGSimpleSurface simpleSurfaceWithRenderTarget:renderTarget depth:NO];
    }

    return self;
}

+ (void)initialize {
    [super initialize];
    _EGMultisamplingSurface_type = [CNClassType classTypeWithCls:[PGMultisamplingSurface class]];
}

- (void)bind {
    [_multisampling bind];
}

- (void)unbind {
//    glBindFramebuffer(GL_READ_FRAMEBUFFER_APPLE, _multisampling.frameBuffer);
    glBindFramebuffer(GL_DRAW_FRAMEBUFFER_APPLE, _simple.frameBuffer);
    glResolveMultisampleFramebufferAPPLE();
    const GLenum discards[]  = {GL_COLOR_ATTACHMENT0, GL_DEPTH_ATTACHMENT};
    glDiscardFramebufferEXT(GL_READ_FRAMEBUFFER_APPLE, 2, discards);
    [_multisampling unbind];
//    const GLenum discards2[]  = {GL_COLOR_ATTACHMENT0};
//    glDiscardFramebufferEXT(GL_DRAW_FRAMEBUFFER_APPLE, 1, discards2);
    egCheckError();
}

- (GLint)frameBuffer {
    return _multisampling.frameBuffer;
}

- (PGTexture*)texture {
    return _simple.texture;
}

- (CNClassType*)type {
    return [PGMultisamplingSurface type];
}

+ (CNClassType*)type {
    return _EGMultisamplingSurface_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    PGMultisamplingSurface * o = ((PGMultisamplingSurface *)(other));
    return pgVec2iIsEqualTo(self.size, o.size) && self.depth == o.depth;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + pgVec2iHash(self.size);
    hash = hash * 31 + self.depth;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"size=%@", pgVec2iDescription(self.size)];
    [description appendFormat:@", depth=%d", self.depth];
    [description appendString:@">"];
    return description;
}
@end


@implementation PGViewportSurface{
    BOOL _depth;
    BOOL _multisampling;
}
static CNClassType* _PGViewportSurface_type;
@synthesize depth = _depth;
@synthesize multisampling = _multisampling;

+ (id)viewportSurfaceWithCreateRenderTarget:(PGSurfaceRenderTarget*(^)(PGVec2i))createRenderTarget depth:(BOOL)depth multisampling:(BOOL)multisampling {
    return [[PGViewportSurface alloc] initWithCreateRenderTarget:createRenderTarget depth:depth multisampling:multisampling];
}

- (id)initWithCreateRenderTarget:(PGSurfaceRenderTarget*(^)(PGVec2i))createRenderTarget depth:(BOOL)depth multisampling:(BOOL)multisampling {
    self = [super initWithCreateRenderTarget:createRenderTarget];
    if(self) {
        _depth = depth;
        _multisampling = multisampling;
    }

    return self;
}

+ (void)initialize {
    [super initialize];
    _PGViewportSurface_type = [CNClassType classTypeWithCls:[PGViewportSurface class]];
}

- (PGRenderTargetSurface*)createSurface {
    PGSurfaceRenderTarget *renderTarget = [self renderTarget];
    if(_multisampling) return [PGMultisamplingSurface multisamplingSurfaceWithRenderTarget:renderTarget depth:_depth];
    else return [PGSimpleSurface simpleSurfaceWithRenderTarget:renderTarget depth:_depth];
}

- (void)drawWithZ:(float)z {
    unsigned int old = [PGGlobal.context.cullFace disable];
    [[PGViewportSurface fullScreenVao] drawParam:[PGViewportSurfaceShaderParam viewportSurfaceShaderParamWithTexture:[self texture] z:z]];
    if(old != GL_NONE) [PGGlobal.context.cullFace setValue:old];
}

- (void)draw {
    if([self surface] == nil) return ;
    BOOL ch = [PGGlobal.context.depthTest disable];
    unsigned int old = [PGGlobal.context.cullFace disable];
    if(old != GL_NONE) [PGGlobal.context.cullFace setValue:old];
    if(ch) [[PGGlobal context].depthTest enable];
}

- (CNClassType*)type {
    return [PGViewportSurface type];
}

+ (CNClassType*)type {
    return _PGViewportSurface_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

+ (PGViewportSurface *)toTextureDepth:(BOOL)depth multisampling:(BOOL)multisampling {
    return [PGViewportSurface viewportSurfaceWithCreateRenderTarget:^PGSurfaceRenderTarget *(PGVec2i i) {
        return [PGSurfaceRenderTargetTexture applySize:i];
    } depth:depth multisampling:multisampling];
}

+ (PGViewportSurface *)toRenderBufferDepth:(BOOL)depth multisampling:(BOOL)multisampling {
    return [PGViewportSurface viewportSurfaceWithCreateRenderTarget:^PGSurfaceRenderTarget *(PGVec2i i) {
        return [PGSurfaceRenderTargetRenderBuffer applySize:i];
    } depth:depth multisampling:multisampling];
}


- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    PGViewportSurface* o = ((PGViewportSurface*)(other));
    return self.depth == o.depth && self.multisampling == o.multisampling;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + self.depth;
    hash = hash * 31 + self.multisampling;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"depth=%d", self.depth];
    [description appendFormat:@", multisampling=%d", self.multisampling];
    [description appendString:@">"];
    return description;
}
@end

