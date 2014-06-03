#import "objd.h"
#import "PGVec.h"
@class PGTexture;
@class PGEmptyTexture;
@class PGGlobal;
@class PGContext;
@class PGDirector;

@class PGSurface;
@class PGSurfaceRenderTarget;
@class PGSurfaceRenderTargetTexture;
@class PGSurfaceRenderTargetRenderBuffer;
@class PGRenderTargetSurface;
@class PGSimpleSurface;

@interface PGSurface : NSObject {
@protected
    PGVec2i _size;
}
@property (nonatomic, readonly) PGVec2i size;

+ (instancetype)surfaceWithSize:(PGVec2i)size;
- (instancetype)initWithSize:(PGVec2i)size;
- (CNClassType*)type;
- (void)bind;
- (void)unbind;
- (int)frameBuffer;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGSurfaceRenderTarget : NSObject {
@protected
    PGVec2i _size;
}
@property (nonatomic, readonly) PGVec2i size;

+ (instancetype)surfaceRenderTargetWithSize:(PGVec2i)size;
- (instancetype)initWithSize:(PGVec2i)size;
- (CNClassType*)type;
- (void)link;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGSurfaceRenderTargetTexture : PGSurfaceRenderTarget {
@protected
    PGTexture* _texture;
}
@property (nonatomic, readonly) PGTexture* texture;

+ (instancetype)surfaceRenderTargetTextureWithTexture:(PGTexture*)texture size:(PGVec2i)size;
- (instancetype)initWithTexture:(PGTexture*)texture size:(PGVec2i)size;
- (CNClassType*)type;
+ (PGSurfaceRenderTargetTexture*)applySize:(PGVec2i)size;
- (void)link;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGSurfaceRenderTargetRenderBuffer : PGSurfaceRenderTarget {
@protected
    unsigned int _renderBuffer;
}
@property (nonatomic, readonly) unsigned int renderBuffer;

+ (instancetype)surfaceRenderTargetRenderBufferWithRenderBuffer:(unsigned int)renderBuffer size:(PGVec2i)size;
- (instancetype)initWithRenderBuffer:(unsigned int)renderBuffer size:(PGVec2i)size;
- (CNClassType*)type;
+ (PGSurfaceRenderTargetRenderBuffer*)applySize:(PGVec2i)size;
- (void)link;
- (void)dealloc;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGRenderTargetSurface : PGSurface {
@protected
    PGSurfaceRenderTarget* _renderTarget;
}
@property (nonatomic, readonly) PGSurfaceRenderTarget* renderTarget;

+ (instancetype)renderTargetSurfaceWithRenderTarget:(PGSurfaceRenderTarget*)renderTarget;
- (instancetype)initWithRenderTarget:(PGSurfaceRenderTarget*)renderTarget;
- (CNClassType*)type;
- (PGTexture*)texture;
- (unsigned int)renderBuffer;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGSimpleSurface : PGRenderTargetSurface {
@protected
    BOOL _depth;
    unsigned int _frameBuffer;
    unsigned int _depthRenderBuffer;
}
@property (nonatomic, readonly) BOOL depth;
@property (nonatomic, readonly) unsigned int frameBuffer;

+ (instancetype)simpleSurfaceWithRenderTarget:(PGSurfaceRenderTarget*)renderTarget depth:(BOOL)depth;
- (instancetype)initWithRenderTarget:(PGSurfaceRenderTarget*)renderTarget depth:(BOOL)depth;
- (CNClassType*)type;
+ (PGSimpleSurface*)toTextureSize:(PGVec2i)size depth:(BOOL)depth;
+ (PGSimpleSurface*)toRenderBufferSize:(PGVec2i)size depth:(BOOL)depth;
- (void)_init;
- (void)dealloc;
- (void)bind;
- (void)unbind;
- (NSString*)description;
+ (CNClassType*)type;
@end


