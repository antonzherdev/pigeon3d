#import "PGInput.h"

#import "PGDirector.h"
#import "CNReact.h"
#import "CNChain.h"
#import "PGMatrixModel.h"
#import "PGMat4.h"
@implementation PGRecognizer
static CNClassType* _PGRecognizer_type;
@synthesize tp = _tp;

+ (instancetype)recognizerWithTp:(PGRecognizerType*)tp {
    return [[PGRecognizer alloc] initWithTp:tp];
}

- (instancetype)initWithTp:(PGRecognizerType*)tp {
    self = [super init];
    if(self) _tp = tp;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGRecognizer class]) _PGRecognizer_type = [CNClassType classTypeWithCls:[PGRecognizer class]];
}

+ (PGRecognizer*)applyTp:(PGRecognizerType*)tp began:(BOOL(^)(id<PGEvent>))began changed:(void(^)(id<PGEvent>))changed ended:(void(^)(id<PGEvent>))ended {
    return [PGLongRecognizer longRecognizerWithTp:tp began:began changed:changed ended:ended canceled:^void(id<PGEvent> _) {
    }];
}

+ (PGRecognizer*)applyTp:(PGRecognizerType*)tp began:(BOOL(^)(id<PGEvent>))began changed:(void(^)(id<PGEvent>))changed ended:(void(^)(id<PGEvent>))ended canceled:(void(^)(id<PGEvent>))canceled {
    return [PGLongRecognizer longRecognizerWithTp:tp began:began changed:changed ended:ended canceled:canceled];
}

+ (PGShortRecognizer*)applyTp:(PGRecognizerType*)tp on:(BOOL(^)(id<PGEvent>))on {
    return [PGShortRecognizer shortRecognizerWithTp:tp on:on];
}

- (PGRecognizers*)addRecognizer:(PGRecognizer*)recognizer {
    return [PGRecognizers recognizersWithItems:(@[((PGRecognizer*)(self)), recognizer])];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Recognizer(%@)", _tp];
}

- (CNClassType*)type {
    return [PGRecognizer type];
}

+ (CNClassType*)type {
    return _PGRecognizer_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGLongRecognizer
static CNClassType* _PGLongRecognizer_type;
@synthesize began = _began;
@synthesize changed = _changed;
@synthesize ended = _ended;
@synthesize canceled = _canceled;

+ (instancetype)longRecognizerWithTp:(PGRecognizerType*)tp began:(BOOL(^)(id<PGEvent>))began changed:(void(^)(id<PGEvent>))changed ended:(void(^)(id<PGEvent>))ended canceled:(void(^)(id<PGEvent>))canceled {
    return [[PGLongRecognizer alloc] initWithTp:tp began:began changed:changed ended:ended canceled:canceled];
}

- (instancetype)initWithTp:(PGRecognizerType*)tp began:(BOOL(^)(id<PGEvent>))began changed:(void(^)(id<PGEvent>))changed ended:(void(^)(id<PGEvent>))ended canceled:(void(^)(id<PGEvent>))canceled {
    self = [super initWithTp:tp];
    if(self) {
        _began = [began copy];
        _changed = [changed copy];
        _ended = [ended copy];
        _canceled = [canceled copy];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGLongRecognizer class]) _PGLongRecognizer_type = [CNClassType classTypeWithCls:[PGLongRecognizer class]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@")"];
}

- (CNClassType*)type {
    return [PGLongRecognizer type];
}

+ (CNClassType*)type {
    return _PGLongRecognizer_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGShortRecognizer
static CNClassType* _PGShortRecognizer_type;
@synthesize on = _on;

+ (instancetype)shortRecognizerWithTp:(PGRecognizerType*)tp on:(BOOL(^)(id<PGEvent>))on {
    return [[PGShortRecognizer alloc] initWithTp:tp on:on];
}

- (instancetype)initWithTp:(PGRecognizerType*)tp on:(BOOL(^)(id<PGEvent>))on {
    self = [super initWithTp:tp];
    if(self) _on = [on copy];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGShortRecognizer class]) _PGShortRecognizer_type = [CNClassType classTypeWithCls:[PGShortRecognizer class]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@")"];
}

- (CNClassType*)type {
    return [PGShortRecognizer type];
}

+ (CNClassType*)type {
    return _PGShortRecognizer_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGInputProcessor_impl

+ (instancetype)inputProcessor_impl {
    return [[PGInputProcessor_impl alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

- (BOOL)isProcessorActive {
    return !(unumb([[PGDirector current].isPaused value]));
}

- (PGRecognizers*)recognizers {
    @throw @"Method recognizers is abstract";
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGRecognizers
static CNClassType* _PGRecognizers_type;
@synthesize items = _items;

+ (instancetype)recognizersWithItems:(NSArray*)items {
    return [[PGRecognizers alloc] initWithItems:items];
}

- (instancetype)initWithItems:(NSArray*)items {
    self = [super init];
    if(self) _items = items;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGRecognizers class]) _PGRecognizers_type = [CNClassType classTypeWithCls:[PGRecognizers class]];
}

+ (PGRecognizers*)applyRecognizer:(PGRecognizer*)recognizer {
    return [PGRecognizers recognizersWithItems:(@[recognizer])];
}

- (PGShortRecognizer*)onEvent:(id<PGEvent>)event {
    return ((PGShortRecognizer*)([_items findWhere:^BOOL(PGRecognizer* item) {
        return [[event recognizerType] isEqual:((PGRecognizer*)(item)).tp] && ((PGShortRecognizer*)(item)).on(event);
    }]));
}

- (PGLongRecognizer*)beganEvent:(id<PGEvent>)event {
    return ((PGLongRecognizer*)([_items findWhere:^BOOL(PGRecognizer* item) {
        return [[event recognizerType] isEqual:((PGRecognizer*)(item)).tp] && ((PGLongRecognizer*)(item)).began(event);
    }]));
}

- (PGRecognizers*)addRecognizer:(PGRecognizer*)recognizer {
    return [PGRecognizers recognizersWithItems:[_items addItem:recognizer]];
}

- (PGRecognizers*)addRecognizers:(PGRecognizers*)recognizers {
    return [PGRecognizers recognizersWithItems:[_items addSeq:recognizers.items]];
}

- (id<CNSet>)types {
    return [[[_items chain] mapF:^PGRecognizerType*(PGRecognizer* _) {
        return ((PGRecognizer*)(_)).tp;
    }] toSet];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Recognizers(%@)", _items];
}

- (CNClassType*)type {
    return [PGRecognizers type];
}

+ (CNClassType*)type {
    return _PGRecognizers_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGRecognizersState
static CNClassType* _PGRecognizersState_type;
@synthesize recognizers = _recognizers;

+ (instancetype)recognizersStateWithRecognizers:(PGRecognizers*)recognizers {
    return [[PGRecognizersState alloc] initWithRecognizers:recognizers];
}

- (instancetype)initWithRecognizers:(PGRecognizers*)recognizers {
    self = [super init];
    if(self) {
        _recognizers = recognizers;
        _longMap = [CNMHashMap hashMap];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGRecognizersState class]) _PGRecognizersState_type = [CNClassType classTypeWithCls:[PGRecognizersState class]];
}

- (BOOL)processEvent:(id<PGEvent>)event {
    if([event phase] == PGEventPhase_on) {
        return [self onEvent:event];
    } else {
        if([event phase] == PGEventPhase_began) {
            return [self beganEvent:event];
        } else {
            if([event phase] == PGEventPhase_ended) {
                return [self endedEvent:event];
            } else {
                if([event phase] == PGEventPhase_changed) return [self changedEvent:event];
                else return [self canceledEvent:event];
            }
        }
    }
}

- (BOOL)onEvent:(id<PGEvent>)event {
    return [_recognizers onEvent:event] != nil;
}

- (BOOL)beganEvent:(id<PGEvent>)event {
    PGRecognizerType* tp = [event recognizerType];
    return [_longMap modifyKey:tp by:^PGLongRecognizer*(PGLongRecognizer* _) {
        return [_recognizers beganEvent:event];
    }] != nil;
}

- (BOOL)changedEvent:(id<PGEvent>)event {
    id __tmp;
    {
        PGLongRecognizer* rec = [_longMap applyKey:[event recognizerType]];
        if(rec != nil) {
            ((PGLongRecognizer*)(rec)).changed(event);
            __tmp = @YES;
        } else {
            __tmp = nil;
        }
    }
    if(__tmp != nil) return unumb(__tmp);
    else return NO;
}

- (BOOL)endedEvent:(id<PGEvent>)event {
    PGRecognizerType* tp = [event recognizerType];
    {
        void(^__nd)(id<PGEvent>) = ((PGLongRecognizer*)([_longMap applyKey:tp])).ended;
        if(__nd != nil) __nd(event);
    }
    return [_longMap removeKey:tp] != nil;
}

- (BOOL)canceledEvent:(id<PGEvent>)event {
    PGRecognizerType* tp = [event recognizerType];
    {
        void(^__nd)(id<PGEvent>) = ((PGLongRecognizer*)([_longMap applyKey:tp])).canceled;
        if(__nd != nil) __nd(event);
    }
    return [_longMap removeKey:tp] != nil;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"RecognizersState(%@)", _recognizers];
}

- (CNClassType*)type {
    return [PGRecognizersState type];
}

+ (CNClassType*)type {
    return _PGRecognizersState_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGRecognizerType
static CNClassType* _PGRecognizerType_type;

+ (instancetype)recognizerType {
    return [[PGRecognizerType alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGRecognizerType class]) _PGRecognizerType_type = [CNClassType classTypeWithCls:[PGRecognizerType class]];
}

- (NSString*)description {
    return @"RecognizerType";
}

- (CNClassType*)type {
    return [PGRecognizerType type];
}

+ (CNClassType*)type {
    return _PGRecognizerType_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGPan
static PGPan* _PGPan_leftMouse;
static PGPan* _PGPan_rightMouse;
static CNClassType* _PGPan_type;
@synthesize fingers = _fingers;

+ (instancetype)panWithFingers:(NSUInteger)fingers {
    return [[PGPan alloc] initWithFingers:fingers];
}

- (instancetype)initWithFingers:(NSUInteger)fingers {
    self = [super init];
    if(self) _fingers = fingers;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGPan class]) {
        _PGPan_type = [CNClassType classTypeWithCls:[PGPan class]];
        _PGPan_leftMouse = [PGPan panWithFingers:1];
        _PGPan_rightMouse = [PGPan panWithFingers:2];
    }
}

+ (PGPan*)apply {
    return _PGPan_leftMouse;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Pan(%lu)", (unsigned long)_fingers];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[PGPan class]])) return NO;
    PGPan* o = ((PGPan*)(to));
    return _fingers == o.fingers;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + _fingers;
    return hash;
}

- (CNClassType*)type {
    return [PGPan type];
}

+ (PGPan*)leftMouse {
    return _PGPan_leftMouse;
}

+ (PGPan*)rightMouse {
    return _PGPan_rightMouse;
}

+ (CNClassType*)type {
    return _PGPan_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGTap
static CNClassType* _PGTap_type;
@synthesize fingers = _fingers;
@synthesize taps = _taps;

+ (instancetype)tapWithFingers:(NSUInteger)fingers taps:(NSUInteger)taps {
    return [[PGTap alloc] initWithFingers:fingers taps:taps];
}

- (instancetype)initWithFingers:(NSUInteger)fingers taps:(NSUInteger)taps {
    self = [super init];
    if(self) {
        _fingers = fingers;
        _taps = taps;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGTap class]) _PGTap_type = [CNClassType classTypeWithCls:[PGTap class]];
}

+ (PGTap*)applyFingers:(NSUInteger)fingers {
    return [PGTap tapWithFingers:fingers taps:1];
}

+ (PGTap*)applyTaps:(NSUInteger)taps {
    return [PGTap tapWithFingers:1 taps:taps];
}

+ (PGTap*)apply {
    return [PGTap tapWithFingers:1 taps:1];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Tap(%lu, %lu)", (unsigned long)_fingers, (unsigned long)_taps];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[PGTap class]])) return NO;
    PGTap* o = ((PGTap*)(to));
    return _fingers == o.fingers && _taps == o.taps;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + _fingers;
    hash = hash * 31 + _taps;
    return hash;
}

- (CNClassType*)type {
    return [PGTap type];
}

+ (CNClassType*)type {
    return _PGTap_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGPinch
static CNClassType* _PGPinch_type;

+ (instancetype)pinch {
    return [[PGPinch alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGPinch class]) _PGPinch_type = [CNClassType classTypeWithCls:[PGPinch class]];
}

- (NSString*)description {
    return @"Pinch";
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[PGPinch class]])) return NO;
    return YES;
}

- (NSUInteger)hash {
    return 0;
}

- (CNClassType*)type {
    return [PGPinch type];
}

+ (CNClassType*)type {
    return _PGPinch_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGPinchParameter
static CNClassType* _PGPinchParameter_type;
@synthesize scale = _scale;
@synthesize velocity = _velocity;

+ (instancetype)pinchParameterWithScale:(CGFloat)scale velocity:(CGFloat)velocity {
    return [[PGPinchParameter alloc] initWithScale:scale velocity:velocity];
}

- (instancetype)initWithScale:(CGFloat)scale velocity:(CGFloat)velocity {
    self = [super init];
    if(self) {
        _scale = scale;
        _velocity = velocity;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGPinchParameter class]) _PGPinchParameter_type = [CNClassType classTypeWithCls:[PGPinchParameter class]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"PinchParameter(%f, %f)", _scale, _velocity];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[PGPinchParameter class]])) return NO;
    PGPinchParameter* o = ((PGPinchParameter*)(to));
    return eqf(_scale, o.scale) && eqf(_velocity, o.velocity);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + floatHash(_scale);
    hash = hash * 31 + floatHash(_velocity);
    return hash;
}

- (CNClassType*)type {
    return [PGPinchParameter type];
}

+ (CNClassType*)type {
    return _PGPinchParameter_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

PGEventPhase* PGEventPhase_Values[6];
PGEventPhase* PGEventPhase_began_Desc;
PGEventPhase* PGEventPhase_changed_Desc;
PGEventPhase* PGEventPhase_ended_Desc;
PGEventPhase* PGEventPhase_canceled_Desc;
PGEventPhase* PGEventPhase_on_Desc;
@implementation PGEventPhase

+ (instancetype)eventPhaseWithOrdinal:(NSUInteger)ordinal name:(NSString*)name {
    return [[PGEventPhase alloc] initWithOrdinal:ordinal name:name];
}

- (instancetype)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name {
    self = [super initWithOrdinal:ordinal name:name];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    PGEventPhase_began_Desc = [PGEventPhase eventPhaseWithOrdinal:0 name:@"began"];
    PGEventPhase_changed_Desc = [PGEventPhase eventPhaseWithOrdinal:1 name:@"changed"];
    PGEventPhase_ended_Desc = [PGEventPhase eventPhaseWithOrdinal:2 name:@"ended"];
    PGEventPhase_canceled_Desc = [PGEventPhase eventPhaseWithOrdinal:3 name:@"canceled"];
    PGEventPhase_on_Desc = [PGEventPhase eventPhaseWithOrdinal:4 name:@"on"];
    PGEventPhase_Values[0] = nil;
    PGEventPhase_Values[1] = PGEventPhase_began_Desc;
    PGEventPhase_Values[2] = PGEventPhase_changed_Desc;
    PGEventPhase_Values[3] = PGEventPhase_ended_Desc;
    PGEventPhase_Values[4] = PGEventPhase_canceled_Desc;
    PGEventPhase_Values[5] = PGEventPhase_on_Desc;
}

+ (NSArray*)values {
    return (@[PGEventPhase_began_Desc, PGEventPhase_changed_Desc, PGEventPhase_ended_Desc, PGEventPhase_canceled_Desc, PGEventPhase_on_Desc]);
}

+ (PGEventPhase*)value:(PGEventPhaseR)r {
    return PGEventPhase_Values[r];
}

@end

@implementation PGEvent_impl

+ (instancetype)event_impl {
    return [[PGEvent_impl alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

- (PGRecognizerType*)recognizerType {
    @throw @"Method recognizerType is abstract";
}

- (PGEventPhaseR)phase {
    @throw @"Method phase is abstract";
}

- (PGVec2)locationInView {
    @throw @"Method locationInView is abstract";
}

- (PGVec2)viewSize {
    @throw @"Method viewSize is abstract";
}

- (id)param {
    @throw @"Method param is abstract";
}

- (PGMatrixModel*)matrixModel {
    return PGMatrixModel.identity;
}

- (PGRect)viewport {
    return pgRectApplyXYWidthHeight(0.0, 0.0, 1.0, 1.0);
}

- (PGVec2)locationInViewport {
    return [self locationInView];
}

- (PGVec2)location {
    return [self locationInView];
}

- (PGVec2)locationForDepth:(CGFloat)depth {
    return [self locationInView];
}

- (PGLine3)segment {
    return PGLine3Make((pgVec3ApplyVec2Z([self locationInView], 0.0)), (PGVec3Make(0.0, 0.0, 1000.0)));
}

- (BOOL)checkViewport {
    return YES;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGViewEvent
static CNClassType* _PGViewEvent_type;
@synthesize recognizerType = _recognizerType;
@synthesize phase = _phase;
@synthesize locationInView = _locationInView;
@synthesize viewSize = _viewSize;
@synthesize param = _param;

+ (instancetype)viewEventWithRecognizerType:(PGRecognizerType*)recognizerType phase:(PGEventPhaseR)phase locationInView:(PGVec2)locationInView viewSize:(PGVec2)viewSize param:(id)param {
    return [[PGViewEvent alloc] initWithRecognizerType:recognizerType phase:phase locationInView:locationInView viewSize:viewSize param:param];
}

- (instancetype)initWithRecognizerType:(PGRecognizerType*)recognizerType phase:(PGEventPhaseR)phase locationInView:(PGVec2)locationInView viewSize:(PGVec2)viewSize param:(id)param {
    self = [super init];
    if(self) {
        _recognizerType = recognizerType;
        _phase = phase;
        _locationInView = locationInView;
        _viewSize = viewSize;
        _param = param;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGViewEvent class]) _PGViewEvent_type = [CNClassType classTypeWithCls:[PGViewEvent class]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"ViewEvent(%@, %@, %@, %@, %@)", _recognizerType, [PGEventPhase value:_phase], pgVec2Description(_locationInView), pgVec2Description(_viewSize), _param];
}

- (CNClassType*)type {
    return [PGViewEvent type];
}

+ (CNClassType*)type {
    return _PGViewEvent_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGCameraEvent
static CNClassType* _PGCameraEvent_type;
@synthesize event = _event;
@synthesize matrixModel = _matrixModel;
@synthesize viewport = _viewport;
@synthesize recognizerType = _recognizerType;
@synthesize locationInView = _locationInView;

+ (instancetype)cameraEventWithEvent:(id<PGEvent>)event matrixModel:(PGMatrixModel*)matrixModel viewport:(PGRect)viewport {
    return [[PGCameraEvent alloc] initWithEvent:event matrixModel:matrixModel viewport:viewport];
}

- (instancetype)initWithEvent:(id<PGEvent>)event matrixModel:(PGMatrixModel*)matrixModel viewport:(PGRect)viewport {
    self = [super init];
    __weak PGCameraEvent* _weakSelf = self;
    if(self) {
        _event = event;
        _matrixModel = matrixModel;
        _viewport = viewport;
        _recognizerType = [event recognizerType];
        _locationInView = [event locationInView];
        __lazy_segment = [CNLazy lazyWithF:^id() {
            PGCameraEvent* _self = _weakSelf;
            if(_self != nil) return wrap(PGLine3, (({
                PGVec2 loc = [_self locationInViewport];
                PGMat4* mat4 = [[matrixModel wcp] inverse];
                PGVec4 p0 = [mat4 mulVec4:PGVec4Make(loc.x, loc.y, -1.0, 1.0)];
                PGVec4 p1 = [mat4 mulVec4:PGVec4Make(loc.x, loc.y, 1.0, 1.0)];
                PGLine3Make(pgVec4Xyz(p0), (pgVec3SubVec3(pgVec4Xyz(p1), pgVec4Xyz(p0))));
            })));
            else return nil;
        }];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGCameraEvent class]) _PGCameraEvent_type = [CNClassType classTypeWithCls:[PGCameraEvent class]];
}

- (PGLine3)segment {
    return uwrap(PGLine3, [__lazy_segment get]);
}

- (PGEventPhaseR)phase {
    return [_event phase];
}

- (PGVec2)viewSize {
    return [_event viewSize];
}

- (id)param {
    return [_event param];
}

- (PGVec2)location {
    return [self locationForDepth:0.0];
}

- (PGVec2)locationInViewport {
    return pgVec2SubVec2((pgVec2MulI((pgVec2DivVec2((pgVec2SubVec2(_locationInView, _viewport.p)), _viewport.size)), 2)), (PGVec2Make(1.0, 1.0)));
}

- (PGVec2)locationForDepth:(CGFloat)depth {
    return pgVec3Xy((pgLine3RPlane([self segment], (PGPlaneMake((PGVec3Make(0.0, 0.0, ((float)(depth)))), (PGVec3Make(0.0, 0.0, 1.0)))))));
}

- (BOOL)checkViewport {
    return pgRectContainsVec2(_viewport, _locationInView);
}

- (NSString*)description {
    return [NSString stringWithFormat:@"CameraEvent(%@, %@, %@)", _event, _matrixModel, pgRectDescription(_viewport)];
}

- (CNClassType*)type {
    return [PGCameraEvent type];
}

+ (CNClassType*)type {
    return _PGCameraEvent_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

