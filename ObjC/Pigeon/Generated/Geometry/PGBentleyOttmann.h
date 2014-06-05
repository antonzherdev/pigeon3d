#import "objd.h"
#import "PGVec.h"
@class CNChain;
@class PGLineSegment;
@class PGLine;
@class PGSlopeLine;

@class PGBentleyOttmann;
@class PGIntersection;
@class PGBentleyOttmannEvent;
@class PGBentleyOttmannPointEvent;
@class PGBentleyOttmannIntersectionEvent;
@class PGBentleyOttmannEventQueue;
@class PGSweepLine;

@interface PGBentleyOttmann : NSObject
+ (instancetype)bentleyOttmann;
- (instancetype)init;
- (CNClassType*)type;
+ (id<CNSet>)intersectionsForSegments:(NSArray*)segments;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGIntersection : NSObject {
@public
    CNPair* _items;
    PGVec2 _point;
}
@property (nonatomic, readonly) CNPair* items;
@property (nonatomic, readonly) PGVec2 point;

+ (instancetype)intersectionWithItems:(CNPair*)items point:(PGVec2)point;
- (instancetype)initWithItems:(CNPair*)items point:(PGVec2)point;
- (CNClassType*)type;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface PGBentleyOttmannEvent : NSObject
+ (instancetype)bentleyOttmannEvent;
- (instancetype)init;
- (CNClassType*)type;
- (PGVec2)point;
- (BOOL)isIntersection;
- (BOOL)isStart;
- (BOOL)isEnd;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGBentleyOttmannPointEvent : PGBentleyOttmannEvent {
@public
    BOOL _isStart;
    id _data;
    PGLineSegment* _segment;
    PGVec2 _point;
}
@property (nonatomic, readonly) BOOL isStart;
@property (nonatomic, readonly) id data;
@property (nonatomic, readonly) PGLineSegment* segment;
@property (nonatomic, readonly) PGVec2 point;

+ (instancetype)bentleyOttmannPointEventWithIsStart:(BOOL)isStart data:(id)data segment:(PGLineSegment*)segment point:(PGVec2)point;
- (instancetype)initWithIsStart:(BOOL)isStart data:(id)data segment:(PGLineSegment*)segment point:(PGVec2)point;
- (CNClassType*)type;
- (CGFloat)yForX:(CGFloat)x;
- (CGFloat)slope;
- (BOOL)isVertical;
- (BOOL)isEnd;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGBentleyOttmannIntersectionEvent : PGBentleyOttmannEvent {
@public
    PGVec2 _point;
}
@property (nonatomic, readonly) PGVec2 point;

+ (instancetype)bentleyOttmannIntersectionEventWithPoint:(PGVec2)point;
- (instancetype)initWithPoint:(PGVec2)point;
- (CNClassType*)type;
- (BOOL)isIntersection;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGBentleyOttmannEventQueue : NSObject {
@public
    CNMTreeMap* _events;
}
@property (nonatomic, readonly) CNMTreeMap* events;

+ (instancetype)bentleyOttmannEventQueue;
- (instancetype)init;
- (CNClassType*)type;
- (BOOL)isEmpty;
+ (PGBentleyOttmannEventQueue*)newWithSegments:(NSArray*)segments sweepLine:(PGSweepLine*)sweepLine;
- (void)offerPoint:(PGVec2)point event:(PGBentleyOttmannEvent*)event;
- (id<CNSeq>)poll;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGSweepLine : NSObject {
@public
    CNMTreeSet* _events;
    CNMHashMap* _intersections;
    PGVec2 _currentEventPoint;
    PGBentleyOttmannEventQueue* _queue;
}
@property (nonatomic, retain) CNMTreeSet* events;
@property (nonatomic, readonly) CNMHashMap* intersections;
@property (nonatomic) PGBentleyOttmannEventQueue* queue;

+ (instancetype)sweepLine;
- (instancetype)init;
- (CNClassType*)type;
- (void)handleEvents:(id<CNSeq>)events;
- (NSString*)description;
+ (CNClassType*)type;
@end


