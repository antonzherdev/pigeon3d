#import "PGSurface.h"

#import "PGTexture.h"
#import "PGContext.h"
#import "GL.h"
#import "PGDirector.h"
@implementation PGSurface
static CNClassType* _PGSurface_type;
@synthesize size = _size;

+ (instancetype)surfaceWithSize:(PGVec2i)size {
    return [[PGSurface alloc] initWithSize:size];
}

- (instancetype)initWithSize:(PGVec2i)size {
    self = [super init];
    if(self) _size = size;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGSurface class]) _PGSurface_type = [CNClassType classTypeWithCls:[PGSurface class]];
}

- (void)applyDraw:(void(^)())draw {
    [self bind];
    draw();
    [self unbind];
}

- (void)bind {
    @throw @"Method bind is abstract";
}

- (void)unbind {
    @throw @"Method unbind is abstract";
}

- (int)frameBuffer {
    @throw @"Method frameBuffer is abstract";
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Surface(%@)", pgVec2iDescription(_size)];
}

- (CNClassType*)type {
    return [PGSurface type];
}

+ (CNClassType*)type {
    return _PGSurface_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGSurfaceRenderTarget
static CNClassType* _PGSurfaceRenderTarget_type;
@synthesize size = _size;

+ (instancetype)surfaceRenderTargetWithSize:(PGVec2i)size {
    return [[PGSurfaceRenderTarget alloc] initWithSize:size];
}

- (instancetype)initWithSize:(PGVec2i)size {
    self = [super init];
    if(self) _size = size;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGSurfaceRenderTarget class]) _PGSurfaceRenderTarget_type = [CNClassType classTypeWithCls:[PGSurfaceRenderTarget class]];
}

- (void)link {
    @throw @"Method link is abstract";
}

- (NSString*)description {
    return [NSString stringWithFormat:@"SurfaceRenderTarget(%@)", pgVec2iDescription(_size)];
}

- (CNClassType*)type {
    return [PGSurfaceRenderTarget type];
}

+ (CNClassType*)type {
    return _PGSurfaceRenderTarget_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGSurfaceRenderTargetTexture
static CNClassType* _PGSurfaceRenderTargetTexture_type;
@synthesize texture = _texture;

+ (instancetype)surfaceRenderTargetTextureWithTexture:(PGTexture*)texture size:(PGVec2i)size {
    return [[PGSurfaceRenderTargetTexture alloc] initWithTexture:texture size:size];
}

- (instancetype)initWithTexture:(PGTexture*)texture size:(PGVec2i)size {
    self = [super initWithSize:size];
    if(self) _texture = texture;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGSurfaceRenderTargetTexture class]) _PGSurfaceRenderTargetTexture_type = [CNClassType classTypeWithCls:[PGSurfaceRenderTargetTexture class]];
}

+ (PGSurfaceRenderTargetTexture*)applySize:(PGVec2i)size {
    PGEmptyTexture* t = [PGEmptyTexture emptyTextureWithSize:pgVec2ApplyVec2i(size)];
    [PGGlobal.context bindTextureTexture:t];
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, ((int)(GL_CLAMP_TO_EDGE)));
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, ((int)(GL_CLAMP_TO_EDGE)));
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, ((int)(GL_NEAREST)));
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, ((int)(GL_NEAREST)));
    glTexImage2D(GL_TEXTURE_2D, 0, ((int)(GL_RGBA)), ((int)(size.x)), ((int)(size.y)), 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
    return [PGSurfaceRenderTargetTexture surfaceRenderTargetTextureWithTexture:t size:size];
}

- (void)link {
    egFramebufferTexture(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, [_texture id], 0);
}

- (NSString*)description {
    return [NSString stringWithFormat:@"SurfaceRenderTargetTexture(%@)", _texture];
}

- (CNClassType*)type {
    return [PGSurfaceRenderTargetTexture type];
}

+ (CNClassType*)type {
    return _PGSurfaceRenderTargetTexture_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGSurfaceRenderTargetRenderBuffer
static CNClassType* _PGSurfaceRenderTargetRenderBuffer_type;
@synthesize renderBuffer = _renderBuffer;

+ (instancetype)surfaceRenderTargetRenderBufferWithRenderBuffer:(unsigned int)renderBuffer size:(PGVec2i)size {
    return [[PGSurfaceRenderTargetRenderBuffer alloc] initWithRenderBuffer:renderBuffer size:size];
}

- (instancetype)initWithRenderBuffer:(unsigned int)renderBuffer size:(PGVec2i)size {
    self = [super initWithSize:size];
    if(self) _renderBuffer = renderBuffer;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGSurfaceRenderTargetRenderBuffer class]) _PGSurfaceRenderTargetRenderBuffer_type = [CNClassType classTypeWithCls:[PGSurfaceRenderTargetRenderBuffer class]];
}

+ (PGSurfaceRenderTargetRenderBuffer*)applySize:(PGVec2i)size {
    unsigned int buf = egGenRenderBuffer();
    [PGGlobal.context bindRenderBufferId:buf];
    glRenderbufferStorage(GL_RENDERBUFFER, GL_RGBA8_OES, ((int)(size.x)), ((int)(size.y)));
    return [PGSurfaceRenderTargetRenderBuffer surfaceRenderTargetRenderBufferWithRenderBuffer:buf size:size];
}

- (void)link {
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _renderBuffer);
}

- (void)dealloc {
    [PGGlobal.context deleteRenderBufferId:_renderBuffer];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"SurfaceRenderTargetRenderBuffer(%u)", _renderBuffer];
}

- (CNClassType*)type {
    return [PGSurfaceRenderTargetRenderBuffer type];
}

+ (CNClassType*)type {
    return _PGSurfaceRenderTargetRenderBuffer_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGRenderTargetSurface
static CNClassType* _PGRenderTargetSurface_type;
@synthesize renderTarget = _renderTarget;

+ (instancetype)renderTargetSurfaceWithRenderTarget:(PGSurfaceRenderTarget*)renderTarget {
    return [[PGRenderTargetSurface alloc] initWithRenderTarget:renderTarget];
}

- (instancetype)initWithRenderTarget:(PGSurfaceRenderTarget*)renderTarget {
    self = [super initWithSize:renderTarget.size];
    if(self) _renderTarget = renderTarget;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGRenderTargetSurface class]) _PGRenderTargetSurface_type = [CNClassType classTypeWithCls:[PGRenderTargetSurface class]];
}

- (PGTexture*)texture {
    return ((PGSurfaceRenderTargetTexture*)(_renderTarget)).texture;
}

- (unsigned int)renderBuffer {
    return ((PGSurfaceRenderTargetRenderBuffer*)(_renderTarget)).renderBuffer;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"RenderTargetSurface(%@)", _renderTarget];
}

- (CNClassType*)type {
    return [PGRenderTargetSurface type];
}

+ (CNClassType*)type {
    return _PGRenderTargetSurface_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGSimpleSurface
static CNClassType* _PGSimpleSurface_type;
@synthesize depth = _depth;
@synthesize frameBuffer = _frameBuffer;

+ (instancetype)simpleSurfaceWithRenderTarget:(PGSurfaceRenderTarget*)renderTarget depth:(BOOL)depth {
    return [[PGSimpleSurface alloc] initWithRenderTarget:renderTarget depth:depth];
}

- (instancetype)initWithRenderTarget:(PGSurfaceRenderTarget*)renderTarget depth:(BOOL)depth {
    self = [super initWithRenderTarget:renderTarget];
    if(self) {
        _depth = depth;
        _frameBuffer = egGenFrameBuffer();
        _depthRenderBuffer = ((depth) ? egGenRenderBuffer() : 0);
        if([self class] == [PGSimpleSurface class]) [self _init];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGSimpleSurface class]) _PGSimpleSurface_type = [CNClassType classTypeWithCls:[PGSimpleSurface class]];
}

+ (PGSimpleSurface*)toTextureSize:(PGVec2i)size depth:(BOOL)depth {
    return [PGSimpleSurface simpleSurfaceWithRenderTarget:[PGSurfaceRenderTargetTexture applySize:size] depth:depth];
}

+ (PGSimpleSurface*)toRenderBufferSize:(PGVec2i)size depth:(BOOL)depth {
    return [PGSimpleSurface simpleSurfaceWithRenderTarget:[PGSurfaceRenderTargetRenderBuffer applySize:size] depth:depth];
}

- (void)_init {
    glGetError();
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    [self.renderTarget link];
    if(glGetError() != 0) {
        NSString* e = [NSString stringWithFormat:@"Error in texture creation for surface with size %ldx%ld", (long)self.size.x, (long)self.size.y];
        @throw e;
    }
    int status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if(status != GL_FRAMEBUFFER_COMPLETE) @throw [NSString stringWithFormat:@"Error in frame buffer color attachment: %d", status];
    if(_depth) {
        [PGGlobal.context bindRenderBufferId:_depthRenderBuffer];
        glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, ((int)(self.size.x)), ((int)(self.size.y)));
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthRenderBuffer);
        int status2 = glCheckFramebufferStatus(GL_FRAMEBUFFER);
        if(status2 != GL_FRAMEBUFFER_COMPLETE) @throw [NSString stringWithFormat:@"Error in frame buffer depth attachment: %d", status];
    }
}

- (void)dealloc {
    unsigned int fb = _frameBuffer;
    [[PGDirector current] onGLThreadF:^void() {
        egDeleteFrameBuffer(fb);
    }];
    if(_depth) [PGGlobal.context deleteRenderBufferId:_depthRenderBuffer];
}

- (void)bind {
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    [PGGlobal.context setViewport:pgRectIApplyXYWidthHeight(0.0, 0.0, ((float)(self.size.x)), ((float)(self.size.y)))];
}

- (void)unbind {
}

- (NSString*)description {
    return [NSString stringWithFormat:@"SimpleSurface(%d)", _depth];
}

- (CNClassType*)type {
    return [PGSimpleSurface type];
}

+ (CNClassType*)type {
    return _PGSimpleSurface_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

