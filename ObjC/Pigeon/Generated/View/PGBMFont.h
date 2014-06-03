#import "objd.h"
#import "PGFont.h"
#import "PGTexture.h"
#import "PGVec.h"
@class CNChain;

@class PGBMFont;

@interface PGBMFont : PGFont {
@protected
    NSString* _name;
    PGFileTexture* _texture;
    id<CNMap> _symbols;
    NSUInteger _height;
    NSUInteger _size;
}
@property (nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) PGFileTexture* texture;
@property (nonatomic, readonly) NSUInteger height;
@property (nonatomic, readonly) NSUInteger size;

+ (instancetype)fontWithName:(NSString*)name;
- (instancetype)initWithName:(NSString*)name;
- (CNClassType*)type;
- (void)_init;
- (PGFontSymbolDesc*)symbolOptSmb:(unichar)smb;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


