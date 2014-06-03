#import "objd.h"
#import "TSTestCase.h"
#import "PGVec.h"
@class PGMapSso;
@class CNChain;

@class PGMapSsoTest;

@interface PGMapSsoTest : TSTestCase
+ (instancetype)mapSsoTest;
- (instancetype)init;
- (CNClassType*)type;
- (void)testFullPartialTile;
- (void)testFullTiles;
- (void)testPartialTiles;
- (NSString*)description;
+ (CNClassType*)type;
@end


