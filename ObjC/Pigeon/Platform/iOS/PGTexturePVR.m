#import "PGTexturePVR.h"
#import "PGTexture.h"
#import "PGContext.h"

typedef struct _PVRTexHeader
{
    uint32_t headerLength;
    uint32_t height;
    uint32_t width;
    uint32_t numMipmaps;
    uint32_t flags;
    uint32_t dataLength;
    uint32_t bpp;
    uint32_t bitmaskRed;
    uint32_t bitmaskGreen;
    uint32_t bitmaskBlue;
    uint32_t bitmaskAlpha;
    uint32_t pvrTag;
    uint32_t numSurfs;
} ccPVRv2TexHeader;

typedef struct {
    uint32_t version;
    uint32_t flags;
    uint64_t pixelFormat;
    uint32_t colorSpace;
    uint32_t channelType;
    uint32_t height;
    uint32_t width;
    uint32_t depth;
    uint32_t numberOfSurfaces;
    uint32_t numberOfFaces;
    uint32_t numberOfMipmaps;
    uint32_t metadataLength;
} __attribute__((packed)) ccPVRv3TexHeader ;

struct CCPVRMipmap {
    unsigned char *address;
    unsigned int len;
};

typedef struct _ccPVRTexturePixelFormatInfo {
    GLenum internalFormat;
    GLenum format;
    GLenum type;
    uint32_t bpp;
    BOOL compressed;
    BOOL alpha;
} ccPVRTexturePixelFormatInfo;

static char gPVRTexIdentifier[4] = "PVR!";

typedef enum
{
    kPVR2TexturePixelFormat_RGBA_4444= 0x10,
    kPVR2TexturePixelFormat_RGBA_5551,
    kPVR2TexturePixelFormat_RGBA_8888,
    kPVR2TexturePixelFormat_RGB_565,
    kPVR2TexturePixelFormat_RGB_555,				// unsupported
    kPVR2TexturePixelFormat_RGB_888,
    kPVR2TexturePixelFormat_I_8,
    kPVR2TexturePixelFormat_AI_88,
    kPVR2TexturePixelFormat_PVRTC_2BPP_RGBA,
    kPVR2TexturePixelFormat_PVRTC_4BPP_RGBA,
    kPVR2TexturePixelFormat_BGRA_8888,
    kPVR2TexturePixelFormat_A_8,
} ccPVR2TexturePixelFormat;

typedef enum {
    /* supported predefined formats */
    kPVR3TexturePixelFormat_PVRTC_2BPP_RGB = 0,
    kPVR3TexturePixelFormat_PVRTC_2BPP_RGBA = 1,
    kPVR3TexturePixelFormat_PVRTC_4BPP_RGB = 2,
    kPVR3TexturePixelFormat_PVRTC_4BPP_RGBA = 3,

    /* supported channel type formats */
    kPVR3TexturePixelFormat_BGRA_8888 = 0x0808080861726762,
    kPVR3TexturePixelFormat_RGBA_8888 = 0x0808080861626772,
    kPVR3TexturePixelFormat_RGBA_4444 = 0x0404040461626772,
    kPVR3TexturePixelFormat_RGBA_5551 = 0x0105050561626772,
    kPVR3TexturePixelFormat_RGB_565 = 0x0005060500626772,
    kPVR3TexturePixelFormat_RGB_888 = 0x0008080800626772,
    kPVR3TexturePixelFormat_A_8 = 0x0000000800000061,
    kPVR3TexturePixelFormat_L_8 = 0x000000080000006c,
    kPVR3TexturePixelFormat_LA_88 = 0x000008080000616c,
} ccPVR3TexturePixelFormat;

static const ccPVRTexturePixelFormatInfo PVRTableFormats[] = {

        // 0: BGRA_8888
        {GL_RGBA, GL_BGRA, GL_UNSIGNED_BYTE, 32, NO, YES},
        // 1: RGBA_8888
        {GL_RGBA, GL_RGBA, GL_UNSIGNED_BYTE, 32, NO, YES},
        // 2: RGBA_4444
        {GL_RGBA, GL_RGBA, GL_UNSIGNED_SHORT_4_4_4_4, 16, NO, YES},
        // 3: RGBA_5551
        {GL_RGBA, GL_RGBA, GL_UNSIGNED_SHORT_5_5_5_1, 16, NO, YES},
        // 4: RGB_565
        {GL_RGB, GL_RGB, GL_UNSIGNED_SHORT_5_6_5, 16, NO, NO},
        // 5: RGB_888
        {GL_RGB, GL_RGB, GL_UNSIGNED_BYTE, 24, NO, NO},
        // 6: A_8
        {GL_ALPHA, GL_ALPHA, GL_UNSIGNED_BYTE, 8, NO, NO},
        // 7: L_8
        {GL_LUMINANCE, GL_LUMINANCE, GL_UNSIGNED_BYTE, 8, NO, NO},
        // 8: LA_88
        {GL_LUMINANCE_ALPHA, GL_LUMINANCE_ALPHA, GL_UNSIGNED_BYTE, 16, NO, YES},

	// 9: PVRTC 2BPP RGB
	{GL_COMPRESSED_RGB_PVRTC_2BPPV1_IMG, -1, -1, 2, YES, NO},
	// 10: PVRTC 2BPP RGBA
	{GL_COMPRESSED_RGBA_PVRTC_2BPPV1_IMG, -1, -1, 2, YES, YES},
	// 11: PVRTC 4BPP RGB
	{GL_COMPRESSED_RGB_PVRTC_4BPPV1_IMG, -1, -1, 4, YES, NO},
	// 12: PVRTC 4BPP RGBA
	{GL_COMPRESSED_RGBA_PVRTC_4BPPV1_IMG, -1, -1, 4, YES, YES},
};

struct _pixel_formathash {
    uint64_t pixelFormat;
    const ccPVRTexturePixelFormatInfo * pixelFormatInfo;
};

// v2
static struct _pixel_formathash v2_pixel_formathash[] = {

        { kPVR2TexturePixelFormat_BGRA_8888,	&PVRTableFormats[0] },
        { kPVR2TexturePixelFormat_RGBA_8888,	&PVRTableFormats[1] },
        { kPVR2TexturePixelFormat_RGBA_4444,	&PVRTableFormats[2] },
        { kPVR2TexturePixelFormat_RGBA_5551,	&PVRTableFormats[3] },
        { kPVR2TexturePixelFormat_RGB_565,		&PVRTableFormats[4] },
        { kPVR2TexturePixelFormat_RGB_888,		&PVRTableFormats[5] },
        { kPVR2TexturePixelFormat_A_8,			&PVRTableFormats[6] },
        { kPVR2TexturePixelFormat_I_8,			&PVRTableFormats[7] },
        { kPVR2TexturePixelFormat_AI_88,		&PVRTableFormats[8] },

	{ kPVR2TexturePixelFormat_PVRTC_2BPP_RGBA,	&PVRTableFormats[10] },
	{ kPVR2TexturePixelFormat_PVRTC_4BPP_RGBA,	&PVRTableFormats[12] },
};

#define PVR2_MAX_TABLE_ELEMENTS (sizeof(v2_pixel_formathash) / sizeof(v2_pixel_formathash[0]))

struct _pixel_formathash v3_pixel_formathash[] = {

        {kPVR3TexturePixelFormat_BGRA_8888,	&PVRTableFormats[0] },
        {kPVR3TexturePixelFormat_RGBA_8888,	&PVRTableFormats[1] },
        {kPVR3TexturePixelFormat_RGBA_4444, &PVRTableFormats[2] },
        {kPVR3TexturePixelFormat_RGBA_5551, &PVRTableFormats[3] },
        {kPVR3TexturePixelFormat_RGB_565,	&PVRTableFormats[4] },
        {kPVR3TexturePixelFormat_RGB_888,	&PVRTableFormats[5] },
        {kPVR3TexturePixelFormat_A_8,		&PVRTableFormats[6] },
        {kPVR3TexturePixelFormat_L_8,		&PVRTableFormats[7] },
        {kPVR3TexturePixelFormat_LA_88,		&PVRTableFormats[8] },

	{kPVR3TexturePixelFormat_PVRTC_2BPP_RGB,	&PVRTableFormats[9] },
	{kPVR3TexturePixelFormat_PVRTC_2BPP_RGBA,	&PVRTableFormats[10] },
	{kPVR3TexturePixelFormat_PVRTC_4BPP_RGB,	&PVRTableFormats[11] },
	{kPVR3TexturePixelFormat_PVRTC_4BPP_RGBA,	&PVRTableFormats[12] },
};
#define PVR3_MAX_TABLE_ELEMENTS (sizeof(v3_pixel_formathash) / sizeof(v3_pixel_formathash[0]))
enum {
    CC_PVRMIPMAP_MAX = 16,
};


PGVec2 egTextureLoadPVR2(GLuint target, PGTextureFilterR filter, NSData *texData);
PGVec2 egTextureLoadPVR3(GLuint target, PGTextureFilterR filter, NSData *texData);

PGVec2 egLoadCompressedTexture(GLuint target, NSURL* url, PGTextureFilterR filter) {
    NSData *texData = [[NSData alloc] initWithContentsOfURL:url];
    if(texData == nil) {
        NSLog(@"ERROR: Not found pvr texture: %@", url);
        return PGVec2Make(0, 0);
    }

    PGVec2 ret = egTextureLoadPVR2(target, filter, texData);
    if(ret.x != 0 ) return ret;
    return egTextureLoadPVR3(target, filter, texData);
}

#define PVR_TEXTURE_FLAG_TYPE_MASK	0xff

enum {
    kPVR2TextureFlagMipmap		= (1<<8),		// has mip map levels
    kPVR2TextureFlagTwiddle		= (1<<9),		// is twiddled
    kPVR2TextureFlagBumpmap		= (1<<10),		// has normals encoded for a bump map
    kPVR2TextureFlagTiling		= (1<<11),		// is bordered for tiled pvr
    kPVR2TextureFlagCubemap		= (1<<12),		// is a cubemap/skybox
    kPVR2TextureFlagFalseMipCol	= (1<<13),		// are there false coloured MIP levels
    kPVR2TextureFlagVolume		= (1<<14),		// is this a volume texture
    kPVR2TextureFlagAlpha		= (1<<15),		// v2.1 is there transparency info in the texture
    kPVR2TextureFlagVerticalFlip	= (1<<16),	// v2.1 is the texture vertically flipped
};

PGVec2 egTextureLoadPVR2(GLuint target, PGTextureFilterR filter, NSData *texData) {
    BOOL success = NO;
    ccPVRv2TexHeader *header = NULL;
    uint32_t flags, pvrTag;
    uint32_t dataLength = 0, dataOffset = 0, dataSize = 0;
    uint32_t blockSize = 0, widthBlocks = 0, heightBlocks = 0;
    uint32_t width = 0, height = 0, bpp = 4;
    uint8_t *bytes = NULL;
    uint32_t formatFlags;

    void const *data = texData.bytes;
    header = (ccPVRv2TexHeader *) data;

    pvrTag = CFSwapInt32LittleToHost(header->pvrTag);

    if ((uint32_t)gPVRTexIdentifier[0] != ((pvrTag >>  0) & 0xff) ||
            (uint32_t)gPVRTexIdentifier[1] != ((pvrTag >>  8) & 0xff) ||
            (uint32_t)gPVRTexIdentifier[2] != ((pvrTag >> 16) & 0xff) ||
            (uint32_t)gPVRTexIdentifier[3] != ((pvrTag >> 24) & 0xff))
    {
        return PGVec2Make(0, 0);
    }


    flags = CFSwapInt32LittleToHost(header->flags);
    formatFlags = flags & PVR_TEXTURE_FLAG_TYPE_MASK;
    BOOL flipped = (BOOL) (flags & kPVR2TextureFlagVerticalFlip);
    if( flipped ) NSLog(@"WARNING: Image is flipped. Regenerate it using PVRTexTool");

//    if( ! [configuration supportsNPOT] &&
//            ( header->width != CCNextPOT(header->width) || header->height != CCNextPOT(header->height ) ) ) {
//        CCLOGWARN(@"cocos2d: ERROR: Loding an NPOT texture (%dx%d) but is not supported on this device", header->width, header->height);
//        return NO;
//    }

    const ccPVRTexturePixelFormatInfo *_pixelFormatInfo;
    int _numberOfMipmaps;
    NSUInteger _width, _height;
    BOOL _hasAlpha;
    struct CCPVRMipmap _mipmaps[CC_PVRMIPMAP_MAX];
    for( NSUInteger i=0; i < (unsigned int)PVR2_MAX_TABLE_ELEMENTS ; i++) {
        if( v2_pixel_formathash[i].pixelFormat == formatFlags ) {

            _pixelFormatInfo = v2_pixel_formathash[i].pixelFormatInfo;
            _numberOfMipmaps = 0;

            _width = width = CFSwapInt32LittleToHost(header->width);
            _height = height = CFSwapInt32LittleToHost(header->height);

            if (CFSwapInt32LittleToHost(header->bitmaskAlpha))
                _hasAlpha = YES;
            else
                _hasAlpha = NO;

            dataLength = CFSwapInt32LittleToHost(header->dataLength);
            bytes = ((uint8_t *)data) + sizeof(ccPVRv2TexHeader);
//            _format = _pixelFormatInfo->ccPixelFormat;
            bpp = _pixelFormatInfo->bpp;

            // Calculate the data size for each texture level and respect the minimum number of blocks
            while (dataOffset < dataLength)
            {
                switch (formatFlags) {
                    case kPVR2TexturePixelFormat_PVRTC_2BPP_RGBA:
                        blockSize = 8 * 4; // Pixel by pixel block size for 2bpp
                        widthBlocks = width / 8;
                        heightBlocks = height / 4;
                        break;
                    case kPVR2TexturePixelFormat_PVRTC_4BPP_RGBA:
                        blockSize = 4 * 4; // Pixel by pixel block size for 4bpp
                        widthBlocks = width / 4;
                        heightBlocks = height / 4;
                        break;
                    case kPVR2TexturePixelFormat_BGRA_8888:
//                        if( ! [[CCConfiguration sharedConfiguration] supportsBGRA8888] ) {
//                            CCLOG(@"cocos2d: TexturePVR. BGRA8888 not supported on this device");
//                            return NO;
//                        }
                    default:
                        blockSize = 1;
                        widthBlocks = width;
                        heightBlocks = height;
                        break;
                }

                // Clamp to minimum number of blocks
                if (widthBlocks < 2)
                    widthBlocks = 2;
                if (heightBlocks < 2)
                    heightBlocks = 2;

                dataSize = widthBlocks * heightBlocks * ((blockSize  * bpp) / 8);
                unsigned int packetLength = (dataLength-dataOffset);
                packetLength = packetLength > dataSize ? dataSize : packetLength;

                _mipmaps[_numberOfMipmaps].address = bytes+dataOffset;
                _mipmaps[_numberOfMipmaps].len = packetLength;
                _numberOfMipmaps++;

//                NSAssert( _numberOfMipmaps < CC_PVRMIPMAP_MAX, @"TexturePVR: Maximum number of mimpaps reached. Increate the CC_PVRMIPMAP_MAX value");

                dataOffset += packetLength;

                width = MAX(width >> 1, 1);
                height = MAX(height >> 1, 1);
            }

            success = YES;
            break;
        }
    }

    if( ! success ) {
        NSLog(@"ERROR: Unsupported PVR Pixel Format: 0x%2x. Re-encode it with a OpenGL pixel format variant", formatFlags);
        return PGVec2Make(0, 0);
    }

    return PGVec2Make(_width, _height);
}

PGVec2 egTextureLoadPVR3(GLuint target, PGTextureFilterR filter, NSData *texData) {
    NSUInteger dataLength = texData.length;
    if(dataLength < sizeof(ccPVRv3TexHeader)) {
        NSLog(@"ERROR: pvr size error");
        return PGVec2Make(0, 0);
    }

    ccPVRv3TexHeader *header = (ccPVRv3TexHeader *)texData.bytes;

    // validate version
    if(CFSwapInt32BigToHost(header->version) != 0x50565203) {
        NSLog(@"ERROR: pvr file version mismatch");
        return PGVec2Make(0, 0);
    }

    // parse pixel format
    uint64_t pixelFormat = header->pixelFormat;


    BOOL infoValid = NO;

    const ccPVRTexturePixelFormatInfo *_pixelFormatInfo;
    for(int i = 0; i < PVR3_MAX_TABLE_ELEMENTS; i++) {
        if( v3_pixel_formathash[i].pixelFormat == pixelFormat ) {
            _pixelFormatInfo = v3_pixel_formathash[i].pixelFormatInfo;
            infoValid = YES;
            break;
        }
    }

    // unsupported / bad pixel format
    if(!infoValid) {
        NSLog(@"ERROR: unsupported pvr pixelformat: %llx", pixelFormat );
        return PGVec2Make(0, 0);
    }

    // flags
//    uint32_t flags = CFSwapInt32LittleToHost(header->flags);

    // PVRv3 specifies premultiply alpha in a flag -- should always respect this in PVRv3 files
//    _forcePremultipliedAlpha = YES;
//    if(flags & kPVR3TextureFlagPremultipliedAlpha) {
//        _hasPremultipliedAlpha = YES;
//    }

    // sizing
    uint32_t width = CFSwapInt32LittleToHost(header->width);
    uint32_t height = CFSwapInt32LittleToHost(header->height);
    uint32_t _width = width;
    uint32_t _height = height;
    uint32_t dataOffset = 0, dataSize = 0;
    uint32_t blockSize = 0, widthBlocks = 0, heightBlocks = 0;
    uint8_t *bytes = NULL;

    dataOffset = (sizeof(ccPVRv3TexHeader) + header->metadataLength);
    bytes = (unsigned char*)texData.bytes;

    uint32_t numberOfMipmaps = header->numberOfMipmaps;
    struct CCPVRMipmap _mipmaps[CC_PVRMIPMAP_MAX];

    for(int i = 0; i < numberOfMipmaps; i++) {

        switch(pixelFormat) {
            case kPVR3TexturePixelFormat_PVRTC_2BPP_RGB :
            case kPVR3TexturePixelFormat_PVRTC_2BPP_RGBA :
                blockSize = 8 * 4; // Pixel by pixel block size for 2bpp
                widthBlocks = width / 8;
                heightBlocks = height / 4;
                break;
            case kPVR3TexturePixelFormat_PVRTC_4BPP_RGB :
            case kPVR3TexturePixelFormat_PVRTC_4BPP_RGBA :
                blockSize = 4 * 4; // Pixel by pixel block size for 4bpp
                widthBlocks = width / 4;
                heightBlocks = height / 4;
                break;
            case kPVR3TexturePixelFormat_BGRA_8888:
            default:
                blockSize = 1;
                widthBlocks = width;
                heightBlocks = height;
                break;
        }

        // Clamp to minimum number of blocks
        if (widthBlocks < 2)
            widthBlocks = 2;
        if (heightBlocks < 2)
            heightBlocks = 2;

        dataSize = widthBlocks * heightBlocks * ((blockSize  * _pixelFormatInfo->bpp) / 8);
        unsigned int packetLength = ((unsigned int)dataLength-dataOffset);
        packetLength = packetLength > dataSize ? dataSize : packetLength;

        _mipmaps[i].address = bytes+dataOffset;
        _mipmaps[i].len = packetLength;

        dataOffset += packetLength;
//        NSAssert( dataOffset <= dataLength, @"TexurePVR: Invalid length");


        width = MAX(width >> 1, 1);
        height = MAX(height >> 1, 1);
    }


    GLenum err;
    err = glGetError();
    if (err != GL_NO_ERROR)
    {
        NSLog(@"TexturePVR: Error before: 0x%04X", err);
        return PGVec2Make(0, 0);
    }


    if (numberOfMipmaps > 0)
    {
        // From PVR sources: "PVR files are never row aligned."
        glPixelStorei(GL_UNPACK_ALIGNMENT,1);

        [[PGGlobal context] bindTextureTextureId:target];
        // Default: Anti alias.
        PGTextureFilter *filterValue = [PGTextureFilter value:filter];
        glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, filterValue.minFilter );
        glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, filterValue.magFilter );
    }

    GLenum internalFormat = _pixelFormatInfo->internalFormat;
    GLenum format = _pixelFormatInfo->format;
    GLenum type = _pixelFormatInfo->type;
    BOOL compressed = _pixelFormatInfo->compressed;

    width = _width;
    height = _height;
    // Generate textures with mipmaps
    for (GLint i=0; i < numberOfMipmaps; i++) {
        unsigned char *data = _mipmaps[i].address;
        GLsizei datalen = _mipmaps[i].len;

        if( compressed)
            glCompressedTexImage2D(GL_TEXTURE_2D, i, internalFormat, width, height, 0, datalen, data);
        else
            glTexImage2D(GL_TEXTURE_2D, i, internalFormat, width, height, 0, format, type, data);

//        if( i > 0 && (width != height || CCNextPOT(width) != width ) )
//            CCLOGWARN(@"cocos2d: TexturePVR. WARNING. Mipmap level %u is not squared. Texture won't render correctly. width=%u != height=%u", i, width, height);

        err = glGetError();
        if (err != GL_NO_ERROR)
        {
            NSLog(@"TexturePVR: Error uploading compressed texture level: %u . glError: 0x%04X", i, err);
            return PGVec2Make(0, 0);
        }

        width = MAX(width >> 1, 1);
        height = MAX(height >> 1, 1);
    }

    return PGVec2Make(_width, _height);
}