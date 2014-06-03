#import "objd.h"
#import "iRate.h"

@class PGRate;

@interface PGRate : NSObject<iRateDelegate>
+ (id)rate;
- (id)init;
- (CNClassType*)type;
- (BOOL)isRated;
- (BOOL)isRatedThisVersion;
- (void)showRate;
+ (PGRate *)instance;

- (void)later;

+ (CNClassType*)type;

- (void)never;

- (BOOL)shouldShowEveryVersion:(BOOL)everyVersion;

- (void)setIdsIos:(NSUInteger)ios osx:(NSUInteger)osx;
@end


