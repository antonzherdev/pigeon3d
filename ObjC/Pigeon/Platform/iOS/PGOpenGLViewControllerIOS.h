//
// Created by Anton Zherdev on 07.10.13.
// Copyright (c) 2013 Anton Zherdev. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "PGVec.h"

@class PGDirector;
@class PGRecognizerType;


@interface PGOpenGLViewControllerIOS : UIViewController
@property (readonly, nonatomic) PGDirector * director;

@property(nonatomic) PGVec2 viewSize;

- (void)lockOpenGLContext;

- (void)unlockOpenGLContext;

- (void)registerRecognizerType:(PGRecognizerType *)type;

- (void)clearRecognizers;

@end