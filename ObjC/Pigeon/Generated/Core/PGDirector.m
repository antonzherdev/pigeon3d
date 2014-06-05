#import "PGDirector.h"

#import "PGScene.h"
#import "CNReact.h"
#import "PGTime.h"
#import "CNFuture.h"
#import "PGStat.h"
#import "CNConcurrentQueue.h"
#import "PGInput.h"
#import "PGContext.h"
#import "GL.h"
#import "PGSoundDirector.h"
@implementation PGDirector
static PGDirector* _PGDirector__current;
static CNClassType* _PGDirector_type;
@synthesize isPaused = _isPaused;
@synthesize time = _time;

+ (instancetype)director {
    return [[PGDirector alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) {
        __scene = nil;
        __isStarted = NO;
        __isPaused = [CNVar applyInitial:@NO];
        _isPaused = __isPaused;
        __lazyScene = nil;
        _time = [PGTime time];
        __lastViewSize = PGVec2Make(0.0, 0.0);
        __timeSpeed = 1.0;
        __updateFuture = [CNFuture successfulResult:nil];
        __stat = nil;
        __defers = [CNConcurrentQueue concurrentQueue];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGDirector class]) _PGDirector_type = [CNClassType classTypeWithCls:[PGDirector class]];
}

+ (PGDirector*)current {
    return ((PGDirector*)(nonnil(_PGDirector__current)));
}

- (PGScene*)scene {
    return __scene;
}

- (void)setScene:(PGScene*(^)())scene {
    __lazyScene = scene;
    {
        PGScene* sc = __scene;
        if(sc != nil) {
            [((PGScene*)(sc)) stop];
            __scene = nil;
            [self clearRecognizers];
        }
    }
    if(unumb([__isPaused value])) [self redraw];
}

- (void)maybeNewScene {
    PGScene*(^f)() = __lazyScene;
    if(f != nil) {
        PGScene* sc = f();
        __lazyScene = nil;
        __scene = sc;
        if(!(pgVec2IsEqualTo(__lastViewSize, (PGVec2Make(0.0, 0.0))))) [sc reshapeWithViewSize:__lastViewSize];
        {
            id<CNIterator> __il__0_4i = [[sc recognizersTypes] iterator];
            while([__il__0_4i hasNext]) {
                PGRecognizerType* _ = [__il__0_4i next];
                [self registerRecognizerType:_];
            }
        }
        [sc start];
    }
}

- (void)clearRecognizers {
    @throw @"Method clearRecognizers is abstract";
}

- (void)registerRecognizerType:(PGRecognizerType*)recognizerType {
    @throw @"Method register is abstract";
}

- (CGFloat)scale {
    @throw @"Method scale is abstract";
}

- (void)lock {
    @throw @"Method lock is abstract";
}

- (void)unlock {
    @throw @"Method unlock is abstract";
}

- (void)redraw {
    @throw @"Method redraw is abstract";
}

- (void)_init {
    _PGDirector__current = self;
}

- (PGVec2)viewSize {
    return __lastViewSize;
}

- (void)reshapeWithSize:(PGVec2)size {
    if(!(pgVec2IsEqualTo(__lastViewSize, size))) {
        autoreleasePoolStart();
        [[PGGlobal context]->_viewSize setValue:wrap(PGVec2i, pgVec2iApplyVec2(size))];
        __lastViewSize = size;
        [((PGScene*)(__scene)) reshapeWithViewSize:size];
        autoreleasePoolEnd();
    }
}

- (void)drawFrame {
    autoreleasePoolStart();
    [self prepare];
    [self draw];
    [self complete];
    autoreleasePoolEnd();
}

- (void)processFrame {
    autoreleasePoolStart();
    [self prepare];
    [self draw];
    [self complete];
    [self tick];
    autoreleasePoolEnd();
}

- (void)prepare {
    [__updateFuture waitResultPeriod:1.0];
    [self executeDefers];
    if(__lastViewSize.x <= 0 || __lastViewSize.y <= 0) return ;
    [self maybeNewScene];
    {
        PGScene* sc = __scene;
        if(sc != nil) {
            egPushGroupMarker(@"Prepare");
            _PGDirector__current = self;
            [[PGGlobal context] clear];
            [[PGGlobal context]->_depthTest enable];
            [((PGScene*)(sc)) prepareWithViewSize:__lastViewSize];
            egCheckError();
            egPopGroupMarker();
        }
    }
}

- (void)draw {
    if(__lastViewSize.x <= 0 || __lastViewSize.y <= 0) return ;
    {
        PGScene* sc = __scene;
        if(sc != nil) {
            egPushGroupMarker(@"Draw");
            [[PGGlobal context] clear];
            [[PGGlobal context]->_depthTest enable];
            [[PGGlobal context] clearColorColor:((PGScene*)(sc))->_backgroundColor];
            [[PGGlobal context] setViewport:pgRectIApplyRect((PGRectMake((PGVec2Make(0.0, 0.0)), __lastViewSize)))];
            glClear(GL_COLOR_BUFFER_BIT + GL_DEPTH_BUFFER_BIT);
            [((PGScene*)(sc)) drawWithViewSize:__lastViewSize];
            {
                PGStat* stat = __stat;
                if(stat != nil) {
                    [[PGGlobal context]->_depthTest disable];
                    [((PGStat*)(stat)) draw];
                }
            }
            egCheckError();
            egPopGroupMarker();
        }
    }
}

- (void)complete {
    egPushGroupMarker(@"Complete");
    [((PGScene*)(__scene)) complete];
    egCheckError();
    egPopGroupMarker();
}

- (void)processEvent:(id<PGEvent>)event {
    numb([((PGScene*)(__scene)) processEvent:event]);
}

- (BOOL)isStarted {
    return __isStarted;
}

- (void)start {
    __isStarted = YES;
    [_time start];
}

- (void)stop {
    __isStarted = NO;
}

- (void)pause {
    [__isPaused setValue:@YES];
    [self redraw];
}

- (void)becomeActive {
}

- (void)resignActive {
    [__isPaused setValue:@YES];
}

- (void)resume {
    if(unumb([__isPaused value])) {
        [_time start];
        [__isPaused setValue:@NO];
    }
}

- (CGFloat)timeSpeed {
    return __timeSpeed;
}

- (void)setTimeSpeed:(CGFloat)timeSpeed {
    if(!(eqf(__timeSpeed, timeSpeed))) {
        __timeSpeed = timeSpeed;
        [[PGSoundDirector instance] setTimeSpeed:__timeSpeed];
    }
}

- (void)tick {
    _PGDirector__current = self;
    [_time tick];
    CGFloat dt = _time.delta * __timeSpeed;
    {
        PGScene* _ = __scene;
        if(_ != nil) [((PGScene*)(_)) updateWithDelta:dt];
    }
    [((PGStat*)(__stat)) tickWithDelta:_time.delta];
}

- (PGStat*)stat {
    return __stat;
}

- (BOOL)isDisplayingStats {
    return __stat != nil;
}

- (void)displayStats {
    __stat = [PGStat stat];
}

- (void)cancelDisplayingStats {
    __stat = nil;
}

- (void)onGLThreadF:(void(^)())f {
    [__defers enqueueItem:f];
}

- (void)executeDefers {
    while(YES) {
        void(^f)() = [__defers dequeue];
        if(f == nil) break;
        void(^ff)() = ((void(^)())(nonnil(f)));
        ff();
    }
}

- (NSString*)description {
    return @"Director";
}

- (CNClassType*)type {
    return [PGDirector type];
}

+ (CNClassType*)type {
    return _PGDirector_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

