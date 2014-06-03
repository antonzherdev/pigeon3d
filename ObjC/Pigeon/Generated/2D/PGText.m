#import "PGText.h"

#import "CNReact.h"
#import "PGContext.h"
#import "PGFont.h"
#import "CNObserver.h"
#import "PGVertexArray.h"
#import "CNDispatchQueue.h"
#import "PGFontShader.h"
@implementation PGText
static CNClassType* _PGText_type;
@synthesize visible = _visible;
@synthesize font = _font;
@synthesize text = _text;
@synthesize position = _position;
@synthesize alignment = _alignment;
@synthesize color = _color;
@synthesize shadow = _shadow;

+ (instancetype)textWithVisible:(CNReact*)visible font:(CNReact*)font text:(CNReact*)text position:(CNReact*)position alignment:(CNReact*)alignment color:(CNReact*)color shadow:(CNReact*)shadow {
    return [[PGText alloc] initWithVisible:visible font:font text:text position:position alignment:alignment color:color shadow:shadow];
}

- (instancetype)initWithVisible:(CNReact*)visible font:(CNReact*)font text:(CNReact*)text position:(CNReact*)position alignment:(CNReact*)alignment color:(CNReact*)color shadow:(CNReact*)shadow {
    self = [super init];
    __weak PGText* _weakSelf = self;
    if(self) {
        _visible = visible;
        _font = font;
        _text = text;
        _position = position;
        _alignment = alignment;
        _color = color;
        _shadow = shadow;
        __changed = [CNReactFlag reactFlagWithInitial:YES reacts:(@[((CNReact*)(font)), ((CNReact*)(text)), ((CNReact*)(position)), ((CNReact*)(alignment)), ((CNReact*)(shadow)), ((CNReact*)(PGGlobal.context.viewSize))])];
        _fontObserver = [font mapF:^CNObserver*(PGFont* newFont) {
            return [((PGFont*)(newFont)).symbolsChanged observeF:^void(id _) {
                PGText* _self = _weakSelf;
                if(_self != nil) [_self->__changed set];
            }];
        }];
        _isEmpty = [text mapF:^id(NSString* _) {
            return numb([_ isEmpty]);
        }];
        __lazy_sizeInPoints = [CNLazy lazyWithF:^CNReact*() {
            return [CNReact asyncQueue:CNDispatchQueue.mainThread a:font b:text f:^id(PGFont* f, NSString* t) {
                return wrap(PGVec2, [((PGFont*)(f)) measureInPointsText:t]);
            }];
        }];
        __lazy_sizeInP = [CNLazy lazyWithF:^CNReact*() {
            PGText* _self = _weakSelf;
            if(_self != nil) return [CNReact asyncQueue:CNDispatchQueue.mainThread a:[_self sizeInPoints] b:PGGlobal.context.scaledViewSize f:^id(id s, id vs) {
                return wrap(PGVec2, (pgVec2DivVec2((pgVec2MulI((uwrap(PGVec2, s)), 2)), (uwrap(PGVec2, vs)))));
            }];
            else return nil;
        }];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGText class]) _PGText_type = [CNClassType classTypeWithCls:[PGText class]];
}

- (CNReact*)sizeInPoints {
    return [__lazy_sizeInPoints get];
}

- (CNReact*)sizeInP {
    return [__lazy_sizeInP get];
}

- (void)draw {
    if(!(unumb([_visible value])) || unumb([_isEmpty value])) return ;
    if(unumb([__changed value])) {
        __vao = [((PGFont*)([_font value])) vaoText:[_text value] at:uwrap(PGVec3, [_position value]) alignment:uwrap(PGTextAlignment, [_alignment value])];
        [__changed clear];
    }
    {
        PGTextShadow* sh = [_shadow value];
        if(sh != nil) [((PGSimpleVertexArray*)(__vao)) drawParam:[PGFontShaderParam fontShaderParamWithTexture:[((PGFont*)([_font value])) texture] color:pgVec4MulK(((PGTextShadow*)(sh)).color, (uwrap(PGVec4, [_color value]).w)) shift:((PGTextShadow*)(sh)).shift]];
    }
    [((PGSimpleVertexArray*)(__vao)) drawParam:[PGFontShaderParam fontShaderParamWithTexture:[((PGFont*)([_font value])) texture] color:uwrap(PGVec4, [_color value]) shift:PGVec2Make(0.0, 0.0)]];
}

- (PGVec2)measureInPoints {
    return [((PGFont*)([_font value])) measureInPointsText:[_text value]];
}

- (PGVec2)measureP {
    return [((PGFont*)([_font value])) measurePText:[_text value]];
}

- (PGVec2)measureC {
    return [((PGFont*)([_font value])) measureCText:[_text value]];
}

+ (PGText*)applyVisible:(CNReact*)visible font:(CNReact*)font text:(CNReact*)text position:(CNReact*)position alignment:(CNReact*)alignment color:(CNReact*)color {
    return [PGText textWithVisible:visible font:font text:text position:position alignment:alignment color:color shadow:[CNReact applyValue:nil]];
}

+ (PGText*)applyFont:(CNReact*)font text:(CNReact*)text position:(CNReact*)position alignment:(CNReact*)alignment color:(CNReact*)color shadow:(CNReact*)shadow {
    return [PGText textWithVisible:[CNReact applyValue:@YES] font:font text:text position:position alignment:alignment color:color shadow:shadow];
}

+ (PGText*)applyFont:(CNReact*)font text:(CNReact*)text position:(CNReact*)position alignment:(CNReact*)alignment color:(CNReact*)color {
    return [PGText textWithVisible:[CNReact applyValue:@YES] font:font text:text position:position alignment:alignment color:color shadow:[CNReact applyValue:nil]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Text(%@, %@, %@, %@, %@, %@, %@)", _visible, _font, _text, _position, _alignment, _color, _shadow];
}

- (CNClassType*)type {
    return [PGText type];
}

+ (CNClassType*)type {
    return _PGText_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGTextShadow
static CNClassType* _PGTextShadow_type;
@synthesize color = _color;
@synthesize shift = _shift;

+ (instancetype)textShadowWithColor:(PGVec4)color shift:(PGVec2)shift {
    return [[PGTextShadow alloc] initWithColor:color shift:shift];
}

- (instancetype)initWithColor:(PGVec4)color shift:(PGVec2)shift {
    self = [super init];
    if(self) {
        _color = color;
        _shift = shift;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGTextShadow class]) _PGTextShadow_type = [CNClassType classTypeWithCls:[PGTextShadow class]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"TextShadow(%@, %@)", pgVec4Description(_color), pgVec2Description(_shift)];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[PGTextShadow class]])) return NO;
    PGTextShadow* o = ((PGTextShadow*)(to));
    return pgVec4IsEqualTo(_color, o.color) && pgVec2IsEqualTo(_shift, o.shift);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + pgVec4Hash(_color);
    hash = hash * 31 + pgVec2Hash(_shift);
    return hash;
}

- (CNClassType*)type {
    return [PGTextShadow type];
}

+ (CNClassType*)type {
    return _PGTextShadow_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

