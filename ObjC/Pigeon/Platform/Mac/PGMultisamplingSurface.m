#import "PGMultisamplingSurface.h"

#import "PGTexture.h"
#import "PGContext.h"
#import "PGMesh.h"
#import "PGVertexArray.h"

@implementation PGFirstMultisamplingSurface {
    BOOL _depth;
    GLuint _frameBuffer;
    id _depthTexture;
    PGTexture* _texture;
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
        _depthTexture = ((_depth) ? [PGEmptyTexture emptyTextureWithSize:pgVec2ApplyVec2i(size)] : nil);
        _texture = ^PGTexture*() {
            PGTexture* t = [PGEmptyTexture emptyTextureWithSize:pgVec2ApplyVec2i(size)];
            glGetError();
            glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
            [[PGGlobal context] bindTextureSlot:GL_TEXTURE0 target:GL_TEXTURE_2D_MULTISAMPLE texture:t];
            glTexImage2DMultisample(GL_TEXTURE_2D_MULTISAMPLE, 4, GL_RGBA, (GLsizei)self.size.x, (GLsizei)self.size.y, GL_FALSE);
            if(glGetError() != 0) {
                NSString* e = [NSString stringWithFormat:@"Error in texture creation for surface with size %lix%li", self.size.x, self.size.y];
                @throw e;
            }
            glFramebufferTexture(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, t.id, 0);
            NSInteger status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
            if(status != GL_FRAMEBUFFER_COMPLETE) @throw [NSString stringWithFormat:@"Error in frame buffer color attachment: %li", status];
            if(_depth) {
                [[PGGlobal context] bindTextureSlot:GL_TEXTURE0 target:GL_TEXTURE_2D_MULTISAMPLE texture:(PGTexture*)(_depthTexture)];
                glTexImage2DMultisample(GL_TEXTURE_2D_MULTISAMPLE, 4, GL_DEPTH_COMPONENT24, (GLsizei)self.size.x, (GLsizei)self.size.y, GL_FALSE);
                glFramebufferTexture(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, ((PGTexture*)(_depthTexture)).id, 0);
                NSInteger status2 = glCheckFramebufferStatus(GL_FRAMEBUFFER);
                if(status2 != GL_FRAMEBUFFER_COMPLETE) @throw [NSString stringWithFormat:@"Error in frame buffer depth attachment: %li", status];
            }
            return t;
        }();
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGFirstMultisamplingSurface_type = [CNClassType classTypeWithCls:[PGFirstMultisamplingSurface class]];
}

- (void)dealloc {
    egDeleteFrameBuffer(_frameBuffer);
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
    [_multisampling unbind];
//    glBindFramebuffer(GL_READ_FRAMEBUFFER, _multisampling.frameBuffer);
    glBindFramebuffer(GL_DRAW_FRAMEBUFFER, _simple.frameBuffer);
    PGVec2i s = self.size;
    glBlitFramebuffer(0, 0, (GLsizei)s.x, (GLsizei)s.y, 0, 0, (GLsizei)s.x, (GLsizei)s.y, GL_COLOR_BUFFER_BIT, GL_NEAREST);
    glBindFramebuffer(GL_READ_FRAMEBUFFER, 0);
    glBindFramebuffer(GL_DRAW_FRAMEBUFFER, 0);
}

- (GLint)frameBuffer {
    return _simple.frameBuffer;
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

- (void)draw {
    if([self surface] == nil) return ;
    if([self needRedraw]) {
        BOOL ch = [PGGlobal.context.depthTest disable];
        unsigned int old = [PGGlobal.context.cullFace disable];
        [[PGViewportSurface fullScreenVao] drawParam:[PGViewportSurfaceShaderParam viewportSurfaceShaderParamWithTexture:[self texture] z:0.0]];
        if(old != GL_NONE) [PGGlobal.context.cullFace setValue:old];
        if(ch) [[PGGlobal context].depthTest enable];
    } else {
        glBindFramebuffer(GL_READ_FRAMEBUFFER, (GLuint) [[self surface] frameBuffer]);
        PGVec2i s = [self surface].size;
        PGRectI v = [PGGlobal.context viewport];
        glBlitFramebuffer(0, 0, (GLsizei)s.x, (GLsizei)s.y, (GLsizei)pgRectIX(v), (GLsizei)pgRectIY(v), (GLsizei)pgRectIX2(v), (GLsizei)pgRectIY2(v), GL_COLOR_BUFFER_BIT, GL_NEAREST);
        glBindFramebuffer(GL_READ_FRAMEBUFFER, 0);
    }
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

