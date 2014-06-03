#import "PGPerlinTest.h"

#import "PGPerlin.h"
#import "CNChain.h"
@implementation PGPerlinTest
static CNClassType* _PGPerlinTest_type;

+ (instancetype)perlinTest {
    return [[PGPerlinTest alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGPerlinTest class]) _PGPerlinTest_type = [CNClassType classTypeWithCls:[PGPerlinTest class]];
}

- (void)testMain {
    PGPerlin1* noise = [PGPerlin1 applyOctaves:2 frequency:10.0 amplitude:1.0];
    NSArray* a = [[[intTo(1, 100) chain] mapF:^id(id i) {
        return numf([noise applyX:unumi(i) / 100.0]);
    }] toArray];
    for(id v in a) {
        assertTrue((floatBetween(unumf(v), -1.0, 1.0)));
    }
    CGFloat s = unumf(([[a chain] foldStart:@0.0 by:^id(id r, id i) {
        return numf(unumf(r) + unumf(i));
    }]));
    assertTrue((!(eqf(s, 0))));
}

- (NSString*)description {
    return @"PerlinTest";
}

- (CNClassType*)type {
    return [PGPerlinTest type];
}

+ (CNClassType*)type {
    return _PGPerlinTest_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

