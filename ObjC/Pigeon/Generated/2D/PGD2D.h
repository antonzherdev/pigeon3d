#import "objd.h"
#import "PGBillboardView.h"
#import "PGVec.h"
#import "PGBillboard.h"
#import "PGMesh.h"
@class PGMutableVertexBuffer;
@class PGSprite;
@class PGVBO;
@class PGVertexArray;
@class PGEmptyIndexSource;
@class PGSimpleShaderSystem;
@class PGCircleShader;
@class PGColorSource;
@class PGTexture;
@class PGGlobal;
@class PGContext;
@class PGCullFace;
@class PGCircleSegment;
@class PGCircleParam;
@class PGMatrixStack;
@class PGMMatrixModel;
@class PGMat4;

@class PGD2D;

@interface PGD2D : NSObject
- (CNClassType*)type;
+ (void)install;
+ (void)drawSpriteMaterial:(PGColorSource*)material at:(PGVec3)at rect:(PGRect)rect;
+ (void)drawSpriteMaterial:(PGColorSource*)material at:(PGVec3)at quad:(PGQuad)quad;
+ (void)drawSpriteMaterial:(PGColorSource*)material at:(PGVec3)at quad:(PGQuad)quad uv:(PGQuad)uv;
+ (void)drawLineMaterial:(PGColorSource*)material p0:(PGVec2)p0 p1:(PGVec2)p1;
+ (void)drawCircleBackColor:(PGVec4)backColor strokeColor:(PGVec4)strokeColor at:(PGVec3)at radius:(float)radius relative:(PGVec2)relative segmentColor:(PGVec4)segmentColor start:(CGFloat)start end:(CGFloat)end;
+ (void)drawCircleBackColor:(PGVec4)backColor strokeColor:(PGVec4)strokeColor at:(PGVec3)at radius:(float)radius relative:(PGVec2)relative;
+ (CNClassType*)type;
@end


