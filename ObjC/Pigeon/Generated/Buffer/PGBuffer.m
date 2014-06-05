#import "PGBuffer.h"

#import "PGContext.h"
#import "GL.h"
#import "CNLock.h"
@implementation PGGlBuffer
static CNClassType* _PGGlBuffer_type;
@synthesize dataType = _dataType;
@synthesize bufferType = _bufferType;
@synthesize handle = _handle;

+ (instancetype)glBufferWithDataType:(CNPType*)dataType bufferType:(unsigned int)bufferType handle:(unsigned int)handle {
    return [[PGGlBuffer alloc] initWithDataType:dataType bufferType:bufferType handle:handle];
}

- (instancetype)initWithDataType:(CNPType*)dataType bufferType:(unsigned int)bufferType handle:(unsigned int)handle {
    self = [super init];
    if(self) {
        _dataType = dataType;
        _bufferType = bufferType;
        _handle = handle;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGGlBuffer class]) _PGGlBuffer_type = [CNClassType classTypeWithCls:[PGGlBuffer class]];
}

- (NSUInteger)length {
    @throw @"Method length is abstract";
}

- (NSUInteger)count {
    @throw @"Method count is abstract";
}

- (void)dealloc {
    [[PGGlobal context] deleteBufferId:_handle];
}

- (void)bind {
    glBindBuffer(_bufferType, _handle);
}

- (unsigned int)stride {
    return ((unsigned int)(_dataType.size));
}

- (NSString*)description {
    return [NSString stringWithFormat:@"GlBuffer(%@, %u, %u)", _dataType, _bufferType, _handle];
}

- (CNClassType*)type {
    return [PGGlBuffer type];
}

+ (CNClassType*)type {
    return _PGGlBuffer_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGMutableGlBuffer
static CNClassType* _PGMutableGlBuffer_type;
@synthesize usage = _usage;

+ (instancetype)mutableGlBufferWithDataType:(CNPType*)dataType bufferType:(unsigned int)bufferType handle:(unsigned int)handle usage:(unsigned int)usage {
    return [[PGMutableGlBuffer alloc] initWithDataType:dataType bufferType:bufferType handle:handle usage:usage];
}

- (instancetype)initWithDataType:(CNPType*)dataType bufferType:(unsigned int)bufferType handle:(unsigned int)handle usage:(unsigned int)usage {
    self = [super initWithDataType:dataType bufferType:bufferType handle:handle];
    if(self) {
        _usage = usage;
        __length = 0;
        __count = 0;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGMutableGlBuffer class]) _PGMutableGlBuffer_type = [CNClassType classTypeWithCls:[PGMutableGlBuffer class]];
}

- (NSUInteger)length {
    return __length;
}

- (NSUInteger)count {
    return __count;
}

- (BOOL)isEmpty {
    return __count > 0;
}

- (id)setData:(CNBuffer*)data {
    [self bind];
    glBufferData(self.bufferType, ((int)([data length])), data->_bytes, _usage);
    egCheckError();
    __length = [data length];
    __count = ((NSUInteger)(data->_count));
    return self;
}

- (id)setArray:(void*)array count:(unsigned int)count {
    [self bind];
    __length = ((NSUInteger)(count * self.dataType.size));
    glBufferData(self.bufferType, ((int)(__length)), array, _usage);
    egCheckError();
    __count = ((NSUInteger)(count));
    return self;
}

- (void)writeCount:(unsigned int)count f:(void(^)(void*))f {
    [self mapCount:count access:GL_WRITE_ONLY f:f];
}

- (void)mapCount:(unsigned int)count access:(unsigned int)access f:(void(^)(void*))f {
    if(_mappedData != nil) return ;
    [self bind];
    __count = ((NSUInteger)(count));
    __length = ((NSUInteger)(count * self.dataType.size));
    glBufferData(self.bufferType, ((int)(__length)), NULL, _usage);
    {
        void* _ = egMapBuffer(self.bufferType, access);
        if(_ != nil) f(_);
    }
    egUnmapBuffer(self.bufferType);
    egCheckError();
}

- (PGMappedBufferData*)beginWriteCount:(unsigned int)count {
    return [self mapCount:count access:GL_WRITE_ONLY];
}

- (PGMappedBufferData*)mapCount:(unsigned int)count access:(unsigned int)access {
    if(_mappedData != nil) return nil;
    [self bind];
    __count = ((NSUInteger)(count));
    __length = ((NSUInteger)(count * self.dataType.size));
    glBufferData(self.bufferType, ((int)(__length)), NULL, _usage);
    {
        void* _ = egMapBuffer(self.bufferType, access);
        if(_ != nil) _mappedData = [PGMappedBufferData mappedBufferDataWithBuffer:self pointer:_];
        else _mappedData = nil;
    }
    egCheckError();
    return _mappedData;
}

- (void)_finishMapping {
    [self bind];
    egUnmapBuffer(self.bufferType);
    egCheckError();
    _mappedData = nil;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"MutableGlBuffer(%u)", _usage];
}

- (CNClassType*)type {
    return [PGMutableGlBuffer type];
}

+ (CNClassType*)type {
    return _PGMutableGlBuffer_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGMappedBufferData
static CNClassType* _PGMappedBufferData_type;
@synthesize buffer = _buffer;
@synthesize pointer = _pointer;

+ (instancetype)mappedBufferDataWithBuffer:(PGMutableGlBuffer*)buffer pointer:(void*)pointer {
    return [[PGMappedBufferData alloc] initWithBuffer:buffer pointer:pointer];
}

- (instancetype)initWithBuffer:(PGMutableGlBuffer*)buffer pointer:(void*)pointer {
    self = [super init];
    if(self) {
        _buffer = buffer;
        _pointer = pointer;
        _lock = [NSConditionLock conditionLockWithCondition:0];
        _finished = NO;
        _updated = NO;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGMappedBufferData class]) _PGMappedBufferData_type = [CNClassType classTypeWithCls:[PGMappedBufferData class]];
}

- (BOOL)wasUpdated {
    return _updated;
}

- (BOOL)beginWrite {
    if(_finished) {
        return NO;
    } else {
        [_lock lock];
        if(_finished) {
            [_lock unlock];
            return NO;
        } else {
            return YES;
        }
    }
}

- (void)endWrite {
    _updated = YES;
    [_lock unlockWithCondition:1];
}

- (void)writeF:(void(^)(void*))f {
    if([self beginWrite]) {
        f(_pointer);
        [self endWrite];
    }
}

- (void)finish {
    [_lock lockWhenCondition:1];
    [_buffer _finishMapping];
    _finished = YES;
    [_lock unlock];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"MappedBufferData(%@, %p)", _buffer, _pointer];
}

- (CNClassType*)type {
    return [PGMappedBufferData type];
}

+ (CNClassType*)type {
    return _PGMappedBufferData_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGBufferRing
static CNClassType* _PGBufferRing_type;
@synthesize ringSize = _ringSize;
@synthesize creator = _creator;

+ (instancetype)bufferRingWithRingSize:(unsigned int)ringSize creator:(id(^)())creator {
    return [[PGBufferRing alloc] initWithRingSize:ringSize creator:creator];
}

- (instancetype)initWithRingSize:(unsigned int)ringSize creator:(id(^)())creator {
    self = [super init];
    if(self) {
        _ringSize = ringSize;
        _creator = [creator copy];
        __ring = [CNMQueue queue];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGBufferRing class]) _PGBufferRing_type = [CNClassType classTypeWithCls:[PGBufferRing class]];
}

- (id)next {
    id buffer = (([__ring count] >= _ringSize) ? [__ring dequeue] : _creator());
    [__ring enqueueItem:buffer];
    return buffer;
}

- (void)writeCount:(unsigned int)count f:(void(^)(void*))f {
    [[self next] writeCount:count f:f];
}

- (void)mapCount:(unsigned int)count access:(unsigned int)access f:(void(^)(void*))f {
    [[self next] mapCount:count access:access f:f];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"BufferRing(%u)", _ringSize];
}

- (CNClassType*)type {
    return [PGBufferRing type];
}

+ (CNClassType*)type {
    return _PGBufferRing_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

