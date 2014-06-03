#import "objd.h"
#import "PGVec.h"
#import "PGController.h"
#import "PGInput.h"
@class PGMatrixModel;
@protocol PGSoundPlayer;
@class CNObserver;
@class PGDirector;
@class CNReact;
@class CNFuture;
@class CNChain;
@class PGPlatform;
@class PGOS;
@class PGGlobal;
@class PGContext;
@class PGCullFace;
@class PGSceneRenderTarget;
@class PGMatrixStack;
@class PGEnvironment;
@class PGLight;
@class PGShadowRenderTarget;
@class PGShadowMap;
@class PGMMatrixModel;
@class PGMat4;

@class PGCamera_impl;
@class PGScene;
@class PGLayers;
@class PGSingleLayer;
@class PGLayer;
@class PGLayerView_impl;
@class PGSceneView_impl;
@protocol PGCamera;
@protocol PGLayerView;
@protocol PGSceneView;

@protocol PGCamera<NSObject>
- (NSUInteger)cullFace;
- (PGMatrixModel*)matrixModel;
- (CGFloat)viewportRatio;
- (NSString*)description;
@end


@interface PGCamera_impl : NSObject<PGCamera>
+ (instancetype)camera_impl;
- (instancetype)init;
@end


@interface PGScene : NSObject {
@protected
    PGVec4 _backgroundColor;
    id<PGController> _controller;
    PGLayers* _layers;
    id<PGSoundPlayer> _soundPlayer;
    CNObserver* _pauseObserve;
}
@property (nonatomic, readonly) PGVec4 backgroundColor;
@property (nonatomic, readonly) id<PGController> controller;
@property (nonatomic, readonly) PGLayers* layers;
@property (nonatomic, readonly) id<PGSoundPlayer> soundPlayer;

+ (instancetype)sceneWithBackgroundColor:(PGVec4)backgroundColor controller:(id<PGController>)controller layers:(PGLayers*)layers soundPlayer:(id<PGSoundPlayer>)soundPlayer;
- (instancetype)initWithBackgroundColor:(PGVec4)backgroundColor controller:(id<PGController>)controller layers:(PGLayers*)layers soundPlayer:(id<PGSoundPlayer>)soundPlayer;
- (CNClassType*)type;
+ (PGScene*)applySceneView:(id<PGSceneView>)sceneView;
- (void)prepareWithViewSize:(PGVec2)viewSize;
- (void)reshapeWithViewSize:(PGVec2)viewSize;
- (void)drawWithViewSize:(PGVec2)viewSize;
- (void)complete;
- (id<CNSet>)recognizersTypes;
- (BOOL)processEvent:(id<PGEvent>)event;
- (CNFuture*)updateWithDelta:(CGFloat)delta;
- (void)start;
- (void)stop;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGLayers : NSObject {
@protected
    NSArray* __viewports;
    NSArray* __viewportsRevers;
}
+ (instancetype)layers;
- (instancetype)init;
- (CNClassType*)type;
+ (PGSingleLayer*)applyLayer:(PGLayer*)layer;
- (NSArray*)layers;
- (NSArray*)viewportsWithViewSize:(PGVec2)viewSize;
- (void)prepare;
- (void)draw;
- (void)complete;
- (id<CNSet>)recognizersTypes;
- (BOOL)processEvent:(id<PGEvent>)event;
- (void)updateWithDelta:(CGFloat)delta;
- (void)reshapeWithViewSize:(PGVec2)viewSize;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGSingleLayer : PGLayers {
@protected
    PGLayer* _layer;
    NSArray* _layers;
}
@property (nonatomic, readonly) PGLayer* layer;
@property (nonatomic, readonly) NSArray* layers;

+ (instancetype)singleLayerWithLayer:(PGLayer*)layer;
- (instancetype)initWithLayer:(PGLayer*)layer;
- (CNClassType*)type;
- (NSArray*)viewportsWithViewSize:(PGVec2)viewSize;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGLayer : PGUpdatable_impl {
@protected
    id<PGLayerView> _view;
    id<PGInputProcessor> _inputProcessor;
    BOOL _iOS6;
    PGRecognizersState* _recognizerState;
}
@property (nonatomic, readonly) id<PGLayerView> view;
@property (nonatomic, readonly) id<PGInputProcessor> inputProcessor;

+ (instancetype)layerWithView:(id<PGLayerView>)view inputProcessor:(id<PGInputProcessor>)inputProcessor;
- (instancetype)initWithView:(id<PGLayerView>)view inputProcessor:(id<PGInputProcessor>)inputProcessor;
- (CNClassType*)type;
+ (PGLayer*)applyView:(id<PGLayerView>)view;
- (void)prepareWithViewport:(PGRect)viewport;
- (void)reshapeWithViewport:(PGRect)viewport;
- (void)drawWithViewport:(PGRect)viewport;
- (void)completeWithViewport:(PGRect)viewport;
- (void)drawShadowForCamera:(id<PGCamera>)camera light:(PGLight*)light;
- (BOOL)processEvent:(id<PGEvent>)event viewport:(PGRect)viewport;
- (void)updateWithDelta:(CGFloat)delta;
+ (PGRect)viewportWithViewSize:(PGVec2)viewSize viewportLayout:(PGRect)viewportLayout viewportRatio:(float)viewportRatio;
- (NSString*)description;
+ (CNClassType*)type;
@end


@protocol PGLayerView<PGUpdatable>
- (NSString*)name;
- (id<PGCamera>)camera;
- (void)prepare;
- (void)draw;
- (void)complete;
- (void)updateWithDelta:(CGFloat)delta;
- (PGEnvironment*)environment;
- (void)reshapeWithViewport:(PGRect)viewport;
- (PGRect)viewportWithViewSize:(PGVec2)viewSize;
- (NSString*)description;
@end


@interface PGLayerView_impl : PGUpdatable_impl<PGLayerView>
+ (instancetype)layerView_impl;
- (instancetype)init;
- (void)updateWithDelta:(CGFloat)delta;
@end


@protocol PGSceneView<PGLayerView, PGController, PGInputProcessor>
- (NSString*)description;
@end


@interface PGSceneView_impl : PGLayerView_impl<PGSceneView>
+ (instancetype)sceneView_impl;
- (instancetype)init;
@end


