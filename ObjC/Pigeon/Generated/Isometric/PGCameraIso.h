#import "objd.h"
#import "PGScene.h"
#import "PGVec.h"
#import "PGMapIso.h"
#import "PGInput.h"
@class PGMat4;
@class PGMatrixModel;
@class PGImMatrixModel;
@class CNSignal;
@class CNVar;
@class CNObserver;

@class PGCameraIso;
@class PGCameraIsoMove;

@interface PGCameraIso : PGCamera_impl {
@protected
    PGVec2 _tilesOnScreen;
    PGCameraReserve _reserve;
    CGFloat _viewportRatio;
    PGVec2 _center;
    CGFloat _ww;
    PGMatrixModel* _matrixModel;
}
@property (nonatomic, readonly) PGVec2 tilesOnScreen;
@property (nonatomic, readonly) PGCameraReserve reserve;
@property (nonatomic, readonly) CGFloat viewportRatio;
@property (nonatomic, readonly) PGVec2 center;
@property (nonatomic, readonly) PGMatrixModel* matrixModel;

+ (instancetype)cameraIsoWithTilesOnScreen:(PGVec2)tilesOnScreen reserve:(PGCameraReserve)reserve viewportRatio:(CGFloat)viewportRatio center:(PGVec2)center;
- (instancetype)initWithTilesOnScreen:(PGVec2)tilesOnScreen reserve:(PGCameraReserve)reserve viewportRatio:(CGFloat)viewportRatio center:(PGVec2)center;
- (CNClassType*)type;
+ (PGCameraIso*)applyTilesOnScreen:(PGVec2)tilesOnScreen reserve:(PGCameraReserve)reserve viewportRatio:(CGFloat)viewportRatio;
- (NSUInteger)cullFace;
- (PGVec2)naturalCenter;
- (NSString*)description;
+ (PGMat4*)m;
+ (PGMat4*)w;
+ (CNClassType*)type;
@end


@interface PGCameraIsoMove : PGInputProcessor_impl {
@protected
    PGCameraIso* _base;
    CGFloat _minScale;
    CGFloat _maxScale;
    NSUInteger _panFingers;
    NSUInteger _tapFingers;
    PGCameraIso* __currentBase;
    PGCameraIso* __camera;
    CNSignal* _changed;
    CNVar* _scale;
    CNObserver* _scaleObs;
    CNVar* _center;
    CNObserver* _centerObs;
    PGVec2 __startPan;
    CGFloat __startScale;
    PGVec2 __pinchLocation;
    PGVec2 __startCenter;
    BOOL _panEnabled;
    BOOL _tapEnabled;
    BOOL _pinchEnabled;
}
@property (nonatomic, readonly) PGCameraIso* base;
@property (nonatomic, readonly) CGFloat minScale;
@property (nonatomic, readonly) CGFloat maxScale;
@property (nonatomic, readonly) NSUInteger panFingers;
@property (nonatomic, readonly) NSUInteger tapFingers;
@property (nonatomic, readonly) CNSignal* changed;
@property (nonatomic, readonly) CNVar* scale;
@property (nonatomic, readonly) CNVar* center;
@property (nonatomic) BOOL panEnabled;
@property (nonatomic) BOOL tapEnabled;
@property (nonatomic) BOOL pinchEnabled;

+ (instancetype)cameraIsoMoveWithBase:(PGCameraIso*)base minScale:(CGFloat)minScale maxScale:(CGFloat)maxScale panFingers:(NSUInteger)panFingers tapFingers:(NSUInteger)tapFingers;
- (instancetype)initWithBase:(PGCameraIso*)base minScale:(CGFloat)minScale maxScale:(CGFloat)maxScale panFingers:(NSUInteger)panFingers tapFingers:(NSUInteger)tapFingers;
- (CNClassType*)type;
- (PGCameraIso*)camera;
- (CGFloat)viewportRatio;
- (void)setViewportRatio:(CGFloat)viewportRatio;
- (PGCameraReserve)reserve;
- (void)setReserve:(PGCameraReserve)reserve;
- (PGRecognizers*)recognizers;
- (NSString*)description;
+ (CNClassType*)type;
@end


