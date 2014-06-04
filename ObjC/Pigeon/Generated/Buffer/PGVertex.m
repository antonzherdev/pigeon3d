#import "PGVertex.h"

#import "GL.h"
#import "PGContext.h"
@implementation PGVertexBufferDesc
static CNClassType* _PGVertexBufferDesc_type;
@synthesize dataType = _dataType;
@synthesize position = _position;
@synthesize uv = _uv;
@synthesize normal = _normal;
@synthesize color = _color;
@synthesize model = _model;

+ (instancetype)vertexBufferDescWithDataType:(CNPType*)dataType position:(int)position uv:(int)uv normal:(int)normal color:(int)color model:(int)model {
    return [[PGVertexBufferDesc alloc] initWithDataType:dataType position:position uv:uv normal:normal color:color model:model];
}

- (instancetype)initWithDataType:(CNPType*)dataType position:(int)position uv:(int)uv normal:(int)normal color:(int)color model:(int)model {
    self = [super init];
    if(self) {
        _dataType = dataType;
        _position = position;
        _uv = uv;
        _normal = normal;
        _color = color;
        _model = model;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGVertexBufferDesc class]) _PGVertexBufferDesc_type = [CNClassType classTypeWithCls:[PGVertexBufferDesc class]];
}

- (unsigned int)stride {
    return ((unsigned int)(_dataType.size));
}

+ (PGVertexBufferDesc*)Vec2 {
    return [PGVertexBufferDesc vertexBufferDescWithDataType:pgVec2Type() position:-1 uv:0 normal:-1 color:-1 model:0];
}

+ (PGVertexBufferDesc*)Vec3 {
    return [PGVertexBufferDesc vertexBufferDescWithDataType:pgVec3Type() position:0 uv:0 normal:0 color:-1 model:0];
}

+ (PGVertexBufferDesc*)Vec4 {
    return [PGVertexBufferDesc vertexBufferDescWithDataType:pgVec4Type() position:0 uv:0 normal:0 color:0 model:0];
}

+ (PGVertexBufferDesc*)mesh {
    return [PGVertexBufferDesc vertexBufferDescWithDataType:pgMeshDataType() position:((int)(5 * 4)) uv:0 normal:((int)(2 * 4)) color:-1 model:-1];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"VertexBufferDesc(%@, %d, %d, %d, %d, %d)", _dataType, _position, _uv, _normal, _color, _model];
}

- (CNClassType*)type {
    return [PGVertexBufferDesc type];
}

+ (CNClassType*)type {
    return _PGVertexBufferDesc_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGVBO
static CNClassType* _PGVBO_type;

+ (void)initialize {
    [super initialize];
    if(self == [PGVBO class]) _PGVBO_type = [CNClassType classTypeWithCls:[PGVBO class]];
}

+ (id<PGVertexBuffer>)applyDesc:(PGVertexBufferDesc*)desc array:(void*)array count:(unsigned int)count {
    unsigned int len = count * desc.dataType.size;
    PGImmutableVertexBuffer* vb = [PGImmutableVertexBuffer immutableVertexBufferWithDesc:desc handle:egGenBuffer() length:((NSUInteger)(len)) count:((NSUInteger)(count))];
    [vb bind];
    glBufferData(GL_ARRAY_BUFFER, ((int)(len)), array, GL_STATIC_DRAW);
    return vb;
}

+ (id<PGVertexBuffer>)applyDesc:(PGVertexBufferDesc*)desc data:(CNPArray*)data {
    PGImmutableVertexBuffer* vb = [PGImmutableVertexBuffer immutableVertexBufferWithDesc:desc handle:egGenBuffer() length:data.length count:data.count];
    [vb bind];
    glBufferData(GL_ARRAY_BUFFER, ((int)(data.length)), data.bytes, GL_STATIC_DRAW);
    return vb;
}

+ (id<PGVertexBuffer>)vec4Data:(CNPArray*)data {
    return [PGVBO applyDesc:[PGVertexBufferDesc Vec4] data:data];
}

+ (id<PGVertexBuffer>)vec3Data:(CNPArray*)data {
    return [PGVBO applyDesc:[PGVertexBufferDesc Vec3] data:data];
}

+ (id<PGVertexBuffer>)vec2Data:(CNPArray*)data {
    return [PGVBO applyDesc:[PGVertexBufferDesc Vec2] data:data];
}

+ (id<PGVertexBuffer>)meshData:(CNPArray*)data {
    return [PGVBO applyDesc:[PGVertexBufferDesc mesh] data:data];
}

+ (PGMutableVertexBuffer*)mutDesc:(PGVertexBufferDesc*)desc usage:(unsigned int)usage {
    return [PGMutableVertexBuffer mutableVertexBufferWithDesc:desc handle:egGenBuffer() usage:usage];
}

+ (PGVertexBufferRing*)ringSize:(unsigned int)size desc:(PGVertexBufferDesc*)desc usage:(unsigned int)usage {
    return [PGVertexBufferRing vertexBufferRingWithRingSize:size desc:desc usage:usage];
}

+ (PGMutableVertexBuffer*)mutVec2Usage:(unsigned int)usage {
    return [PGMutableVertexBuffer mutableVertexBufferWithDesc:[PGVertexBufferDesc Vec2] handle:egGenBuffer() usage:usage];
}

+ (PGMutableVertexBuffer*)mutVec3Usage:(unsigned int)usage {
    return [PGMutableVertexBuffer mutableVertexBufferWithDesc:[PGVertexBufferDesc Vec3] handle:egGenBuffer() usage:usage];
}

+ (PGMutableVertexBuffer*)mutVec4Usage:(unsigned int)usage {
    return [PGMutableVertexBuffer mutableVertexBufferWithDesc:[PGVertexBufferDesc Vec4] handle:egGenBuffer() usage:usage];
}

+ (PGMutableVertexBuffer*)mutMeshUsage:(unsigned int)usage {
    return [PGMutableVertexBuffer mutableVertexBufferWithDesc:[PGVertexBufferDesc mesh] handle:egGenBuffer() usage:usage];
}

- (CNClassType*)type {
    return [PGVBO type];
}

+ (CNClassType*)type {
    return _PGVBO_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGVertexBuffer_impl

+ (instancetype)vertexBuffer_impl {
    return [[PGVertexBuffer_impl alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

- (PGVertexBufferDesc*)desc {
    @throw @"Method desc is abstract";
}

- (NSUInteger)count {
    @throw @"Method count is abstract";
}

- (unsigned int)handle {
    @throw @"Method handle is abstract";
}

- (BOOL)isMutable {
    return NO;
}

- (void)bind {
    @throw @"Method bind is abstract";
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGImmutableVertexBuffer
static CNClassType* _PGImmutableVertexBuffer_type;
@synthesize desc = _desc;
@synthesize length = _length;
@synthesize count = _count;

+ (instancetype)immutableVertexBufferWithDesc:(PGVertexBufferDesc*)desc handle:(unsigned int)handle length:(NSUInteger)length count:(NSUInteger)count {
    return [[PGImmutableVertexBuffer alloc] initWithDesc:desc handle:handle length:length count:count];
}

- (instancetype)initWithDesc:(PGVertexBufferDesc*)desc handle:(unsigned int)handle length:(NSUInteger)length count:(NSUInteger)count {
    self = [super initWithDataType:desc.dataType bufferType:GL_ARRAY_BUFFER handle:handle];
    if(self) {
        _desc = desc;
        _length = length;
        _count = count;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGImmutableVertexBuffer class]) _PGImmutableVertexBuffer_type = [CNClassType classTypeWithCls:[PGImmutableVertexBuffer class]];
}

- (void)bind {
    [PGGlobal.context bindVertexBufferBuffer:self];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"ImmutableVertexBuffer(%@, %lu, %lu)", _desc, (unsigned long)_length, (unsigned long)_count];
}

- (BOOL)isMutable {
    return NO;
}

- (CNClassType*)type {
    return [PGImmutableVertexBuffer type];
}

+ (CNClassType*)type {
    return _PGImmutableVertexBuffer_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGMutableVertexBuffer
static CNClassType* _PGMutableVertexBuffer_type;
@synthesize desc = _desc;

+ (instancetype)mutableVertexBufferWithDesc:(PGVertexBufferDesc*)desc handle:(unsigned int)handle usage:(unsigned int)usage {
    return [[PGMutableVertexBuffer alloc] initWithDesc:desc handle:handle usage:usage];
}

- (instancetype)initWithDesc:(PGVertexBufferDesc*)desc handle:(unsigned int)handle usage:(unsigned int)usage {
    self = [super initWithDataType:desc.dataType bufferType:GL_ARRAY_BUFFER handle:handle usage:usage];
    if(self) _desc = desc;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGMutableVertexBuffer class]) _PGMutableVertexBuffer_type = [CNClassType classTypeWithCls:[PGMutableVertexBuffer class]];
}

- (BOOL)isMutable {
    return YES;
}

- (void)bind {
    [PGGlobal.context bindVertexBufferBuffer:self];
}

- (BOOL)isEmpty {
    return NO;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"MutableVertexBuffer(%@)", _desc];
}

- (CNClassType*)type {
    return [PGMutableVertexBuffer type];
}

+ (CNClassType*)type {
    return _PGMutableVertexBuffer_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGVertexBufferRing
static CNClassType* _PGVertexBufferRing_type;
@synthesize desc = _desc;
@synthesize usage = _usage;

+ (instancetype)vertexBufferRingWithRingSize:(unsigned int)ringSize desc:(PGVertexBufferDesc*)desc usage:(unsigned int)usage {
    return [[PGVertexBufferRing alloc] initWithRingSize:ringSize desc:desc usage:usage];
}

- (instancetype)initWithRingSize:(unsigned int)ringSize desc:(PGVertexBufferDesc*)desc usage:(unsigned int)usage {
    self = [super initWithRingSize:ringSize creator:^PGMutableVertexBuffer*() {
        return [PGMutableVertexBuffer mutableVertexBufferWithDesc:desc handle:egGenBuffer() usage:usage];
    }];
    if(self) {
        _desc = desc;
        _usage = usage;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGVertexBufferRing class]) _PGVertexBufferRing_type = [CNClassType classTypeWithCls:[PGVertexBufferRing class]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"VertexBufferRing(%@, %u)", _desc, _usage];
}

- (CNClassType*)type {
    return [PGVertexBufferRing type];
}

+ (CNClassType*)type {
    return _PGVertexBufferRing_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

