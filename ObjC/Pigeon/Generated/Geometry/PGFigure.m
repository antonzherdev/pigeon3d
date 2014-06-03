#import "PGFigure.h"

#import "math.h"
#import "CNChain.h"
@implementation PGLine
static CNClassType* _PGLine_type;

+ (instancetype)line {
    return [[PGLine alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGLine class]) _PGLine_type = [CNClassType classTypeWithCls:[PGLine class]];
}

+ (PGLine*)applySlope:(CGFloat)slope point:(PGVec2)point {
    return [PGSlopeLine slopeLineWithSlope:slope constant:[PGLine calculateConstantWithSlope:slope point:point]];
}

+ (PGLine*)applyP0:(PGVec2)p0 p1:(PGVec2)p1 {
    if(eqf4(p0.x, p1.x)) {
        return ((PGLine*)([PGVerticalLine verticalLineWithX:((CGFloat)(p0.x))]));
    } else {
        CGFloat slope = [PGLine calculateSlopeWithP0:p0 p1:p1];
        return ((PGLine*)([PGSlopeLine slopeLineWithSlope:slope constant:[PGLine calculateConstantWithSlope:slope point:p0]]));
    }
}

+ (CGFloat)calculateSlopeWithP0:(PGVec2)p0 p1:(PGVec2)p1 {
    return ((CGFloat)((p1.y - p0.y) / (p1.x - p0.x)));
}

+ (CGFloat)calculateConstantWithSlope:(CGFloat)slope point:(PGVec2)point {
    return ((CGFloat)(point.y - slope * point.x));
}

- (BOOL)containsPoint:(PGVec2)point {
    @throw @"Method contains is abstract";
}

- (BOOL)isVertical {
    @throw @"Method isVertical is abstract";
}

- (BOOL)isHorizontal {
    @throw @"Method isHorizontal is abstract";
}

- (id)intersectionWithLine:(PGLine*)line {
    @throw @"Method intersectionWith is abstract";
}

- (CGFloat)xIntersectionWithLine:(PGLine*)line {
    @throw @"Method xIntersectionWith is abstract";
}

- (BOOL)isRightPoint:(PGVec2)point {
    @throw @"Method isRight is abstract";
}

- (CGFloat)slope {
    @throw @"Method slope is abstract";
}

- (id)moveWithDistance:(CGFloat)distance {
    @throw @"Method moveWith is abstract";
}

- (CGFloat)angle {
    @throw @"Method angle is abstract";
}

- (CGFloat)degreeAngle {
    return ([self angle] * 180) / M_PI;
}

- (PGLine*)perpendicularWithPoint:(PGVec2)point {
    @throw @"Method perpendicularWith is abstract";
}

- (NSString*)description {
    return @"Line";
}

- (CNClassType*)type {
    return [PGLine type];
}

+ (CNClassType*)type {
    return _PGLine_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGSlopeLine
static CNClassType* _PGSlopeLine_type;
@synthesize slope = _slope;
@synthesize constant = _constant;

+ (instancetype)slopeLineWithSlope:(CGFloat)slope constant:(CGFloat)constant {
    return [[PGSlopeLine alloc] initWithSlope:slope constant:constant];
}

- (instancetype)initWithSlope:(CGFloat)slope constant:(CGFloat)constant {
    self = [super init];
    if(self) {
        _slope = slope;
        _constant = constant;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGSlopeLine class]) _PGSlopeLine_type = [CNClassType classTypeWithCls:[PGSlopeLine class]];
}

- (BOOL)containsPoint:(PGVec2)point {
    return eqf4(point.y, _slope * point.x + _constant);
}

- (BOOL)isVertical {
    return NO;
}

- (BOOL)isHorizontal {
    return eqf(_slope, 0);
}

- (CGFloat)xIntersectionWithLine:(PGLine*)line {
    if([line isVertical]) {
        return [line xIntersectionWithLine:self];
    } else {
        PGSlopeLine* that = ((PGSlopeLine*)(line));
        return (that.constant - _constant) / (_slope - that.slope);
    }
}

- (CGFloat)yForX:(CGFloat)x {
    return _slope * x + _constant;
}

- (id)intersectionWithLine:(PGLine*)line {
    if(!([line isVertical]) && eqf(((PGSlopeLine*)(line)).slope, _slope)) {
        return nil;
    } else {
        CGFloat xInt = [self xIntersectionWithLine:line];
        return wrap(PGVec2, (PGVec2Make(((float)(xInt)), ((float)([self yForX:xInt])))));
    }
}

- (BOOL)isRightPoint:(PGVec2)point {
    if([self containsPoint:point]) return NO;
    else return point.y < [self yForX:((CGFloat)(point.x))];
}

- (id)moveWithDistance:(CGFloat)distance {
    return [PGSlopeLine slopeLineWithSlope:_slope constant:_constant + distance];
}

- (CGFloat)angle {
    CGFloat a = atan(_slope);
    if(a < 0) return M_PI + a;
    else return a;
}

- (PGLine*)perpendicularWithPoint:(PGVec2)point {
    if(eqf(_slope, 0)) return ((PGLine*)([PGVerticalLine verticalLineWithX:((CGFloat)(point.x))]));
    else return [PGLine applySlope:-_slope point:point];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"SlopeLine(%f, %f)", _slope, _constant];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[PGSlopeLine class]])) return NO;
    PGSlopeLine* o = ((PGSlopeLine*)(to));
    return eqf(_slope, o.slope) && eqf(_constant, o.constant);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + floatHash(_slope);
    hash = hash * 31 + floatHash(_constant);
    return hash;
}

- (CNClassType*)type {
    return [PGSlopeLine type];
}

+ (CNClassType*)type {
    return _PGSlopeLine_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGVerticalLine
static CNClassType* _PGVerticalLine_type;
@synthesize x = _x;

+ (instancetype)verticalLineWithX:(CGFloat)x {
    return [[PGVerticalLine alloc] initWithX:x];
}

- (instancetype)initWithX:(CGFloat)x {
    self = [super init];
    if(self) _x = x;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGVerticalLine class]) _PGVerticalLine_type = [CNClassType classTypeWithCls:[PGVerticalLine class]];
}

- (BOOL)containsPoint:(PGVec2)point {
    return eqf4(point.x, _x);
}

- (BOOL)isVertical {
    return YES;
}

- (BOOL)isHorizontal {
    return NO;
}

- (CGFloat)xIntersectionWithLine:(PGLine*)line {
    return _x;
}

- (id)intersectionWithLine:(PGLine*)line {
    if([line isVertical]) return nil;
    else return [line intersectionWithLine:self];
}

- (BOOL)isRightPoint:(PGVec2)point {
    return point.x > _x;
}

- (CGFloat)slope {
    return cnFloatMax();
}

- (id)moveWithDistance:(CGFloat)distance {
    return [PGVerticalLine verticalLineWithX:_x + distance];
}

- (CGFloat)angle {
    return M_PI_2;
}

- (PGLine*)perpendicularWithPoint:(PGVec2)point {
    return [PGSlopeLine slopeLineWithSlope:0.0 constant:((CGFloat)(point.y))];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"VerticalLine(%f)", _x];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[PGVerticalLine class]])) return NO;
    PGVerticalLine* o = ((PGVerticalLine*)(to));
    return eqf(_x, o.x);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + floatHash(_x);
    return hash;
}

- (CNClassType*)type {
    return [PGVerticalLine type];
}

+ (CNClassType*)type {
    return _PGVerticalLine_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGFigure_impl

+ (instancetype)figure_impl {
    return [[PGFigure_impl alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

- (PGRect)boundingRect {
    @throw @"Method boundingRect is abstract";
}

- (NSArray*)segments {
    @throw @"Method segments is abstract";
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGLineSegment
static CNClassType* _PGLineSegment_type;
@synthesize p0 = _p0;
@synthesize p1 = _p1;
@synthesize boundingRect = _boundingRect;

+ (instancetype)lineSegmentWithP0:(PGVec2)p0 p1:(PGVec2)p1 {
    return [[PGLineSegment alloc] initWithP0:p0 p1:p1];
}

- (instancetype)initWithP0:(PGVec2)p0 p1:(PGVec2)p1 {
    self = [super init];
    if(self) {
        _p0 = p0;
        _p1 = p1;
        _dir = p0.y < p1.y || (eqf4(p0.y, p1.y) && p0.x < p1.x);
        _boundingRect = pgVec2RectToVec2((PGVec2Make((float4MinB(p0.x, p1.x)), (float4MinB(p0.y, p1.y)))), (PGVec2Make((float4MaxB(p0.x, p1.x)), (float4MaxB(p0.y, p1.y)))));
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGLineSegment class]) _PGLineSegment_type = [CNClassType classTypeWithCls:[PGLineSegment class]];
}

+ (PGLineSegment*)newWithP0:(PGVec2)p0 p1:(PGVec2)p1 {
    if(pgVec2CompareTo(p0, p1) < 0) return [PGLineSegment lineSegmentWithP0:p0 p1:p1];
    else return [PGLineSegment lineSegmentWithP0:p1 p1:p0];
}

+ (PGLineSegment*)newWithX1:(CGFloat)x1 y1:(CGFloat)y1 x2:(CGFloat)x2 y2:(CGFloat)y2 {
    return [PGLineSegment newWithP0:PGVec2Make(((float)(x1)), ((float)(y1))) p1:PGVec2Make(((float)(x2)), ((float)(y2)))];
}

- (BOOL)isVertical {
    return eqf4(_p0.x, _p1.x);
}

- (BOOL)isHorizontal {
    return eqf4(_p0.y, _p1.y);
}

- (PGLine*)line {
    if(__line == nil) {
        __line = [PGLine applyP0:_p0 p1:_p1];
        return ((PGLine*)(nonnil(__line)));
    } else {
        return __line;
    }
}

- (BOOL)containsPoint:(PGVec2)point {
    return pgVec2IsEqualTo(_p0, point) || pgVec2IsEqualTo(_p1, point) || ([[self line] containsPoint:point] && pgRectContainsVec2(_boundingRect, point));
}

- (BOOL)containsInBoundingRectPoint:(PGVec2)point {
    return pgRectContainsVec2(_boundingRect, point);
}

- (id)intersectionWithSegment:(PGLineSegment*)segment {
    if(pgVec2IsEqualTo(_p0, segment.p1)) {
        return wrap(PGVec2, _p0);
    } else {
        if(pgVec2IsEqualTo(_p1, segment.p0)) {
            return wrap(PGVec2, _p0);
        } else {
            if(pgVec2IsEqualTo(_p0, segment.p0)) {
                if([[self line] isEqual:[segment line]]) return nil;
                else return wrap(PGVec2, _p0);
            } else {
                if(pgVec2IsEqualTo(_p1, segment.p1)) {
                    if([[self line] isEqual:[segment line]]) return nil;
                    else return wrap(PGVec2, _p1);
                } else {
                    id p = [[self line] intersectionWithLine:[segment line]];
                    if(p != nil) {
                        if([self containsInBoundingRectPoint:uwrap(PGVec2, p)] && [segment containsInBoundingRectPoint:uwrap(PGVec2, p)]) return ((id)(p));
                        else return nil;
                    } else {
                        return nil;
                    }
                }
            }
        }
    }
}

- (BOOL)endingsContainPoint:(PGVec2)point {
    return pgVec2IsEqualTo(_p0, point) || pgVec2IsEqualTo(_p1, point);
}

- (NSArray*)segments {
    return (@[self]);
}

- (PGLineSegment*)moveWithPoint:(PGVec2)point {
    return [self moveWithX:((CGFloat)(point.x)) y:((CGFloat)(point.y))];
}

- (PGLineSegment*)moveWithX:(CGFloat)x y:(CGFloat)y {
    PGLineSegment* ret = [PGLineSegment lineSegmentWithP0:PGVec2Make(_p0.x + x, _p0.y + y) p1:PGVec2Make(_p1.x + x, _p1.y + y)];
    [ret setLine:[[self line] moveWithDistance:x + y]];
    return ret;
}

- (void)setLine:(PGLine*)line {
    __line = line;
}

- (PGVec2)mid {
    return pgVec2MidVec2(_p0, _p1);
}

- (CGFloat)angle {
    if(_dir) return [[self line] angle];
    else return M_PI + [[self line] angle];
}

- (CGFloat)degreeAngle {
    if(_dir) return [[self line] degreeAngle];
    else return 180 + [[self line] degreeAngle];
}

- (float)length {
    return pgVec2Length((pgVec2SubVec2(_p1, _p0)));
}

- (PGVec2)vec {
    return pgVec2SubVec2(_p1, _p0);
}

- (PGVec2)vec1 {
    return pgVec2SubVec2(_p0, _p1);
}

- (NSString*)description {
    return [NSString stringWithFormat:@"LineSegment(%@, %@)", pgVec2Description(_p0), pgVec2Description(_p1)];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[PGLineSegment class]])) return NO;
    PGLineSegment* o = ((PGLineSegment*)(to));
    return pgVec2IsEqualTo(_p0, o.p0) && pgVec2IsEqualTo(_p1, o.p1);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + pgVec2Hash(_p0);
    hash = hash * 31 + pgVec2Hash(_p1);
    return hash;
}

- (CNClassType*)type {
    return [PGLineSegment type];
}

+ (CNClassType*)type {
    return _PGLineSegment_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGPolygon
static CNClassType* _PGPolygon_type;
@synthesize points = _points;
@synthesize segments = _segments;

+ (instancetype)polygonWithPoints:(NSArray*)points {
    return [[PGPolygon alloc] initWithPoints:points];
}

- (instancetype)initWithPoints:(NSArray*)points {
    self = [super init];
    if(self) {
        _points = points;
        _segments = [[[[points chain] neighboursRing] mapF:^PGLineSegment*(CNTuple* ps) {
            return [PGLineSegment newWithP0:uwrap(PGVec2, ((CNTuple*)(ps)).a) p1:uwrap(PGVec2, ((CNTuple*)(ps)).b)];
        }] toArray];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGPolygon class]) _PGPolygon_type = [CNClassType classTypeWithCls:[PGPolygon class]];
}

- (PGRect)boundingRect {
    __block CGFloat minX = cnFloatMax();
    __block CGFloat maxX = cnFloatMin();
    __block CGFloat minY = cnFloatMax();
    __block CGFloat maxY = cnFloatMin();
    for(id p in _points) {
        if(uwrap(PGVec2, p).x < minX) minX = ((CGFloat)(uwrap(PGVec2, p).x));
        if(uwrap(PGVec2, p).x > maxX) maxX = ((CGFloat)(uwrap(PGVec2, p).x));
        if(uwrap(PGVec2, p).y < minY) minY = ((CGFloat)(uwrap(PGVec2, p).y));
        if(uwrap(PGVec2, p).y > maxY) maxY = ((CGFloat)(uwrap(PGVec2, p).y));
    }
    return pgVec2RectToVec2((PGVec2Make(((float)(minX)), ((float)(minY)))), (PGVec2Make(((float)(maxX)), ((float)(maxY)))));
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Polygon(%@)", _points];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[PGPolygon class]])) return NO;
    PGPolygon* o = ((PGPolygon*)(to));
    return [_points isEqual:o.points];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [_points hash];
    return hash;
}

- (CNClassType*)type {
    return [PGPolygon type];
}

+ (CNClassType*)type {
    return _PGPolygon_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGThickLineSegment
static CNClassType* _PGThickLineSegment_type;
@synthesize segment = _segment;
@synthesize thickness = _thickness;
@synthesize thickness_2 = _thickness_2;

+ (instancetype)thickLineSegmentWithSegment:(PGLineSegment*)segment thickness:(CGFloat)thickness {
    return [[PGThickLineSegment alloc] initWithSegment:segment thickness:thickness];
}

- (instancetype)initWithSegment:(PGLineSegment*)segment thickness:(CGFloat)thickness {
    self = [super init];
    if(self) {
        _segment = segment;
        _thickness = thickness;
        _thickness_2 = thickness / 2;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGThickLineSegment class]) _PGThickLineSegment_type = [CNClassType classTypeWithCls:[PGThickLineSegment class]];
}

- (PGRect)boundingRect {
    return pgRectThickenHalfSize(_segment.boundingRect, (PGVec2Make((([_segment isHorizontal]) ? ((float)(0.0)) : ((float)(_thickness_2))), (([_segment isVertical]) ? ((float)(0.0)) : ((float)(_thickness_2))))));
}

- (NSArray*)segments {
    if(__segments == nil) {
        CGFloat dx = 0.0;
        CGFloat dy = 0.0;
        if([_segment isVertical]) {
            dx = _thickness_2;
            dy = 0.0;
        } else {
            if([_segment isHorizontal]) {
                dx = 0.0;
                dy = _thickness_2;
            } else {
                CGFloat k = [[_segment line] slope];
                dy = _thickness_2 / sqrt(1 + k);
                dx = k * dy;
            }
        }
        PGLineSegment* line1 = [_segment moveWithX:-dx y:dy];
        PGLineSegment* line2 = [_segment moveWithX:dx y:-dy];
        PGLineSegment* line3 = [PGLineSegment newWithP0:line1.p0 p1:line2.p0];
        __segments = (@[line1, line2, line3, [line3 moveWithPoint:pgVec2SubVec2(_segment.p1, _segment.p0)]]);
        return ((NSArray*)(nonnil(__segments)));
    } else {
        return __segments;
    }
}

- (NSString*)description {
    return [NSString stringWithFormat:@"ThickLineSegment(%@, %f)", _segment, _thickness];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[PGThickLineSegment class]])) return NO;
    PGThickLineSegment* o = ((PGThickLineSegment*)(to));
    return [_segment isEqual:o.segment] && eqf(_thickness, o.thickness);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [_segment hash];
    hash = hash * 31 + floatHash(_thickness);
    return hash;
}

- (CNClassType*)type {
    return [PGThickLineSegment type];
}

+ (CNClassType*)type {
    return _PGThickLineSegment_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

