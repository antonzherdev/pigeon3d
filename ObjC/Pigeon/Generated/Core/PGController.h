#import "objd.h"

@class PGUpdatable_impl;
@class PGController_impl;
@protocol PGUpdatable;
@protocol PGController;

@protocol PGUpdatable<NSObject>
- (void)updateWithDelta:(CGFloat)delta;
- (NSString*)description;
@end


@interface PGUpdatable_impl : NSObject<PGUpdatable>
+ (instancetype)updatable_impl;
- (instancetype)init;
@end


@protocol PGController<PGUpdatable>
- (void)start;
- (void)stop;
- (NSString*)description;
@end


@interface PGController_impl : PGUpdatable_impl<PGController>
+ (instancetype)controller_impl;
- (instancetype)init;
@end


