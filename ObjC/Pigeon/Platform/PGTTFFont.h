#import "objd.h"
#import "PGFont.h"
@class PGTexture;

@class PGTTFFont;

@interface PGTTFFont : PGFont
@property (nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) NSUInteger size;

+ (id)fontWithName:(NSString*)name size:(NSUInteger)size;
- (id)initWithName:(NSString*)name size:(NSUInteger)size;
- (CNClassType*)type;
- (id)symbolOptSmb:(unichar)smb;
- (PGFontSymbolDesc*)symbolSmb:(unichar)smb;
- (PGTexture*)texture;
+ (CNClassType*)type;
@end


