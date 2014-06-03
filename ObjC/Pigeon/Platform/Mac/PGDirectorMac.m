#import "PGDirectorMac.h"
#import "PGOpenGLViewMac.h"
#import "PGInput.h"
#import "CNObserver.h"
#import "CNReact.h"
#import <OpenGL/gl3.h>


@implementation PGDirectorMac {
@private
    CVDisplayLinkRef _displayLink;
    __unsafe_unretained PGOpenGLViewMac *_view;
    CNObserver *_pauseObs;
}

@synthesize view = _view;

- (id)initWithView:(__unsafe_unretained PGOpenGLViewMac *)view {
    self = [super init];
    if (self) {
        _view = view;
        _pauseObs = [[self isPaused] observeF:^(id x) {
            if(!unumb(x)) CVDisplayLinkStart(_displayLink);
            else {
                [self performSelectorInBackground:@selector(doStop) withObject:nil];
                [self redraw];
            }
        }];
        [self _init];
    }

    return self;
}

+ (id)directorWithView:(__unsafe_unretained PGOpenGLViewMac *)view {
    return [[self alloc] initWithView:view];
}

- (void)lock {
    [self.view lockOpenGLContext];
}

- (void)unlock {
    [self.view unlockOpenGLContext];
}


- (CVReturn)getFrameForTime:(const CVTimeStamp*)outputTime
{
    @autoreleasepool{
        [self.view lockOpenGLContext];
        @try {
            [self processFrame];
        } @finally {
            [self.view unlockOpenGLContext];
        }
    }

    return kCVReturnSuccess;
}

- (void)draw {
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
    [super draw];
    [[self.view openGLContext] flushBuffer];
}


// This is the renderer output callback function
static CVReturn MyDisplayLinkCallback(CVDisplayLinkRef displayLink, const CVTimeStamp* now, const CVTimeStamp* outputTime, CVOptionFlags flagsIn, CVOptionFlags* flagsOut, void* displayLinkContext)
{
    CVReturn result = [(__bridge PGDirectorMac *)displayLinkContext getFrameForTime:outputTime];
    return result;
}

- (void)start {
    if(self.isStarted) return;

    // Create a display link capable of being used with all active displays
    CVDisplayLinkCreateWithActiveCGDisplays(&_displayLink);

    // Set the renderer output callback function
    CVDisplayLinkSetOutputCallback(_displayLink, &MyDisplayLinkCallback, (__bridge void*)self);

    // Set the display link for the current renderer
    PGOpenGLViewMac *openGLView = self.view;
    CGLContextObj cglContext = [[openGLView openGLContext] CGLContextObj];
    CGLPixelFormatObj cglPixelFormat = [[openGLView pixelFormat] CGLPixelFormatObj];
    CVDisplayLinkSetCurrentCGDisplayFromOpenGLContext(_displayLink, cglContext, cglPixelFormat);

    // Activate the display link
    CVDisplayLinkStart(_displayLink);

    [super start];
}

- (void)stop {
    if(!self.isStarted) return;


    if( _displayLink ) {
        [self doStopAndRelease];
        _displayLink = nil;
    }

    [super stop];
}


- (void)doStop {
    CVDisplayLinkStop(_displayLink);
}

- (void)doStopAndRelease {
    CVDisplayLinkStop(_displayLink);
    CVDisplayLinkRelease(_displayLink);
}

- (void)redraw {
    [_view redraw];
}

- (CGFloat)scale {
    return [[NSScreen mainScreen] backingScaleFactor];
}

- (void)registerRecognizerType:(PGRecognizerType *)recognizerType {
    [_view registerRecognizerType:recognizerType];

}

- (void)clearRecognizers {
    [_view clearRecognizers];
}


@end