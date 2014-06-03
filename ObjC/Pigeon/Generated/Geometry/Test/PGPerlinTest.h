#import "objd.h"
#import "TSTestCase.h"
@class PGPerlin1;
@class CNChain;

@class PGPerlinTest;

@interface PGPerlinTest : TSTestCase
+ (instancetype)perlinTest;
- (instancetype)init;
- (CNClassType*)type;
- (void)testMain;
- (NSString*)description;
+ (CNClassType*)type;
@end


