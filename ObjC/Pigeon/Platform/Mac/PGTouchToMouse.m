#import "PGTouchToMouse.h"
#import "PGOpenGLViewMac.h"
#import "PGDirectorMac.h"

@implementation PGTouchToMouse {
    PGDirectorMac * _director;
    BOOL _touching;
    NSTouch* _startTouches[2];
    PGVec2 _touchStartPoint;
    PGVec2 _touchStartScreenPoint;
    PGVec2 _touchLastPoint;
}

+ (id)touchToMouseWithDirector:(PGDirectorMac *)director {
    return [[PGTouchToMouse alloc] initWithDirector:director];
}

- (id)initWithDirector:(PGDirectorMac *)director {
    self = [super init];
    if(self) {
        _director = director;
        _touching = NO;
    }
    
    return self;
}

#define DISPATCH_EVENT(theEvent, __tp__, __phase__, __location__) {\
[_director.view lockOpenGLContext];\
[_director processEvent:[PGViewEvent viewEventWithRecognizerType:__tp__ phase:__phase__ locationInView:__location__ viewSize:_director.view.viewSize param : nil]];\
[_director.view unlockOpenGLContext];\
}

- (void)touchBeganEvent:(NSEvent *)event {
    NSSet* touches = [event touchesMatchingPhase:NSTouchPhaseTouching inView:_director.view];
    if(touches.count == 2) {
        _touching = YES;
        NSArray *array = [touches allObjects];
        _startTouches[0] = [array objectAtIndex:0];
        _startTouches[1] = [array objectAtIndex:1];
        CGPoint eventLocation = CGEventGetLocation([event CGEvent]);
        _touchStartScreenPoint.x = (float) eventLocation.x;
        _touchStartScreenPoint.y = (float) eventLocation.y;
        NSPoint sp = [event locationInWindow];
        _touchStartPoint.x = (float) sp.x;
        _touchStartPoint.y = (float) sp.y;
        DISPATCH_EVENT(theEvent, [PGPan leftMouse], PGEventPhase_began, _touchStartPoint);
    }
}

- (void)touchMovedEvent:(NSEvent*)event {
    if(!_touching) return;

    NSSet* touches = [event touchesMatchingPhase:NSTouchPhaseTouching inView:_director.view];
    NSTouch *touch0 = [self findTouch:_startTouches[0] inTouches:touches];
    if(touch0 == nil) return ;
    NSTouch *touch1 = [self findTouch:_startTouches[1] inTouches:touches];
    if(touch1 == nil) return ;

    NSPoint np1 = _startTouches[0].normalizedPosition;
    NSPoint np2 = _startTouches[1].normalizedPosition;
    NSPoint p1 = touch0.normalizedPosition;
    NSPoint p2 = touch1.normalizedPosition;
    CGFloat w = touch0.deviceSize.width;
    CGFloat h = touch0.deviceSize.height;
    PGVec2 delta = PGVec2Make(
            (float) (3*((MIN(p1.x, p2.x) * w) - (MIN(np1.x, np2.x)* w))),
            (float) (3*((MIN(p1.y, p2.y) * h) - (MIN(np1.y, np2.y)* h)))
    );

    _touchLastPoint = pgVec2AddVec2(_touchStartPoint, delta);
    CGPoint cursor = CGPointMake(_touchStartScreenPoint.x + delta.x, _touchStartScreenPoint.y - delta.y);
    CGWarpMouseCursorPosition(cursor);
    DISPATCH_EVENT(theEvent, [PGPan leftMouse], PGEventPhase_changed, _touchLastPoint);
}

- (NSTouch *)findTouch:(NSTouch *)touch inTouches:(NSSet *)touches {
    for(NSTouch * t in touches) {
        if([t.identity isEqual:touch.identity]) {
            return t;
        }
    }
    return nil;
}


- (void)touchEndedEvent:(NSEvent*)event {
    if(!_touching) return;

    _touching = NO;
    _startTouches[0] = nil;
    _startTouches[1] = nil;
    DISPATCH_EVENT(theEvent, [PGPan leftMouse], PGEventPhase_ended, _touchLastPoint);
}

- (void)touchCanceledEvent:(NSEvent*)event {
    if(!_touching) return;

    _touching = NO;
    _startTouches[0] = nil;
    _startTouches[1] = nil;
    DISPATCH_EVENT(theEvent, [PGPan leftMouse], PGEventPhase_canceled, _touchStartPoint);
}
@end

