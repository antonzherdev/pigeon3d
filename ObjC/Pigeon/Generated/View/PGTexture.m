#import "PGTexture.h"

#import "GL.h"
#import "PGContext.h"
#import "PGTexturePlat.h"
#import "PGMaterial.h"
PGTextureFileFormat* PGTextureFileFormat_Values[4];
PGTextureFileFormat* PGTextureFileFormat_PNG_Desc;
PGTextureFileFormat* PGTextureFileFormat_JPEG_Desc;
PGTextureFileFormat* PGTextureFileFormat_compressed_Desc;
@implementation PGTextureFileFormat{
    NSString* _extension;
}
@synthesize extension = _extension;

+ (instancetype)textureFileFormatWithOrdinal:(NSUInteger)ordinal name:(NSString*)name extension:(NSString*)extension {
    return [[PGTextureFileFormat alloc] initWithOrdinal:ordinal name:name extension:extension];
}

- (instancetype)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name extension:(NSString*)extension {
    self = [super initWithOrdinal:ordinal name:name];
    if(self) _extension = extension;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    PGTextureFileFormat_PNG_Desc = [PGTextureFileFormat textureFileFormatWithOrdinal:0 name:@"PNG" extension:@"png"];
    PGTextureFileFormat_JPEG_Desc = [PGTextureFileFormat textureFileFormatWithOrdinal:1 name:@"JPEG" extension:@"jpg"];
    PGTextureFileFormat_compressed_Desc = [PGTextureFileFormat textureFileFormatWithOrdinal:2 name:@"compressed" extension:@"?"];
    PGTextureFileFormat_Values[0] = nil;
    PGTextureFileFormat_Values[1] = PGTextureFileFormat_PNG_Desc;
    PGTextureFileFormat_Values[2] = PGTextureFileFormat_JPEG_Desc;
    PGTextureFileFormat_Values[3] = PGTextureFileFormat_compressed_Desc;
}

+ (NSArray*)values {
    return (@[PGTextureFileFormat_PNG_Desc, PGTextureFileFormat_JPEG_Desc, PGTextureFileFormat_compressed_Desc]);
}

+ (PGTextureFileFormat*)value:(PGTextureFileFormatR)r {
    return PGTextureFileFormat_Values[r];
}

@end

PGTextureFormat* PGTextureFormat_Values[6];
PGTextureFormat* PGTextureFormat_RGBA8_Desc;
PGTextureFormat* PGTextureFormat_RGBA4_Desc;
PGTextureFormat* PGTextureFormat_RGB5A1_Desc;
PGTextureFormat* PGTextureFormat_RGB8_Desc;
PGTextureFormat* PGTextureFormat_RGB565_Desc;
@implementation PGTextureFormat

+ (instancetype)textureFormatWithOrdinal:(NSUInteger)ordinal name:(NSString*)name {
    return [[PGTextureFormat alloc] initWithOrdinal:ordinal name:name];
}

- (instancetype)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name {
    self = [super initWithOrdinal:ordinal name:name];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    PGTextureFormat_RGBA8_Desc = [PGTextureFormat textureFormatWithOrdinal:0 name:@"RGBA8"];
    PGTextureFormat_RGBA4_Desc = [PGTextureFormat textureFormatWithOrdinal:1 name:@"RGBA4"];
    PGTextureFormat_RGB5A1_Desc = [PGTextureFormat textureFormatWithOrdinal:2 name:@"RGB5A1"];
    PGTextureFormat_RGB8_Desc = [PGTextureFormat textureFormatWithOrdinal:3 name:@"RGB8"];
    PGTextureFormat_RGB565_Desc = [PGTextureFormat textureFormatWithOrdinal:4 name:@"RGB565"];
    PGTextureFormat_Values[0] = nil;
    PGTextureFormat_Values[1] = PGTextureFormat_RGBA8_Desc;
    PGTextureFormat_Values[2] = PGTextureFormat_RGBA4_Desc;
    PGTextureFormat_Values[3] = PGTextureFormat_RGB5A1_Desc;
    PGTextureFormat_Values[4] = PGTextureFormat_RGB8_Desc;
    PGTextureFormat_Values[5] = PGTextureFormat_RGB565_Desc;
}

+ (NSArray*)values {
    return (@[PGTextureFormat_RGBA8_Desc, PGTextureFormat_RGBA4_Desc, PGTextureFormat_RGB5A1_Desc, PGTextureFormat_RGB8_Desc, PGTextureFormat_RGB565_Desc]);
}

+ (PGTextureFormat*)value:(PGTextureFormatR)r {
    return PGTextureFormat_Values[r];
}

@end

PGTextureFilter* PGTextureFilter_Values[4];
PGTextureFilter* PGTextureFilter_nearest_Desc;
PGTextureFilter* PGTextureFilter_linear_Desc;
PGTextureFilter* PGTextureFilter_mipmapNearest_Desc;
@implementation PGTextureFilter{
    unsigned int _magFilter;
    unsigned int _minFilter;
}
@synthesize magFilter = _magFilter;
@synthesize minFilter = _minFilter;

+ (instancetype)textureFilterWithOrdinal:(NSUInteger)ordinal name:(NSString*)name magFilter:(unsigned int)magFilter minFilter:(unsigned int)minFilter {
    return [[PGTextureFilter alloc] initWithOrdinal:ordinal name:name magFilter:magFilter minFilter:minFilter];
}

- (instancetype)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name magFilter:(unsigned int)magFilter minFilter:(unsigned int)minFilter {
    self = [super initWithOrdinal:ordinal name:name];
    if(self) {
        _magFilter = magFilter;
        _minFilter = minFilter;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    PGTextureFilter_nearest_Desc = [PGTextureFilter textureFilterWithOrdinal:0 name:@"nearest" magFilter:GL_NEAREST minFilter:GL_NEAREST];
    PGTextureFilter_linear_Desc = [PGTextureFilter textureFilterWithOrdinal:1 name:@"linear" magFilter:GL_LINEAR minFilter:GL_LINEAR];
    PGTextureFilter_mipmapNearest_Desc = [PGTextureFilter textureFilterWithOrdinal:2 name:@"mipmapNearest" magFilter:GL_LINEAR minFilter:GL_LINEAR_MIPMAP_NEAREST];
    PGTextureFilter_Values[0] = nil;
    PGTextureFilter_Values[1] = PGTextureFilter_nearest_Desc;
    PGTextureFilter_Values[2] = PGTextureFilter_linear_Desc;
    PGTextureFilter_Values[3] = PGTextureFilter_mipmapNearest_Desc;
}

+ (NSArray*)values {
    return (@[PGTextureFilter_nearest_Desc, PGTextureFilter_linear_Desc, PGTextureFilter_mipmapNearest_Desc]);
}

+ (PGTextureFilter*)value:(PGTextureFilterR)r {
    return PGTextureFilter_Values[r];
}

@end

@implementation PGTexture
static CNClassType* _PGTexture_type;

+ (instancetype)texture {
    return [[PGTexture alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGTexture class]) _PGTexture_type = [CNClassType classTypeWithCls:[PGTexture class]];
}

- (unsigned int)id {
    @throw @"Method id is abstract";
}

- (PGVec2)size {
    @throw @"Method size is abstract";
}

- (CGFloat)scale {
    return 1.0;
}

- (PGVec2)scaledSize {
    return pgVec2DivF([self size], [self scale]);
}

- (void)dealloc {
    [self deleteTexture];
}

- (void)deleteTexture {
    [[PGGlobal context] deleteTextureId:[self id]];
}

- (void)saveToFile:(NSString*)file {
    egSaveTextureToFile([self id], file);
}

- (PGRect)uv {
    return pgRectApplyXYWidthHeight(0.0, 0.0, 1.0, 1.0);
}

- (PGRect)uvRect:(PGRect)rect {
    return pgRectDivVec2(rect, [self scaledSize]);
}

- (PGRect)uvX:(float)x y:(float)y width:(float)width height:(float)height {
    return [self uvRect:pgRectApplyXYWidthHeight(x, y, width, height)];
}

- (PGTextureRegion*)regionX:(float)x y:(float)y width:(CGFloat)width height:(float)height {
    return [PGTextureRegion textureRegionWithTexture:self uv:pgRectDivVec2((pgRectApplyXYWidthHeight(x, y, ((float)(width)), height)), [self scaledSize])];
}

- (PGColorSource*)colorSource {
    return [PGColorSource applyTexture:self];
}

- (NSString*)description {
    return @"Texture";
}

- (CNClassType*)type {
    return [PGTexture type];
}

+ (CNClassType*)type {
    return _PGTexture_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGEmptyTexture
static CNClassType* _PGEmptyTexture_type;
@synthesize size = _size;
@synthesize id = _id;

+ (instancetype)emptyTextureWithSize:(PGVec2)size {
    return [[PGEmptyTexture alloc] initWithSize:size];
}

- (instancetype)initWithSize:(PGVec2)size {
    self = [super init];
    if(self) {
        _size = size;
        _id = egGenTexture();
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGEmptyTexture class]) _PGEmptyTexture_type = [CNClassType classTypeWithCls:[PGEmptyTexture class]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"EmptyTexture(%@)", pgVec2Description(_size)];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[PGEmptyTexture class]])) return NO;
    PGEmptyTexture* o = ((PGEmptyTexture*)(to));
    return pgVec2IsEqualTo(_size, o->_size);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + pgVec2Hash(_size);
    return hash;
}

- (CNClassType*)type {
    return [PGEmptyTexture type];
}

+ (CNClassType*)type {
    return _PGEmptyTexture_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGFileTexture
static CNClassType* _PGFileTexture_type;
@synthesize name = _name;
@synthesize fileFormat = _fileFormat;
@synthesize format = _format;
@synthesize scale = _scale;
@synthesize filter = _filter;
@synthesize id = _id;

+ (instancetype)fileTextureWithName:(NSString*)name fileFormat:(PGTextureFileFormatR)fileFormat format:(PGTextureFormatR)format scale:(CGFloat)scale filter:(PGTextureFilterR)filter {
    return [[PGFileTexture alloc] initWithName:name fileFormat:fileFormat format:format scale:scale filter:filter];
}

- (instancetype)initWithName:(NSString*)name fileFormat:(PGTextureFileFormatR)fileFormat format:(PGTextureFormatR)format scale:(CGFloat)scale filter:(PGTextureFilterR)filter {
    self = [super init];
    if(self) {
        _name = name;
        _fileFormat = fileFormat;
        _format = format;
        _scale = scale;
        _filter = filter;
        _id = egGenTexture();
        [self _init];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGFileTexture class]) _PGFileTexture_type = [CNClassType classTypeWithCls:[PGFileTexture class]];
}

- (void)_init {
    __size = egLoadTextureFromFile(_id, _name, _fileFormat, _scale, _format, _filter);
}

- (PGVec2)size {
    return __size;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"FileTexture(%@, %@, %@, %f, %@)", _name, [PGTextureFileFormat value:_fileFormat], [PGTextureFormat value:_format], _scale, [PGTextureFilter value:_filter]];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[PGFileTexture class]])) return NO;
    PGFileTexture* o = ((PGFileTexture*)(to));
    return [_name isEqual:o->_name] && _fileFormat == o->_fileFormat && _format == o->_format && eqf(_scale, o->_scale) && _filter == o->_filter;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [_name hash];
    hash = hash * 31 + [[PGTextureFileFormat value:_fileFormat] hash];
    hash = hash * 31 + [[PGTextureFormat value:_format] hash];
    hash = hash * 31 + floatHash(_scale);
    hash = hash * 31 + [[PGTextureFilter value:_filter] hash];
    return hash;
}

- (CNClassType*)type {
    return [PGFileTexture type];
}

+ (CNClassType*)type {
    return _PGFileTexture_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGTextureRegion
static CNClassType* _PGTextureRegion_type;
@synthesize texture = _texture;
@synthesize uv = _uv;
@synthesize id = _id;
@synthesize size = _size;

+ (instancetype)textureRegionWithTexture:(PGTexture*)texture uv:(PGRect)uv {
    return [[PGTextureRegion alloc] initWithTexture:texture uv:uv];
}

- (instancetype)initWithTexture:(PGTexture*)texture uv:(PGRect)uv {
    self = [super init];
    if(self) {
        _texture = texture;
        _uv = uv;
        _id = [texture id];
        _size = pgVec2MulVec2([texture size], uv.size);
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGTextureRegion class]) _PGTextureRegion_type = [CNClassType classTypeWithCls:[PGTextureRegion class]];
}

+ (PGTextureRegion*)applyTexture:(PGTexture*)texture {
    return [PGTextureRegion textureRegionWithTexture:texture uv:pgRectApplyXYWidthHeight(0.0, 0.0, 1.0, 1.0)];
}

- (CGFloat)scale {
    return [_texture scale];
}

- (void)deleteTexture {
}

- (NSString*)description {
    return [NSString stringWithFormat:@"TextureRegion(%@, %@)", _texture, pgRectDescription(_uv)];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[PGTextureRegion class]])) return NO;
    PGTextureRegion* o = ((PGTextureRegion*)(to));
    return [_texture isEqual:o->_texture] && pgRectIsEqualTo(_uv, o->_uv);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [_texture hash];
    hash = hash * 31 + pgRectHash(_uv);
    return hash;
}

- (CNClassType*)type {
    return [PGTextureRegion type];
}

+ (CNClassType*)type {
    return _PGTextureRegion_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

