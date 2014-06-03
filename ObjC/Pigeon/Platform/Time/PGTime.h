#import <Foundation/Foundation.h>

@interface PGTime : NSObject
@property (nonatomic, readonly) CGFloat delta;
@property (nonatomic, readonly) BOOL started;

+ (id)time;
- (id)init;
- (void)tick;
- (void) start;
@end


