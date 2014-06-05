#import "PGVertexArray.h"

#import "PGVertex.h"
#import "PGIndex.h"
#import "PGContext.h"
#import "PGShader.h"
#import "CNChain.h"
#import "PGFence.h"
#import "GL.h"
@implementation PGVertexArray
static CNClassType* _PGVertexArray_type;

+ (instancetype)vertexArray {
    return [[PGVertexArray alloc] init];
}

- (instancetype)init {
    self = [super init];
    __weak PGVertexArray* _weakSelf = self;
    if(self) __lazy_mutableVertexBuffer = [CNLazy lazyWithF:^PGMutableVertexBuffer*() {
        PGVertexArray* _self = _weakSelf;
        if(_self != nil) return ((PGMutableVertexBuffer*)([[_self vertexBuffers] findWhere:^BOOL(id<PGVertexBuffer> _) {
            return [((id<PGVertexBuffer>)(_)) isKindOfClass:[PGMutableVertexBuffer class]];
        }]));
        else return nil;
    }];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGVertexArray class]) _PGVertexArray_type = [CNClassType classTypeWithCls:[PGVertexArray class]];
}

- (PGMutableVertexBuffer*)mutableVertexBuffer {
    return [__lazy_mutableVertexBuffer get];
}

- (void)drawParam:(id)param start:(NSUInteger)start end:(NSUInteger)end {
    @throw @"Method draw is abstract";
}

- (void)drawParam:(id)param {
    @throw @"Method draw is abstract";
}

- (void)draw {
    @throw @"Method draw is abstract";
}

- (void)syncWait {
    @throw @"Method syncWait is abstract";
}

- (void)syncSet {
    @throw @"Method syncSet is abstract";
}

- (void)syncF:(void(^)())f {
    @throw @"Method sync is abstract";
}

- (NSArray*)vertexBuffers {
    @throw @"Method vertexBuffers is abstract";
}

- (id<PGIndexSource>)index {
    @throw @"Method index is abstract";
}

- (void)vertexWriteCount:(unsigned int)count f:(void(^)(void*))f {
    [((PGMutableVertexBuffer*)(((PGMutableVertexBuffer*)([self mutableVertexBuffer])))) writeCount:count f:f];
}

- (NSString*)description {
    return @"VertexArray";
}

- (CNClassType*)type {
    return [PGVertexArray type];
}

+ (CNClassType*)type {
    return _PGVertexArray_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGRouteVertexArray
static CNClassType* _PGRouteVertexArray_type;
@synthesize standard = _standard;
@synthesize shadow = _shadow;

+ (instancetype)routeVertexArrayWithStandard:(PGVertexArray*)standard shadow:(PGVertexArray*)shadow {
    return [[PGRouteVertexArray alloc] initWithStandard:standard shadow:shadow];
}

- (instancetype)initWithStandard:(PGVertexArray*)standard shadow:(PGVertexArray*)shadow {
    self = [super init];
    if(self) {
        _standard = standard;
        _shadow = shadow;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGRouteVertexArray class]) _PGRouteVertexArray_type = [CNClassType classTypeWithCls:[PGRouteVertexArray class]];
}

- (PGVertexArray*)mesh {
    if([[PGGlobal context]->_renderTarget isKindOfClass:[PGShadowRenderTarget class]]) return _shadow;
    else return _standard;
}

- (void)drawParam:(id)param {
    [[self mesh] drawParam:param];
}

- (void)drawParam:(id)param start:(NSUInteger)start end:(NSUInteger)end {
    [[self mesh] drawParam:param start:start end:end];
}

- (void)draw {
    [[self mesh] draw];
}

- (void)syncF:(void(^)())f {
    [[self mesh] syncF:f];
}

- (void)syncWait {
    [[self mesh] syncWait];
}

- (void)syncSet {
    [[self mesh] syncSet];
}

- (NSArray*)vertexBuffers {
    return [[self mesh] vertexBuffers];
}

- (id<PGIndexSource>)index {
    return [[self mesh] index];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"RouteVertexArray(%@, %@)", _standard, _shadow];
}

- (CNClassType*)type {
    return [PGRouteVertexArray type];
}

+ (CNClassType*)type {
    return _PGRouteVertexArray_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGSimpleVertexArray
static CNClassType* _PGSimpleVertexArray_type;
@synthesize handle = _handle;
@synthesize shader = _shader;
@synthesize vertexBuffers = _vertexBuffers;
@synthesize index = _index;
@synthesize isMutable = _isMutable;

+ (instancetype)simpleVertexArrayWithHandle:(unsigned int)handle shader:(PGShader*)shader vertexBuffers:(NSArray*)vertexBuffers index:(id<PGIndexSource>)index {
    return [[PGSimpleVertexArray alloc] initWithHandle:handle shader:shader vertexBuffers:vertexBuffers index:index];
}

- (instancetype)initWithHandle:(unsigned int)handle shader:(PGShader*)shader vertexBuffers:(NSArray*)vertexBuffers index:(id<PGIndexSource>)index {
    self = [super init];
    if(self) {
        _handle = handle;
        _shader = shader;
        _vertexBuffers = vertexBuffers;
        _index = index;
        _isMutable = [index isMutable] || [[vertexBuffers chain] findWhere:^BOOL(id<PGVertexBuffer> _) {
            return [((id<PGVertexBuffer>)(_)) isMutable];
        }] != nil;
        _fence = [PGFence fenceWithName:@"VAO"];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGSimpleVertexArray class]) _PGSimpleVertexArray_type = [CNClassType classTypeWithCls:[PGSimpleVertexArray class]];
}

+ (PGSimpleVertexArray*)applyShader:(PGShader*)shader buffers:(NSArray*)buffers index:(id<PGIndexSource>)index {
    return [PGSimpleVertexArray simpleVertexArrayWithHandle:egGenVertexArray() shader:shader vertexBuffers:buffers index:index];
}

- (void)bind {
    [[PGGlobal context] bindVertexArrayHandle:_handle vertexCount:({
        id<PGVertexBuffer> __tmp_0rp1 = [_vertexBuffers head];
        ((__tmp_0rp1 != nil) ? ((unsigned int)([((id<PGVertexBuffer>)([_vertexBuffers head])) count])) : ((unsigned int)(0)));
    }) mutable:_isMutable];
}

- (void)unbind {
    [[PGGlobal context] bindDefaultVertexArray];
}

- (void)dealloc {
    [[PGGlobal context] deleteVertexArrayId:_handle];
}

- (NSUInteger)count {
    id<PGVertexBuffer> __tmp = [_vertexBuffers head];
    if(__tmp != nil) return [((id<PGVertexBuffer>)([_vertexBuffers head])) count];
    else return 0;
}

- (void)drawParam:(id)param {
    if(!([_index isEmpty])) [_shader drawParam:param vao:self];
}

- (void)drawParam:(id)param start:(NSUInteger)start end:(NSUInteger)end {
    if(!([_index isEmpty])) [_shader drawParam:param vao:self start:start end:end];
}

- (void)draw {
    @throw @"No default material";
}

- (void)syncF:(void(^)())f {
    [_fence syncF:f];
}

- (void)syncWait {
    [_fence clientWait];
}

- (void)syncSet {
    [_fence set];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"SimpleVertexArray(%u, %@, %@, %@)", _handle, _shader, _vertexBuffers, _index];
}

- (CNClassType*)type {
    return [PGSimpleVertexArray type];
}

+ (CNClassType*)type {
    return _PGSimpleVertexArray_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGMaterialVertexArray
static CNClassType* _PGMaterialVertexArray_type;
@synthesize vao = _vao;
@synthesize material = _material;

+ (instancetype)materialVertexArrayWithVao:(PGVertexArray*)vao material:(id)material {
    return [[PGMaterialVertexArray alloc] initWithVao:vao material:material];
}

- (instancetype)initWithVao:(PGVertexArray*)vao material:(id)material {
    self = [super init];
    if(self) {
        _vao = vao;
        _material = material;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGMaterialVertexArray class]) _PGMaterialVertexArray_type = [CNClassType classTypeWithCls:[PGMaterialVertexArray class]];
}

- (void)draw {
    [_vao drawParam:_material];
}

- (void)drawParam:(id)param {
    [_vao drawParam:param];
}

- (void)drawParam:(id)param start:(NSUInteger)start end:(NSUInteger)end {
    [_vao drawParam:param start:start end:end];
}

- (void)syncF:(void(^)())f {
    [_vao syncF:f];
}

- (void)syncWait {
    [_vao syncWait];
}

- (void)syncSet {
    [_vao syncSet];
}

- (NSArray*)vertexBuffers {
    return [_vao vertexBuffers];
}

- (id<PGIndexSource>)index {
    return [_vao index];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"MaterialVertexArray(%@, %@)", _vao, _material];
}

- (CNClassType*)type {
    return [PGMaterialVertexArray type];
}

+ (CNClassType*)type {
    return _PGMaterialVertexArray_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGVertexArrayRing
static CNClassType* _PGVertexArrayRing_type;
@synthesize ringSize = _ringSize;
@synthesize creator = _creator;

+ (instancetype)vertexArrayRingWithRingSize:(unsigned int)ringSize creator:(PGVertexArray*(^)(unsigned int))creator {
    return [[PGVertexArrayRing alloc] initWithRingSize:ringSize creator:creator];
}

- (instancetype)initWithRingSize:(unsigned int)ringSize creator:(PGVertexArray*(^)(unsigned int))creator {
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
    if(self == [PGVertexArrayRing class]) _PGVertexArrayRing_type = [CNClassType classTypeWithCls:[PGVertexArrayRing class]];
}

- (PGVertexArray*)next {
    PGVertexArray* buffer = (([__ring count] >= _ringSize) ? ((PGVertexArray*)(nonnil([__ring dequeue]))) : ((PGVertexArray*)(_creator(((unsigned int)([__ring count]))))));
    [__ring enqueueItem:buffer];
    return buffer;
}

- (void)syncF:(void(^)(PGVertexArray*))f {
    PGVertexArray* vao = [self next];
    [[self next] syncF:^void() {
        f(vao);
    }];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"VertexArrayRing(%u)", _ringSize];
}

- (CNClassType*)type {
    return [PGVertexArrayRing type];
}

+ (CNClassType*)type {
    return _PGVertexArrayRing_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

