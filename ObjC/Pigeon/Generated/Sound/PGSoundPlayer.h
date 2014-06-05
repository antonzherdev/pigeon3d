#import "objd.h"
#import "PGController.h"
@class PGSimpleSound;
@class PGSound;
@protocol CNObservableBase;
@class CNObserver;

@class PGSoundPlayer_impl;
@class PGBackgroundSoundPlayer;
@class PGSoundPlayersCollection;
@class PGSporadicSoundPlayer;
@class PGSignalSoundPlayer;
@protocol PGSoundPlayer;

@protocol PGSoundPlayer<PGUpdatable>
- (void)start;
- (void)stop;
- (void)pause;
- (void)resume;
- (void)updateWithDelta:(CGFloat)delta;
- (NSString*)description;
@end


@interface PGSoundPlayer_impl : PGUpdatable_impl<PGSoundPlayer>
+ (instancetype)soundPlayer_impl;
- (instancetype)init;
- (void)updateWithDelta:(CGFloat)delta;
@end


@interface PGBackgroundSoundPlayer : PGSoundPlayer_impl {
@public
    PGSimpleSound* _sound;
}
@property (nonatomic, readonly) PGSimpleSound* sound;

+ (instancetype)backgroundSoundPlayerWithSound:(PGSimpleSound*)sound;
- (instancetype)initWithSound:(PGSimpleSound*)sound;
- (CNClassType*)type;
- (void)start;
- (void)stop;
- (void)pause;
- (void)resume;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGSoundPlayersCollection : PGSoundPlayer_impl {
@public
    NSArray* _players;
}
@property (nonatomic, readonly) NSArray* players;

+ (instancetype)soundPlayersCollectionWithPlayers:(NSArray*)players;
- (instancetype)initWithPlayers:(NSArray*)players;
- (CNClassType*)type;
- (void)start;
- (void)stop;
- (void)pause;
- (void)resume;
- (void)updateWithDelta:(CGFloat)delta;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGSporadicSoundPlayer : PGSoundPlayer_impl {
@public
    PGSound* _sound;
    CGFloat _secondsBetween;
    CGFloat __timeToNextPlaying;
    BOOL _wasPlaying;
}
@property (nonatomic, readonly) PGSound* sound;
@property (nonatomic, readonly) CGFloat secondsBetween;

+ (instancetype)sporadicSoundPlayerWithSound:(PGSound*)sound secondsBetween:(CGFloat)secondsBetween;
- (instancetype)initWithSound:(PGSound*)sound secondsBetween:(CGFloat)secondsBetween;
- (CNClassType*)type;
- (void)start;
- (void)stop;
- (void)pause;
- (void)resume;
- (void)updateWithDelta:(CGFloat)delta;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGSignalSoundPlayer : PGSoundPlayer_impl {
@public
    PGSound* _sound;
    id<CNObservableBase> _signal;
    BOOL(^_condition)(id);
    CNObserver* _obs;
}
@property (nonatomic, readonly) PGSound* sound;
@property (nonatomic, readonly) id<CNObservableBase> signal;
@property (nonatomic, readonly) BOOL(^condition)(id);

+ (instancetype)signalSoundPlayerWithSound:(PGSound*)sound signal:(id<CNObservableBase>)signal condition:(BOOL(^)(id))condition;
- (instancetype)initWithSound:(PGSound*)sound signal:(id<CNObservableBase>)signal condition:(BOOL(^)(id))condition;
- (CNClassType*)type;
- (void)start;
- (void)stop;
- (void)pause;
- (void)resume;
+ (PGSignalSoundPlayer*)applySound:(PGSound*)sound signal:(id<CNObservableBase>)signal;
- (NSString*)description;
+ (CNClassType*)type;
@end


