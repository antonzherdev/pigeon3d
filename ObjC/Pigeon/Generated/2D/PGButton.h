#import "objd.h"
#import "PGVec.h"
#import "PGFont.h"
@class PGSprite;
@class PGText;
@class CNSignal;
@protocol PGEvent;
@class CNReact;

@class PGButton;

@interface PGButton : NSObject {
@protected
    PGSprite* _sprite;
    PGText* _text;
}
@property (nonatomic, readonly) PGSprite* sprite;
@property (nonatomic, readonly) PGText* text;

+ (instancetype)buttonWithSprite:(PGSprite*)sprite text:(PGText*)text;
- (instancetype)initWithSprite:(PGSprite*)sprite text:(PGText*)text;
- (CNClassType*)type;
- (CNSignal*)tap;
- (void)draw;
- (BOOL)tapEvent:(id<PGEvent>)event;
+ (PGButton*)applyVisible:(CNReact*)visible font:(CNReact*)font text:(CNReact*)text textColor:(CNReact*)textColor backgroundMaterial:(CNReact*)backgroundMaterial position:(CNReact*)position rect:(CNReact*)rect;
+ (PGButton*)applyFont:(CNReact*)font text:(CNReact*)text textColor:(CNReact*)textColor backgroundMaterial:(CNReact*)backgroundMaterial position:(CNReact*)position rect:(CNReact*)rect;
- (NSString*)description;
+ (CNClassType*)type;
@end


