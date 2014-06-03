#import "PGTime.h"
#include <sys/time.h>

@implementation PGTime {
    struct timeval _lastUpdate;
    BOOL _started;
    CGFloat _delta;
}

@synthesize delta = _delta;
@synthesize started = _started;

+ (id)time {
    return [[PGTime alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        _started = NO;
        _delta = 0;
    }
    return self;
}

- (void)tick {
    if(!_started) return;

    struct timeval now;

    if(gettimeofday( &now, NULL) != 0) return;

    CGFloat dt;
    dt = (now.tv_sec - _lastUpdate.tv_sec) + (now.tv_usec - _lastUpdate.tv_usec) / 1000000.0f;
    dt = MAX(0, dt);

#ifdef DEBUG
    // If we are debugging our code, prevent big delta time
    if(dt > 1.0f) dt = 1/60.0f;
#endif

    _delta = dt;
    _lastUpdate = now;
}

- (void)start {
    struct timeval now;

    if(gettimeofday( &now, NULL) != 0) return;
    _lastUpdate = now;
    _started = YES;
}


@end


