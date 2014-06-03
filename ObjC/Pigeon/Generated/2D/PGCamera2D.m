#import "PGCamera2D.h"

#import "PGMatrixModel.h"
#import "PGMat4.h"
@implementation PGCamera2D
static CNClassType* _PGCamera2D_type;
@synthesize size = _size;
@synthesize viewportRatio = _viewportRatio;
@synthesize matrixModel = _matrixModel;

+ (instancetype)camera2DWithSize:(PGVec2)size {
    return [[PGCamera2D alloc] initWithSize:size];
}

- (instancetype)initWithSize:(PGVec2)size {
    self = [super init];
    if(self) {
        _size = size;
        _viewportRatio = ((CGFloat)(size.x / size.y));
        _matrixModel = [PGImMatrixModel imMatrixModelWithM:[PGMat4 identity] w:[PGMat4 identity] c:[PGMat4 identity] p:[PGMat4 orthoLeft:0.0 right:size.x bottom:0.0 top:size.y zNear:-1.0 zFar:1.0]];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGCamera2D class]) _PGCamera2D_type = [CNClassType classTypeWithCls:[PGCamera2D class]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Camera2D(%@)", pgVec2Description(_size)];
}

- (CNClassType*)type {
    return [PGCamera2D type];
}

+ (CNClassType*)type {
    return _PGCamera2D_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

