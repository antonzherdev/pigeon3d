#import "PGMapSsoTest.h"

#import "PGMapIso.h"
#import "CNChain.h"
@implementation PGMapSsoTest
static CNClassType* _PGMapSsoTest_type;

+ (instancetype)mapSsoTest {
    return [[PGMapSsoTest alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGMapSsoTest class]) _PGMapSsoTest_type = [CNClassType classTypeWithCls:[PGMapSsoTest class]];
}

- (void)testFullPartialTile {
    PGMapSso* map = [PGMapSso mapSsoWithSize:PGVec2iMake(2, 3)];
    assertTrue(([map isFullTile:PGVec2iMake(0, 2)]));
    assertTrue(([map isFullTile:PGVec2iMake(1, 0)]));
    assertTrue(([map isFullTile:PGVec2iMake(-1, 1)]));
    assertFalse(([map isFullTile:PGVec2iMake(-1, 0)]));
    assertTrue(([map isPartialTile:PGVec2iMake(-1, 0)]));
    assertFalse(([map isFullTile:PGVec2iMake(-2, 1)]));
    assertTrue(([map isPartialTile:PGVec2iMake(-2, 1)]));
    assertFalse(([map isFullTile:PGVec2iMake(-3, 1)]));
    assertFalse(([map isPartialTile:PGVec2iMake(-3, 1)]));
}

- (void)testFullTiles {
    PGMapSso* map = [PGMapSso mapSsoWithSize:PGVec2iMake(2, 3)];
    id<CNSet> exp = [[(@[tuple(@-1, @1), tuple(@0, @0), tuple(@0, @1), tuple(@0, @2), tuple(@1, @0), tuple(@1, @1), tuple(@1, @2), tuple(@2, @1)]) chain] toSet];
    id<CNSet> tiles = [[[map->_fullTiles chain] mapF:^CNTuple*(id v) {
        return tuple((numi((uwrap(PGVec2i, v).x))), (numi((uwrap(PGVec2i, v).y))));
    }] toSet];
    assertEquals(exp, tiles);
}

- (void)testPartialTiles {
    PGMapSso* map = [PGMapSso mapSsoWithSize:PGVec2iMake(2, 3)];
    id<CNSet> exp = [[(@[tuple(@-2, @1), tuple(@-1, @0), tuple(@-1, @2), tuple(@0, @-1), tuple(@0, @3), tuple(@1, @-1), tuple(@1, @3), tuple(@2, @0), tuple(@2, @2), tuple(@3, @1)]) chain] toSet];
    id<CNSet> tiles = [[[map->_partialTiles chain] mapF:^CNTuple*(id v) {
        return tuple((numi((uwrap(PGVec2i, v).x))), (numi((uwrap(PGVec2i, v).y))));
    }] toSet];
    assertEquals(exp, tiles);
}

- (NSString*)description {
    return @"MapSsoTest";
}

- (CNClassType*)type {
    return [PGMapSsoTest type];
}

+ (CNClassType*)type {
    return _PGMapSsoTest_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

