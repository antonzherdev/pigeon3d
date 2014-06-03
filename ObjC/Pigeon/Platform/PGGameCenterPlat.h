#import <GameKit/GameKit.h>
#import "objd.h"

@class PGGameCenter;
@class PGAchievement;
@class GKAchievement;
@class PGLocalPlayerScore;

@interface PGGameCenter : NSObject <GKGameCenterControllerDelegate>
+ (id)gameCenter;
- (id)init;
- (CNClassType*)type;
- (void)authenticate;
- (id)achievementName:(NSString*)name;
+ (PGGameCenter *)instance;

- (void)completeAchievementName:(NSString *)name;
- (void)clearAchievements;

+ (CNClassType*)type;

- (void)reportScoreLeaderboard:(NSString *)leaderboard value:(long)value;

+ (BOOL)isSupported;

- (void)reportScoreLeaderboard:(NSString *)leaderboard value:(long)value completed :(void (^)(PGLocalPlayerScore*))completed;

- (void)localPlayerScoreLeaderboard:(NSString *)leaderboard callback:(void (^)(id))callback;

- (void)showLeaderboardName:(NSString *)name;
@end



@interface PGAchievement : NSObject
@property (nonatomic, readonly) NSString* name;

- (instancetype)initWithAchievementDescription:(GKAchievementDescription *)description chievement:(GKAchievement *)achievement;

+ (instancetype)initWithAchievementDescription:(GKAchievementDescription *)description achievementWithAchievement:(GKAchievement *)achievement;

- (void)complete;
- (CNClassType*)type;
- (CGFloat)progress;
- (void)setProgress:(CGFloat)progress;
+ (CNClassType*)type;
@end
