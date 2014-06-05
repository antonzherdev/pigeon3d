#import "objd.h"
#import "PGVec.h"
@class CNReact;
@class CNReactFlag;
@class PGGlobal;
@class PGContext;
@class PGFont;
@class CNSignal;
@class PGSimpleVertexArray;
@class CNDispatchQueue;
@class PGFontShaderParam;

@class PGText;
@class PGTextShadow;

@interface PGText : NSObject {
@public
    CNReact* _visible;
    CNReact* _font;
    CNReact* _text;
    CNReact* _position;
    CNReact* _alignment;
    CNReact* _color;
    CNReact* _shadow;
    CNReactFlag* __changed;
    CNReact* _fontObserver;
    PGSimpleVertexArray* __vao;
    CNReact* _isEmpty;
    CNLazy* __lazy_sizeInPoints;
    CNLazy* __lazy_sizeInP;
}
@property (nonatomic, readonly) CNReact* visible;
@property (nonatomic, readonly) CNReact* font;
@property (nonatomic, readonly) CNReact* text;
@property (nonatomic, readonly) CNReact* position;
@property (nonatomic, readonly) CNReact* alignment;
@property (nonatomic, readonly) CNReact* color;
@property (nonatomic, readonly) CNReact* shadow;

+ (instancetype)textWithVisible:(CNReact*)visible font:(CNReact*)font text:(CNReact*)text position:(CNReact*)position alignment:(CNReact*)alignment color:(CNReact*)color shadow:(CNReact*)shadow;
- (instancetype)initWithVisible:(CNReact*)visible font:(CNReact*)font text:(CNReact*)text position:(CNReact*)position alignment:(CNReact*)alignment color:(CNReact*)color shadow:(CNReact*)shadow;
- (CNClassType*)type;
- (CNReact*)sizeInPoints;
- (CNReact*)sizeInP;
- (void)draw;
- (PGVec2)measureInPoints;
- (PGVec2)measureP;
- (PGVec2)measureC;
+ (PGText*)applyVisible:(CNReact*)visible font:(CNReact*)font text:(CNReact*)text position:(CNReact*)position alignment:(CNReact*)alignment color:(CNReact*)color;
+ (PGText*)applyFont:(CNReact*)font text:(CNReact*)text position:(CNReact*)position alignment:(CNReact*)alignment color:(CNReact*)color shadow:(CNReact*)shadow;
+ (PGText*)applyFont:(CNReact*)font text:(CNReact*)text position:(CNReact*)position alignment:(CNReact*)alignment color:(CNReact*)color;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGTextShadow : NSObject {
@public
    PGVec4 _color;
    PGVec2 _shift;
}
@property (nonatomic, readonly) PGVec4 color;
@property (nonatomic, readonly) PGVec2 shift;

+ (instancetype)textShadowWithColor:(PGVec4)color shift:(PGVec2)shift;
- (instancetype)initWithColor:(PGVec4)color shift:(PGVec2)shift;
- (CNClassType*)type;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


