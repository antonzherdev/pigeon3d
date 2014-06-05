#import "PGMapIso.h"

#import "CNChain.h"
float pgCameraReserveWidth(PGCameraReserve self) {
    return self.left + self.right;
}
float pgCameraReserveHeight(PGCameraReserve self) {
    return self.top + self.bottom;
}
PGCameraReserve pgCameraReserveMulF4(PGCameraReserve self, float f4) {
    return PGCameraReserveMake(self.left * f4, self.right * f4, self.top * f4, self.bottom * f4);
}
PGCameraReserve pgCameraReserveDivF4(PGCameraReserve self, float f4) {
    return PGCameraReserveMake(self.left / f4, self.right / f4, self.top / f4, self.bottom / f4);
}
NSString* pgCameraReserveDescription(PGCameraReserve self) {
    return [NSString stringWithFormat:@"CameraReserve(%f, %f, %f, %f)", self.left, self.right, self.top, self.bottom];
}
BOOL pgCameraReserveIsEqualTo(PGCameraReserve self, PGCameraReserve to) {
    return eqf4(self.left, to.left) && eqf4(self.right, to.right) && eqf4(self.top, to.top) && eqf4(self.bottom, to.bottom);
}
NSUInteger pgCameraReserveHash(PGCameraReserve self) {
    NSUInteger hash = 0;
    hash = hash * 31 + float4Hash(self.left);
    hash = hash * 31 + float4Hash(self.right);
    hash = hash * 31 + float4Hash(self.top);
    hash = hash * 31 + float4Hash(self.bottom);
    return hash;
}
CNPType* pgCameraReserveType() {
    static CNPType* _ret = nil;
    if(_ret == nil) _ret = [CNPType typeWithCls:[PGCameraReserveWrap class] name:@"PGCameraReserve" size:sizeof(PGCameraReserve) wrap:^id(void* data, NSUInteger i) {
        return wrap(PGCameraReserve, ((PGCameraReserve*)(data))[i]);
    }];
    return _ret;
}
@implementation PGCameraReserveWrap{
    PGCameraReserve _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(PGCameraReserve)value {
    return [[PGCameraReserveWrap alloc] initWithValue:value];
}

- (id)initWithValue:(PGCameraReserve)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return pgCameraReserveDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    PGCameraReserveWrap* o = ((PGCameraReserveWrap*)(other));
    return pgCameraReserveIsEqualTo(_value, o.value);
}

- (NSUInteger)hash {
    return pgCameraReserveHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


@implementation PGMapSso
static CGFloat _PGMapSso_ISO = 0.70710678118655;
static CNClassType* _PGMapSso_type;
@synthesize size = _size;
@synthesize limits = _limits;
@synthesize fullTiles = _fullTiles;
@synthesize partialTiles = _partialTiles;
@synthesize allTiles = _allTiles;

+ (instancetype)mapSsoWithSize:(PGVec2i)size {
    return [[PGMapSso alloc] initWithSize:size];
}

- (instancetype)initWithSize:(PGVec2i)size {
    self = [super init];
    if(self) {
        _size = size;
        _limits = pgVec2iRectToVec2i((PGVec2iMake((1 - size.y) / 2 - 1, (1 - size.x) / 2 - 1)), (PGVec2iMake((2 * size.x + size.y - 3) / 2 + 1, (size.x + 2 * size.y - 3) / 2 + 1)));
        _fullTiles = [[[self allPosibleTiles] filterWhen:^BOOL(id _) {
            return [self isFullTile:uwrap(PGVec2i, _)];
        }] toArray];
        _partialTiles = [[[self allPosibleTiles] filterWhen:^BOOL(id _) {
            return [self isPartialTile:uwrap(PGVec2i, _)];
        }] toArray];
        _allTiles = [_fullTiles addSeq:_partialTiles];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGMapSso class]) _PGMapSso_type = [CNClassType classTypeWithCls:[PGMapSso class]];
}

- (BOOL)isFullTile:(PGVec2i)tile {
    return tile.y + tile.x >= 0 && tile.y - tile.x <= _size.y - 1 && tile.y + tile.x <= _size.x + _size.y - 2 && tile.y - tile.x >= -_size.x + 1;
}

- (BOOL)isPartialTile:(PGVec2i)tile {
    return tile.y + tile.x >= -1 && tile.y - tile.x <= _size.y && tile.y + tile.x <= _size.x + _size.y - 1 && tile.y - tile.x >= -_size.x && (tile.y + tile.x == -1 || tile.y - tile.x == _size.y || tile.y + tile.x == _size.x + _size.y - 1 || tile.y - tile.x == -_size.x);
}

- (BOOL)isLeftTile:(PGVec2i)tile {
    return tile.y + tile.x == -1;
}

- (BOOL)isTopTile:(PGVec2i)tile {
    return tile.y - tile.x == _size.y;
}

- (BOOL)isRightTile:(PGVec2i)tile {
    return tile.y + tile.x == _size.x + _size.y - 1;
}

- (BOOL)isBottomTile:(PGVec2i)tile {
    return tile.y - tile.x == -_size.x;
}

- (BOOL)isVisibleTile:(PGVec2i)tile {
    return tile.y + tile.x >= -1 && tile.y - tile.x <= _size.y && tile.y + tile.x <= _size.x + _size.y - 1 && tile.y - tile.x >= -_size.x;
}

- (BOOL)isVisibleVec2:(PGVec2)vec2 {
    return vec2.y + vec2.x >= -1 && vec2.y - vec2.x <= _size.y && vec2.y + vec2.x <= _size.x + _size.y - 1 && vec2.y - vec2.x >= -_size.x;
}

- (PGVec2)distanceToMapVec2:(PGVec2)vec2 {
    return PGVec2Make(((vec2.y + vec2.x < -1) ? vec2.y + vec2.x + 1 : ((vec2.y + vec2.x > _size.x + _size.y - 1) ? (vec2.y + vec2.x - _size.x) - _size.y + 1 : 0.0)), ((vec2.y - vec2.x > _size.y) ? (vec2.y - vec2.x) - _size.y : ((vec2.y - vec2.x < -_size.x) ? vec2.y - vec2.x + _size.x : 0.0)));
}

- (CNChain*)allPosibleTiles {
    return [[[[CNRange rangeWithStart:pgRectIX(_limits) end:pgRectIX2(_limits) step:1] chain] mulBy:[CNRange rangeWithStart:pgRectIY(_limits) end:pgRectIY2(_limits) step:1]] mapF:^id(CNTuple* _) {
        return wrap(PGVec2i, (PGVec2iMake(unumi(((CNTuple*)(_))->_a), unumi(((CNTuple*)(_))->_b))));
    }];
}

- (NSInteger)tileCutAxisLess:(NSInteger)less more:(NSInteger)more {
    if(less == more) {
        return 1;
    } else {
        if(less < more) return 0;
        else return 2;
    }
}

- (PGMapTileCutState)cutStateForTile:(PGVec2i)tile {
    return PGMapTileCutStateMake([self tileCutAxisLess:0 more:tile.x + tile.y], [self tileCutAxisLess:tile.y - tile.x more:_size.y - 1], [self tileCutAxisLess:tile.x + tile.y more:_size.x + _size.y - 2], [self tileCutAxisLess:-_size.x + 1 more:tile.y - tile.x]);
}

- (NSString*)description {
    return [NSString stringWithFormat:@"MapSso(%@)", pgVec2iDescription(_size)];
}

- (CNClassType*)type {
    return [PGMapSso type];
}

+ (CGFloat)ISO {
    return _PGMapSso_ISO;
}

+ (CNClassType*)type {
    return _PGMapSso_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

NSString* pgMapTileCutStateDescription(PGMapTileCutState self) {
    return [NSString stringWithFormat:@"MapTileCutState(%ld, %ld, %ld, %ld)", (long)self.x, (long)self.y, (long)self.x2, (long)self.y2];
}
BOOL pgMapTileCutStateIsEqualTo(PGMapTileCutState self, PGMapTileCutState to) {
    return self.x == to.x && self.y == to.y && self.x2 == to.x2 && self.y2 == to.y2;
}
NSUInteger pgMapTileCutStateHash(PGMapTileCutState self) {
    NSUInteger hash = 0;
    hash = hash * 31 + self.x;
    hash = hash * 31 + self.y;
    hash = hash * 31 + self.x2;
    hash = hash * 31 + self.y2;
    return hash;
}
CNPType* pgMapTileCutStateType() {
    static CNPType* _ret = nil;
    if(_ret == nil) _ret = [CNPType typeWithCls:[PGMapTileCutStateWrap class] name:@"PGMapTileCutState" size:sizeof(PGMapTileCutState) wrap:^id(void* data, NSUInteger i) {
        return wrap(PGMapTileCutState, ((PGMapTileCutState*)(data))[i]);
    }];
    return _ret;
}
@implementation PGMapTileCutStateWrap{
    PGMapTileCutState _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(PGMapTileCutState)value {
    return [[PGMapTileCutStateWrap alloc] initWithValue:value];
}

- (id)initWithValue:(PGMapTileCutState)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return pgMapTileCutStateDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    PGMapTileCutStateWrap* o = ((PGMapTileCutStateWrap*)(other));
    return pgMapTileCutStateIsEqualTo(_value, o.value);
}

- (NSUInteger)hash {
    return pgMapTileCutStateHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


