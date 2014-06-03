#import "PGScene.h"

#import "GL.h"
#import "PGMatrixModel.h"
#import "PGSoundPlayer.h"
#import "CNObserver.h"
#import "PGDirector.h"
#import "CNReact.h"
#import "CNFuture.h"
#import "CNChain.h"
#import "PGPlatformPlat.h"
#import "PGPlatform.h"
#import "PGContext.h"
#import "PGShadow.h"
#import "PGMat4.h"
@implementation PGCamera_impl

+ (instancetype)camera_impl {
    return [[PGCamera_impl alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

- (NSUInteger)cullFace {
    return ((NSUInteger)(GL_NONE));
}

- (PGMatrixModel*)matrixModel {
    @throw @"Method matrixModel is abstract";
}

- (CGFloat)viewportRatio {
    @throw @"Method viewportRatio is abstract";
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGScene
static CNClassType* _PGScene_type;
@synthesize backgroundColor = _backgroundColor;
@synthesize controller = _controller;
@synthesize layers = _layers;
@synthesize soundPlayer = _soundPlayer;

+ (instancetype)sceneWithBackgroundColor:(PGVec4)backgroundColor controller:(id<PGController>)controller layers:(PGLayers*)layers soundPlayer:(id<PGSoundPlayer>)soundPlayer {
    return [[PGScene alloc] initWithBackgroundColor:backgroundColor controller:controller layers:layers soundPlayer:soundPlayer];
}

- (instancetype)initWithBackgroundColor:(PGVec4)backgroundColor controller:(id<PGController>)controller layers:(PGLayers*)layers soundPlayer:(id<PGSoundPlayer>)soundPlayer {
    self = [super init];
    if(self) {
        _backgroundColor = backgroundColor;
        _controller = controller;
        _layers = layers;
        _soundPlayer = soundPlayer;
        _pauseObserve = [[PGDirector current].isPaused observeF:^void(id p) {
            if(unumb(p)) [((id<PGSoundPlayer>)(soundPlayer)) pause];
            else [((id<PGSoundPlayer>)(soundPlayer)) resume];
        }];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGScene class]) _PGScene_type = [CNClassType classTypeWithCls:[PGScene class]];
}

+ (PGScene*)applySceneView:(id<PGSceneView>)sceneView {
    return [PGScene sceneWithBackgroundColor:PGVec4Make(1.0, 1.0, 1.0, 1.0) controller:sceneView layers:[PGLayers applyLayer:[PGLayer layerWithView:sceneView inputProcessor:sceneView]] soundPlayer:nil];
}

- (void)prepareWithViewSize:(PGVec2)viewSize {
    [_layers prepare];
}

- (void)reshapeWithViewSize:(PGVec2)viewSize {
    [_layers reshapeWithViewSize:viewSize];
}

- (void)drawWithViewSize:(PGVec2)viewSize {
    [_layers draw];
}

- (void)complete {
    [_layers complete];
}

- (id<CNSet>)recognizersTypes {
    return [_layers recognizersTypes];
}

- (BOOL)processEvent:(id<PGEvent>)event {
    return [_layers processEvent:event];
}

- (CNFuture*)updateWithDelta:(CGFloat)delta {
    return [CNFuture applyF:^id() {
        [_controller updateWithDelta:delta];
        [_layers updateWithDelta:delta];
        [((id<PGSoundPlayer>)(_soundPlayer)) updateWithDelta:delta];
        return nil;
    }];
}

- (void)start {
    [((id<PGSoundPlayer>)(_soundPlayer)) start];
    [_controller start];
}

- (void)stop {
    [((id<PGSoundPlayer>)(_soundPlayer)) stop];
    [_controller stop];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Scene(%@, %@, %@, %@)", pgVec4Description(_backgroundColor), _controller, _layers, _soundPlayer];
}

- (CNClassType*)type {
    return [PGScene type];
}

+ (CNClassType*)type {
    return _PGScene_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGLayers
static CNClassType* _PGLayers_type;

+ (instancetype)layers {
    return [[PGLayers alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) {
        __viewports = ((NSArray*)((@[])));
        __viewportsRevers = ((NSArray*)((@[])));
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGLayers class]) _PGLayers_type = [CNClassType classTypeWithCls:[PGLayers class]];
}

+ (PGSingleLayer*)applyLayer:(PGLayer*)layer {
    return [PGSingleLayer singleLayerWithLayer:layer];
}

- (NSArray*)layers {
    @throw @"Method layers is abstract";
}

- (NSArray*)viewportsWithViewSize:(PGVec2)viewSize {
    @throw @"Method viewportsWith is abstract";
}

- (void)prepare {
    for(CNTuple* p in __viewports) {
        [((PGLayer*)(((CNTuple*)(p)).a)) prepareWithViewport:uwrap(PGRect, ((CNTuple*)(p)).b)];
    }
}

- (void)draw {
    for(CNTuple* p in __viewports) {
        [((PGLayer*)(((CNTuple*)(p)).a)) drawWithViewport:uwrap(PGRect, ((CNTuple*)(p)).b)];
    }
}

- (void)complete {
    for(CNTuple* p in __viewports) {
        [((PGLayer*)(((CNTuple*)(p)).a)) completeWithViewport:uwrap(PGRect, ((CNTuple*)(p)).b)];
    }
}

- (id<CNSet>)recognizersTypes {
    return [[[[[[self layers] chain] mapOptF:^id<PGInputProcessor>(PGLayer* _) {
        return ((PGLayer*)(_)).inputProcessor;
    }] flatMapF:^NSArray*(id<PGInputProcessor> _) {
        return [((id<PGInputProcessor>)(_)) recognizers].items;
    }] mapF:^PGRecognizerType*(PGRecognizer* _) {
        return ((PGRecognizer*)(_)).tp;
    }] toSet];
}

- (BOOL)processEvent:(id<PGEvent>)event {
    __block BOOL r = NO;
    for(CNTuple* p in __viewportsRevers) {
        r = r || [((PGLayer*)(((CNTuple*)(p)).a)) processEvent:event viewport:uwrap(PGRect, ((CNTuple*)(p)).b)];
    }
    return r;
}

- (void)updateWithDelta:(CGFloat)delta {
    for(PGLayer* _ in [self layers]) {
        [((PGLayer*)(_)) updateWithDelta:delta];
    }
}

- (void)reshapeWithViewSize:(PGVec2)viewSize {
    __viewports = [self viewportsWithViewSize:viewSize];
    __viewportsRevers = [[[__viewports chain] reverse] toArray];
    for(CNTuple* p in __viewports) {
        [((PGLayer*)(((CNTuple*)(p)).a)) reshapeWithViewport:uwrap(PGRect, ((CNTuple*)(p)).b)];
    }
}

- (NSString*)description {
    return @"Layers";
}

- (CNClassType*)type {
    return [PGLayers type];
}

+ (CNClassType*)type {
    return _PGLayers_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGSingleLayer
static CNClassType* _PGSingleLayer_type;
@synthesize layer = _layer;
@synthesize layers = _layers;

+ (instancetype)singleLayerWithLayer:(PGLayer*)layer {
    return [[PGSingleLayer alloc] initWithLayer:layer];
}

- (instancetype)initWithLayer:(PGLayer*)layer {
    self = [super init];
    if(self) {
        _layer = layer;
        _layers = (@[layer]);
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGSingleLayer class]) _PGSingleLayer_type = [CNClassType classTypeWithCls:[PGSingleLayer class]];
}

- (NSArray*)viewportsWithViewSize:(PGVec2)viewSize {
    return (@[tuple(_layer, (wrap(PGRect, [_layer.view viewportWithViewSize:viewSize])))]);
}

- (NSString*)description {
    return [NSString stringWithFormat:@"SingleLayer(%@)", _layer];
}

- (CNClassType*)type {
    return [PGSingleLayer type];
}

+ (CNClassType*)type {
    return _PGSingleLayer_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGLayer
static CNClassType* _PGLayer_type;
@synthesize view = _view;
@synthesize inputProcessor = _inputProcessor;

+ (instancetype)layerWithView:(id<PGLayerView>)view inputProcessor:(id<PGInputProcessor>)inputProcessor {
    return [[PGLayer alloc] initWithView:view inputProcessor:inputProcessor];
}

- (instancetype)initWithView:(id<PGLayerView>)view inputProcessor:(id<PGInputProcessor>)inputProcessor {
    self = [super init];
    if(self) {
        _view = view;
        _inputProcessor = inputProcessor;
        _iOS6 = [egPlatform().os isIOSLessVersion:@"7"];
        _recognizerState = [PGRecognizersState recognizersStateWithRecognizers:((inputProcessor != nil) ? [((id<PGInputProcessor>)(nonnil(inputProcessor))) recognizers] : [PGRecognizers recognizersWithItems:((NSArray*)((@[])))])];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGLayer class]) _PGLayer_type = [CNClassType classTypeWithCls:[PGLayer class]];
}

+ (PGLayer*)applyView:(id<PGLayerView>)view {
    return [PGLayer layerWithView:view inputProcessor:[CNObject asKindOfProtocol:@protocol(PGInputProcessor) object:view]];
}

- (void)prepareWithViewport:(PGRect)viewport {
    egPushGroupMarker(([NSString stringWithFormat:@"Prepare %@", [_view name]]));
    PGEnvironment* env = [_view environment];
    PGGlobal.context.environment = env;
    id<PGCamera> camera = [_view camera];
    NSUInteger cullFace = [camera cullFace];
    [PGGlobal.context.cullFace setValue:((unsigned int)(cullFace))];
    PGGlobal.context.renderTarget = [PGSceneRenderTarget sceneRenderTarget];
    [PGGlobal.context setViewport:pgRectIApplyRect(viewport)];
    [PGGlobal.matrix setValue:[camera matrixModel]];
    [_view prepare];
    egPopGroupMarker();
    if(egPlatform().shadows) {
        for(PGLight* light in env.lights) {
            if(((PGLight*)(light)).hasShadows) {
                egPushGroupMarker(([NSString stringWithFormat:@"Shadow %@", [_view name]]));
                {
                    PGCullFace* __tmp__il__11t_0rt_1self = PGGlobal.context.cullFace;
                    {
                        unsigned int __il__11t_0rt_1oldValue = [__tmp__il__11t_0rt_1self invert];
                        [self drawShadowForCamera:camera light:light];
                        if(__il__11t_0rt_1oldValue != GL_NONE) [__tmp__il__11t_0rt_1self setValue:__il__11t_0rt_1oldValue];
                    }
                }
                egPopGroupMarker();
            }
        }
        if(_iOS6) glFinish();
    }
    egCheckError();
}

- (void)reshapeWithViewport:(PGRect)viewport {
    [PGGlobal.context setViewport:pgRectIApplyRect(viewport)];
    [_view reshapeWithViewport:viewport];
}

- (void)drawWithViewport:(PGRect)viewport {
    egPushGroupMarker([_view name]);
    PGEnvironment* env = [_view environment];
    PGGlobal.context.environment = env;
    id<PGCamera> camera = [_view camera];
    [PGGlobal.context.cullFace setValue:((unsigned int)([camera cullFace]))];
    PGGlobal.context.renderTarget = [PGSceneRenderTarget sceneRenderTarget];
    [PGGlobal.context setViewport:pgRectIApplyRect(viewport)];
    [PGGlobal.matrix setValue:[camera matrixModel]];
    [_view draw];
    egCheckError();
    egPopGroupMarker();
}

- (void)completeWithViewport:(PGRect)viewport {
    [_view complete];
}

- (void)drawShadowForCamera:(id<PGCamera>)camera light:(PGLight*)light {
    PGGlobal.context.renderTarget = [PGShadowRenderTarget shadowRenderTargetWithShadowLight:light];
    [PGGlobal.matrix setValue:[light shadowMatrixModel:[camera matrixModel]]];
    [light shadowMap].biasDepthCp = [PGShadowMap.biasMatrix mulMatrix:[[PGGlobal.matrix value] cp]];
    if(PGGlobal.context.redrawShadows) {
        PGShadowMap* __tmp__il__3t_0self = [light shadowMap];
        {
            [__tmp__il__3t_0self bind];
            {
                glClear(GL_DEPTH_BUFFER_BIT);
                [_view draw];
            }
            [__tmp__il__3t_0self unbind];
        }
    }
    egCheckError();
}

- (BOOL)processEvent:(id<PGEvent>)event viewport:(PGRect)viewport {
    if(((_inputProcessor != nil) ? [((id<PGInputProcessor>)(nonnil(_inputProcessor))) isProcessorActive] : NO)) {
        id<PGCamera> camera = [_view camera];
        [PGGlobal.matrix setValue:[camera matrixModel]];
        return [_recognizerState processEvent:[PGCameraEvent cameraEventWithEvent:event matrixModel:[camera matrixModel] viewport:viewport]];
    } else {
        return NO;
    }
}

- (void)updateWithDelta:(CGFloat)delta {
    [_view updateWithDelta:delta];
}

+ (PGRect)viewportWithViewSize:(PGVec2)viewSize viewportLayout:(PGRect)viewportLayout viewportRatio:(float)viewportRatio {
    PGVec2 size = pgVec2MulVec2(viewSize, viewportLayout.size);
    PGVec2 vpSize = ((eqf4(size.x, 0) && eqf4(size.y, 0)) ? PGVec2Make(viewSize.x, viewSize.y) : ((eqf4(size.x, 0)) ? PGVec2Make(viewSize.x, size.y) : ((eqf4(size.y, 0)) ? PGVec2Make(size.x, viewSize.y) : ((size.x / size.y < viewportRatio) ? PGVec2Make(size.x, size.x / viewportRatio) : PGVec2Make(size.y * viewportRatio, size.y)))));
    PGVec2 po = pgVec2AddF((pgVec2DivI(viewportLayout.p, 2)), 0.5);
    return PGRectMake((pgVec2MulVec2((pgVec2SubVec2(viewSize, vpSize)), po)), vpSize);
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Layer(%@, %@)", _view, _inputProcessor];
}

- (CNClassType*)type {
    return [PGLayer type];
}

+ (CNClassType*)type {
    return _PGLayer_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGLayerView_impl

+ (instancetype)layerView_impl {
    return [[PGLayerView_impl alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

- (void)updateWithDelta:(CGFloat)delta {
}

- (NSString*)name {
    @throw @"Method name is abstract";
}

- (id<PGCamera>)camera {
    @throw @"Method camera is abstract";
}

- (void)prepare {
}

- (void)draw {
    @throw @"Method draw is abstract";
}

- (void)complete {
}

- (PGEnvironment*)environment {
    return PGEnvironment.aDefault;
}

- (void)reshapeWithViewport:(PGRect)viewport {
}

- (PGRect)viewportWithViewSize:(PGVec2)viewSize {
    return [PGLayer viewportWithViewSize:viewSize viewportLayout:pgRectApplyXYWidthHeight(0.0, 0.0, 1.0, 1.0) viewportRatio:((float)([[self camera] viewportRatio]))];
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGSceneView_impl

+ (instancetype)sceneView_impl {
    return [[PGSceneView_impl alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

- (NSString*)name {
    @throw @"Method name is abstract";
}

- (id<PGCamera>)camera {
    @throw @"Method camera is abstract";
}

- (void)draw {
    @throw @"Method draw is abstract";
}

- (void)start {
}

- (void)stop {
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

