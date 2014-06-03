#import "objd.h"
#import "PGInput.h"

@class PGTouchToMouse;
@class PGDirectorMac;
@class PGOpenGLViewMac;

@interface PGTouchToMouse : NSObject

+ (id)touchToMouseWithDirector:(PGDirectorMac *)director;
- (id)initWithDirector:(PGDirectorMac *)director;

- (void)touchBeganEvent:(NSEvent *)event;
- (void)touchMovedEvent:(NSEvent*)event;
- (void)touchEndedEvent:(NSEvent*)event;
- (void)touchCanceledEvent:(NSEvent*)event;
@end
