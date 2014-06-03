#import "PGTTFFont.h"

#import "PGTexture.h"
#import "GL.h"
#import "PGTexturePlat.h"
#import "CNObserver.h"

@implementation PGTTFFont {
    NSString* _name;
    NSUInteger _size;
    NSMutableDictionary* _symbols;
    BOOL _textureStale;
    BOOL _symbolsStale;
    PGTexture* _texture;
    NSUInteger _height;
}
static CNClassType* _EGTTFFont_type;
@synthesize name = _name;
@synthesize size = _size;

+ (id)fontWithName:(NSString*)name size:(NSUInteger)size {
    return [[PGTTFFont alloc] initWithName:name size:size];
}

- (id)initWithName:(NSString*)name size:(NSUInteger)size {
    self = [super init];
    if(self) {
        _name = name;
        _size = size;
        _symbols = [NSMutableDictionary dictionary];
        _textureStale = YES;
        _symbolsStale = YES;
        #if TARGET_OS_IPHONE
        UIFont* font = [UIFont fontWithName:_name size:_size];
        _height = (NSUInteger) ceil(font.lineHeight);
        #else
        NSFont* font = [NSFont fontWithName:_name size:_size];
        _height = (NSUInteger) [[[NSLayoutManager alloc] init] defaultLineHeightForFont:font];
        #endif
        
        NSAssert(font, @"Not found font %@", _name);
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGTTFFont_type = [CNClassType classTypeWithCls:[PGTTFFont class]];
}

- (id)symbolOptSmb:(unichar)smb {
    return [_symbols applyKey:nums(smb) orUpdateWith:^PGFontSymbolDesc*() {
        _textureStale = YES;
        _symbolsStale = YES;
        [[self symbolsChanged] post];
        return [self symbolSmb:smb];
    }];
}

- (PGFontSymbolDesc*)symbolSmb:(unichar)smb {
    return [PGFont zeroDesc];
}

- (PGTexture*)texture {
    if(_textureStale) {
        @synchronized (self) {
            if(_textureStale) {
                _texture = [self generateTexture:YES];
                OSMemoryBarrier();
            }
        }
    }
    return _texture;
}

- (NSUInteger)height {
    return _height;
}

- (BOOL)resymbolHasGL:(BOOL)hasGL {
    if(hasGL) {
        if(_textureStale) {
            _texture = [self generateTexture:YES];
            OSMemoryBarrier();
            return YES;
        }
    } else {
        if(_symbolsStale) {
            [self generateTexture:NO];
            return YES;
        }
    }
    return NO;
}


- (PGTexture *)generateTexture:(BOOL)gl {
    #if TARGET_OS_IPHONE
    UIFont* font = [UIFont fontWithName:_name size:_size];
    #else
    NSFont* font = [NSFont fontWithName:_name size:_size];
    #endif
    
    //Measure texture size
    NSUInteger symbolsCount = _symbols.count;
    NSUInteger symbolsInString = (NSUInteger) ceil(sqrt(symbolsCount));
    NSUInteger textureSize = (NSUInteger) (symbolsInString * (_height + 1));
    NSUInteger w = 32;
    while(textureSize > w) w *= 2;
    textureSize = w;

    NSLog(@"Font: GenerateTexture %@: %@ %lu %lu%lui", gl ? @"with Texture" : @"only Sizes",
            _name, (unsigned long)_size, (unsigned long)textureSize, (unsigned long)textureSize);

    
    //Create Texture
    NSDictionary *attributes;
    unsigned char* data;
    CGContextRef context;
    if(gl) {
        data = calloc(textureSize, textureSize * 4);
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        context = CGBitmapContextCreate(data, textureSize, textureSize, 8, textureSize * 4, colorSpace,
                kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
        CGColorSpaceRelease(colorSpace);
        if (!context)
        {
            free(data);
            return NULL;
        }
        CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, textureSize);
        CGContextConcatCTM(context, flipVertical);

        #if TARGET_OS_IPHONE
        UIGraphicsPushContext(context);
        UIColor* color = [UIColor whiteColor];
        [color set];
        #else
        [NSGraphicsContext saveGraphicsState];
        NSGraphicsContext * nscg = [NSGraphicsContext graphicsContextWithGraphicsPort:context flipped:YES];
        [NSGraphicsContext setCurrentContext:nscg];
        NSColor* color = [NSColor whiteColor];
        [color set];
        #endif
        attributes = @{NSFontAttributeName : font, NSForegroundColorAttributeName : color};
    } else {
        attributes = @{NSFontAttributeName : font};
        context = NULL;
        data = NULL;
    }


  
    __block NSUInteger i = 0;
    __block NSUInteger x = 0, y = 0;
    [[_symbols copy] enumerateKeysAndObjectsUsingBlock:^(id key, PGFontSymbolDesc* desc, BOOL *stop) {
        unichar c = unums(key);
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:[NSString stringWithCharacters:&c length:1] attributes:attributes];
        PGVec2 size;
        if(desc.width == 0) {
            #if TARGET_OS_IPHONE
            CGSize s = [str size];
            #else
            NSSize s = [str size];
            #endif
            size = (PGVec2){ceil(s.width), ceil(s.height)};
        } else {
            size = desc.size;
        }
        PGFontSymbolDesc *d = [PGFontSymbolDesc fontSymbolDescWithWidth:size.x offset:PGVec2Make(0, 0) size:size
                                                              textureRect:pgRectDivF(pgRectApplyXYWidthHeight(
                                                                      x, y, size.x, _height), textureSize)
                                                                isNewLine:false];
        [_symbols setObject:d forKey:key];

        if(gl) {
            [str drawAtPoint:CGPointMake(x, y)];
            i++;
            if(i >= symbolsInString) {
                i = 0;
                x = 0;
                y += _height + 1;
            } else {
                x += size.x + 1;
            }
        }

    }];

    if(gl) {
        #if TARGET_OS_IPHONE
        UIGraphicsPopContext();
        #else
        [NSGraphicsContext restoreGraphicsState];
        #endif
        CGContextRelease(context);

        //Create texture
        PGVec2 ts = PGVec2Make(textureSize, textureSize);
        PGEmptyTexture *texture = [PGEmptyTexture emptyTextureWithSize:ts];
        egLoadTextureFromData(texture.id, PGTextureFormat_RGBA4, PGTextureFilter_nearest, ts, data);
        _textureStale = NO;
        _symbolsStale = NO;
//    egSaveTextureToFile(texture.id, [NSString stringWithFormat:@"test%lu.png", (long)_size]);
        return texture;
    } else {
        _symbolsStale = NO;
        return nil;
    }
}


- (CNClassType*)type {
    return [PGTTFFont type];
}

+ (CNClassType*)type {
    return _EGTTFFont_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    PGTTFFont * o = ((PGTTFFont *)(other));
    return [self.name isEqual:o.name] && self.size == o.size;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.name hash];
    hash = hash * 31 + self.size;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"name=%@", self.name];
    [description appendFormat:@", size=%lu", (unsigned long)self.size];
    [description appendString:@">"];
    return description;
}

@end


