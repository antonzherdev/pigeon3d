//
// Created by Anton Zherdev on 07.10.13.
// Copyright (c) 2013 Anton Zherdev. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PGOpenGLViewControllerIOS.h"
#import "PGDirector.h"
#import "PGDirectorIOS.h"
#import "PGContext.h"
#import "PGInput.h"
#import "GL.h"
#import "PGMultisamplingSurface.h"


@implementation PGOpenGLViewControllerIOS {
    PGDirector * _director;
    PGVec2 _viewSize;
}
@synthesize director = _director;

- (NSUInteger) supportedInterfaceOrientations {
    //Because your app is only landscape, your view controller for the view in your
    // popover needs to support only landscape
    return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];

    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }

    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification
                                                      object:nil queue:nil usingBlock:^(NSNotification *note) {
        [_director resignActive];
    }];

    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification
                                                      object:nil queue:nil usingBlock:^(NSNotification *note) {
        [_director becomeActive];
    }];

    _director = [PGDirectorIOS directorWithView:self];
    // Create an OpenGL ES context and assign it to the view loaded from storyboard

    const CGFloat scale = [UIScreen mainScreen].scale;
    self.view.contentScaleFactor = scale;
    CAEAGLLayer *layer = (CAEAGLLayer *) self.view.layer;
    layer.contentsScale = scale;
    layer.opaque = YES;
    layer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking,
                    kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];

    [self start];
}

- (void)start {

}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_director start];
}


//- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
//    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
//    _needUpdateViewSize = YES;
//}

- (void)lockOpenGLContext {

}

- (void)unlockOpenGLContext {

}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#define DISPATCH_EVENT(theEvent, tp) {\
[_director processEvent:[PGEventIOS eventIOSWithEvent:theEvent type:tp view:self camera:nil]];\
}

- (IBAction)tap:(UITapGestureRecognizer *)recognizer {
    [self processRecognizer:recognizer tp:[PGTap tapWithFingers:recognizer.numberOfTouchesRequired
                                                           taps:recognizer.numberOfTapsRequired] phase:PGEventPhase_on param:nil ];
}

- (IBAction)pan:(UIPanGestureRecognizer *)recognizer {
    [self processRecognizer:recognizer tp:[PGPan panWithFingers:recognizer.minimumNumberOfTouches] phase:[self phase:recognizer] param:nil ];
}

- (IBAction)pinch:(UIPinchGestureRecognizer *)recognizer {
    [self processRecognizer:recognizer tp:[PGPinch pinch] phase:[self phase:recognizer]
                      param:[PGPinchParameter pinchParameterWithScale:recognizer.scale velocity:recognizer.velocity] ];
}

- (PGEventPhaseR)phase:(UIGestureRecognizer *)recognizer {
    if(recognizer.state == UIGestureRecognizerStateBegan) return PGEventPhase_began;
    if(recognizer.state == UIGestureRecognizerStateEnded) return PGEventPhase_ended;
    if(recognizer.state == UIGestureRecognizerStateChanged) return PGEventPhase_changed;
    return PGEventPhase_canceled;
}

- (void)processRecognizer:(UIGestureRecognizer *)recognizer tp:(PGRecognizerType *)tp phase:(PGEventPhaseR)phase param:(id)param {
    @autoreleasepool {
        [_director processEvent:[PGViewEvent viewEventWithRecognizerType:tp
                                                                   phase:phase locationInView:[self locationForRecognizer:recognizer]
                                                                viewSize:_viewSize
                                                                   param:param
        ]];
    }

}


- (PGVec2)locationForRecognizer:(UIGestureRecognizer *)recognizer {
    CGPoint point = [recognizer locationInView:self.view];
    CGFloat scale = [[UIScreen mainScreen] scale];
    return PGVec2Make(scale* (float) point.x, _viewSize.y - scale*(float) point.y);
}


- (void)registerRecognizerType:(PGRecognizerType *)type {
    if([type isKindOfClass:[PGTap class]]) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        NSUInteger f = ((PGTap*)type).fingers;
        tap.numberOfTouchesRequired = f;
        NSUInteger t = ((PGTap*)type).taps;
        tap.numberOfTapsRequired = t;
        if(t > 1) {
            id o = [[self.view gestureRecognizers] findWhere:^BOOL(id x) {
                        return [x isMemberOfClass:[UITapGestureRecognizer class]] && [x numberOfTapsRequired] == t - 1  && [x numberOfTouchesRequired] == f;
                    }];
            
            [o requireGestureRecognizerToFail:tap];
        }
        id o = [[self.view gestureRecognizers] findWhere:^BOOL(id x) {
                return [x isMemberOfClass:[UITapGestureRecognizer class]] && [x numberOfTapsRequired] == t + 1 && [x numberOfTouchesRequired] == f;
            }];
        if(o != nil) [tap requireGestureRecognizerToFail:o];
        [self.view addGestureRecognizer:tap];
    } else if([type isKindOfClass:[PGPan class]]) {
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        pan.minimumNumberOfTouches = ((PGPan*)type).fingers;
        pan.maximumNumberOfTouches = ((PGPan*)type).fingers;
        [self.view addGestureRecognizer:pan];
    } else if([type isKindOfClass:[PGPinch class]]) {
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
        [self.view addGestureRecognizer:pinch];
    }
}

- (void)clearRecognizers {
    UIView *view = self.view;
    for(UIGestureRecognizer * recognizer in view.gestureRecognizers) {
        [view removeGestureRecognizer:recognizer];
    }
}
@end