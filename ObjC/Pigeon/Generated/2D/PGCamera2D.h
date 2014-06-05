#import "objd.h"
#import "PGScene.h"
#import "PGVec.h"
@class PGMatrixModel;
@class PGMat4;
@class PGImMatrixModel;

@class PGCamera2D;

@interface PGCamera2D : PGCamera_impl {
@public
    PGVec2 _size;
    CGFloat _viewportRatio;
    PGMatrixModel* _matrixModel;
}
@property (nonatomic, readonly) PGVec2 size;
@property (nonatomic, readonly) CGFloat viewportRatio;
@property (nonatomic, readonly) PGMatrixModel* matrixModel;

+ (instancetype)camera2DWithSize:(PGVec2)size;
- (instancetype)initWithSize:(PGVec2)size;
- (CNClassType*)type;
- (NSString*)description;
+ (CNClassType*)type;
@end


