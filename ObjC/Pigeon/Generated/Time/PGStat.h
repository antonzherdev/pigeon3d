#import "objd.h"
#import "PGVec.h"
#import "PGFont.h"
@class CNVar;
@class PGText;
@class PGGlobal;
@class CNReact;
@class PGContext;
@class PGEnablingState;
@class PGBlendFunction;

@class PGStat;

@interface PGStat : NSObject {
@public
    CGFloat _accumDelta;
    NSUInteger _framesCount;
    CGFloat __frameRate;
    CNVar* _textVar;
    PGText* _text;
}
+ (instancetype)stat;
- (instancetype)init;
- (CNClassType*)type;
- (CGFloat)frameRate;
- (void)draw;
- (void)tickWithDelta:(CGFloat)delta;
- (NSString*)description;
+ (CNClassType*)type;
@end


