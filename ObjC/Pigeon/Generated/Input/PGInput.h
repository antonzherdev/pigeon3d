#import "objd.h"
#import "PGVec.h"
@class PGDirector;
@class CNReact;
@class CNChain;
@class PGMatrixModel;
@class PGMat4;

@class PGRecognizer;
@class PGLongRecognizer;
@class PGShortRecognizer;
@class PGInputProcessor_impl;
@class PGRecognizers;
@class PGRecognizersState;
@class PGRecognizerType;
@class PGPan;
@class PGTap;
@class PGPinch;
@class PGPinchParameter;
@class PGEvent_impl;
@class PGViewEvent;
@class PGCameraEvent;
@class PGEventPhase;
@protocol PGInputProcessor;
@protocol PGEvent;

typedef enum PGEventPhaseR {
    PGEventPhase_Nil = 0,
    PGEventPhase_began = 1,
    PGEventPhase_changed = 2,
    PGEventPhase_ended = 3,
    PGEventPhase_canceled = 4,
    PGEventPhase_on = 5
} PGEventPhaseR;
@interface PGEventPhase : CNEnum
+ (NSArray*)values;
+ (PGEventPhase*)value:(PGEventPhaseR)r;
@end


@interface PGRecognizer : NSObject {
@protected
    PGRecognizerType* _tp;
}
@property (nonatomic, readonly) PGRecognizerType* tp;

+ (instancetype)recognizerWithTp:(PGRecognizerType*)tp;
- (instancetype)initWithTp:(PGRecognizerType*)tp;
- (CNClassType*)type;
+ (PGRecognizer*)applyTp:(PGRecognizerType*)tp began:(BOOL(^)(id<PGEvent>))began changed:(void(^)(id<PGEvent>))changed ended:(void(^)(id<PGEvent>))ended;
+ (PGRecognizer*)applyTp:(PGRecognizerType*)tp began:(BOOL(^)(id<PGEvent>))began changed:(void(^)(id<PGEvent>))changed ended:(void(^)(id<PGEvent>))ended canceled:(void(^)(id<PGEvent>))canceled;
+ (PGShortRecognizer*)applyTp:(PGRecognizerType*)tp on:(BOOL(^)(id<PGEvent>))on;
- (PGRecognizers*)addRecognizer:(PGRecognizer*)recognizer;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGLongRecognizer : PGRecognizer {
@protected
    BOOL(^_began)(id<PGEvent>);
    void(^_changed)(id<PGEvent>);
    void(^_ended)(id<PGEvent>);
    void(^_canceled)(id<PGEvent>);
}
@property (nonatomic, readonly) BOOL(^began)(id<PGEvent>);
@property (nonatomic, readonly) void(^changed)(id<PGEvent>);
@property (nonatomic, readonly) void(^ended)(id<PGEvent>);
@property (nonatomic, readonly) void(^canceled)(id<PGEvent>);

+ (instancetype)longRecognizerWithTp:(PGRecognizerType*)tp began:(BOOL(^)(id<PGEvent>))began changed:(void(^)(id<PGEvent>))changed ended:(void(^)(id<PGEvent>))ended canceled:(void(^)(id<PGEvent>))canceled;
- (instancetype)initWithTp:(PGRecognizerType*)tp began:(BOOL(^)(id<PGEvent>))began changed:(void(^)(id<PGEvent>))changed ended:(void(^)(id<PGEvent>))ended canceled:(void(^)(id<PGEvent>))canceled;
- (CNClassType*)type;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGShortRecognizer : PGRecognizer {
@protected
    BOOL(^_on)(id<PGEvent>);
}
@property (nonatomic, readonly) BOOL(^on)(id<PGEvent>);

+ (instancetype)shortRecognizerWithTp:(PGRecognizerType*)tp on:(BOOL(^)(id<PGEvent>))on;
- (instancetype)initWithTp:(PGRecognizerType*)tp on:(BOOL(^)(id<PGEvent>))on;
- (CNClassType*)type;
- (NSString*)description;
+ (CNClassType*)type;
@end


@protocol PGInputProcessor<NSObject>
- (BOOL)isProcessorActive;
- (PGRecognizers*)recognizers;
- (NSString*)description;
@end


@interface PGInputProcessor_impl : NSObject<PGInputProcessor>
+ (instancetype)inputProcessor_impl;
- (instancetype)init;
@end


@interface PGRecognizers : NSObject {
@protected
    NSArray* _items;
}
@property (nonatomic, readonly) NSArray* items;

+ (instancetype)recognizersWithItems:(NSArray*)items;
- (instancetype)initWithItems:(NSArray*)items;
- (CNClassType*)type;
+ (PGRecognizers*)applyRecognizer:(PGRecognizer*)recognizer;
- (PGShortRecognizer*)onEvent:(id<PGEvent>)event;
- (PGLongRecognizer*)beganEvent:(id<PGEvent>)event;
- (PGRecognizers*)addRecognizer:(PGRecognizer*)recognizer;
- (PGRecognizers*)addRecognizers:(PGRecognizers*)recognizers;
- (id<CNSet>)types;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGRecognizersState : NSObject {
@protected
    PGRecognizers* _recognizers;
    CNMHashMap* _longMap;
}
@property (nonatomic, readonly) PGRecognizers* recognizers;

+ (instancetype)recognizersStateWithRecognizers:(PGRecognizers*)recognizers;
- (instancetype)initWithRecognizers:(PGRecognizers*)recognizers;
- (CNClassType*)type;
- (BOOL)processEvent:(id<PGEvent>)event;
- (BOOL)onEvent:(id<PGEvent>)event;
- (BOOL)beganEvent:(id<PGEvent>)event;
- (BOOL)changedEvent:(id<PGEvent>)event;
- (BOOL)endedEvent:(id<PGEvent>)event;
- (BOOL)canceledEvent:(id<PGEvent>)event;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGRecognizerType : NSObject
+ (instancetype)recognizerType;
- (instancetype)init;
- (CNClassType*)type;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGPan : PGRecognizerType {
@protected
    NSUInteger _fingers;
}
@property (nonatomic, readonly) NSUInteger fingers;

+ (instancetype)panWithFingers:(NSUInteger)fingers;
- (instancetype)initWithFingers:(NSUInteger)fingers;
- (CNClassType*)type;
+ (PGPan*)apply;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (PGPan*)leftMouse;
+ (PGPan*)rightMouse;
+ (CNClassType*)type;
@end


@interface PGTap : PGRecognizerType {
@protected
    NSUInteger _fingers;
    NSUInteger _taps;
}
@property (nonatomic, readonly) NSUInteger fingers;
@property (nonatomic, readonly) NSUInteger taps;

+ (instancetype)tapWithFingers:(NSUInteger)fingers taps:(NSUInteger)taps;
- (instancetype)initWithFingers:(NSUInteger)fingers taps:(NSUInteger)taps;
- (CNClassType*)type;
+ (PGTap*)applyFingers:(NSUInteger)fingers;
+ (PGTap*)applyTaps:(NSUInteger)taps;
+ (PGTap*)apply;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface PGPinch : PGRecognizerType
+ (instancetype)pinch;
- (instancetype)init;
- (CNClassType*)type;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface PGPinchParameter : NSObject {
@protected
    CGFloat _scale;
    CGFloat _velocity;
}
@property (nonatomic, readonly) CGFloat scale;
@property (nonatomic, readonly) CGFloat velocity;

+ (instancetype)pinchParameterWithScale:(CGFloat)scale velocity:(CGFloat)velocity;
- (instancetype)initWithScale:(CGFloat)scale velocity:(CGFloat)velocity;
- (CNClassType*)type;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@protocol PGEvent<NSObject>
- (PGRecognizerType*)recognizerType;
- (PGEventPhaseR)phase;
- (PGVec2)locationInView;
- (PGVec2)viewSize;
- (id)param;
- (PGMatrixModel*)matrixModel;
- (PGRect)viewport;
- (PGVec2)locationInViewport;
- (PGVec2)location;
- (PGVec2)locationForDepth:(CGFloat)depth;
- (PGLine3)segment;
- (BOOL)checkViewport;
- (NSString*)description;
@end


@interface PGEvent_impl : NSObject<PGEvent>
+ (instancetype)event_impl;
- (instancetype)init;
@end


@interface PGViewEvent : PGEvent_impl {
@protected
    PGRecognizerType* _recognizerType;
    PGEventPhaseR _phase;
    PGVec2 _locationInView;
    PGVec2 _viewSize;
    id _param;
}
@property (nonatomic, readonly) PGRecognizerType* recognizerType;
@property (nonatomic, readonly) PGEventPhaseR phase;
@property (nonatomic, readonly) PGVec2 locationInView;
@property (nonatomic, readonly) PGVec2 viewSize;
@property (nonatomic, readonly) id param;

+ (instancetype)viewEventWithRecognizerType:(PGRecognizerType*)recognizerType phase:(PGEventPhaseR)phase locationInView:(PGVec2)locationInView viewSize:(PGVec2)viewSize param:(id)param;
- (instancetype)initWithRecognizerType:(PGRecognizerType*)recognizerType phase:(PGEventPhaseR)phase locationInView:(PGVec2)locationInView viewSize:(PGVec2)viewSize param:(id)param;
- (CNClassType*)type;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGCameraEvent : PGEvent_impl {
@protected
    id<PGEvent> _event;
    PGMatrixModel* _matrixModel;
    PGRect _viewport;
    PGRecognizerType* _recognizerType;
    PGVec2 _locationInView;
    CNLazy* __lazy_segment;
}
@property (nonatomic, readonly) id<PGEvent> event;
@property (nonatomic, readonly) PGMatrixModel* matrixModel;
@property (nonatomic, readonly) PGRect viewport;
@property (nonatomic, readonly) PGRecognizerType* recognizerType;
@property (nonatomic, readonly) PGVec2 locationInView;

+ (instancetype)cameraEventWithEvent:(id<PGEvent>)event matrixModel:(PGMatrixModel*)matrixModel viewport:(PGRect)viewport;
- (instancetype)initWithEvent:(id<PGEvent>)event matrixModel:(PGMatrixModel*)matrixModel viewport:(PGRect)viewport;
- (CNClassType*)type;
- (PGLine3)segment;
- (PGEventPhaseR)phase;
- (PGVec2)viewSize;
- (id)param;
- (PGVec2)location;
- (PGVec2)locationInViewport;
- (PGVec2)locationForDepth:(CGFloat)depth;
- (BOOL)checkViewport;
- (NSString*)description;
+ (CNClassType*)type;
@end


