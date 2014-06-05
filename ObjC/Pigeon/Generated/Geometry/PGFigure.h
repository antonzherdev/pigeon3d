#import "objd.h"
#import "PGVec.h"
@class CNChain;

@class PGLine;
@class PGSlopeLine;
@class PGVerticalLine;
@class PGFigure_impl;
@class PGLineSegment;
@class PGPolygon;
@class PGThickLineSegment;
@protocol PGFigure;

@interface PGLine : NSObject
+ (instancetype)line;
- (instancetype)init;
- (CNClassType*)type;
+ (PGLine*)applySlope:(CGFloat)slope point:(PGVec2)point;
+ (PGLine*)applyP0:(PGVec2)p0 p1:(PGVec2)p1;
+ (CGFloat)calculateSlopeWithP0:(PGVec2)p0 p1:(PGVec2)p1;
+ (CGFloat)calculateConstantWithSlope:(CGFloat)slope point:(PGVec2)point;
- (BOOL)containsPoint:(PGVec2)point;
- (BOOL)isVertical;
- (BOOL)isHorizontal;
- (id)intersectionWithLine:(PGLine*)line;
- (CGFloat)xIntersectionWithLine:(PGLine*)line;
- (BOOL)isRightPoint:(PGVec2)point;
- (CGFloat)slope;
- (id)moveWithDistance:(CGFloat)distance;
- (CGFloat)angle;
- (CGFloat)degreeAngle;
- (PGLine*)perpendicularWithPoint:(PGVec2)point;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGSlopeLine : PGLine {
@public
    CGFloat _slope;
    CGFloat _constant;
}
@property (nonatomic, readonly) CGFloat slope;
@property (nonatomic, readonly) CGFloat constant;

+ (instancetype)slopeLineWithSlope:(CGFloat)slope constant:(CGFloat)constant;
- (instancetype)initWithSlope:(CGFloat)slope constant:(CGFloat)constant;
- (CNClassType*)type;
- (BOOL)containsPoint:(PGVec2)point;
- (BOOL)isVertical;
- (BOOL)isHorizontal;
- (CGFloat)xIntersectionWithLine:(PGLine*)line;
- (CGFloat)yForX:(CGFloat)x;
- (id)intersectionWithLine:(PGLine*)line;
- (BOOL)isRightPoint:(PGVec2)point;
- (id)moveWithDistance:(CGFloat)distance;
- (CGFloat)angle;
- (PGLine*)perpendicularWithPoint:(PGVec2)point;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface PGVerticalLine : PGLine {
@public
    CGFloat _x;
}
@property (nonatomic, readonly) CGFloat x;

+ (instancetype)verticalLineWithX:(CGFloat)x;
- (instancetype)initWithX:(CGFloat)x;
- (CNClassType*)type;
- (BOOL)containsPoint:(PGVec2)point;
- (BOOL)isVertical;
- (BOOL)isHorizontal;
- (CGFloat)xIntersectionWithLine:(PGLine*)line;
- (id)intersectionWithLine:(PGLine*)line;
- (BOOL)isRightPoint:(PGVec2)point;
- (CGFloat)slope;
- (id)moveWithDistance:(CGFloat)distance;
- (CGFloat)angle;
- (PGLine*)perpendicularWithPoint:(PGVec2)point;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@protocol PGFigure<NSObject>
- (PGRect)boundingRect;
- (NSArray*)segments;
- (NSString*)description;
@end


@interface PGFigure_impl : NSObject<PGFigure>
+ (instancetype)figure_impl;
- (instancetype)init;
@end


@interface PGLineSegment : PGFigure_impl {
@public
    PGVec2 _p0;
    PGVec2 _p1;
    BOOL _dir;
    PGLine* __line;
    PGRect _boundingRect;
}
@property (nonatomic, readonly) PGVec2 p0;
@property (nonatomic, readonly) PGVec2 p1;
@property (nonatomic, readonly) PGRect boundingRect;

+ (instancetype)lineSegmentWithP0:(PGVec2)p0 p1:(PGVec2)p1;
- (instancetype)initWithP0:(PGVec2)p0 p1:(PGVec2)p1;
- (CNClassType*)type;
+ (PGLineSegment*)newWithP0:(PGVec2)p0 p1:(PGVec2)p1;
+ (PGLineSegment*)newWithX1:(CGFloat)x1 y1:(CGFloat)y1 x2:(CGFloat)x2 y2:(CGFloat)y2;
- (BOOL)isVertical;
- (BOOL)isHorizontal;
- (PGLine*)line;
- (BOOL)containsPoint:(PGVec2)point;
- (BOOL)containsInBoundingRectPoint:(PGVec2)point;
- (id)intersectionWithSegment:(PGLineSegment*)segment;
- (BOOL)endingsContainPoint:(PGVec2)point;
- (NSArray*)segments;
- (PGLineSegment*)moveWithPoint:(PGVec2)point;
- (PGLineSegment*)moveWithX:(CGFloat)x y:(CGFloat)y;
- (PGVec2)mid;
- (CGFloat)angle;
- (CGFloat)degreeAngle;
- (float)length;
- (PGVec2)vec;
- (PGVec2)vec1;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface PGPolygon : PGFigure_impl {
@public
    NSArray* _points;
    NSArray* _segments;
}
@property (nonatomic, readonly) NSArray* points;
@property (nonatomic, readonly) NSArray* segments;

+ (instancetype)polygonWithPoints:(NSArray*)points;
- (instancetype)initWithPoints:(NSArray*)points;
- (CNClassType*)type;
- (PGRect)boundingRect;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface PGThickLineSegment : PGFigure_impl {
@public
    PGLineSegment* _segment;
    CGFloat _thickness;
    CGFloat _thickness_2;
    NSArray* __segments;
}
@property (nonatomic, readonly) PGLineSegment* segment;
@property (nonatomic, readonly) CGFloat thickness;
@property (nonatomic, readonly) CGFloat thickness_2;

+ (instancetype)thickLineSegmentWithSegment:(PGLineSegment*)segment thickness:(CGFloat)thickness;
- (instancetype)initWithSegment:(PGLineSegment*)segment thickness:(CGFloat)thickness;
- (CNClassType*)type;
- (PGRect)boundingRect;
- (NSArray*)segments;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


