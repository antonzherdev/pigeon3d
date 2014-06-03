#import "PGController.h"

@implementation PGUpdatable_impl

+ (instancetype)updatable_impl {
    return [[PGUpdatable_impl alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

- (void)updateWithDelta:(CGFloat)delta {
    @throw @"Method updateWith is abstract";
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGController_impl

+ (instancetype)controller_impl {
    return [[PGController_impl alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

- (void)start {
}

- (void)stop {
}

- (void)updateWithDelta:(CGFloat)delta {
    @throw @"Method updateWith is abstract";
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

