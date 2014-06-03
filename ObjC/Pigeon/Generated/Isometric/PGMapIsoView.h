#import "objd.h"
#import "PGVec.h"
#import "PGMesh.h"
@class PGMapSso;
@class PGMaterial;
@protocol PGVertexBuffer;
@class PGCameraIso;
@class PGMat4;
@class PGVBO;
@class PGEmptyIndexSource;
@class PGVertexArray;
@class PGColorSource;
@class PGArrayIndexSource;
@class PGGlobal;
@class PGContext;
@class PGCullFace;

@class PGMapSsoView;

@interface PGMapSsoView : NSObject {
@protected
    PGMapSso* _map;
    PGMaterial* _material;
    CNLazy* __lazy_axisVertexBuffer;
    PGMesh* _plane;
    PGVertexArray* _planeVao;
}
@property (nonatomic, readonly) PGMapSso* map;
@property (nonatomic, readonly) PGMaterial* material;
@property (nonatomic, readonly) PGMesh* plane;

+ (instancetype)mapSsoViewWithMap:(PGMapSso*)map material:(PGMaterial*)material;
- (instancetype)initWithMap:(PGMapSso*)map material:(PGMaterial*)material;
- (CNClassType*)type;
- (id<PGVertexBuffer>)axisVertexBuffer;
- (void)drawLayout;
- (void)draw;
- (NSString*)description;
+ (CNClassType*)type;
@end


