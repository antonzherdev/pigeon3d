#import "objd.h"

@class PGLocalPlayerScore;

@interface PGLocalPlayerScore : NSObject {
@public
    long _value;
    NSUInteger _rank;
    NSUInteger _maxRank;
}
@property (nonatomic, readonly) long value;
@property (nonatomic, readonly) NSUInteger rank;
@property (nonatomic, readonly) NSUInteger maxRank;

+ (instancetype)localPlayerScoreWithValue:(long)value rank:(NSUInteger)rank maxRank:(NSUInteger)maxRank;
- (instancetype)initWithValue:(long)value rank:(NSUInteger)rank maxRank:(NSUInteger)maxRank;
- (CNClassType*)type;
- (CGFloat)percent;
- (NSString*)description;
+ (CNClassType*)type;
@end


