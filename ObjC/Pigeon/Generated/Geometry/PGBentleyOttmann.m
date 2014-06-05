#import "PGBentleyOttmann.h"

#import "CNChain.h"
#import "PGFigure.h"
@implementation PGBentleyOttmann
static CNClassType* _PGBentleyOttmann_type;

+ (instancetype)bentleyOttmann {
    return [[PGBentleyOttmann alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGBentleyOttmann class]) _PGBentleyOttmann_type = [CNClassType classTypeWithCls:[PGBentleyOttmann class]];
}

+ (id<CNSet>)intersectionsForSegments:(NSArray*)segments {
    if([segments count] < 2) {
        return ((id<CNSet>)([CNImHashSet imHashSet]));
    } else {
        PGSweepLine* sweepLine = [PGSweepLine sweepLine];
        PGBentleyOttmannEventQueue* queue = [PGBentleyOttmannEventQueue newWithSegments:segments sweepLine:sweepLine];
        while(!([queue isEmpty])) {
            id<CNSeq> events = [queue poll];
            [sweepLine handleEvents:events];
        }
        return [[[sweepLine->_intersections chain] flatMapF:^CNChain*(CNTuple* p) {
            return [[[[((id<CNMSet>)(((CNTuple*)(p))->_b)) chain] combinations] filterWhen:^BOOL(CNTuple* comb) {
                return !([((PGBentleyOttmannPointEvent*)(((CNTuple*)(comb))->_a)) isVertical]) || !([((PGBentleyOttmannPointEvent*)(((CNTuple*)(comb))->_b)) isVertical]);
            }] mapF:^PGIntersection*(CNTuple* comb) {
                return [PGIntersection intersectionWithItems:[CNPair pairWithA:((PGBentleyOttmannPointEvent*)(((CNTuple*)(comb))->_a))->_data b:((PGBentleyOttmannPointEvent*)(((CNTuple*)(comb))->_b))->_data] point:uwrap(PGVec2, ((CNTuple*)(p))->_a)];
            }];
        }] toSet];
    }
}

- (NSString*)description {
    return @"BentleyOttmann";
}

- (CNClassType*)type {
    return [PGBentleyOttmann type];
}

+ (CNClassType*)type {
    return _PGBentleyOttmann_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGIntersection
static CNClassType* _PGIntersection_type;
@synthesize items = _items;
@synthesize point = _point;

+ (instancetype)intersectionWithItems:(CNPair*)items point:(PGVec2)point {
    return [[PGIntersection alloc] initWithItems:items point:point];
}

- (instancetype)initWithItems:(CNPair*)items point:(PGVec2)point {
    self = [super init];
    if(self) {
        _items = items;
        _point = point;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGIntersection class]) _PGIntersection_type = [CNClassType classTypeWithCls:[PGIntersection class]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Intersection(%@, %@)", _items, pgVec2Description(_point)];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[PGIntersection class]])) return NO;
    PGIntersection* o = ((PGIntersection*)(to));
    return [_items isEqual:o->_items] && pgVec2IsEqualTo(_point, o->_point);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [_items hash];
    hash = hash * 31 + pgVec2Hash(_point);
    return hash;
}

- (CNClassType*)type {
    return [PGIntersection type];
}

+ (CNClassType*)type {
    return _PGIntersection_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGBentleyOttmannEvent
static CNClassType* _PGBentleyOttmannEvent_type;

+ (instancetype)bentleyOttmannEvent {
    return [[PGBentleyOttmannEvent alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGBentleyOttmannEvent class]) _PGBentleyOttmannEvent_type = [CNClassType classTypeWithCls:[PGBentleyOttmannEvent class]];
}

- (PGVec2)point {
    @throw @"Method point is abstract";
}

- (BOOL)isIntersection {
    return NO;
}

- (BOOL)isStart {
    return NO;
}

- (BOOL)isEnd {
    return NO;
}

- (NSString*)description {
    return @"BentleyOttmannEvent";
}

- (CNClassType*)type {
    return [PGBentleyOttmannEvent type];
}

+ (CNClassType*)type {
    return _PGBentleyOttmannEvent_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGBentleyOttmannPointEvent
static CNClassType* _PGBentleyOttmannPointEvent_type;
@synthesize isStart = _isStart;
@synthesize data = _data;
@synthesize segment = _segment;
@synthesize point = _point;

+ (instancetype)bentleyOttmannPointEventWithIsStart:(BOOL)isStart data:(id)data segment:(PGLineSegment*)segment point:(PGVec2)point {
    return [[PGBentleyOttmannPointEvent alloc] initWithIsStart:isStart data:data segment:segment point:point];
}

- (instancetype)initWithIsStart:(BOOL)isStart data:(id)data segment:(PGLineSegment*)segment point:(PGVec2)point {
    self = [super init];
    if(self) {
        _isStart = isStart;
        _data = data;
        _segment = segment;
        _point = point;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGBentleyOttmannPointEvent class]) _PGBentleyOttmannPointEvent_type = [CNClassType classTypeWithCls:[PGBentleyOttmannPointEvent class]];
}

- (CGFloat)yForX:(CGFloat)x {
    if([[_segment line] isVertical]) {
        if(_isStart) return ((CGFloat)(_segment->_p0.y));
        else return ((CGFloat)(_segment->_p1.y));
    } else {
        return ((CGFloat)(((float)([((PGSlopeLine*)([_segment line])) yForX:x]))));
    }
}

- (CGFloat)slope {
    return [[_segment line] slope];
}

- (BOOL)isVertical {
    return [[_segment line] isVertical];
}

- (BOOL)isEnd {
    return !(_isStart);
}

- (NSString*)description {
    return [NSString stringWithFormat:@"BentleyOttmannPointEvent(%d, %@, %@, %@)", _isStart, _data, _segment, pgVec2Description(_point)];
}

- (CNClassType*)type {
    return [PGBentleyOttmannPointEvent type];
}

+ (CNClassType*)type {
    return _PGBentleyOttmannPointEvent_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGBentleyOttmannIntersectionEvent
static CNClassType* _PGBentleyOttmannIntersectionEvent_type;
@synthesize point = _point;

+ (instancetype)bentleyOttmannIntersectionEventWithPoint:(PGVec2)point {
    return [[PGBentleyOttmannIntersectionEvent alloc] initWithPoint:point];
}

- (instancetype)initWithPoint:(PGVec2)point {
    self = [super init];
    if(self) _point = point;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGBentleyOttmannIntersectionEvent class]) _PGBentleyOttmannIntersectionEvent_type = [CNClassType classTypeWithCls:[PGBentleyOttmannIntersectionEvent class]];
}

- (BOOL)isIntersection {
    return YES;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"BentleyOttmannIntersectionEvent(%@)", pgVec2Description(_point)];
}

- (CNClassType*)type {
    return [PGBentleyOttmannIntersectionEvent type];
}

+ (CNClassType*)type {
    return _PGBentleyOttmannIntersectionEvent_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGBentleyOttmannEventQueue
static CNClassType* _PGBentleyOttmannEventQueue_type;
@synthesize events = _events;

+ (instancetype)bentleyOttmannEventQueue {
    return [[PGBentleyOttmannEventQueue alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) _events = [CNMTreeMap treeMapWithComparator:^NSInteger(id a, id b) {
        return pgVec2CompareTo((uwrap(PGVec2, a)), (uwrap(PGVec2, b)));
    }];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGBentleyOttmannEventQueue class]) _PGBentleyOttmannEventQueue_type = [CNClassType classTypeWithCls:[PGBentleyOttmannEventQueue class]];
}

- (BOOL)isEmpty {
    return [_events isEmpty];
}

+ (PGBentleyOttmannEventQueue*)newWithSegments:(NSArray*)segments sweepLine:(PGSweepLine*)sweepLine {
    PGBentleyOttmannEventQueue* ret = [PGBentleyOttmannEventQueue bentleyOttmannEventQueue];
    if(!([segments isEmpty])) {
        for(CNTuple* s in segments) {
            PGLineSegment* segment = ((CNTuple*)(s))->_b;
            [ret offerPoint:segment->_p0 event:[PGBentleyOttmannPointEvent bentleyOttmannPointEventWithIsStart:YES data:((CNTuple*)(s))->_a segment:segment point:segment->_p0]];
            [ret offerPoint:segment->_p1 event:[PGBentleyOttmannPointEvent bentleyOttmannPointEventWithIsStart:NO data:((CNTuple*)(s))->_a segment:segment point:segment->_p1]];
        }
        sweepLine->_queue = ret;
    }
    return ret;
}

- (void)offerPoint:(PGVec2)point event:(PGBentleyOttmannEvent*)event {
    [((CNMArray*)([_events applyKey:wrap(PGVec2, point) orUpdateWith:^CNMArray*() {
        return [CNMArray array];
    }])) appendItem:event];
}

- (id<CNSeq>)poll {
    return ((CNTuple*)(nonnil([_events pollFirst])))->_b;
}

- (NSString*)description {
    return @"BentleyOttmannEventQueue";
}

- (CNClassType*)type {
    return [PGBentleyOttmannEventQueue type];
}

+ (CNClassType*)type {
    return _PGBentleyOttmannEventQueue_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGSweepLine
static CNClassType* _PGSweepLine_type;
@synthesize events = _events;
@synthesize intersections = _intersections;
@synthesize queue = _queue;

+ (instancetype)sweepLine {
    return [[PGSweepLine alloc] init];
}

- (instancetype)init {
    self = [super init];
    __weak PGSweepLine* _weakSelf = self;
    if(self) {
        _events = [CNMTreeSet applyComparator:^NSInteger(PGBentleyOttmannPointEvent* a, PGBentleyOttmannPointEvent* b) {
            PGSweepLine* _self = _weakSelf;
            if(_self != nil) return [_self compareEventsA:a b:b];
            else return 0;
        }];
        _intersections = [CNMHashMap hashMap];
        _currentEventPoint = PGVec2Make(0.0, 0.0);
        _queue = nil;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGSweepLine class]) _PGSweepLine_type = [CNClassType classTypeWithCls:[PGSweepLine class]];
}

- (void)handleEvents:(id<CNSeq>)events {
    id<CNIterator> __il__0i = [events iterator];
    while([__il__0i hasNext]) {
        PGBentleyOttmannEvent* _ = [__il__0i next];
        [self handleOneEvent:_];
    }
}

- (void)sweepToEvent:(PGBentleyOttmannEvent*)event {
    _currentEventPoint = [event point];
}

- (void)handleOneEvent:(PGBentleyOttmannEvent*)event {
    if([event isStart]) {
        [self sweepToEvent:event];
        PGBentleyOttmannPointEvent* pe = ((PGBentleyOttmannPointEvent*)(event));
        if([pe isVertical]) {
            float minY = pe->_segment->_p0.y;
            float maxY = pe->_segment->_p1.y;
            id<CNIterator> i = [_events iteratorHigherThanItem:pe];
            while([i hasNext]) {
                PGBentleyOttmannPointEvent* e = [i next];
                if(!([e isVertical])) {
                    CGFloat y = [e yForX:((CGFloat)(_currentEventPoint.x))];
                    if(y > maxY) break;
                    if(y >= minY) [self registerIntersectionA:pe b:e point:PGVec2Make(_currentEventPoint.x, ((float)(y)))];
                }
            }
        } else {
            [_events appendItem:pe];
            [self checkIntersectionA:event b:[self aboveEvent:pe]];
            [self checkIntersectionA:event b:[self belowEvent:pe]];
        }
    } else {
        if([event isEnd]) {
            PGBentleyOttmannPointEvent* pe = ((PGBentleyOttmannPointEvent*)(event));
            if(!([pe isVertical])) {
                PGBentleyOttmannPointEvent* a = [self aboveEvent:pe];
                PGBentleyOttmannPointEvent* b = [self belowEvent:pe];
                [_events removeItem:pe];
                [self sweepToEvent:event];
                [self checkIntersectionA:a b:b];
            }
        } else {
            id<CNMSet> set = ((id<CNMSet>)(nonnil(([_intersections applyKey:wrap(PGVec2, [event point])]))));
            NSArray* toInsert = [[[set chain] filterWhen:^BOOL(PGBentleyOttmannPointEvent* _) {
                return [_events removeItem:_];
            }] toArray];
            [self sweepToEvent:event];
            for(PGBentleyOttmannPointEvent* e in toInsert) {
                [_events appendItem:e];
                [self checkIntersectionA:e b:[self aboveEvent:e]];
                [self checkIntersectionA:e b:[self belowEvent:e]];
            }
        }
    }
}

- (PGBentleyOttmannPointEvent*)aboveEvent:(PGBentleyOttmannPointEvent*)event {
    return [_events higherThanItem:event];
}

- (PGBentleyOttmannPointEvent*)belowEvent:(PGBentleyOttmannPointEvent*)event {
    return [_events lowerThanItem:event];
}

- (void)checkIntersectionA:(PGBentleyOttmannEvent*)a b:(PGBentleyOttmannEvent*)b {
    if(a != nil && b != nil && [((PGBentleyOttmannEvent*)(a)) isKindOfClass:[PGBentleyOttmannPointEvent class]] && [((PGBentleyOttmannEvent*)(b)) isKindOfClass:[PGBentleyOttmannPointEvent class]]) {
        PGBentleyOttmannPointEvent* aa = ((PGBentleyOttmannPointEvent*)(a));
        PGBentleyOttmannPointEvent* bb = ((PGBentleyOttmannPointEvent*)(b));
        {
            id _ = [aa->_segment intersectionWithSegment:bb->_segment];
            if(_ != nil) [self registerIntersectionA:aa b:bb point:uwrap(PGVec2, _)];
        }
    }
}

- (void)registerIntersectionA:(PGBentleyOttmannPointEvent*)a b:(PGBentleyOttmannPointEvent*)b point:(PGVec2)point {
    if(!([a->_segment endingsContainPoint:point]) || !([b->_segment endingsContainPoint:point])) {
        id<CNMSet> existing = [_intersections applyKey:wrap(PGVec2, point) orUpdateWith:^CNMHashSet*() {
            return [CNMHashSet hashSet];
        }];
        [existing appendItem:a];
        [existing appendItem:b];
        if(point.x > _currentEventPoint.x || (eqf4(point.x, _currentEventPoint.x) && point.y > _currentEventPoint.y)) {
            PGBentleyOttmannIntersectionEvent* intersection = [PGBentleyOttmannIntersectionEvent bentleyOttmannIntersectionEventWithPoint:point];
            [((PGBentleyOttmannEventQueue*)(_queue)) offerPoint:point event:intersection];
        }
    }
}

- (NSInteger)compareEventsA:(PGBentleyOttmannPointEvent*)a b:(PGBentleyOttmannPointEvent*)b {
    if([a isEqual:b]) return 0;
    CGFloat ay = [a yForX:((CGFloat)(_currentEventPoint.x))];
    CGFloat by = [b yForX:((CGFloat)(_currentEventPoint.x))];
    NSInteger c = floatCompareTo(ay, by);
    if(c == 0) {
        if([a isVertical]) {
            c = -1;
        } else {
            if([b isVertical]) {
                c = 1;
            } else {
                c = floatCompareTo([a slope], [b slope]);
                if(ay > _currentEventPoint.y) c = -c;
                if(c == 0) c = float4CompareTo(a->_point.x, b->_point.x);
            }
        }
    }
    return c;
}

- (NSString*)description {
    return @"SweepLine";
}

- (CNClassType*)type {
    return [PGSweepLine type];
}

+ (CNClassType*)type {
    return _PGSweepLine_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

