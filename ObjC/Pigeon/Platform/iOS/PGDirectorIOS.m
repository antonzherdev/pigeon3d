//
// Created by Anton Zherdev on 07.10.13.
// Copyright (c) 2013 Anton Zherdev. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PGDirectorIOS.h"
#import "PGOpenGLViewControllerIOS.h"
#import "PGInput.h"
#import "GL.h"
#import "PGContext.h"
#import "PGSurface.h"
#import "CNReact.h"
#import "PGMultisamplingSurface.h"


@implementation PGDirectorIOS {
    __unsafe_unretained PGOpenGLViewControllerIOS *_view;
    EAGLContext *_context;
    CADisplayLink *_displayLink;
    PGRenderTargetSurface* _surface;
    PGVec2 _viewSize;
    NSLock* _drawingLock;
    BOOL _active;
    BOOL _needUpdateViewSize;
    CNObserver *_pauseObs;
}
- (id)initWithView:(__unsafe_unretained PGOpenGLViewControllerIOS *)view {
    self = [super init];
    if (self) {
        _view = view;
        _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        _active = YES;
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateAndDraw:)];
        [_displayLink setFrameInterval:2];

        [EAGLContext setCurrentContext:_context];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        _pauseObs = [[self isPaused] observeF:^(id x) {
                [_displayLink setPaused:unumb(x)];
            }];
        _drawingLock = [[NSLock alloc] init];
        _needUpdateViewSize = YES;
        [self _init];
    }

    return self;
}

- (void)updateAndDraw:(CADisplayLink*)sender {
    if(![self isStarted] || !_active || ![_drawingLock tryLock]) return;
    [self processFrame];
    [_drawingLock unlock];
}

- (void)prepare {
    if(_needUpdateViewSize) {
        [self updateViewSize];
        _needUpdateViewSize = NO;
    }

    [super prepare];
}

- (void)draw {
    if([PGGlobal context].redrawFrame || unumb([[self isPaused] value])) {
        [_surface bind];
        [super draw];
        [_surface unbind];
        [[PGGlobal context] bindRenderBufferId:_surface.renderBuffer];
        [_context presentRenderbuffer:GL_RENDERBUFFER];
    } else {
        glFinish();
    }
}


+ (id)directorWithView:(__unsafe_unretained PGOpenGLViewControllerIOS *)view {
    return [[self alloc] initWithView:view];
}


- (void)beforeDraw {
}

- (void)lock {
}

- (void)unlock {
}

- (void)redraw {
    if(!self.isStarted || !_active) return;
    [self performSelectorOnMainThread:@selector(syncRedraw) withObject:nil waitUntilDone:NO];
}

- (void)syncRedraw {
    if(!self.isStarted || !_active || ![_drawingLock tryLock]) return;
    [self drawFrame];
    [_drawingLock unlock];
}


- (CGFloat)scale {
    return [UIScreen mainScreen].scale;
}

- (void)registerRecognizerType:(PGRecognizerType *)recognizerType {
    [_view registerRecognizerType:recognizerType];
}

- (void)clearRecognizers {
    [_view clearRecognizers];
}

- (void)resignActive {
    [_drawingLock lock];
    _active = NO;
    [super resignActive];
    [_drawingLock unlock];
}

- (void)becomeActive {
    _active = YES;
    [super becomeActive];
    if(!self.isStarted) return;
    [self redraw];
    delay(0.1, ^{
        [self redraw];
    });
    delay(0.5, ^{
        [self redraw];
    });
}


- (void)updateViewSize {
    [EAGLContext setCurrentContext:_context];

    GLuint renderBuffer = egGenRenderBuffer();
    [[PGGlobal context] bindRenderBufferId:renderBuffer];

    if(![_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer*)_view.view.layer]) {
        @throw @"Error in initialize renderbufferStorage";
    }
    GLint backingWidth = 0;
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &backingWidth);
    GLint backingHeight = 0;
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &backingHeight);
    PGSurfaceRenderTargetRenderBuffer *target = [PGSurfaceRenderTargetRenderBuffer surfaceRenderTargetRenderBufferWithRenderBuffer:renderBuffer
                                                                                                                              size:PGVec2iMake(backingWidth, backingHeight)];
//    _surface = [PGSimpleSurface simpleSurfaceWithRenderTarget:target depth:YES];
    _surface = [PGMultisamplingSurface multisamplingSurfaceWithRenderTarget:target depth:YES];
    _viewSize = PGVec2Make(backingWidth, backingHeight);
    _view.viewSize = _viewSize;
    [self reshapeWithSize:_viewSize];
}

@end