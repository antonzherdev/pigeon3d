#import "objd.h"
#import "PGVec.h"
@class PGGlobal;
@class PGContext;
@class PGColorSource;

@class PGTexture;
@class PGEmptyTexture;
@class PGFileTexture;
@class PGTextureRegion;
@class PGTextureFileFormat;
@class PGTextureFormat;
@class PGTextureFilter;

typedef enum PGTextureFileFormatR {
    PGTextureFileFormat_Nil = 0,
    PGTextureFileFormat_PNG = 1,
    PGTextureFileFormat_JPEG = 2,
    PGTextureFileFormat_compressed = 3
} PGTextureFileFormatR;
@interface PGTextureFileFormat : CNEnum
@property (nonatomic, readonly) NSString* extension;

+ (NSArray*)values;
+ (PGTextureFileFormat*)value:(PGTextureFileFormatR)r;
@end


typedef enum PGTextureFormatR {
    PGTextureFormat_Nil = 0,
    PGTextureFormat_RGBA8 = 1,
    PGTextureFormat_RGBA4 = 2,
    PGTextureFormat_RGB5A1 = 3,
    PGTextureFormat_RGB8 = 4,
    PGTextureFormat_RGB565 = 5
} PGTextureFormatR;
@interface PGTextureFormat : CNEnum
+ (NSArray*)values;
+ (PGTextureFormat*)value:(PGTextureFormatR)r;
@end


typedef enum PGTextureFilterR {
    PGTextureFilter_Nil = 0,
    PGTextureFilter_nearest = 1,
    PGTextureFilter_linear = 2,
    PGTextureFilter_mipmapNearest = 3
} PGTextureFilterR;
@interface PGTextureFilter : CNEnum
@property (nonatomic, readonly) unsigned int magFilter;
@property (nonatomic, readonly) unsigned int minFilter;

+ (NSArray*)values;
+ (PGTextureFilter*)value:(PGTextureFilterR)r;
@end


@interface PGTexture : NSObject
+ (instancetype)texture;
- (instancetype)init;
- (CNClassType*)type;
- (unsigned int)id;
- (PGVec2)size;
- (CGFloat)scale;
- (PGVec2)scaledSize;
- (void)dealloc;
- (void)deleteTexture;
- (void)saveToFile:(NSString*)file;
- (PGRect)uv;
- (PGRect)uvRect:(PGRect)rect;
- (PGRect)uvX:(float)x y:(float)y width:(float)width height:(float)height;
- (PGTextureRegion*)regionX:(float)x y:(float)y width:(CGFloat)width height:(float)height;
- (PGColorSource*)colorSource;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGEmptyTexture : PGTexture {
@public
    PGVec2 _size;
    unsigned int _id;
}
@property (nonatomic, readonly) PGVec2 size;
@property (nonatomic, readonly) unsigned int id;

+ (instancetype)emptyTextureWithSize:(PGVec2)size;
- (instancetype)initWithSize:(PGVec2)size;
- (CNClassType*)type;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface PGFileTexture : PGTexture {
@public
    NSString* _name;
    PGTextureFileFormatR _fileFormat;
    PGTextureFormatR _format;
    CGFloat _scale;
    PGTextureFilterR _filter;
    unsigned int _id;
    PGVec2 __size;
}
@property (nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) PGTextureFileFormatR fileFormat;
@property (nonatomic, readonly) PGTextureFormatR format;
@property (nonatomic, readonly) CGFloat scale;
@property (nonatomic, readonly) PGTextureFilterR filter;
@property (nonatomic, readonly) unsigned int id;

+ (instancetype)fileTextureWithName:(NSString*)name fileFormat:(PGTextureFileFormatR)fileFormat format:(PGTextureFormatR)format scale:(CGFloat)scale filter:(PGTextureFilterR)filter;
- (instancetype)initWithName:(NSString*)name fileFormat:(PGTextureFileFormatR)fileFormat format:(PGTextureFormatR)format scale:(CGFloat)scale filter:(PGTextureFilterR)filter;
- (CNClassType*)type;
- (void)_init;
- (PGVec2)size;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface PGTextureRegion : PGTexture {
@public
    PGTexture* _texture;
    PGRect _uv;
    unsigned int _id;
    PGVec2 _size;
}
@property (nonatomic, readonly) PGTexture* texture;
@property (nonatomic, readonly) PGRect uv;
@property (nonatomic, readonly) unsigned int id;
@property (nonatomic, readonly) PGVec2 size;

+ (instancetype)textureRegionWithTexture:(PGTexture*)texture uv:(PGRect)uv;
- (instancetype)initWithTexture:(PGTexture*)texture uv:(PGRect)uv;
- (CNClassType*)type;
+ (PGTextureRegion*)applyTexture:(PGTexture*)texture;
- (CGFloat)scale;
- (void)deleteTexture;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


