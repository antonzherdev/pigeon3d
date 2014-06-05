#import "objd.h"
#import "PGController.h"
@class CNReact;
@class CNVar;
@class CNVal;
@class CNObserver;
@class CNChain;

@class PGScheduleEvent;
@class PGImSchedule;
@class PGMSchedule;
@class PGCounter;
@class PGEmptyCounter;
@class PGLengthCounter;
@class PGFinisher;
@class PGEventCounter;
@class PGCounterData;
@class PGMutableCounterArray;

@interface PGScheduleEvent : NSObject<CNComparable> {
@public
    CGFloat _time;
    void(^_f)();
}
@property (nonatomic, readonly) CGFloat time;
@property (nonatomic, readonly) void(^f)();

+ (instancetype)scheduleEventWithTime:(CGFloat)time f:(void(^)())f;
- (instancetype)initWithTime:(CGFloat)time f:(void(^)())f;
- (CNClassType*)type;
- (NSInteger)compareTo:(PGScheduleEvent*)to;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGImSchedule : NSObject {
@public
    CNImList* _events;
    NSUInteger _time;
}
@property (nonatomic, readonly) CNImList* events;
@property (nonatomic, readonly) NSUInteger time;

+ (instancetype)imScheduleWithEvents:(CNImList*)events time:(NSUInteger)time;
- (instancetype)initWithEvents:(CNImList*)events time:(NSUInteger)time;
- (CNClassType*)type;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGMSchedule : NSObject {
@public
    CNImList* __events;
    CGFloat __current;
    CGFloat __next;
}
+ (instancetype)schedule;
- (instancetype)init;
- (CNClassType*)type;
- (void)scheduleAfter:(CGFloat)after event:(void(^)())event;
- (void)updateWithDelta:(CGFloat)delta;
- (CGFloat)time;
- (BOOL)isEmpty;
- (PGImSchedule*)imCopy;
- (void)assignImSchedule:(PGImSchedule*)imSchedule;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGCounter : PGUpdatable_impl
+ (instancetype)counter;
- (instancetype)init;
- (CNClassType*)type;
- (CNReact*)isRunning;
- (CNVar*)time;
- (void)restart;
- (void)finish;
- (id)finished;
- (void)updateWithDelta:(CGFloat)delta;
+ (PGCounter*)stoppedLength:(CGFloat)length;
+ (PGCounter*)applyLength:(CGFloat)length;
+ (PGCounter*)applyLength:(CGFloat)length finish:(void(^)())finish;
+ (PGCounter*)apply;
- (PGCounter*)onTime:(CGFloat)time event:(void(^)())event;
- (PGCounter*)onEndEvent:(void(^)())event;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGEmptyCounter : PGCounter
+ (instancetype)emptyCounter;
- (instancetype)init;
- (CNClassType*)type;
- (CNReact*)isRunning;
- (CNVar*)time;
- (void)updateWithDelta:(CGFloat)delta;
- (void)restart;
- (void)finish;
- (NSString*)description;
+ (PGEmptyCounter*)instance;
+ (CNClassType*)type;
@end


@interface PGLengthCounter : PGCounter {
@public
    CGFloat _length;
    CNVar* _time;
    CNReact* _isRunning;
}
@property (nonatomic, readonly) CGFloat length;
@property (nonatomic, readonly) CNVar* time;
@property (nonatomic, readonly) CNReact* isRunning;

+ (instancetype)lengthCounterWithLength:(CGFloat)length;
- (instancetype)initWithLength:(CGFloat)length;
- (CNClassType*)type;
- (void)updateWithDelta:(CGFloat)delta;
- (void)restart;
- (void)finish;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGFinisher : PGCounter {
@public
    PGCounter* _counter;
    void(^_onFinish)();
    CNObserver* _obs;
}
@property (nonatomic, readonly) PGCounter* counter;
@property (nonatomic, readonly) void(^onFinish)();

+ (instancetype)finisherWithCounter:(PGCounter*)counter onFinish:(void(^)())onFinish;
- (instancetype)initWithCounter:(PGCounter*)counter onFinish:(void(^)())onFinish;
- (CNClassType*)type;
- (CNReact*)isRunning;
- (CNVar*)time;
- (void)updateWithDelta:(CGFloat)delta;
- (void)restart;
- (void)finish;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGEventCounter : PGCounter {
@public
    PGCounter* _counter;
    CGFloat _eventTime;
    void(^_event)();
    BOOL _executed;
    CNObserver* _obs;
}
@property (nonatomic, readonly) PGCounter* counter;
@property (nonatomic, readonly) CGFloat eventTime;
@property (nonatomic, readonly) void(^event)();

+ (instancetype)eventCounterWithCounter:(PGCounter*)counter eventTime:(CGFloat)eventTime event:(void(^)())event;
- (instancetype)initWithCounter:(PGCounter*)counter eventTime:(CGFloat)eventTime event:(void(^)())event;
- (CNClassType*)type;
- (CNReact*)isRunning;
- (CNVar*)time;
- (void)updateWithDelta:(CGFloat)delta;
- (void)restart;
- (void)finish;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGCounterData : PGCounter {
@public
    PGCounter* _counter;
    id _data;
}
@property (nonatomic, readonly) PGCounter* counter;
@property (nonatomic, readonly) id data;

+ (instancetype)counterDataWithCounter:(PGCounter*)counter data:(id)data;
- (instancetype)initWithCounter:(PGCounter*)counter data:(id)data;
- (CNClassType*)type;
- (CNReact*)isRunning;
- (CNVar*)time;
- (void)updateWithDelta:(CGFloat)delta;
- (void)restart;
- (void)finish;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGMutableCounterArray : PGUpdatable_impl {
@public
    NSArray* __counters;
}
+ (instancetype)mutableCounterArray;
- (instancetype)init;
- (CNClassType*)type;
- (NSArray*)counters;
- (void)appendCounter:(PGCounterData*)counter;
- (void)appendCounter:(PGCounter*)counter data:(id)data;
- (void)updateWithDelta:(CGFloat)delta;
- (void)forEach:(void(^)(PGCounterData*))each;
- (NSString*)description;
+ (CNClassType*)type;
@end


