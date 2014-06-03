#import "PGCameraIso.h"

#import "PGMat4.h"
#import "PGMatrixModel.h"
#import "math.h"
#import "GL.h"
#import "CNObserver.h"
#import "CNReact.h"
@implementation PGCameraIso
static CGFloat _PGCameraIso_ISO;
static PGMat4* _PGCameraIso_m;
static PGMat4* _PGCameraIso_w;
static CNClassType* _PGCameraIso_type;
@synthesize tilesOnScreen = _tilesOnScreen;
@synthesize reserve = _reserve;
@synthesize viewportRatio = _viewportRatio;
@synthesize center = _center;
@synthesize matrixModel = _matrixModel;

+ (instancetype)cameraIsoWithTilesOnScreen:(PGVec2)tilesOnScreen reserve:(PGCameraReserve)reserve viewportRatio:(CGFloat)viewportRatio center:(PGVec2)center {
    return [[PGCameraIso alloc] initWithTilesOnScreen:tilesOnScreen reserve:reserve viewportRatio:viewportRatio center:center];
}

- (instancetype)initWithTilesOnScreen:(PGVec2)tilesOnScreen reserve:(PGCameraReserve)reserve viewportRatio:(CGFloat)viewportRatio center:(PGVec2)center {
    self = [super init];
    if(self) {
        _tilesOnScreen = tilesOnScreen;
        _reserve = reserve;
        _viewportRatio = viewportRatio;
        _center = center;
        _ww = ((CGFloat)(tilesOnScreen.x + tilesOnScreen.y));
        _matrixModel = ({
            CGFloat isoWW = _ww * _PGCameraIso_ISO;
            CGFloat isoWW2 = isoWW / 2;
            CGFloat as = (isoWW - viewportRatio * pgCameraReserveHeight(reserve) + pgCameraReserveWidth(reserve)) / (isoWW * viewportRatio);
            CGFloat angleSin = ((as > 1.0) ? 1.0 : as);
            [PGImMatrixModel imMatrixModelWithM:_PGCameraIso_m w:_PGCameraIso_w c:({
                CGFloat ang = (asin(angleSin) * 180) / M_PI;
                PGMat4* t = [[PGMat4 identity] translateX:-center.x y:0.0 z:center.y];
                PGMat4* r = [[[PGMat4 identity] rotateAngle:((float)(ang)) x:1.0 y:0.0 z:0.0] rotateAngle:-45.0 x:0.0 y:1.0 z:0.0];
                [r mulMatrix:t];
            }) p:[PGMat4 orthoLeft:((float)(-isoWW2 - reserve.left)) right:((float)(isoWW2 + reserve.right)) bottom:((float)(-isoWW2 * angleSin - reserve.bottom)) top:((float)(isoWW2 * angleSin + reserve.top)) zNear:-1000.0 zFar:1000.0]];
        });
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGCameraIso class]) {
        _PGCameraIso_type = [CNClassType classTypeWithCls:[PGCameraIso class]];
        _PGCameraIso_ISO = PGMapSso.ISO;
        _PGCameraIso_m = [[PGMat4 identity] rotateAngle:90.0 x:1.0 y:0.0 z:0.0];
        _PGCameraIso_w = [[PGMat4 identity] rotateAngle:-90.0 x:1.0 y:0.0 z:0.0];
    }
}

+ (PGCameraIso*)applyTilesOnScreen:(PGVec2)tilesOnScreen reserve:(PGCameraReserve)reserve viewportRatio:(CGFloat)viewportRatio {
    return [PGCameraIso cameraIsoWithTilesOnScreen:tilesOnScreen reserve:reserve viewportRatio:viewportRatio center:pgVec2DivF((pgVec2SubVec2(tilesOnScreen, (PGVec2Make(1.0, 1.0)))), 2.0)];
}

- (NSUInteger)cullFace {
    return ((NSUInteger)(GL_FRONT));
}

- (PGVec2)naturalCenter {
    return pgVec2DivF((pgVec2SubVec2(_tilesOnScreen, (PGVec2Make(1.0, 1.0)))), 2.0);
}

- (NSString*)description {
    return [NSString stringWithFormat:@"CameraIso(%@, %@, %f, %@)", pgVec2Description(_tilesOnScreen), pgCameraReserveDescription(_reserve), _viewportRatio, pgVec2Description(_center)];
}

- (CNClassType*)type {
    return [PGCameraIso type];
}

+ (PGMat4*)m {
    return _PGCameraIso_m;
}

+ (PGMat4*)w {
    return _PGCameraIso_w;
}

+ (CNClassType*)type {
    return _PGCameraIso_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGCameraIsoMove
static CNClassType* _PGCameraIsoMove_type;
@synthesize base = _base;
@synthesize minScale = _minScale;
@synthesize maxScale = _maxScale;
@synthesize panFingers = _panFingers;
@synthesize tapFingers = _tapFingers;
@synthesize changed = _changed;
@synthesize scale = _scale;
@synthesize center = _center;
@synthesize panEnabled = _panEnabled;
@synthesize tapEnabled = _tapEnabled;
@synthesize pinchEnabled = _pinchEnabled;

+ (instancetype)cameraIsoMoveWithBase:(PGCameraIso*)base minScale:(CGFloat)minScale maxScale:(CGFloat)maxScale panFingers:(NSUInteger)panFingers tapFingers:(NSUInteger)tapFingers {
    return [[PGCameraIsoMove alloc] initWithBase:base minScale:minScale maxScale:maxScale panFingers:panFingers tapFingers:tapFingers];
}

- (instancetype)initWithBase:(PGCameraIso*)base minScale:(CGFloat)minScale maxScale:(CGFloat)maxScale panFingers:(NSUInteger)panFingers tapFingers:(NSUInteger)tapFingers {
    self = [super init];
    __weak PGCameraIsoMove* _weakSelf = self;
    if(self) {
        _base = base;
        _minScale = minScale;
        _maxScale = maxScale;
        _panFingers = panFingers;
        _tapFingers = tapFingers;
        __currentBase = base;
        __camera = base;
        _changed = [CNSignal signal];
        _scale = [CNVar limitedInitial:@1.0 limits:^id(id s) {
            return numf((floatClampMinMax(unumf(s), minScale, maxScale)));
        }];
        _scaleObs = [_scale observeF:^void(id s) {
            PGCameraIsoMove* _self = _weakSelf;
            if(_self != nil) {
                _self->__camera = [PGCameraIso cameraIsoWithTilesOnScreen:pgVec2DivF4(_self->__currentBase.tilesOnScreen, ((float)(unumf(s)))) reserve:pgCameraReserveDivF4(_self->__currentBase.reserve, ((float)(unumf(s)))) viewportRatio:_self->__currentBase.viewportRatio center:_self->__camera.center];
                [_self->_changed post];
            }
        }];
        _center = [CNVar limitedInitial:wrap(PGVec2, __camera.center) limits:^id(id cen) {
            PGCameraIsoMove* _self = _weakSelf;
            if(_self != nil) {
                if(unumf([_self->_scale value]) <= 1) {
                    return wrap(PGVec2, [_self->__currentBase naturalCenter]);
                } else {
                    PGVec2 centerP = pgVec4Xy(([[_self->__currentBase.matrixModel wcp] mulVec4:pgVec4ApplyVec2ZW((uwrap(PGVec2, cen)), 0.0, 1.0)]));
                    PGVec2 cp = pgRectClosestPointForVec2([_self centerBounds], centerP);
                    if(pgVec2IsEqualTo(cp, centerP)) {
                        return cen;
                    } else {
                        PGMat4* mat4 = [[_self->__currentBase.matrixModel wcp] inverse];
                        PGVec4 p0 = [mat4 mulVec4:PGVec4Make(cp.x, cp.y, -1.0, 1.0)];
                        PGVec4 p1 = [mat4 mulVec4:PGVec4Make(cp.x, cp.y, 1.0, 1.0)];
                        PGLine3 line = PGLine3Make(pgVec4Xyz(p0), (pgVec3SubVec3(pgVec4Xyz(p1), pgVec4Xyz(p0))));
                        return wrap(PGVec2, (pgVec3Xy((pgLine3RPlane(line, (PGPlaneMake((PGVec3Make(0.0, 0.0, 0.0)), (PGVec3Make(0.0, 0.0, 1.0)))))))));
                    }
                }
            } else {
                return nil;
            }
        }];
        _centerObs = [_center observeF:^void(id cen) {
            PGCameraIsoMove* _self = _weakSelf;
            if(_self != nil) {
                _self->__camera = [PGCameraIso cameraIsoWithTilesOnScreen:[_self camera].tilesOnScreen reserve:[_self camera].reserve viewportRatio:[_self camera].viewportRatio center:uwrap(PGVec2, cen)];
                [_self->_changed post];
            }
        }];
        __startPan = PGVec2Make(-1.0, -1.0);
        __startScale = 1.0;
        __pinchLocation = PGVec2Make(-1.0, -1.0);
        __startCenter = PGVec2Make(-1.0, -1.0);
        _panEnabled = YES;
        _tapEnabled = YES;
        _pinchEnabled = YES;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGCameraIsoMove class]) _PGCameraIsoMove_type = [CNClassType classTypeWithCls:[PGCameraIsoMove class]];
}

- (PGCameraIso*)camera {
    return __camera;
}

- (CGFloat)viewportRatio {
    return __currentBase.viewportRatio;
}

- (void)setViewportRatio:(CGFloat)viewportRatio {
    __currentBase = [PGCameraIso cameraIsoWithTilesOnScreen:__currentBase.tilesOnScreen reserve:__currentBase.reserve viewportRatio:viewportRatio center:__currentBase.center];
    __camera = [PGCameraIso cameraIsoWithTilesOnScreen:__camera.tilesOnScreen reserve:__camera.reserve viewportRatio:viewportRatio center:__camera.center];
}

- (PGCameraReserve)reserve {
    return __currentBase.reserve;
}

- (void)setReserve:(PGCameraReserve)reserve {
    __currentBase = [PGCameraIso cameraIsoWithTilesOnScreen:__currentBase.tilesOnScreen reserve:reserve viewportRatio:__currentBase.viewportRatio center:__currentBase.center];
    __camera = [PGCameraIso cameraIsoWithTilesOnScreen:__camera.tilesOnScreen reserve:reserve viewportRatio:__camera.viewportRatio center:__camera.center];
}

- (PGRecognizers*)recognizers {
    return [PGRecognizers recognizersWithItems:(@[((PGRecognizer*)([PGRecognizer applyTp:[PGPinch pinch] began:^BOOL(id<PGEvent> event) {
    if(_pinchEnabled) {
        __startScale = unumf([_scale value]);
        __pinchLocation = [event location];
        __startCenter = __camera.center;
        return YES;
    } else {
        return NO;
    }
} changed:^void(id<PGEvent> event) {
    CGFloat s = ((PGPinchParameter*)([event param])).scale;
    [_scale setValue:numf(__startScale * s)];
    [_center setValue:wrap(PGVec2, (((s <= 1.0) ? __startCenter : ((s < 2.0) ? pgVec2AddVec2(__startCenter, (pgVec2MulF((pgVec2SubVec2(__pinchLocation, __startCenter)), s - 1.0))) : __pinchLocation))))];
} ended:^void(id<PGEvent> event) {
}])), ((PGRecognizer*)([PGRecognizer applyTp:[PGPan panWithFingers:_panFingers] began:^BOOL(id<PGEvent> event) {
    __startPan = [event location];
    return _panEnabled && unumf([_scale value]) > 1.0;
} changed:^void(id<PGEvent> event) {
    [_center setValue:wrap(PGVec2, (pgVec2SubVec2((pgVec2AddVec2(__camera.center, __startPan)), [event location])))];
} ended:^void(id<PGEvent> event) {
}])), ((PGRecognizer*)([PGRecognizer applyTp:[PGTap tapWithFingers:_tapFingers taps:2] on:^BOOL(id<PGEvent> event) {
    if(_tapEnabled) {
        if(!(eqf(unumf([_scale value]), _maxScale))) {
            PGVec2 loc = [event location];
            [_scale setValue:numf(_maxScale)];
            [_center setValue:wrap(PGVec2, loc)];
        } else {
            [_scale setValue:@1.0];
            [_center setValue:wrap(PGVec2, [__currentBase naturalCenter])];
        }
        return YES;
    } else {
        return NO;
    }
}]))])];
}

- (PGRect)centerBounds {
    PGVec2 sizeP = pgVec2ApplyF(2.0 - 2.0 / unumf([_scale value]));
    return PGRectMake((pgVec2DivF(sizeP, -2.0)), sizeP);
}

- (NSString*)description {
    return [NSString stringWithFormat:@"CameraIsoMove(%@, %f, %f, %lu, %lu)", _base, _minScale, _maxScale, (unsigned long)_panFingers, (unsigned long)_tapFingers];
}

- (CNClassType*)type {
    return [PGCameraIsoMove type];
}

+ (CNClassType*)type {
    return _PGCameraIsoMove_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

