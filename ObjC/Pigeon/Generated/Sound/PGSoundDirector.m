#import "PGSoundDirector.h"

#import "CNObserver.h"
@implementation PGSoundDirector
static PGSoundDirector* _PGSoundDirector_instance;
static CNClassType* _PGSoundDirector_type;
@synthesize enabledChanged = _enabledChanged;
@synthesize timeSpeedChanged = _timeSpeedChanged;

+ (instancetype)soundDirector {
    return [[PGSoundDirector alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) {
        __enabled = YES;
        _enabledChanged = [CNSignal signal];
        __timeSpeed = 1.0;
        _timeSpeedChanged = [CNSignal signal];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGSoundDirector class]) {
        _PGSoundDirector_type = [CNClassType classTypeWithCls:[PGSoundDirector class]];
        _PGSoundDirector_instance = [PGSoundDirector soundDirector];
    }
}

- (BOOL)enabled {
    return __enabled;
}

- (void)setEnabled:(BOOL)enabled {
    if(__enabled != enabled) {
        __enabled = enabled;
        [_enabledChanged postData:numb(enabled)];
    }
}

- (CGFloat)timeSpeed {
    return __timeSpeed;
}

- (void)setTimeSpeed:(CGFloat)timeSpeed {
    if(!(eqf(__timeSpeed, timeSpeed))) {
        __timeSpeed = timeSpeed;
        [_timeSpeedChanged postData:numf(timeSpeed)];
    }
}

- (NSString*)description {
    return @"SoundDirector";
}

- (CNClassType*)type {
    return [PGSoundDirector type];
}

+ (PGSoundDirector*)instance {
    return _PGSoundDirector_instance;
}

+ (CNClassType*)type {
    return _PGSoundDirector_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

