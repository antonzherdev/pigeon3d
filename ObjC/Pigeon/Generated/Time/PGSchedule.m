#import "PGSchedule.h"

#import "CNReact.h"
#import "CNObserver.h"
#import "CNChain.h"
@implementation PGScheduleEvent
static CNClassType* _PGScheduleEvent_type;
@synthesize time = _time;
@synthesize f = _f;

+ (instancetype)scheduleEventWithTime:(CGFloat)time f:(void(^)())f {
    return [[PGScheduleEvent alloc] initWithTime:time f:f];
}

- (instancetype)initWithTime:(CGFloat)time f:(void(^)())f {
    self = [super init];
    if(self) {
        _time = time;
        _f = [f copy];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGScheduleEvent class]) _PGScheduleEvent_type = [CNClassType classTypeWithCls:[PGScheduleEvent class]];
}

- (NSInteger)compareTo:(PGScheduleEvent*)to {
    return floatCompareTo(_time, ((PGScheduleEvent*)(to)).time);
}

- (NSString*)description {
    return [NSString stringWithFormat:@"ScheduleEvent(%f)", _time];
}

- (CNClassType*)type {
    return [PGScheduleEvent type];
}

+ (CNClassType*)type {
    return _PGScheduleEvent_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGImSchedule
static CNClassType* _PGImSchedule_type;
@synthesize events = _events;
@synthesize time = _time;

+ (instancetype)imScheduleWithEvents:(CNImList*)events time:(NSUInteger)time {
    return [[PGImSchedule alloc] initWithEvents:events time:time];
}

- (instancetype)initWithEvents:(CNImList*)events time:(NSUInteger)time {
    self = [super init];
    if(self) {
        _events = events;
        _time = time;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGImSchedule class]) _PGImSchedule_type = [CNClassType classTypeWithCls:[PGImSchedule class]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"ImSchedule(%@, %lu)", _events, (unsigned long)_time];
}

- (CNClassType*)type {
    return [PGImSchedule type];
}

+ (CNClassType*)type {
    return _PGImSchedule_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGMSchedule
static CNClassType* _PGMSchedule_type;

+ (instancetype)schedule {
    return [[PGMSchedule alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) {
        __events = [CNImList apply];
        __current = 0.0;
        __next = -1.0;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGMSchedule class]) _PGMSchedule_type = [CNClassType classTypeWithCls:[PGMSchedule class]];
}

- (void)scheduleAfter:(CGFloat)after event:(void(^)())event {
    __events = [__events insertItem:[PGScheduleEvent scheduleEventWithTime:__current + after f:event]];
    __next = ((PGScheduleEvent*)(nonnil([__events head]))).time;
}

- (void)updateWithDelta:(CGFloat)delta {
    __current += delta;
    while(__next >= 0 && __current > __next) {
        PGScheduleEvent* e = [__events head];
        __events = [__events tail];
        ((PGScheduleEvent*)(e)).f();
        [self updateNext];
    }
}

- (CGFloat)time {
    return __current;
}

- (BOOL)isEmpty {
    return __next < 0.0;
}

- (PGImSchedule*)imCopy {
    return [PGImSchedule imScheduleWithEvents:__events time:((NSUInteger)(__current))];
}

- (void)assignImSchedule:(PGImSchedule*)imSchedule {
    __events = imSchedule.events;
    __current = ((CGFloat)(imSchedule.time));
    [self updateNext];
}

- (void)updateNext {
    PGScheduleEvent* __tmp_0 = [__events head];
    if(__tmp_0 != nil) __next = ((PGScheduleEvent*)([__events head])).time;
    else __next = -1.0;
}

- (NSString*)description {
    return @"MSchedule";
}

- (CNClassType*)type {
    return [PGMSchedule type];
}

+ (CNClassType*)type {
    return _PGMSchedule_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGCounter
static CNClassType* _PGCounter_type;

+ (instancetype)counter {
    return [[PGCounter alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGCounter class]) _PGCounter_type = [CNClassType classTypeWithCls:[PGCounter class]];
}

- (CNReact*)isRunning {
    @throw @"Method isRunning is abstract";
}

- (CNVar*)time {
    @throw @"Method time is abstract";
}

- (void)restart {
    @throw @"Method restart is abstract";
}

- (void)finish {
    @throw @"Method finish is abstract";
}

- (id)finished {
    [self finish];
    return self;
}

- (void)forF:(void(^)(CGFloat))f {
    if(unumb([[self isRunning] value])) f(unumf([[self time] value]));
}

- (void)updateWithDelta:(CGFloat)delta {
    @throw @"Method updateWith is abstract";
}

+ (PGCounter*)stoppedLength:(CGFloat)length {
    return [PGLengthCounter lengthCounterWithLength:length];
}

+ (PGCounter*)applyLength:(CGFloat)length {
    return [PGLengthCounter lengthCounterWithLength:length];
}

+ (PGCounter*)applyLength:(CGFloat)length finish:(void(^)())finish {
    return [PGFinisher finisherWithCounter:[PGLengthCounter lengthCounterWithLength:length] onFinish:finish];
}

+ (PGCounter*)apply {
    return [PGEmptyCounter emptyCounter];
}

- (PGCounter*)onTime:(CGFloat)time event:(void(^)())event {
    return [PGEventCounter eventCounterWithCounter:self eventTime:time event:event];
}

- (PGCounter*)onEndEvent:(void(^)())event {
    return [PGFinisher finisherWithCounter:self onFinish:event];
}

- (NSString*)description {
    return @"Counter";
}

- (CNClassType*)type {
    return [PGCounter type];
}

+ (CNClassType*)type {
    return _PGCounter_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGEmptyCounter
static PGEmptyCounter* _PGEmptyCounter_instance;
static CNClassType* _PGEmptyCounter_type;

+ (instancetype)emptyCounter {
    return [[PGEmptyCounter alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGEmptyCounter class]) {
        _PGEmptyCounter_type = [CNClassType classTypeWithCls:[PGEmptyCounter class]];
        _PGEmptyCounter_instance = [PGEmptyCounter emptyCounter];
    }
}

- (CNReact*)isRunning {
    return [CNVal valWithValue:@NO];
}

- (CNVar*)time {
    return [CNVar applyInitial:@1.0];
}

- (void)updateWithDelta:(CGFloat)delta {
}

- (void)restart {
}

- (void)finish {
}

- (NSString*)description {
    return @"EmptyCounter";
}

- (CNClassType*)type {
    return [PGEmptyCounter type];
}

+ (PGEmptyCounter*)instance {
    return _PGEmptyCounter_instance;
}

+ (CNClassType*)type {
    return _PGEmptyCounter_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGLengthCounter
static CNClassType* _PGLengthCounter_type;
@synthesize length = _length;
@synthesize time = _time;
@synthesize isRunning = _isRunning;

+ (instancetype)lengthCounterWithLength:(CGFloat)length {
    return [[PGLengthCounter alloc] initWithLength:length];
}

- (instancetype)initWithLength:(CGFloat)length {
    self = [super init];
    if(self) {
        _length = length;
        _time = [CNVar applyInitial:@0.0];
        _isRunning = [_time mapF:^id(id _) {
            return numb(unumf(_) < 1.0);
        }];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGLengthCounter class]) _PGLengthCounter_type = [CNClassType classTypeWithCls:[PGLengthCounter class]];
}

- (void)updateWithDelta:(CGFloat)delta {
    if(unumb([_isRunning value])) {
        CGFloat t = unumf([_time value]);
        t += delta / _length;
        if(t >= 1.0) [_time setValue:@1.0];
        else [_time setValue:numf(t)];
    }
}

- (void)restart {
    [_time setValue:@0.0];
}

- (void)finish {
    [_time setValue:@1.0];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"LengthCounter(%f)", _length];
}

- (CNClassType*)type {
    return [PGLengthCounter type];
}

+ (CNClassType*)type {
    return _PGLengthCounter_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGFinisher
static CNClassType* _PGFinisher_type;
@synthesize counter = _counter;
@synthesize onFinish = _onFinish;

+ (instancetype)finisherWithCounter:(PGCounter*)counter onFinish:(void(^)())onFinish {
    return [[PGFinisher alloc] initWithCounter:counter onFinish:onFinish];
}

- (instancetype)initWithCounter:(PGCounter*)counter onFinish:(void(^)())onFinish {
    self = [super init];
    if(self) {
        _counter = counter;
        _onFinish = [onFinish copy];
        _obs = [[counter isRunning] observeF:^void(id r) {
            if(!(unumb(r))) onFinish();
        }];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGFinisher class]) _PGFinisher_type = [CNClassType classTypeWithCls:[PGFinisher class]];
}

- (CNReact*)isRunning {
    return [_counter isRunning];
}

- (CNVar*)time {
    return [_counter time];
}

- (void)updateWithDelta:(CGFloat)delta {
    [_counter updateWithDelta:delta];
}

- (void)restart {
    [_counter restart];
}

- (void)finish {
    [_counter finish];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Finisher(%@)", _counter];
}

- (CNClassType*)type {
    return [PGFinisher type];
}

+ (CNClassType*)type {
    return _PGFinisher_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGEventCounter
static CNClassType* _PGEventCounter_type;
@synthesize counter = _counter;
@synthesize eventTime = _eventTime;
@synthesize event = _event;

+ (instancetype)eventCounterWithCounter:(PGCounter*)counter eventTime:(CGFloat)eventTime event:(void(^)())event {
    return [[PGEventCounter alloc] initWithCounter:counter eventTime:eventTime event:event];
}

- (instancetype)initWithCounter:(PGCounter*)counter eventTime:(CGFloat)eventTime event:(void(^)())event {
    self = [super init];
    __weak PGEventCounter* _weakSelf = self;
    if(self) {
        _counter = counter;
        _eventTime = eventTime;
        _event = [event copy];
        _executed = NO;
        _obs = [[counter time] observeF:^void(id time) {
            PGEventCounter* _self = _weakSelf;
            if(_self != nil) {
                if(!(_self->_executed)) {
                    if(unumf([[counter time] value]) > eventTime) {
                        event();
                        _self->_executed = YES;
                    }
                } else {
                    if(unumf([[counter time] value]) < eventTime) _self->_executed = NO;
                }
            }
        }];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGEventCounter class]) _PGEventCounter_type = [CNClassType classTypeWithCls:[PGEventCounter class]];
}

- (CNReact*)isRunning {
    return [_counter isRunning];
}

- (CNVar*)time {
    return [_counter time];
}

- (void)updateWithDelta:(CGFloat)delta {
    [_counter updateWithDelta:delta];
}

- (void)restart {
    _executed = NO;
    [_counter restart];
}

- (void)finish {
    _executed = YES;
    [_counter finish];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"EventCounter(%@, %f)", _counter, _eventTime];
}

- (CNClassType*)type {
    return [PGEventCounter type];
}

+ (CNClassType*)type {
    return _PGEventCounter_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGCounterData
static CNClassType* _PGCounterData_type;
@synthesize counter = _counter;
@synthesize data = _data;

+ (instancetype)counterDataWithCounter:(PGCounter*)counter data:(id)data {
    return [[PGCounterData alloc] initWithCounter:counter data:data];
}

- (instancetype)initWithCounter:(PGCounter*)counter data:(id)data {
    self = [super init];
    if(self) {
        _counter = counter;
        _data = data;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGCounterData class]) _PGCounterData_type = [CNClassType classTypeWithCls:[PGCounterData class]];
}

- (CNReact*)isRunning {
    return [_counter isRunning];
}

- (CNVar*)time {
    return [_counter time];
}

- (void)updateWithDelta:(CGFloat)delta {
    [_counter updateWithDelta:delta];
}

- (void)restart {
    [_counter restart];
}

- (void)finish {
    [_counter finish];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"CounterData(%@, %@)", _counter, _data];
}

- (CNClassType*)type {
    return [PGCounterData type];
}

+ (CNClassType*)type {
    return _PGCounterData_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGMutableCounterArray
static CNClassType* _PGMutableCounterArray_type;

+ (instancetype)mutableCounterArray {
    return [[PGMutableCounterArray alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) __counters = ((NSArray*)((@[])));
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGMutableCounterArray class]) _PGMutableCounterArray_type = [CNClassType classTypeWithCls:[PGMutableCounterArray class]];
}

- (NSArray*)counters {
    return __counters;
}

- (void)appendCounter:(PGCounterData*)counter {
    __counters = [__counters addItem:counter];
}

- (void)appendCounter:(PGCounter*)counter data:(id)data {
    __counters = [__counters addItem:[PGCounterData counterDataWithCounter:counter data:data]];
}

- (void)updateWithDelta:(CGFloat)delta {
    __block BOOL hasDied = NO;
    for(PGCounterData* counter in __counters) {
        [((PGCounterData*)(counter)) updateWithDelta:delta];
        if(!(unumb([[((PGCounterData*)(counter)) isRunning] value]))) hasDied = YES;
    }
    if(hasDied) __counters = [[[__counters chain] filterWhen:^BOOL(PGCounterData* _) {
        return !(unumb([[((PGCounterData*)(_)) isRunning] value]));
    }] toArray];
}

- (void)forEach:(void(^)(PGCounterData*))each {
    [__counters forEach:each];
}

- (NSString*)description {
    return @"MutableCounterArray";
}

- (CNClassType*)type {
    return [PGMutableCounterArray type];
}

+ (CNClassType*)type {
    return _PGMutableCounterArray_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

