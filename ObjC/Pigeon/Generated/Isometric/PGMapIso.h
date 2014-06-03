#import "objd.h"
#import "PGVec.h"
@class CNChain;

@class PGMapSso;
typedef struct PGCameraReserve PGCameraReserve;
typedef struct PGMapTileCutState PGMapTileCutState;

struct PGCameraReserve {
    float left;
    float right;
    float top;
    float bottom;
};
static inline PGCameraReserve PGCameraReserveMake(float left, float right, float top, float bottom) {
    return (PGCameraReserve){left, right, top, bottom};
}
float pgCameraReserveWidth(PGCameraReserve self);
float pgCameraReserveHeight(PGCameraReserve self);
PGCameraReserve pgCameraReserveMulF4(PGCameraReserve self, float f4);
PGCameraReserve pgCameraReserveDivF4(PGCameraReserve self, float f4);
NSString* pgCameraReserveDescription(PGCameraReserve self);
BOOL pgCameraReserveIsEqualTo(PGCameraReserve self, PGCameraReserve to);
NSUInteger pgCameraReserveHash(PGCameraReserve self);
CNPType* pgCameraReserveType();
@interface PGCameraReserveWrap : NSObject
@property (readonly, nonatomic) PGCameraReserve value;

+ (id)wrapWithValue:(PGCameraReserve)value;
- (id)initWithValue:(PGCameraReserve)value;
@end



@interface PGMapSso : NSObject {
@protected
    PGVec2i _size;
    PGRectI _limits;
    NSArray* _fullTiles;
    NSArray* _partialTiles;
    NSArray* _allTiles;
}
@property (nonatomic, readonly) PGVec2i size;
@property (nonatomic, readonly) PGRectI limits;
@property (nonatomic, readonly) NSArray* fullTiles;
@property (nonatomic, readonly) NSArray* partialTiles;
@property (nonatomic, readonly) NSArray* allTiles;

+ (instancetype)mapSsoWithSize:(PGVec2i)size;
- (instancetype)initWithSize:(PGVec2i)size;
- (CNClassType*)type;
- (BOOL)isFullTile:(PGVec2i)tile;
- (BOOL)isPartialTile:(PGVec2i)tile;
- (BOOL)isLeftTile:(PGVec2i)tile;
- (BOOL)isTopTile:(PGVec2i)tile;
- (BOOL)isRightTile:(PGVec2i)tile;
- (BOOL)isBottomTile:(PGVec2i)tile;
- (BOOL)isVisibleTile:(PGVec2i)tile;
- (BOOL)isVisibleVec2:(PGVec2)vec2;
- (PGVec2)distanceToMapVec2:(PGVec2)vec2;
- (PGMapTileCutState)cutStateForTile:(PGVec2i)tile;
- (NSString*)description;
+ (CGFloat)ISO;
+ (CNClassType*)type;
@end


struct PGMapTileCutState {
    NSInteger x;
    NSInteger y;
    NSInteger x2;
    NSInteger y2;
};
static inline PGMapTileCutState PGMapTileCutStateMake(NSInteger x, NSInteger y, NSInteger x2, NSInteger y2) {
    return (PGMapTileCutState){x, y, x2, y2};
}
NSString* pgMapTileCutStateDescription(PGMapTileCutState self);
BOOL pgMapTileCutStateIsEqualTo(PGMapTileCutState self, PGMapTileCutState to);
NSUInteger pgMapTileCutStateHash(PGMapTileCutState self);
CNPType* pgMapTileCutStateType();
@interface PGMapTileCutStateWrap : NSObject
@property (readonly, nonatomic) PGMapTileCutState value;

+ (id)wrapWithValue:(PGMapTileCutState)value;
- (id)initWithValue:(PGMapTileCutState)value;
@end



