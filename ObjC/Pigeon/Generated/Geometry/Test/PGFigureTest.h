#import "objd.h"
#import "TSTestCase.h"
#import "PGVec.h"
@class PGLineSegment;
@class PGThickLineSegment;
@class PGPolygon;

@class PGFigureTest;

@interface PGFigureTest : TSTestCase
+ (instancetype)figureTest;
- (instancetype)init;
- (CNClassType*)type;
- (void)testThickLine;
- (NSString*)description;
+ (CNClassType*)type;
@end


