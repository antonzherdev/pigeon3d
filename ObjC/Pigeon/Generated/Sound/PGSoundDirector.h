#import "objd.h"
@class CNSignal;

@class PGSoundDirector;

@interface PGSoundDirector : NSObject {
@public
    BOOL __enabled;
    CNSignal* _enabledChanged;
    CGFloat __timeSpeed;
    CNSignal* _timeSpeedChanged;
}
@property (nonatomic, readonly) CNSignal* enabledChanged;
@property (nonatomic, readonly) CNSignal* timeSpeedChanged;

+ (instancetype)soundDirector;
- (instancetype)init;
- (CNClassType*)type;
- (BOOL)enabled;
- (void)setEnabled:(BOOL)enabled;
- (CGFloat)timeSpeed;
- (void)setTimeSpeed:(CGFloat)timeSpeed;
- (NSString*)description;
+ (PGSoundDirector*)instance;
+ (CNClassType*)type;
@end


