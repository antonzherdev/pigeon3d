#import "PGFont.h"

#import "PGVertex.h"
#import "CNObserver.h"
#import "PGTexture.h"
#import "PGDirector.h"
#import "PGContext.h"
#import "CNReact.h"
#import "PGMatrixModel.h"
#import "PGMat4.h"
#import "CNChain.h"
#import "PGVertexArray.h"
#import "PGIndex.h"
#import "PGFontShader.h"
#import "GL.h"
PGTextAlignment pgTextAlignmentApplyXY(float x, float y) {
    return PGTextAlignmentMake(x, y, NO, (PGVec2Make(0.0, 0.0)));
}
PGTextAlignment pgTextAlignmentApplyXYShift(float x, float y, PGVec2 shift) {
    return PGTextAlignmentMake(x, y, NO, shift);
}
PGTextAlignment pgTextAlignmentBaselineX(float x) {
    return PGTextAlignmentMake(x, 0.0, YES, (PGVec2Make(0.0, 0.0)));
}
NSString* pgTextAlignmentDescription(PGTextAlignment self) {
    return [NSString stringWithFormat:@"TextAlignment(%f, %f, %d, %@)", self.x, self.y, self.baseline, pgVec2Description(self.shift)];
}
BOOL pgTextAlignmentIsEqualTo(PGTextAlignment self, PGTextAlignment to) {
    return eqf4(self.x, to.x) && eqf4(self.y, to.y) && self.baseline == to.baseline && pgVec2IsEqualTo(self.shift, to.shift);
}
NSUInteger pgTextAlignmentHash(PGTextAlignment self) {
    NSUInteger hash = 0;
    hash = hash * 31 + float4Hash(self.x);
    hash = hash * 31 + float4Hash(self.y);
    hash = hash * 31 + self.baseline;
    hash = hash * 31 + pgVec2Hash(self.shift);
    return hash;
}
PGTextAlignment pgTextAlignmentLeft() {
    static PGTextAlignment _ret = (PGTextAlignment){-1.0, 0.0, YES, {0.0, 0.0}};
    return _ret;
}
PGTextAlignment pgTextAlignmentRight() {
    static PGTextAlignment _ret = (PGTextAlignment){1.0, 0.0, YES, {0.0, 0.0}};
    return _ret;
}
PGTextAlignment pgTextAlignmentCenter() {
    static PGTextAlignment _ret = (PGTextAlignment){0.0, 0.0, YES, {0.0, 0.0}};
    return _ret;
}
CNPType* pgTextAlignmentType() {
    static CNPType* _ret = nil;
    if(_ret == nil) _ret = [CNPType typeWithCls:[PGTextAlignmentWrap class] name:@"PGTextAlignment" size:sizeof(PGTextAlignment) wrap:^id(void* data, NSUInteger i) {
        return wrap(PGTextAlignment, ((PGTextAlignment*)(data))[i]);
    }];
    return _ret;
}
@implementation PGTextAlignmentWrap{
    PGTextAlignment _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(PGTextAlignment)value {
    return [[PGTextAlignmentWrap alloc] initWithValue:value];
}

- (id)initWithValue:(PGTextAlignment)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return pgTextAlignmentDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    PGTextAlignmentWrap* o = ((PGTextAlignmentWrap*)(other));
    return pgTextAlignmentIsEqualTo(_value, o.value);
}

- (NSUInteger)hash {
    return pgTextAlignmentHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


@implementation PGFont
static PGFontSymbolDesc* _PGFont_newLineDesc;
static PGFontSymbolDesc* _PGFont_zeroDesc;
static PGVertexBufferDesc* _PGFont_vbDesc;
static CNClassType* _PGFont_type;
@synthesize symbolsChanged = _symbolsChanged;

+ (instancetype)font {
    return [[PGFont alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) _symbolsChanged = [CNSignal signal];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGFont class]) {
        _PGFont_type = [CNClassType classTypeWithCls:[PGFont class]];
        _PGFont_newLineDesc = [PGFontSymbolDesc fontSymbolDescWithWidth:0.0 offset:PGVec2Make(0.0, 0.0) size:PGVec2Make(0.0, 0.0) textureRect:pgRectApplyXYWidthHeight(0.0, 0.0, 0.0, 0.0) isNewLine:YES];
        _PGFont_zeroDesc = [PGFontSymbolDesc fontSymbolDescWithWidth:0.0 offset:PGVec2Make(0.0, 0.0) size:PGVec2Make(0.0, 0.0) textureRect:pgRectApplyXYWidthHeight(0.0, 0.0, 0.0, 0.0) isNewLine:NO];
        _PGFont_vbDesc = [PGVertexBufferDesc vertexBufferDescWithDataType:pgFontPrintDataType() position:0 uv:((int)(2 * 4)) normal:-1 color:-1 model:-1];
    }
}

- (PGTexture*)texture {
    @throw @"Method texture is abstract";
}

- (NSUInteger)height {
    @throw @"Method height is abstract";
}

- (NSUInteger)size {
    @throw @"Method size is abstract";
}

- (PGVec2)measureInPointsText:(NSString*)text {
    CNTuple* pair = [self buildSymbolArrayHasGL:NO text:text];
    NSArray* symbolsArr = pair->_a;
    NSInteger newLines = unumi(pair->_b);
    __block NSInteger fullWidth = 0;
    __block NSInteger lineWidth = 0;
    for(PGFontSymbolDesc* s in symbolsArr) {
        if(((PGFontSymbolDesc*)(s))->_isNewLine) {
            if(lineWidth > fullWidth) fullWidth = lineWidth;
            lineWidth = 0;
        } else {
            lineWidth += ((NSInteger)(((PGFontSymbolDesc*)(s))->_width));
        }
    }
    if(lineWidth > fullWidth) fullWidth = lineWidth;
    return pgVec2DivF((PGVec2Make(((float)(fullWidth)), ((float)([self height])) * (newLines + 1))), [[PGDirector current] scale]);
}

- (PGFontSymbolDesc*)symbolOptSmb:(unichar)smb {
    @throw @"Method symbolOpt is abstract";
}

- (PGVec2)measurePText:(NSString*)text {
    return pgVec2DivVec2((pgVec2MulF([self measureInPointsText:text], 2.0)), (uwrap(PGVec2, [[PGGlobal context]->_scaledViewSize value])));
}

- (PGVec2)measureCText:(NSString*)text {
    return pgVec4Xy(([[[PGGlobal matrix] p] divBySelfVec4:pgVec4ApplyVec2ZW([self measurePText:text], 0.0, 0.0)]));
}

- (BOOL)resymbolHasGL:(BOOL)hasGL {
    return NO;
}

- (CNTuple*)buildSymbolArrayHasGL:(BOOL)hasGL text:(NSString*)text {
    @synchronized(self) {
        __block NSInteger newLines = 0;
        NSArray* symbolsArr = [[[text chain] mapOptF:^PGFontSymbolDesc*(id s) {
            if(unumi(s) == 10) {
                newLines++;
                return _PGFont_newLineDesc;
            } else {
                return [self symbolOptSmb:unums(s)];
            }
        }] toArray];
        if([self resymbolHasGL:hasGL]) symbolsArr = [[[text chain] mapOptF:^PGFontSymbolDesc*(id s) {
            if(unumi(s) == 10) return _PGFont_newLineDesc;
            else return [self symbolOptSmb:unums(s)];
        }] toArray];
        return tuple(symbolsArr, numi(newLines));
    }
}

- (PGSimpleVertexArray*)vaoText:(NSString*)text at:(PGVec3)at alignment:(PGTextAlignment)alignment {
    PGVec2 pos = pgVec2AddVec2((pgVec4Xy(([[[PGGlobal matrix] wcp] mulVec4:pgVec4ApplyVec3W(at, 1.0)]))), (pgVec2MulI((pgVec2DivVec2(alignment.shift, (uwrap(PGVec2, [[PGGlobal context]->_scaledViewSize value])))), 2)));
    CNTuple* pair = [self buildSymbolArrayHasGL:YES text:text];
    NSArray* symbolsArr = pair->_a;
    NSInteger newLines = unumi(pair->_b);
    NSUInteger symbolsCount = [symbolsArr count] - newLines;
    PGFontPrintDataBuffer* vertexes = [PGFontPrintDataBuffer fontPrintDataBufferWithCount:((unsigned int)(symbolsCount * 4))];
    CNInt4Buffer* indexes = [CNInt4Buffer int4BufferWithCount:((unsigned int)(symbolsCount * 6))];
    PGVec2 vpSize = pgVec2iDivF([[PGGlobal context] viewport].size, 2.0);
    __block unsigned int n = 0;
    CNMArray* linesWidth = [CNMArray array];
    id<CNIterator> linesWidthIterator;
    __block float x = pos.x;
    if(!(eqf4(alignment.x, -1))) {
        __block NSInteger lineWidth = 0;
        for(PGFontSymbolDesc* s in symbolsArr) {
            if(((PGFontSymbolDesc*)(s))->_isNewLine) {
                [linesWidth appendItem:numi(lineWidth)];
                lineWidth = 0;
            } else {
                lineWidth += ((NSInteger)(((PGFontSymbolDesc*)(s))->_width));
            }
        }
        [linesWidth appendItem:numi(lineWidth)];
        linesWidthIterator = [linesWidth iterator];
        x = pos.x - unumi([((id<CNIterator>)(nonnil(linesWidthIterator))) next]) / vpSize.x * (alignment.x / 2 + 0.5);
    }
    float hh = ((float)([self height])) / vpSize.y;
    __block float y = ((alignment.baseline) ? pos.y + ((float)([self size])) / vpSize.y : pos.y - hh * (newLines + 1) * (alignment.y / 2 - 0.5));
    for(PGFontSymbolDesc* s in symbolsArr) {
        if(((PGFontSymbolDesc*)(s))->_isNewLine) {
            x = ((eqf4(alignment.x, -1)) ? pos.x : pos.x - unumi([((id<CNIterator>)(nonnil(linesWidthIterator))) next]) / vpSize.x * (alignment.x / 2 + 0.5));
            y -= hh;
        } else {
            PGVec2 size = pgVec2DivVec2(((PGFontSymbolDesc*)(s))->_size, vpSize);
            PGRect tr = ((PGFontSymbolDesc*)(s))->_textureRect;
            PGVec2 v0 = PGVec2Make(x + ((PGFontSymbolDesc*)(s))->_offset.x / vpSize.x, y - ((PGFontSymbolDesc*)(s))->_offset.y / vpSize.y);
            if(vertexes->__position >= vertexes->_count) @throw @"Out of bound";
            *(((PGFontPrintData*)(vertexes->__pointer))) = PGFontPrintDataMake(v0, tr.p);
            vertexes->__pointer = ((PGFontPrintData*)(vertexes->__pointer)) + 1;
            vertexes->__position++;
            if(vertexes->__position >= vertexes->_count) @throw @"Out of bound";
            *(((PGFontPrintData*)(vertexes->__pointer))) = PGFontPrintDataMake((PGVec2Make(v0.x, v0.y - size.y)), pgRectPh(tr));
            vertexes->__pointer = ((PGFontPrintData*)(vertexes->__pointer)) + 1;
            vertexes->__position++;
            if(vertexes->__position >= vertexes->_count) @throw @"Out of bound";
            *(((PGFontPrintData*)(vertexes->__pointer))) = PGFontPrintDataMake((PGVec2Make(v0.x + size.x, v0.y - size.y)), pgRectPhw(tr));
            vertexes->__pointer = ((PGFontPrintData*)(vertexes->__pointer)) + 1;
            vertexes->__position++;
            if(vertexes->__position >= vertexes->_count) @throw @"Out of bound";
            *(((PGFontPrintData*)(vertexes->__pointer))) = PGFontPrintDataMake((PGVec2Make(v0.x + size.x, v0.y)), pgRectPw(tr));
            vertexes->__pointer = ((PGFontPrintData*)(vertexes->__pointer)) + 1;
            vertexes->__position++;
            [indexes setV:((int)(n))];
            [indexes setV:((int)(n + 1))];
            [indexes setV:((int)(n + 2))];
            [indexes setV:((int)(n + 2))];
            [indexes setV:((int)(n + 3))];
            [indexes setV:((int)(n))];
            x += ((PGFontSymbolDesc*)(s))->_width / vpSize.x;
            n += 4;
        }
    }
    id<PGVertexBuffer> vb = [PGVBO applyDesc:_PGFont_vbDesc buffer:vertexes];
    PGImmutableIndexBuffer* ib = [PGIBO applyData:indexes];
    return [[PGFontShader instance] vaoVbo:vb ibo:ib];
}

- (void)drawText:(NSString*)text at:(PGVec3)at alignment:(PGTextAlignment)alignment color:(PGVec4)color {
    PGSimpleVertexArray* vao = [self vaoText:text at:at alignment:alignment];
    {
        PGCullFace* __tmp__il__1self = [PGGlobal context]->_cullFace;
        {
            unsigned int __il__1oldValue = [__tmp__il__1self disable];
            [vao drawParam:[PGFontShaderParam fontShaderParamWithTexture:[self texture] color:color shift:PGVec2Make(0.0, 0.0)]];
            if(__il__1oldValue != GL_NONE) [__tmp__il__1self setValue:__il__1oldValue];
        }
    }
}

- (PGFont*)beReadyForText:(NSString*)text {
    [[text chain] forEach:^void(id s) {
        [self symbolOptSmb:unums(s)];
    }];
    return self;
}

- (NSString*)description {
    return @"Font";
}

- (CNClassType*)type {
    return [PGFont type];
}

+ (PGFontSymbolDesc*)newLineDesc {
    return _PGFont_newLineDesc;
}

+ (PGFontSymbolDesc*)zeroDesc {
    return _PGFont_zeroDesc;
}

+ (PGVertexBufferDesc*)vbDesc {
    return _PGFont_vbDesc;
}

+ (CNClassType*)type {
    return _PGFont_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGFontSymbolDesc
static CNClassType* _PGFontSymbolDesc_type;
@synthesize width = _width;
@synthesize offset = _offset;
@synthesize size = _size;
@synthesize textureRect = _textureRect;
@synthesize isNewLine = _isNewLine;

+ (instancetype)fontSymbolDescWithWidth:(float)width offset:(PGVec2)offset size:(PGVec2)size textureRect:(PGRect)textureRect isNewLine:(BOOL)isNewLine {
    return [[PGFontSymbolDesc alloc] initWithWidth:width offset:offset size:size textureRect:textureRect isNewLine:isNewLine];
}

- (instancetype)initWithWidth:(float)width offset:(PGVec2)offset size:(PGVec2)size textureRect:(PGRect)textureRect isNewLine:(BOOL)isNewLine {
    self = [super init];
    if(self) {
        _width = width;
        _offset = offset;
        _size = size;
        _textureRect = textureRect;
        _isNewLine = isNewLine;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGFontSymbolDesc class]) _PGFontSymbolDesc_type = [CNClassType classTypeWithCls:[PGFontSymbolDesc class]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"FontSymbolDesc(%f, %@, %@, %@, %d)", _width, pgVec2Description(_offset), pgVec2Description(_size), pgRectDescription(_textureRect), _isNewLine];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[PGFontSymbolDesc class]])) return NO;
    PGFontSymbolDesc* o = ((PGFontSymbolDesc*)(to));
    return eqf4(_width, o->_width) && pgVec2IsEqualTo(_offset, o->_offset) && pgVec2IsEqualTo(_size, o->_size) && pgRectIsEqualTo(_textureRect, o->_textureRect) && _isNewLine == o->_isNewLine;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + float4Hash(_width);
    hash = hash * 31 + pgVec2Hash(_offset);
    hash = hash * 31 + pgVec2Hash(_size);
    hash = hash * 31 + pgRectHash(_textureRect);
    hash = hash * 31 + _isNewLine;
    return hash;
}

- (CNClassType*)type {
    return [PGFontSymbolDesc type];
}

+ (CNClassType*)type {
    return _PGFontSymbolDesc_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

NSString* pgFontPrintDataDescription(PGFontPrintData self) {
    return [NSString stringWithFormat:@"FontPrintData(%@, %@)", pgVec2Description(self.position), pgVec2Description(self.uv)];
}
BOOL pgFontPrintDataIsEqualTo(PGFontPrintData self, PGFontPrintData to) {
    return pgVec2IsEqualTo(self.position, to.position) && pgVec2IsEqualTo(self.uv, to.uv);
}
NSUInteger pgFontPrintDataHash(PGFontPrintData self) {
    NSUInteger hash = 0;
    hash = hash * 31 + pgVec2Hash(self.position);
    hash = hash * 31 + pgVec2Hash(self.uv);
    return hash;
}
CNPType* pgFontPrintDataType() {
    static CNPType* _ret = nil;
    if(_ret == nil) _ret = [CNPType typeWithCls:[PGFontPrintDataWrap class] name:@"PGFontPrintData" size:sizeof(PGFontPrintData) wrap:^id(void* data, NSUInteger i) {
        return wrap(PGFontPrintData, ((PGFontPrintData*)(data))[i]);
    }];
    return _ret;
}
@implementation PGFontPrintDataWrap{
    PGFontPrintData _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(PGFontPrintData)value {
    return [[PGFontPrintDataWrap alloc] initWithValue:value];
}

- (id)initWithValue:(PGFontPrintData)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return pgFontPrintDataDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    PGFontPrintDataWrap* o = ((PGFontPrintDataWrap*)(other));
    return pgFontPrintDataIsEqualTo(_value, o.value);
}

- (NSUInteger)hash {
    return pgFontPrintDataHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


@implementation PGFontPrintDataBuffer
static CNClassType* _PGFontPrintDataBuffer_type;

+ (instancetype)fontPrintDataBufferWithCount:(unsigned int)count {
    return [[PGFontPrintDataBuffer alloc] initWithCount:count];
}

- (instancetype)initWithCount:(unsigned int)count {
    self = [super initWithTp:pgFontPrintDataType() count:count];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGFontPrintDataBuffer class]) _PGFontPrintDataBuffer_type = [CNClassType classTypeWithCls:[PGFontPrintDataBuffer class]];
}

- (PGFontPrintData)get {
    if(__position >= _count) @throw @"Out of bound";
    PGFontPrintData __il_r = *(((PGFontPrintData*)(__pointer)));
    __pointer = ((PGFontPrintData*)(__pointer)) + 1;
    __position++;
    return __il_r;
}

- (void)setV:(PGFontPrintData)v {
    if(__position >= _count) @throw @"Out of bound";
    *(((PGFontPrintData*)(__pointer))) = v;
    __pointer = ((PGFontPrintData*)(__pointer)) + 1;
    __position++;
}

- (NSString*)description {
    return @"FontPrintDataBuffer";
}

- (CNClassType*)type {
    return [PGFontPrintDataBuffer type];
}

+ (CNClassType*)type {
    return _PGFontPrintDataBuffer_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

