#import <GameKit/GameKit.h>
#import "PGGameCenterPlat.h"
#import "PGDirector.h"
#import "PGGameCenter.h"

@implementation PGGameCenter {
    BOOL _paused;
    BOOL _active;
    NSDictionary* _achievements;
}
static PGGameCenter * _EGGameCenter_instance;
static CNClassType* _EGGameCenter_type;
static BOOL _isSupported;

+ (id)gameCenter {
    return [[PGGameCenter alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        _paused = NO;
        _active = NO;
    }
    return self;
}

+ (void)load {
    if([GKLocalPlayer class]) _isSupported = YES; else _isSupported = NO;
}

+ (void)initialize {
    [super initialize];
    _EGGameCenter_type = [CNClassType classTypeWithCls:[PGGameCenter class]];
    _EGGameCenter_instance = [PGGameCenter gameCenter];
}

- (void)authenticate {
    if(!_isSupported) return;
    __weak typeof(self) weakSelf = self; // removes retain cycle error

    GKLocalPlayer* localPlayer = [GKLocalPlayer localPlayer]; // localPlayer is the public GKLocalPlayer
    __weak GKLocalPlayer *weakPlayer = localPlayer; // removes retain cycle error


    if([weakPlayer respondsToSelector:@selector(setAuthenticateHandler:)]) {
         weakPlayer.authenticateHandler =
#if TARGET_OS_IPHONE
            ^(UIViewController *viewController, NSError *error)
#else
            ^(NSViewController *viewController, NSError *error)
#endif
         {
            if (viewController != nil) {
                if(![[PGDirector current] isPaused]) {
                    _paused = YES;
                    [[PGDirector current] pause];
                }
                [weakSelf showAuthenticationDialogWhenReasonable:viewController];
            } else {
                if (weakPlayer.isAuthenticated) {
                    [weakSelf authenticatedPlayer:weakPlayer];
                }
                else {
                    [weakSelf disableGameCenter];
                    _active = NO;
                }
                if(_paused) {
                    _paused = NO;
                    [[PGDirector current] resume];
                }
            }
        };
    } else {
        [weakPlayer authenticateWithCompletionHandler:^(NSError *error) {
            if (weakPlayer.isAuthenticated) {
                [weakSelf authenticatedPlayer:weakPlayer];
            }
            else {
                [weakSelf disableGameCenter];
                _active = NO;
            }
        }];
    }
}


#if TARGET_OS_IPHONE
-(void)showAuthenticationDialogWhenReasonable:(UIViewController *)controller {
    [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:controller animated:YES completion:nil];
}
#else
-(void)showAuthenticationDialogWhenReasonable:(NSViewController *)controller {
    [[GKDialogController sharedDialogController] presentViewController:(NSViewController <GKViewController> *) controller];

}
#endif

-(void)authenticatedPlayer:(GKLocalPlayer *)player{
    [GKAchievementDescription loadAchievementDescriptionsWithCompletionHandler:^(NSArray *descriptions, NSError *error) {
        if (error != nil) {
            NSLog(@"Error while loading achievements descriptions: %@", error);
            return;
        }

        [GKAchievement loadAchievementsWithCompletionHandler:^(NSArray *achievements, NSError *err) {
            if (error != nil) {
                NSLog(@"Error while loading achievements: %@", err);
                return;
            }
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            _achievements = dic;
            _active = YES;
            if(achievements == nil) achievements = [NSArray array];
            for(GKAchievementDescription* desc in descriptions) {
                id _a = [achievements findWhere:^BOOL(GKAchievement *x) {
                                                return [x.identifier isEqual:desc.identifier];
                                            }];
                GKAchievement* a = _a == nil ?[[GKAchievement alloc] initWithIdentifier:desc.identifier] : _a;
                [dic setObject:[PGAchievement initWithAchievementDescription:desc achievementWithAchievement:a] forKey:desc.identifier];
            }
        }];
    }];

}

- (void)clearAchievements {
    if(!_active) return;
    NSEnumerator *enumerator = _achievements.objectEnumerator;
    PGAchievement * no;
    while((no = enumerator.nextObject) != nil) {
        [no setProgress:0];
    }
}

-(void)disableGameCenter {

}

- (id)achievementName:(NSString*)name {
    if(!_active) return nil;

    return [_achievements applyKey:name];
}


- (CNClassType*)type {
    return [PGGameCenter type];
}

+ (PGGameCenter *)instance {
    return _EGGameCenter_instance;
}

+ (CNClassType*)type {
    return _EGGameCenter_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

+ (BOOL)isSupported {
    return _isSupported;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    return YES;
}

- (NSUInteger)hash {
    return 0;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

- (void)completeAchievementName:(NSString *)name {
    [[self achievementName:name] complete];
}

- (void)reportScoreLeaderboard:(NSString *)leaderboard value:(long)value {
    [self reportScoreLeaderboard:leaderboard value:value completed:nil];
}

- (void)reportScoreLeaderboard:(NSString *)leaderboard value:(long)value completed :(void (^)(PGLocalPlayerScore*))completed {
    if(!_active) return;
#if TARGET_OS_IPHONE
    GKScore *scoreReporter = [GKScore alloc];

    if([scoreReporter respondsToSelector:@selector(initWithLeaderboardIdentifier:)]) {
        scoreReporter = [scoreReporter initWithLeaderboardIdentifier:leaderboard];
    } else {
        scoreReporter = [scoreReporter initWithCategory:leaderboard];
    }
    scoreReporter.value = value;
    scoreReporter.context = 0;
    NSArray *scores = @[scoreReporter];
    [GKScore reportScores:scores withCompletionHandler:^(NSError *error) {
        if(error != nil) NSLog(@"Error while writing leaderboard %@", error);
        if(completed != nil) [self retrieveLocalPlayerScoreLeaderboard: leaderboard minValue : [NSNumber numberWithLong:value] callback:^(id o) {
                if(o == nil) {
                    NSLog(@"Error while retrurning written value to leaderboard");
                    return;
                }
                completed(o);
            } attems:0];
    }];
#else
    GKScore *scoreReporter = [[GKScore alloc] initWithCategory:leaderboard];

    scoreReporter.value = value;
    scoreReporter.context = 0;

    [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
        if(error != nil) NSLog(@"Error while writing leaderboard %@", error);
        if(completed != nil) [self retrieveLocalPlayerScoreLeaderboard: leaderboard minValue : [NSNumber numberWithLong:value] callback:^(id o) {
                if(o == nil) {
                    NSLog(@"Error while retrurning written value to leaderboard");
                    return;
                }
                completed(o);
            } attems:0];
    }];
#endif
}

- (void)retrieveLocalPlayerScoreLeaderboard:(NSString *)leaderboard minValue:(NSNumber *)value callback:(void (^)(id))callback attems:(int)attems {
    GKLeaderboard *leaderboardRequest = [[GKLeaderboard alloc] init];
    leaderboardRequest.timeScope = GKLeaderboardTimeScopeAllTime;
    leaderboardRequest.playerScope = GKLeaderboardPlayerScopeGlobal;
#if TARGET_OS_IPHONE
    if([leaderboardRequest respondsToSelector:@selector(setIdentifier:)]) {
        leaderboardRequest.identifier = leaderboard;
    } else {
        leaderboardRequest.category = leaderboard;
    }
#else
    leaderboardRequest.category = leaderboard;
#endif
    leaderboardRequest.range = NSMakeRange(1, 1);
    [leaderboardRequest loadScoresWithCompletionHandler:^(NSArray *scores, NSError *error) {
        if(error != nil) {
            NSLog(@"Error while loading scores %@", error);
            return;
        }
        GKScore *s = leaderboardRequest.localPlayerScore;
        if(s.rank == 0 && value == nil) {
            callback(nil);

        } else if(s.rank != 0 && (value == nil || s.value >= value.longValue)) {
            PGLocalPlayerScore *lps = [PGLocalPlayerScore localPlayerScoreWithValue:(long) s.value
                                                                               rank:(NSUInteger) s.rank
                                                                            maxRank:leaderboardRequest.maxRange];
            callback(lps);
        } else {
            if(attems > 10) {
                NSLog(@"Could not write retrieve new information from Game Center during a timeout.");
            } else {
                delay(0.5, ^{
                    [self retrieveLocalPlayerScoreLeaderboard:leaderboard minValue:value callback:callback attems:attems + 1];
                });
            }
        }
    }];
}

- (void)localPlayerScoreLeaderboard:(NSString *)leaderboard callback:(void (^)(id))callback {
    [self retrieveLocalPlayerScoreLeaderboard:leaderboard minValue:nil callback:callback attems:0];
}

- (void)showLeaderboardName:(NSString *)name {
    GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
    if (gameCenterController != nil)
    {
        gameCenterController.gameCenterDelegate = self;
        gameCenterController.viewState = GKGameCenterViewControllerStateLeaderboards;
#if TARGET_OS_IPHONE
        if([gameCenterController respondsToSelector:@selector(setLeaderboardIdentifier:)]) {
            gameCenterController.leaderboardIdentifier = name;
        } else {
            gameCenterController.leaderboardCategory = name;
        }
        [[[[[UIApplication sharedApplication] delegate] window] rootViewController]
            presentViewController:gameCenterController animated:YES completion:nil];
#else
        gameCenterController.leaderboardCategory = name;
        GKDialogController *controller = [GKDialogController sharedDialogController];
        controller.parentWindow = [[NSApplication sharedApplication] mainWindow];
        [controller performSelectorOnMainThread:@selector(presentViewController:) withObject:gameCenterController waitUntilDone:NO];
#endif

    }

}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController {
#if TARGET_OS_IPHONE
    [[[[[UIApplication sharedApplication] delegate] window] rootViewController] dismissViewControllerAnimated:YES completion:nil];
#else
    GKDialogController *controller = [GKDialogController sharedDialogController];
    [controller performSelectorOnMainThread:@selector(dismiss:) withObject:self waitUntilDone:NO];
#endif
}

@end



@implementation PGAchievement {
    GKAchievementDescription* _description;
    GKAchievement* _achievement;
}
static CNClassType* _EGAchievement_type;

- (instancetype)initWithAchievementDescription:(GKAchievementDescription *)description chievement:(GKAchievement *)achievement {
    self = [super init];
    if (self) {
        _achievement = achievement;
        _description=description;
    }

    return self;
}

+ (instancetype)initWithAchievementDescription:(GKAchievementDescription *)description achievementWithAchievement:(GKAchievement *)achievement {
    return [[self alloc] initWithAchievementDescription:description chievement:achievement];
}


+ (void)initialize {
    [super initialize];
    _EGAchievement_type = [CNClassType classTypeWithCls:[PGAchievement class]];
}

- (NSString*) name {
    return _achievement.identifier;
}
- (CGFloat)progress {
    return (CGFloat) (_achievement.percentComplete/100.0);
}

- (void)setProgress:(CGFloat)progress {
    CGFloat d = progress*100.0;
    if(!eqf((CGFloat) _achievement.percentComplete, d)) {
        _achievement.showsCompletionBanner = NO;
        _achievement.percentComplete = d;
        [GKAchievement reportAchievements:@[_achievement] withCompletionHandler:^(NSError *error) {
            if(error != nil) {
                NSLog(@"Error in achievenment %@ reporting: %@", _achievement.identifier, error);
            } else {
                NSLog(@"The achievenment %@ has been reported", _achievement.identifier);
                if(eqf(d, 100.0)) {
                    [GKNotificationBanner showBannerWithTitle:_description.title message:_description.achievedDescription
                                            completionHandler:^{

                                            }];
                }
            }
        }];
    }
}

- (void)complete {
    [self setProgress:1.0];
}

- (CNClassType*)type {
    return [PGAchievement type];
}

+ (CNClassType*)type {
    return _EGAchievement_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    PGAchievement * o = ((PGAchievement *)(other));
    return [self.name isEqual:o.name];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.name hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"name=%@", self.name];
    [description appendString:@">"];
    return description;
}

@end
