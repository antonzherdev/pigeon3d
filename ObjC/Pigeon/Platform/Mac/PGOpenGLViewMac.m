#import <OpenGL/gl3.h>
#import "PGOpenGLViewMac.h"
#import "PGDirectorMac.h"
#import "PGContext.h"
#import "PGTouchToMouse.h"


@implementation PGOpenGLViewMac {

@private
    PGDirectorMac *_director;
    PGVec2 _viewSize;
    BOOL _mouseDraged;
    BOOL _mouseDown;
    PGTouchToMouse * _ttm;
}

@synthesize director = _director;

@synthesize viewSize = _viewSize;

- (id)initWithFrame:(NSRect)frame
{
    CGLPixelFormatAttribute attribs[17] = {
            kCGLPFAOpenGLProfile, (CGLPixelFormatAttribute)kCGLOGLPVersion_3_2_Core, // This sets the context to 3.2
            kCGLPFAColorSize,     (CGLPixelFormatAttribute)24,
            kCGLPFAAlphaSize,     (CGLPixelFormatAttribute)8,
            kCGLPFAAccelerated,
            kCGLPFADoubleBuffer,
            kCGLPFASampleBuffers, (CGLPixelFormatAttribute)1,
            kCGLPFASamples,       (CGLPixelFormatAttribute)4,
            kCGLPFADepthSize,     (CGLPixelFormatAttribute)24,
            kCGLPFAStencilSize, (CGLPixelFormatAttribute)0,
            (CGLPixelFormatAttribute)0
    };
    NSOpenGLPixelFormat *pix = [[NSOpenGLPixelFormat alloc] initWithAttributes:(NSOpenGLPixelFormatAttribute const *) attribs];
    return [self initWithFrame:frame pixelFormat:pix];
}

- (id)initWithFrame:(NSRect)frameRect pixelFormat:(NSOpenGLPixelFormat *)format {
    self = [super initWithFrame:frameRect pixelFormat:format];
    if (self) {
        [self doInit];
    }

    return self;
}

- (void)doInit {
    if(_director != nil) return;
    [self setWantsBestResolutionOpenGLSurface:YES];
    [[NSNotificationCenter defaultCenter] addObserverForName:NSApplicationWillResignActiveNotification
                                                      object:nil queue:nil usingBlock:^(NSNotification *note) {
        [_director pause];
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:NSApplicationWillTerminateNotification
                                                      object:nil queue:nil usingBlock:^(NSNotification *note) {
        [_director stop];
    }];
    _director = [[PGDirectorMac alloc] initWithView:self];
    [_director start];
    [self setAcceptsTouchEvents:YES];
}

- (void)viewWillMoveToWindow:(NSWindow *)newWindow {
    [super viewWillMoveToWindow:newWindow];
    if(newWindow == nil) {
        [_director stop];
    } else {
        [[NSNotificationCenter defaultCenter] addObserverForName:NSWindowWillCloseNotification
                                                          object:newWindow queue:nil usingBlock:^(NSNotification *note) {
            [_director stop];
        }];
    }
}

- (void)clearGLContext {
    [super clearGLContext];
    [_director stop];
}


- (id)init {
    self = [super init];
    if (self) {
        [self doInit];
    }

    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self doInit];
}


- (void)redraw {
    [self performSelectorOnMainThread:@selector(syncRedraw) withObject:nil waitUntilDone:NO];
}

- (void)syncRedraw {
    [self lockOpenGLContext];
    @try {
        [_director drawFrame];
    } @finally {
        [self unlockOpenGLContext];
    }
}


- (void)reshape {
    // We draw on a secondary thread through the display link
    // When resizing the view, -reshape is called automatically on the main thread
    // Add a mutex around to avoid the threads accessing the context simultaneously when resizing

    CGSize nsSize = [self convertRectToBacking:[self bounds]].size;
    PGVec2 vec2 = PGVec2Make((float) nsSize.width, (float) nsSize.height);
//    if(!pgVec2IsEqualTo(vec2, _viewSize)) {
        [self lockOpenGLContext];
        @try {

            _viewSize = vec2;
            [_director reshapeWithSize:_viewSize];
            [_director drawFrame];
        } @finally {
            [self unlockOpenGLContext];
        }
//    }
}

- (void) prepareOpenGL {
    // XXX: Initialize OpenGL context
    [super prepareOpenGL];

    // Make this openGL context current to the thread
    // (i.e. all openGL on this thread calls will go to this context)
    [[self openGLContext] makeCurrentContext];

    // Synchronize buffer swaps with vertical refresh rate
    GLint swapInt = 1;
    [[self openGLContext] setValues:&swapInt forParameter:NSOpenGLCPSwapInterval];


    GLuint vertexArray;
    glGenVertexArrays(1, &vertexArray);
    glBindVertexArray(vertexArray);
    [PGGlobal context].defaultVertexArray = vertexArray;

    glHint(GL_LINE_SMOOTH_HINT, GL_NICEST);
    glHint(GL_POLYGON_SMOOTH_HINT, GL_NICEST);
//	GLint order = -1;
//	[[self openGLContext] setValues:&order forParameter:NSOpenGLCPSurfaceOrder];
}

- (NSUInteger) depthFormat {
    return 24;
}


-(void) lockOpenGLContext
{
    NSOpenGLContext *glContext = [self openGLContext];
    NSAssert( glContext, @"FATAL: could not get openGL context");

    [glContext makeCurrentContext];
    CGLLockContext([glContext CGLContextObj]);
}

-(void) unlockOpenGLContext
{
    NSOpenGLContext *glContext = [self openGLContext];
    NSAssert( glContext, @"FATAL: could not get openGL context");

    CGLUnlockContext([glContext CGLContextObj]);
}

#define DISPATCH_EVENT(theEvent, __tp__, __phase__, __param__) {\
@autoreleasepool {\
[self lockOpenGLContext];\
[_director processEvent:[PGViewEvent viewEventWithRecognizerType:__tp__ phase:__phase__ locationInView:[self locationForEvent:theEvent] viewSize:_viewSize param : __param__]];\
[self unlockOpenGLContext];\
}\
}

#pragma mark CCGLView - Mouse events

- (PGVec2) locationForEvent:(NSEvent*)event{
    NSPoint point = [self convertPointToBacking:[self convertPoint:[event locationInWindow] fromView:nil]];
    return PGVec2Make((float) point.x, (float) point.y);
}

- (void)mouseDown:(NSEvent *)theEvent
{
    DISPATCH_EVENT(theEvent, [PGPan leftMouse], PGEventPhase_began, nil);
    _mouseDraged = NO;
    _mouseDown = YES;
}


- (void)mouseDragged:(NSEvent *)theEvent
{
    DISPATCH_EVENT(theEvent, [PGPan leftMouse], PGEventPhase_changed, nil);
    _mouseDraged = YES;
}

- (void)mouseUp:(NSEvent *)theEvent
{
    DISPATCH_EVENT(theEvent, [PGPan leftMouse], PGEventPhase_ended, nil);
    if(!_mouseDraged) {
        DISPATCH_EVENT(theEvent, [PGTap tapWithFingers:1 taps:(NSUInteger)theEvent.clickCount], PGEventPhase_on, nil);
    }
    _mouseDown = NO;
}

- (void)rightMouseDown:(NSEvent *)theEvent {
    DISPATCH_EVENT(theEvent, [PGPan rightMouse], PGEventPhase_began, nil);
}

- (void)rightMouseDragged:(NSEvent *)theEvent {
    DISPATCH_EVENT(theEvent, [PGPan rightMouse], PGEventPhase_changed, nil);
}

- (void)rightMouseUp:(NSEvent *)theEvent {
    DISPATCH_EVENT(theEvent, [PGPan rightMouse], PGEventPhase_ended, nil);
}

- (void)scrollWheel:(NSEvent *)theEvent {
    if(!theEvent.hasPreciseScrollingDeltas) {
        DISPATCH_EVENT(theEvent, [PGPinch pinch], PGEventPhase_began, [PGPinchParameter pinchParameterWithScale:1.0 velocity:1.0]);
        CGFloat scale = theEvent.scrollingDeltaY < 0 ? -0.1* theEvent.scrollingDeltaY + 1.0 : -0.05*theEvent.scrollingDeltaY + 1.0;
        DISPATCH_EVENT(theEvent, [PGPinch pinch], PGEventPhase_changed, [PGPinchParameter pinchParameterWithScale:scale velocity:1.0]);
        DISPATCH_EVENT(theEvent, [PGPinch pinch], PGEventPhase_ended, [PGPinchParameter pinchParameterWithScale:scale velocity:1.0]);
    }
}


#pragma mark CCGLView - Key events

-(BOOL) becomeFirstResponder
{
    return YES;
}

-(BOOL) acceptsFirstResponder
{
    return YES;
}

-(BOOL) resignFirstResponder
{
    return YES;
}

//- (void)keyDown:(NSEvent *)theEvent
//{
//    DISPATCH_EVENT(theEvent, NSKeyDown);
//}
//
//- (void)keyUp:(NSEvent *)theEvent
//{
//    DISPATCH_EVENT(theEvent, NSKeyUp);
//}
//
//- (void)flagsChanged:(NSEvent *)theEvent
//{
//    DISPATCH_EVENT(theEvent, NSFlagsChanged);
//}
//
#pragma mark CCGLView - Touch events
- (void)touchesBeganWithEvent:(NSEvent *)theEvent
{
    if(!_mouseDown) [_ttm touchBeganEvent:theEvent];
//    DISPATCH_EVENT(theEvent, PGEventTouchBegan);
}

- (void)touchesMovedWithEvent:(NSEvent *)theEvent
{
    if(!_mouseDown) [_ttm touchMovedEvent:theEvent];
//    DISPATCH_EVENT(theEvent, PGEventTouchMoved);
}

- (void)touchesEndedWithEvent:(NSEvent *)theEvent
{
    if(!_mouseDown) [_ttm touchEndedEvent:theEvent];
//    DISPATCH_EVENT(theEvent, PGEventTouchEnded);
}

- (void)touchesCancelledWithEvent:(NSEvent *)theEvent
{
    if(!_mouseDown) [_ttm touchCanceledEvent:theEvent];
//    DISPATCH_EVENT(theEvent, PGEventTouchCanceled);
}

- (void)clearRecognizers {
    _ttm = nil;
}

- (void)registerRecognizerType:(PGRecognizerType *)type {
    if([type isKindOfClass:[PGPan class]]) {
        if(((PGPan*)type).fingers == 1) _ttm = [PGTouchToMouse touchToMouseWithDirector:_director];
    }
}
@end