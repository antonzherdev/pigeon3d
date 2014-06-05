#import "objd.h"
#import "PGVec.h"
@class PGVertexBufferDesc;
@class CNSignal;
@class PGTexture;
@class PGDirector;
@class PGGlobal;
@class PGContext;
@class CNReact;
@class PGMatrixStack;
@class PGMat4;
@class CNChain;
@class PGSimpleVertexArray;
@class PGVBO;
@class PGIBO;
@class PGFontShader;
@class PGCullFace;
@class PGFontShaderParam;

@class PGFont;
@class PGFontSymbolDesc;
@class PGFontPrintDataBuffer;
typedef struct PGTextAlignment PGTextAlignment;
typedef struct PGFontPrintData PGFontPrintData;

struct PGTextAlignment {
    float x;
    float y;
    BOOL baseline;
    PGVec2 shift;
};
static inline PGTextAlignment PGTextAlignmentMake(float x, float y, BOOL baseline, PGVec2 shift) {
    return (PGTextAlignment){x, y, baseline, shift};
}
PGTextAlignment pgTextAlignmentApplyXY(float x, float y);
PGTextAlignment pgTextAlignmentApplyXYShift(float x, float y, PGVec2 shift);
PGTextAlignment pgTextAlignmentBaselineX(float x);
NSString* pgTextAlignmentDescription(PGTextAlignment self);
BOOL pgTextAlignmentIsEqualTo(PGTextAlignment self, PGTextAlignment to);
NSUInteger pgTextAlignmentHash(PGTextAlignment self);
PGTextAlignment pgTextAlignmentLeft();
PGTextAlignment pgTextAlignmentRight();
PGTextAlignment pgTextAlignmentCenter();
CNPType* pgTextAlignmentType();
@interface PGTextAlignmentWrap : NSObject
@property (readonly, nonatomic) PGTextAlignment value;

+ (id)wrapWithValue:(PGTextAlignment)value;
- (id)initWithValue:(PGTextAlignment)value;
@end



@interface PGFont : NSObject {
@public
    CNSignal* _symbolsChanged;
}
@property (nonatomic, readonly) CNSignal* symbolsChanged;

+ (instancetype)font;
- (instancetype)init;
- (CNClassType*)type;
- (PGTexture*)texture;
- (NSUInteger)height;
- (NSUInteger)size;
- (PGVec2)measureInPointsText:(NSString*)text;
- (PGFontSymbolDesc*)symbolOptSmb:(unichar)smb;
- (PGVec2)measurePText:(NSString*)text;
- (PGVec2)measureCText:(NSString*)text;
- (BOOL)resymbolHasGL:(BOOL)hasGL;
- (PGSimpleVertexArray*)vaoText:(NSString*)text at:(PGVec3)at alignment:(PGTextAlignment)alignment;
- (void)drawText:(NSString*)text at:(PGVec3)at alignment:(PGTextAlignment)alignment color:(PGVec4)color;
- (PGFont*)beReadyForText:(NSString*)text;
- (NSString*)description;
+ (PGFontSymbolDesc*)newLineDesc;
+ (PGFontSymbolDesc*)zeroDesc;
+ (PGVertexBufferDesc*)vbDesc;
+ (CNClassType*)type;
@end


@interface PGFontSymbolDesc : NSObject {
@public
    float _width;
    PGVec2 _offset;
    PGVec2 _size;
    PGRect _textureRect;
    BOOL _isNewLine;
}
@property (nonatomic, readonly) float width;
@property (nonatomic, readonly) PGVec2 offset;
@property (nonatomic, readonly) PGVec2 size;
@property (nonatomic, readonly) PGRect textureRect;
@property (nonatomic, readonly) BOOL isNewLine;

+ (instancetype)fontSymbolDescWithWidth:(float)width offset:(PGVec2)offset size:(PGVec2)size textureRect:(PGRect)textureRect isNewLine:(BOOL)isNewLine;
- (instancetype)initWithWidth:(float)width offset:(PGVec2)offset size:(PGVec2)size textureRect:(PGRect)textureRect isNewLine:(BOOL)isNewLine;
- (CNClassType*)type;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


struct PGFontPrintData {
    PGVec2 position;
    PGVec2 uv;
};
static inline PGFontPrintData PGFontPrintDataMake(PGVec2 position, PGVec2 uv) {
    return (PGFontPrintData){position, uv};
}
NSString* pgFontPrintDataDescription(PGFontPrintData self);
BOOL pgFontPrintDataIsEqualTo(PGFontPrintData self, PGFontPrintData to);
NSUInteger pgFontPrintDataHash(PGFontPrintData self);
CNPType* pgFontPrintDataType();
@interface PGFontPrintDataWrap : NSObject
@property (readonly, nonatomic) PGFontPrintData value;

+ (id)wrapWithValue:(PGFontPrintData)value;
- (id)initWithValue:(PGFontPrintData)value;
@end



@interface PGFontPrintDataBuffer : CNUBuffer
+ (instancetype)fontPrintDataBufferWithCount:(unsigned int)count;
- (instancetype)initWithCount:(unsigned int)count;
- (CNClassType*)type;
- (NSString*)description;
+ (CNClassType*)type;
@end


