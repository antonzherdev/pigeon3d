#import "PGBentleyOttmannTest.h"

#import "PGFigure.h"
#import "PGBentleyOttmann.h"
@implementation PGBentleyOttmannTest
static CNClassType* _PGBentleyOttmannTest_type;

+ (instancetype)bentleyOttmannTest {
    return [[PGBentleyOttmannTest alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGBentleyOttmannTest class]) _PGBentleyOttmannTest_type = [CNClassType classTypeWithCls:[PGBentleyOttmannTest class]];
}

- (void)testMain {
    id<CNSet> r = [PGBentleyOttmann intersectionsForSegments:(@[tuple(@1, [PGLineSegment newWithX1:-1.0 y1:-1.0 x2:2.0 y2:2.0]), tuple(@2, [PGLineSegment newWithX1:-2.0 y1:1.0 x2:2.0 y2:1.0]), tuple(@3, [PGLineSegment newWithX1:-2.0 y1:2.0 x2:1.0 y2:-1.0])])];
    id<CNSet> e = [(@[[PGIntersection intersectionWithItems:[CNPair pairWithA:@1 b:@2] point:PGVec2Make(1.0, 1.0)], [PGIntersection intersectionWithItems:[CNPair pairWithA:@1 b:@3] point:PGVec2Make(0.0, 0.0)], [PGIntersection intersectionWithItems:[CNPair pairWithA:@2 b:@3] point:PGVec2Make(-1.0, 1.0)]]) toSet];
    assertEquals(e, r);
}

- (void)testInPoint {
    id<CNSet> r = [PGBentleyOttmann intersectionsForSegments:(@[tuple(@1, [PGLineSegment newWithX1:-1.0 y1:-1.0 x2:2.0 y2:2.0]), tuple(@3, [PGLineSegment newWithX1:-2.0 y1:2.0 x2:0.0 y2:0.0])])];
    assertEquals(([(@[[PGIntersection intersectionWithItems:[CNPair pairWithA:@1 b:@3] point:PGVec2Make(0.0, 0.0)]]) toSet]), r);
}

- (void)testNoCross {
    id<CNSet> r = [PGBentleyOttmann intersectionsForSegments:(@[tuple(@1, [PGLineSegment newWithX1:-1.0 y1:-1.0 x2:2.0 y2:2.0]), tuple(@3, [PGLineSegment newWithX1:-1.0 y1:-1.0 x2:2.0 y2:0.0])])];
    assertTrue([r isEmpty]);
}

- (void)testVertical {
    id<CNSet> r = [PGBentleyOttmann intersectionsForSegments:(@[tuple(@1, [PGLineSegment newWithX1:-1.0 y1:-1.0 x2:2.0 y2:2.0]), tuple(@2, [PGLineSegment newWithX1:1.0 y1:-2.0 x2:1.0 y2:2.0]), tuple(@3, [PGLineSegment newWithX1:1.0 y1:-4.0 x2:1.0 y2:0.0]), tuple(@4, [PGLineSegment newWithX1:-1.0 y1:-1.0 x2:2.0 y2:-4.0]), tuple(@5, [PGLineSegment newWithX1:-1.0 y1:-1.0 x2:2.0 y2:-1.0])])];
    id<CNSet> e = [(@[[PGIntersection intersectionWithItems:[CNPair pairWithA:@3 b:@4] point:PGVec2Make(1.0, -3.0)], [PGIntersection intersectionWithItems:[CNPair pairWithA:@2 b:@5] point:PGVec2Make(1.0, -1.0)], [PGIntersection intersectionWithItems:[CNPair pairWithA:@1 b:@2] point:PGVec2Make(1.0, 1.0)], [PGIntersection intersectionWithItems:[CNPair pairWithA:@3 b:@5] point:PGVec2Make(1.0, -1.0)]]) toSet];
    assertEquals(e, r);
}

- (void)testVerticalInPoint {
    id<CNSet> r = [PGBentleyOttmann intersectionsForSegments:(@[tuple(@1, [PGLineSegment newWithX1:0.0 y1:0.0 x2:0.0 y2:1.0]), tuple(@2, [PGLineSegment newWithX1:-1.0 y1:1.0 x2:1.0 y2:1.0]), tuple(@3, [PGLineSegment newWithX1:-1.0 y1:0.0 x2:1.0 y2:0.0])])];
    id<CNSet> e = [(@[[PGIntersection intersectionWithItems:[CNPair pairWithA:@1 b:@2] point:PGVec2Make(0.0, 1.0)], [PGIntersection intersectionWithItems:[CNPair pairWithA:@1 b:@3] point:PGVec2Make(0.0, 0.0)]]) toSet];
    assertEquals(e, r);
}

- (void)testOneStart {
    id<CNSet> r = [PGBentleyOttmann intersectionsForSegments:(@[tuple(@1, [PGLineSegment newWithX1:-1.0 y1:1.0 x2:1.0 y2:-1.0]), tuple(@2, [PGLineSegment newWithX1:-1.0 y1:1.0 x2:2.0 y2:1.0]), tuple(@3, [PGLineSegment newWithX1:-1.0 y1:-1.0 x2:2.0 y2:2.0])])];
    id<CNSet> e = [(@[[PGIntersection intersectionWithItems:[CNPair pairWithA:@1 b:@3] point:PGVec2Make(0.0, 0.0)], [PGIntersection intersectionWithItems:[CNPair pairWithA:@2 b:@3] point:PGVec2Make(1.0, 1.0)]]) toSet];
    assertEquals(e, r);
}

- (void)testOneEnd {
    id<CNSet> r = [PGBentleyOttmann intersectionsForSegments:(@[tuple(@1, [PGLineSegment newWithX1:-2.0 y1:1.0 x2:1.0 y2:1.0]), tuple(@2, [PGLineSegment newWithX1:-1.0 y1:-1.0 x2:1.0 y2:1.0]), tuple(@3, [PGLineSegment newWithX1:-2.0 y1:2.0 x2:2.0 y2:-2.0])])];
    id<CNSet> e = [(@[[PGIntersection intersectionWithItems:[CNPair pairWithA:@1 b:@3] point:PGVec2Make(-1.0, 1.0)], [PGIntersection intersectionWithItems:[CNPair pairWithA:@2 b:@3] point:PGVec2Make(0.0, 0.0)]]) toSet];
    assertEquals(e, r);
}

- (void)testSameLines {
    id<CNSet> r = [PGBentleyOttmann intersectionsForSegments:(@[tuple(@1, [PGLineSegment newWithX1:-1.0 y1:1.0 x2:1.0 y2:-1.0]), tuple(@2, [PGLineSegment newWithX1:-1.0 y1:1.0 x2:1.0 y2:-1.0]), tuple(@3, [PGLineSegment newWithX1:-1.0 y1:-1.0 x2:2.0 y2:2.0])])];
    id<CNSet> e = [(@[[PGIntersection intersectionWithItems:[CNPair pairWithA:@1 b:@2] point:PGVec2Make(0.0, 0.0)], [PGIntersection intersectionWithItems:[CNPair pairWithA:@2 b:@3] point:PGVec2Make(0.0, 0.0)], [PGIntersection intersectionWithItems:[CNPair pairWithA:@1 b:@3] point:PGVec2Make(0.0, 0.0)]]) toSet];
    assertEquals(e, r);
}

- (NSString*)description {
    return @"BentleyOttmannTest";
}

- (CNClassType*)type {
    return [PGBentleyOttmannTest type];
}

+ (CNClassType*)type {
    return _PGBentleyOttmannTest_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

