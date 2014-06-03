#import "PGFigureTest.h"

#import "PGFigure.h"
#import "math.h"
@implementation PGFigureTest
static CNClassType* _PGFigureTest_type;

+ (instancetype)figureTest {
    return [[PGFigureTest alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGFigureTest class]) _PGFigureTest_type = [CNClassType classTypeWithCls:[PGFigureTest class]];
}

- (void)testThickLine {
    PGThickLineSegment* l = [PGThickLineSegment thickLineSegmentWithSegment:[PGLineSegment lineSegmentWithP0:PGVec2Make(0.0, 0.0) p1:PGVec2Make(1.0, 0.0)] thickness:1.0];
    assertEquals((wrap(PGRect, [l boundingRect])), (wrap(PGRect, (pgRectApplyXYWidthHeight(0.0, -0.5, 1.0, 1.0)))));
    PGPolygon* p = [PGPolygon polygonWithPoints:(@[wrap(PGVec2, (PGVec2Make(0.0, 0.5))), wrap(PGVec2, (PGVec2Make(0.0, -0.5))), wrap(PGVec2, (PGVec2Make(1.0, -0.5))), wrap(PGVec2, (PGVec2Make(1.0, 0.5)))])];
    assertEquals([[l segments] toSet], [p.segments toSet]);
    l = [PGThickLineSegment thickLineSegmentWithSegment:[PGLineSegment lineSegmentWithP0:PGVec2Make(0.0, 0.0) p1:PGVec2Make(0.0, 1.0)] thickness:1.0];
    assertEquals((wrap(PGRect, [l boundingRect])), (wrap(PGRect, (pgRectApplyXYWidthHeight(-0.5, 0.0, 1.0, 1.0)))));
    p = [PGPolygon polygonWithPoints:(@[wrap(PGVec2, (PGVec2Make(0.5, 0.0))), wrap(PGVec2, (PGVec2Make(-0.5, 0.0))), wrap(PGVec2, (PGVec2Make(-0.5, 1.0))), wrap(PGVec2, (PGVec2Make(0.5, 1.0)))])];
    assertEquals([[l segments] toSet], [p.segments toSet]);
    CGFloat s2 = sqrt(2.0);
    l = [PGThickLineSegment thickLineSegmentWithSegment:[PGLineSegment lineSegmentWithP0:PGVec2Make(0.0, 0.0) p1:PGVec2Make(1.0, 1.0)] thickness:s2];
    assertEquals((wrap(PGRect, [l boundingRect])), (wrap(PGRect, (pgRectThickenHalfSize((pgRectApplyXYWidthHeight(0.0, 0.0, 1.0, 1.0)), (PGVec2Make(((float)(s2 / 2)), ((float)(s2 / 2)))))))));
    p = [PGPolygon polygonWithPoints:(@[wrap(PGVec2, (PGVec2Make(-0.5, 0.5))), wrap(PGVec2, (PGVec2Make(0.5, 1.5))), wrap(PGVec2, (PGVec2Make(1.5, 0.5))), wrap(PGVec2, (PGVec2Make(0.5, -0.5)))])];
    assertEquals([[l segments] toSet], [p.segments toSet]);
}

- (NSString*)description {
    return @"FigureTest";
}

- (CNClassType*)type {
    return [PGFigureTest type];
}

+ (CNClassType*)type {
    return _PGFigureTest_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

