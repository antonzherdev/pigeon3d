#import <Cocoa/Cocoa.h>

#import "PGDirector.h"

@interface PGOpenGLViewMac : NSOpenGLView
@property (readonly, nonatomic) PGDirector * director;
@property (readonly, nonatomic) PGVec2 viewSize;

- (void)lockOpenGLContext;

- (void)unlockOpenGLContext;

- (void)redraw;

- (void)clearRecognizers;

- (void)registerRecognizerType:(PGRecognizerType *)type;
@end