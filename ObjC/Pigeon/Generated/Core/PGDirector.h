#import "objd.h"
#import "PGVec.h"
@class PGScene;
@class CNVar;
@class CNReact;
@class PGTime;
@class CNFuture;
@class PGStat;
@class CNConcurrentQueue;
@class PGRecognizerType;
@class PGGlobal;
@class PGContext;
@class PGEnablingState;
@protocol PGEvent;
@class PGSoundDirector;

@class PGDirector;

@interface PGDirector : NSObject {
@public
    PGScene* __scene;
    BOOL __isStarted;
    CNVar* __isPaused;
    CNReact* _isPaused;
    PGScene*(^__lazyScene)();
    PGTime* _time;
    PGVec2 __lastViewSize;
    CGFloat __timeSpeed;
    CNFuture* __updateFuture;
    PGStat* __stat;
    CNConcurrentQueue* __defers;
}
@property (nonatomic, readonly) CNReact* isPaused;
@property (nonatomic, readonly) PGTime* time;

+ (instancetype)director;
- (instancetype)init;
- (CNClassType*)type;
+ (PGDirector*)current;
- (PGScene*)scene;
- (void)setScene:(PGScene*(^)())scene;
- (void)clearRecognizers;
- (void)registerRecognizerType:(PGRecognizerType*)recognizerType;
- (CGFloat)scale;
- (void)lock;
- (void)unlock;
- (void)redraw;
- (void)_init;
- (PGVec2)viewSize;
- (void)reshapeWithSize:(PGVec2)size;
- (void)drawFrame;
- (void)processFrame;
- (void)prepare;
- (void)draw;
- (void)complete;
- (void)processEvent:(id<PGEvent>)event;
- (BOOL)isStarted;
- (void)start;
- (void)stop;
- (void)pause;
- (void)becomeActive;
- (void)resignActive;
- (void)resume;
- (CGFloat)timeSpeed;
- (void)setTimeSpeed:(CGFloat)timeSpeed;
- (void)tick;
- (PGStat*)stat;
- (BOOL)isDisplayingStats;
- (void)displayStats;
- (void)cancelDisplayingStats;
- (void)onGLThreadF:(void(^)())f;
- (NSString*)description;
+ (CNClassType*)type;
@end


