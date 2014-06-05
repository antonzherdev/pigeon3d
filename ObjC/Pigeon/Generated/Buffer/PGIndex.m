#import "PGIndex.h"

#import "GL.h"
#import "PGContext.h"
@implementation PGIndexSource_impl

+ (instancetype)indexSource_impl {
    return [[PGIndexSource_impl alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

- (void)bind {
}

- (void)draw {
    @throw @"Method draw is abstract";
}

- (void)drawWithStart:(NSUInteger)start count:(NSUInteger)count {
    @throw @"Method drawWith is abstract";
}

- (BOOL)isMutable {
    return NO;
}

- (BOOL)isEmpty {
    return NO;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGIBO
static CNClassType* _PGIBO_type;

+ (void)initialize {
    [super initialize];
    if(self == [PGIBO class]) _PGIBO_type = [CNClassType classTypeWithCls:[PGIBO class]];
}

+ (PGImmutableIndexBuffer*)applyPointer:(unsigned int*)pointer count:(unsigned int)count {
    PGImmutableIndexBuffer* ib = [PGImmutableIndexBuffer immutableIndexBufferWithHandle:egGenBuffer() mode:GL_TRIANGLES length:((NSUInteger)(count * 4)) count:((NSUInteger)(count))];
    [ib bind];
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, ((int)(count * 4)), pointer, GL_STATIC_DRAW);
    return ib;
}

+ (PGImmutableIndexBuffer*)applyData:(CNPArray*)data {
    PGImmutableIndexBuffer* ib = [PGImmutableIndexBuffer immutableIndexBufferWithHandle:egGenBuffer() mode:GL_TRIANGLES length:data->_length count:data->_count];
    [ib bind];
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, ((int)(data->_length)), data->_bytes, GL_STATIC_DRAW);
    return ib;
}

+ (PGMutableIndexBuffer*)mutMode:(unsigned int)mode usage:(unsigned int)usage {
    return [PGMutableIndexBuffer mutableIndexBufferWithHandle:egGenBuffer() mode:mode usage:usage];
}

+ (PGMutableIndexBuffer*)mutUsage:(unsigned int)usage {
    return [PGIBO mutMode:GL_TRIANGLES usage:usage];
}

- (CNClassType*)type {
    return [PGIBO type];
}

+ (CNClassType*)type {
    return _PGIBO_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGIndexBuffer_impl

+ (instancetype)indexBuffer_impl {
    return [[PGIndexBuffer_impl alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

- (void)draw {
    [[PGGlobal context] draw];
    NSUInteger n = [self count];
    if(n > 0) glDrawElements([self mode], ((int)(n)), GL_UNSIGNED_INT, NULL);
    egCheckError();
}

- (void)drawWithStart:(NSUInteger)start count:(NSUInteger)count {
    [[PGGlobal context] draw];
    if(count > 0) glDrawElements([self mode], ((int)(count)), GL_UNSIGNED_INT, ((unsigned int*)(4 * start)));
    egCheckError();
}

- (unsigned int)handle {
    @throw @"Method handle is abstract";
}

- (unsigned int)mode {
    @throw @"Method mode is abstract";
}

- (NSUInteger)count {
    @throw @"Method count is abstract";
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGImmutableIndexBuffer
static CNClassType* _PGImmutableIndexBuffer_type;
@synthesize mode = _mode;
@synthesize length = _length;
@synthesize count = _count;

+ (instancetype)immutableIndexBufferWithHandle:(unsigned int)handle mode:(unsigned int)mode length:(NSUInteger)length count:(NSUInteger)count {
    return [[PGImmutableIndexBuffer alloc] initWithHandle:handle mode:mode length:length count:count];
}

- (instancetype)initWithHandle:(unsigned int)handle mode:(unsigned int)mode length:(NSUInteger)length count:(NSUInteger)count {
    self = [super initWithDataType:cnuInt4Type() bufferType:GL_ELEMENT_ARRAY_BUFFER handle:handle];
    if(self) {
        _mode = mode;
        _length = length;
        _count = count;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGImmutableIndexBuffer class]) _PGImmutableIndexBuffer_type = [CNClassType classTypeWithCls:[PGImmutableIndexBuffer class]];
}

- (void)bind {
    [[PGGlobal context] bindIndexBufferHandle:self.handle];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"ImmutableIndexBuffer(%u, %lu, %lu)", _mode, (unsigned long)_length, (unsigned long)_count];
}

- (void)draw {
    [[PGGlobal context] draw];
    NSUInteger n = [self count];
    if(n > 0) glDrawElements([self mode], ((int)(n)), GL_UNSIGNED_INT, NULL);
    egCheckError();
}

- (void)drawWithStart:(NSUInteger)start count:(NSUInteger)count {
    [[PGGlobal context] draw];
    if(count > 0) glDrawElements([self mode], ((int)(count)), GL_UNSIGNED_INT, ((unsigned int*)(4 * start)));
    egCheckError();
}

- (BOOL)isMutable {
    return NO;
}

- (BOOL)isEmpty {
    return NO;
}

- (CNClassType*)type {
    return [PGImmutableIndexBuffer type];
}

+ (CNClassType*)type {
    return _PGImmutableIndexBuffer_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGMutableIndexBuffer
static CNClassType* _PGMutableIndexBuffer_type;
@synthesize mode = _mode;

+ (instancetype)mutableIndexBufferWithHandle:(unsigned int)handle mode:(unsigned int)mode usage:(unsigned int)usage {
    return [[PGMutableIndexBuffer alloc] initWithHandle:handle mode:mode usage:usage];
}

- (instancetype)initWithHandle:(unsigned int)handle mode:(unsigned int)mode usage:(unsigned int)usage {
    self = [super initWithDataType:cnuInt4Type() bufferType:GL_ELEMENT_ARRAY_BUFFER handle:handle usage:usage];
    if(self) _mode = mode;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGMutableIndexBuffer class]) _PGMutableIndexBuffer_type = [CNClassType classTypeWithCls:[PGMutableIndexBuffer class]];
}

- (BOOL)isMutable {
    return YES;
}

- (void)bind {
    [[PGGlobal context] bindIndexBufferHandle:self.handle];
}

- (BOOL)isEmpty {
    return NO;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"MutableIndexBuffer(%u)", _mode];
}

- (void)draw {
    [[PGGlobal context] draw];
    NSUInteger n = [self count];
    if(n > 0) glDrawElements([self mode], ((int)(n)), GL_UNSIGNED_INT, NULL);
    egCheckError();
}

- (void)drawWithStart:(NSUInteger)start count:(NSUInteger)count {
    [[PGGlobal context] draw];
    if(count > 0) glDrawElements([self mode], ((int)(count)), GL_UNSIGNED_INT, ((unsigned int*)(4 * start)));
    egCheckError();
}

- (CNClassType*)type {
    return [PGMutableIndexBuffer type];
}

+ (CNClassType*)type {
    return _PGMutableIndexBuffer_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGIndexBufferRing
static CNClassType* _PGIndexBufferRing_type;
@synthesize mode = _mode;
@synthesize usage = _usage;

+ (instancetype)indexBufferRingWithRingSize:(unsigned int)ringSize mode:(unsigned int)mode usage:(unsigned int)usage {
    return [[PGIndexBufferRing alloc] initWithRingSize:ringSize mode:mode usage:usage];
}

- (instancetype)initWithRingSize:(unsigned int)ringSize mode:(unsigned int)mode usage:(unsigned int)usage {
    self = [super initWithRingSize:ringSize creator:^PGMutableIndexBuffer*() {
        return [PGMutableIndexBuffer mutableIndexBufferWithHandle:egGenBuffer() mode:mode usage:usage];
    }];
    if(self) {
        _mode = mode;
        _usage = usage;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGIndexBufferRing class]) _PGIndexBufferRing_type = [CNClassType classTypeWithCls:[PGIndexBufferRing class]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"IndexBufferRing(%u, %u)", _mode, _usage];
}

- (CNClassType*)type {
    return [PGIndexBufferRing type];
}

+ (CNClassType*)type {
    return _PGIndexBufferRing_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGEmptyIndexSource
static PGEmptyIndexSource* _PGEmptyIndexSource_triangleStrip;
static PGEmptyIndexSource* _PGEmptyIndexSource_triangleFan;
static PGEmptyIndexSource* _PGEmptyIndexSource_triangles;
static PGEmptyIndexSource* _PGEmptyIndexSource_lines;
static CNClassType* _PGEmptyIndexSource_type;
@synthesize mode = _mode;

+ (instancetype)emptyIndexSourceWithMode:(unsigned int)mode {
    return [[PGEmptyIndexSource alloc] initWithMode:mode];
}

- (instancetype)initWithMode:(unsigned int)mode {
    self = [super init];
    if(self) _mode = mode;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGEmptyIndexSource class]) {
        _PGEmptyIndexSource_type = [CNClassType classTypeWithCls:[PGEmptyIndexSource class]];
        _PGEmptyIndexSource_triangleStrip = [PGEmptyIndexSource emptyIndexSourceWithMode:GL_TRIANGLE_STRIP];
        _PGEmptyIndexSource_triangleFan = [PGEmptyIndexSource emptyIndexSourceWithMode:GL_TRIANGLE_FAN];
        _PGEmptyIndexSource_triangles = [PGEmptyIndexSource emptyIndexSourceWithMode:GL_TRIANGLES];
        _PGEmptyIndexSource_lines = [PGEmptyIndexSource emptyIndexSourceWithMode:GL_LINES];
    }
}

- (void)draw {
    [[PGGlobal context] draw];
    glDrawArrays(_mode, 0, ((int)([[PGGlobal context] vertexBufferCount])));
    egCheckError();
}

- (void)drawWithStart:(NSUInteger)start count:(NSUInteger)count {
    [[PGGlobal context] draw];
    if(count > 0) glDrawArrays(_mode, ((int)(start)), ((int)(count)));
    egCheckError();
}

- (NSString*)description {
    return [NSString stringWithFormat:@"EmptyIndexSource(%u)", _mode];
}

- (CNClassType*)type {
    return [PGEmptyIndexSource type];
}

+ (PGEmptyIndexSource*)triangleStrip {
    return _PGEmptyIndexSource_triangleStrip;
}

+ (PGEmptyIndexSource*)triangleFan {
    return _PGEmptyIndexSource_triangleFan;
}

+ (PGEmptyIndexSource*)triangles {
    return _PGEmptyIndexSource_triangles;
}

+ (PGEmptyIndexSource*)lines {
    return _PGEmptyIndexSource_lines;
}

+ (CNClassType*)type {
    return _PGEmptyIndexSource_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGArrayIndexSource
static CNClassType* _PGArrayIndexSource_type;
@synthesize array = _array;
@synthesize mode = _mode;

+ (instancetype)arrayIndexSourceWithArray:(CNPArray*)array mode:(unsigned int)mode {
    return [[PGArrayIndexSource alloc] initWithArray:array mode:mode];
}

- (instancetype)initWithArray:(CNPArray*)array mode:(unsigned int)mode {
    self = [super init];
    if(self) {
        _array = array;
        _mode = mode;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGArrayIndexSource class]) _PGArrayIndexSource_type = [CNClassType classTypeWithCls:[PGArrayIndexSource class]];
}

- (void)draw {
    [[PGGlobal context] bindIndexBufferHandle:0];
    NSUInteger n = _array->_count;
    if(n > 0) glDrawElements(_mode, ((int)(n)), GL_UNSIGNED_INT, _array->_bytes);
    egCheckError();
}

- (void)drawWithStart:(NSUInteger)start count:(NSUInteger)count {
    [[PGGlobal context] bindIndexBufferHandle:0];
    if(count > 0) glDrawElements(_mode, ((int)(count)), GL_UNSIGNED_INT, _array->_bytes + 4 * start);
    egCheckError();
}

- (NSString*)description {
    return [NSString stringWithFormat:@"ArrayIndexSource(%@, %u)", _array, _mode];
}

- (CNClassType*)type {
    return [PGArrayIndexSource type];
}

+ (CNClassType*)type {
    return _PGArrayIndexSource_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGIndexSourceGap
static CNClassType* _PGIndexSourceGap_type;
@synthesize source = _source;
@synthesize start = _start;
@synthesize count = _count;

+ (instancetype)indexSourceGapWithSource:(id<PGIndexSource>)source start:(unsigned int)start count:(unsigned int)count {
    return [[PGIndexSourceGap alloc] initWithSource:source start:start count:count];
}

- (instancetype)initWithSource:(id<PGIndexSource>)source start:(unsigned int)start count:(unsigned int)count {
    self = [super init];
    if(self) {
        _source = source;
        _start = start;
        _count = count;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGIndexSourceGap class]) _PGIndexSourceGap_type = [CNClassType classTypeWithCls:[PGIndexSourceGap class]];
}

- (void)bind {
    [_source bind];
}

- (void)draw {
    if(_count > 0) [_source drawWithStart:((NSUInteger)(_start)) count:((NSUInteger)(_count))];
}

- (void)drawWithStart:(NSUInteger)start count:(NSUInteger)count {
    if(count > 0) [_source drawWithStart:((NSUInteger)(_start + start)) count:count];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"IndexSourceGap(%@, %u, %u)", _source, _start, _count];
}

- (CNClassType*)type {
    return [PGIndexSourceGap type];
}

+ (CNClassType*)type {
    return _PGIndexSourceGap_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGMutableIndexSourceGap
static CNClassType* _PGMutableIndexSourceGap_type;
@synthesize source = _source;
@synthesize start = _start;
@synthesize count = _count;

+ (instancetype)mutableIndexSourceGapWithSource:(id<PGIndexSource>)source {
    return [[PGMutableIndexSourceGap alloc] initWithSource:source];
}

- (instancetype)initWithSource:(id<PGIndexSource>)source {
    self = [super init];
    if(self) {
        _source = source;
        _start = 0;
        _count = 0;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGMutableIndexSourceGap class]) _PGMutableIndexSourceGap_type = [CNClassType classTypeWithCls:[PGMutableIndexSourceGap class]];
}

- (void)bind {
    [_source bind];
}

- (void)draw {
    if(_count > 0) [_source drawWithStart:((NSUInteger)(_start)) count:((NSUInteger)(_count))];
}

- (void)drawWithStart:(NSUInteger)start count:(NSUInteger)count {
    if(count > 0) [_source drawWithStart:((NSUInteger)(_start + start)) count:count];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"MutableIndexSourceGap(%@)", _source];
}

- (CNClassType*)type {
    return [PGMutableIndexSourceGap type];
}

+ (CNClassType*)type {
    return _PGMutableIndexSourceGap_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

