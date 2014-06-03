#import "objd.h"
#import "PGSurface.h"
#import "GL.h"
#import "PGVec.h"
#import "PGViewportSurface.h"

@class PGTexture;

@class PGFirstMultisamplingSurface;

@interface PGFirstMultisamplingSurface : PGSurface
@property (nonatomic, readonly) BOOL depth;
@property (nonatomic, readonly) GLuint frameBuffer;

+ (id)firstMultisamplingSurfaceWithSize:(PGVec2i)size depth:(BOOL)depth;
- (id)initWithSize:(PGVec2i)size depth:(BOOL)depth;
- (CNClassType*)type;
- (void)dealloc;
- (void)bind;
- (void)unbind;
+ (CNClassType*)type;
@end


@interface PGMultisamplingSurface : PGRenderTargetSurface
@property (nonatomic, readonly) BOOL depth;

+ (id)multisamplingSurfaceWithRenderTarget:(PGSurfaceRenderTarget*)renderTarget depth:(BOOL)depth;
- (id)initWithRenderTarget:(PGSurfaceRenderTarget*)renderTarget depth:(BOOL)depth;
- (CNClassType*)type;
- (void)bind;
- (void)unbind;
- (GLint)frameBuffer;
+ (CNClassType*)type;
@end



@interface PGViewportSurface : PGBaseViewportSurface
@property (nonatomic, readonly) BOOL depth;
@property (nonatomic, readonly) BOOL multisampling;

+ (id)viewportSurfaceWithCreateRenderTarget:(PGSurfaceRenderTarget*(^)(PGVec2i))createRenderTarget depth:(BOOL)depth multisampling:(BOOL)multisampling;
- (id)initWithCreateRenderTarget:(PGSurfaceRenderTarget*(^)(PGVec2i))createRenderTarget depth:(BOOL)depth multisampling:(BOOL)multisampling;
- (CNClassType*)type;
- (void)drawWithZ:(float)z;
- (void)draw;
+ (CNClassType*)type;

+ (PGViewportSurface *)toTextureDepth:(BOOL)depth multisampling:(BOOL)multisampling;
+ (PGViewportSurface *)toRenderBufferDepth:(BOOL)depth multisampling:(BOOL)multisampling;
@end


