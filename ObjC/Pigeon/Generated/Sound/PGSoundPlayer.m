#import "PGSoundPlayer.h"

#import "PGSound.h"
#import "CNObserver.h"
@implementation PGSoundPlayer_impl

+ (instancetype)soundPlayer_impl {
    return [[PGSoundPlayer_impl alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

- (void)updateWithDelta:(CGFloat)delta {
}

- (void)start {
}

- (void)stop {
}

- (void)pause {
}

- (void)resume {
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGBackgroundSoundPlayer
static CNClassType* _PGBackgroundSoundPlayer_type;
@synthesize sound = _sound;

+ (instancetype)backgroundSoundPlayerWithSound:(PGSimpleSound*)sound {
    return [[PGBackgroundSoundPlayer alloc] initWithSound:sound];
}

- (instancetype)initWithSound:(PGSimpleSound*)sound {
    self = [super init];
    if(self) _sound = sound;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGBackgroundSoundPlayer class]) _PGBackgroundSoundPlayer_type = [CNClassType classTypeWithCls:[PGBackgroundSoundPlayer class]];
}

- (void)start {
    [_sound playAlways];
}

- (void)stop {
    [_sound stop];
}

- (void)pause {
    [_sound pause];
}

- (void)resume {
    [_sound resume];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"BackgroundSoundPlayer(%@)", _sound];
}

- (CNClassType*)type {
    return [PGBackgroundSoundPlayer type];
}

+ (CNClassType*)type {
    return _PGBackgroundSoundPlayer_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGSoundPlayersCollection
static CNClassType* _PGSoundPlayersCollection_type;
@synthesize players = _players;

+ (instancetype)soundPlayersCollectionWithPlayers:(NSArray*)players {
    return [[PGSoundPlayersCollection alloc] initWithPlayers:players];
}

- (instancetype)initWithPlayers:(NSArray*)players {
    self = [super init];
    if(self) _players = players;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGSoundPlayersCollection class]) _PGSoundPlayersCollection_type = [CNClassType classTypeWithCls:[PGSoundPlayersCollection class]];
}

- (void)start {
    for(id<PGSoundPlayer> _ in _players) {
        [((id<PGSoundPlayer>)(_)) start];
    }
}

- (void)stop {
    for(id<PGSoundPlayer> _ in _players) {
        [((id<PGSoundPlayer>)(_)) stop];
    }
}

- (void)pause {
    for(id<PGSoundPlayer> _ in _players) {
        [((id<PGSoundPlayer>)(_)) pause];
    }
}

- (void)resume {
    for(id<PGSoundPlayer> _ in _players) {
        [((id<PGSoundPlayer>)(_)) resume];
    }
}

- (void)updateWithDelta:(CGFloat)delta {
    for(id<PGSoundPlayer> _ in _players) {
        [((id<PGSoundPlayer>)(_)) updateWithDelta:delta];
    }
}

- (NSString*)description {
    return [NSString stringWithFormat:@"SoundPlayersCollection(%@)", _players];
}

- (CNClassType*)type {
    return [PGSoundPlayersCollection type];
}

+ (CNClassType*)type {
    return _PGSoundPlayersCollection_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGSporadicSoundPlayer
static CNClassType* _PGSporadicSoundPlayer_type;
@synthesize sound = _sound;
@synthesize secondsBetween = _secondsBetween;

+ (instancetype)sporadicSoundPlayerWithSound:(PGSound*)sound secondsBetween:(CGFloat)secondsBetween {
    return [[PGSporadicSoundPlayer alloc] initWithSound:sound secondsBetween:secondsBetween];
}

- (instancetype)initWithSound:(PGSound*)sound secondsBetween:(CGFloat)secondsBetween {
    self = [super init];
    if(self) {
        _sound = sound;
        _secondsBetween = secondsBetween;
        __timeToNextPlaying = 0.0;
        _wasPlaying = NO;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGSporadicSoundPlayer class]) _PGSporadicSoundPlayer_type = [CNClassType classTypeWithCls:[PGSporadicSoundPlayer class]];
}

- (void)start {
    __timeToNextPlaying = cnFloatRndMinMax(0.0, _secondsBetween * 2);
}

- (void)stop {
    [_sound stop];
}

- (void)pause {
    [_sound pause];
}

- (void)resume {
    [_sound resume];
}

- (void)updateWithDelta:(CGFloat)delta {
    if(!([_sound isPlaying])) {
        __timeToNextPlaying -= delta;
        if(__timeToNextPlaying <= 0) {
            [_sound play];
            __timeToNextPlaying = cnFloatRndMinMax(0.0, _secondsBetween * 2);
        }
    }
}

- (NSString*)description {
    return [NSString stringWithFormat:@"SporadicSoundPlayer(%@, %f)", _sound, _secondsBetween];
}

- (CNClassType*)type {
    return [PGSporadicSoundPlayer type];
}

+ (CNClassType*)type {
    return _PGSporadicSoundPlayer_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGSignalSoundPlayer
static CNClassType* _PGSignalSoundPlayer_type;
@synthesize sound = _sound;
@synthesize signal = _signal;
@synthesize condition = _condition;

+ (instancetype)signalSoundPlayerWithSound:(PGSound*)sound signal:(id<CNObservableBase>)signal condition:(BOOL(^)(id))condition {
    return [[PGSignalSoundPlayer alloc] initWithSound:sound signal:signal condition:condition];
}

- (instancetype)initWithSound:(PGSound*)sound signal:(id<CNObservableBase>)signal condition:(BOOL(^)(id))condition {
    self = [super init];
    if(self) {
        _sound = sound;
        _signal = signal;
        _condition = [condition copy];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGSignalSoundPlayer class]) _PGSignalSoundPlayer_type = [CNClassType classTypeWithCls:[PGSignalSoundPlayer class]];
}

- (void)start {
    __weak PGSignalSoundPlayer* _weakSelf = self;
    _obs = [_signal observeF:^void(id data) {
        PGSignalSoundPlayer* _self = _weakSelf;
        if(_self != nil) {
            if(_self->_condition(data)) [_self->_sound play];
        }
    }];
}

- (void)stop {
    [((CNObserver*)(_obs)) detach];
    _obs = nil;
    [_sound stop];
}

- (void)pause {
    [_sound pause];
}

- (void)resume {
    [_sound resume];
}

+ (PGSignalSoundPlayer*)applySound:(PGSound*)sound signal:(id<CNObservableBase>)signal {
    return [PGSignalSoundPlayer signalSoundPlayerWithSound:sound signal:signal condition:^BOOL(id _) {
        return YES;
    }];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"SignalSoundPlayer(%@, %@)", _sound, _signal];
}

- (CNClassType*)type {
    return [PGSignalSoundPlayer type];
}

+ (CNClassType*)type {
    return _PGSignalSoundPlayer_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

