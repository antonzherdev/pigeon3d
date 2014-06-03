#import "objd.h"
#import "TSTestCase.h"
#import "PGVec.h"
@class PGLineSegment;
@class PGBentleyOttmann;
@class PGIntersection;

@class PGBentleyOttmannTest;

@interface PGBentleyOttmannTest : TSTestCase
+ (instancetype)bentleyOttmannTest;
- (instancetype)init;
- (CNClassType*)type;
- (void)testMain;
- (void)testInPoint;
- (void)testNoCross;
- (void)testVertical;
- (void)testVerticalInPoint;
- (void)testOneStart;
- (void)testOneEnd;
- (void)testSameLines;
- (NSString*)description;
+ (CNClassType*)type;
@end


