#import "PGStat.h"

#import "CNReact.h"
#import "PGText.h"
#import "PGContext.h"
#import "PGMaterial.h"
@implementation PGStat
static CNClassType* _PGStat_type;

+ (instancetype)stat {
    return [[PGStat alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) {
        _accumDelta = 0.0;
        _framesCount = 0;
        __frameRate = 0.0;
        _textVar = [CNVar applyInitial:@""];
        _text = [PGText applyFont:[CNReact applyValue:[PGGlobal mainFontWithSize:18]] text:_textVar position:[CNReact applyValue:wrap(PGVec3, (PGVec3Make(-0.98, -0.99, 0.0)))] alignment:[CNReact applyValue:wrap(PGTextAlignment, pgTextAlignmentLeft())] color:[CNReact applyValue:wrap(PGVec4, (PGVec4Make(1.0, 1.0, 1.0, 1.0)))]];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGStat class]) _PGStat_type = [CNClassType classTypeWithCls:[PGStat class]];
}

- (CGFloat)frameRate {
    return __frameRate;
}

- (void)draw {
    PGEnablingState* __il__0__tmp__il__0self = [PGGlobal context]->_blend;
    {
        BOOL __il__0__il__0changed = [__il__0__tmp__il__0self enable];
        {
            [[PGGlobal context] setBlendFunction:[PGBlendFunction standard]];
            [_text draw];
        }
        if(__il__0__il__0changed) [__il__0__tmp__il__0self disable];
    }
}

- (void)tickWithDelta:(CGFloat)delta {
    _accumDelta += delta;
    _framesCount++;
    if(_accumDelta > 1.0) {
        __frameRate = _framesCount / _accumDelta;
        [_textVar setValue:[NSString stringWithFormat:@"%ld", (long)floatRound(__frameRate)]];
        _accumDelta = 0.0;
        _framesCount = 0;
    }
}

- (NSString*)description {
    return @"Stat";
}

- (CNClassType*)type {
    return [PGStat type];
}

+ (CNClassType*)type {
    return _PGStat_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

