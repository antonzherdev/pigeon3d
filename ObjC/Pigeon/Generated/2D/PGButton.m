#import "PGButton.h"

#import "PGSprite.h"
#import "PGText.h"
#import "CNObserver.h"
#import "PGInput.h"
#import "CNReact.h"
@implementation PGButton
static CNClassType* _PGButton_type;
@synthesize sprite = _sprite;
@synthesize text = _text;

+ (instancetype)buttonWithSprite:(PGSprite*)sprite text:(PGText*)text {
    return [[PGButton alloc] initWithSprite:sprite text:text];
}

- (instancetype)initWithSprite:(PGSprite*)sprite text:(PGText*)text {
    self = [super init];
    if(self) {
        _sprite = sprite;
        _text = text;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGButton class]) _PGButton_type = [CNClassType classTypeWithCls:[PGButton class]];
}

- (CNSignal*)tap {
    return _sprite.tap;
}

- (void)draw {
    [_sprite draw];
    [_text draw];
}

- (BOOL)tapEvent:(id<PGEvent>)event {
    return [_sprite tapEvent:event];
}

+ (PGButton*)applyVisible:(CNReact*)visible font:(CNReact*)font text:(CNReact*)text textColor:(CNReact*)textColor backgroundMaterial:(CNReact*)backgroundMaterial position:(CNReact*)position rect:(CNReact*)rect {
    return [PGButton buttonWithSprite:[PGSprite spriteWithVisible:visible material:backgroundMaterial position:position rect:rect] text:[PGText applyVisible:visible font:font text:text position:position alignment:[rect mapF:^id(id r) {
        return wrap(PGTextAlignment, (PGTextAlignmentMake(0.0, 0.0, NO, (pgRectCenter((uwrap(PGRect, r)))))));
    }] color:textColor]];
}

+ (PGButton*)applyFont:(CNReact*)font text:(CNReact*)text textColor:(CNReact*)textColor backgroundMaterial:(CNReact*)backgroundMaterial position:(CNReact*)position rect:(CNReact*)rect {
    return [PGButton applyVisible:[CNReact applyValue:@YES] font:font text:text textColor:textColor backgroundMaterial:backgroundMaterial position:position rect:rect];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Button(%@, %@)", _sprite, _text];
}

- (CNClassType*)type {
    return [PGButton type];
}

+ (CNClassType*)type {
    return _PGButton_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

