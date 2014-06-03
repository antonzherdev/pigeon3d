#import <Foundation/Foundation.h>
#import "PGDirector.h"

@class PGOpenGLViewMac;

@interface PGDirectorMac : PGDirector
@property (readonly, assign) PGOpenGLViewMac * view;

- (id)initWithView:(__unsafe_unretained PGOpenGLViewMac *)view;

+ (id)directorWithView:(__unsafe_unretained PGOpenGLViewMac *)view;

@end