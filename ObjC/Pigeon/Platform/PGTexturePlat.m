#import "GL.h"
#import "PGTexturePlat.h"
#import "PGContext.h"
#import "PGTexture.h"
#import "CNPlatform.h"
#import <ImageIO/ImageIO.h>

#if TARGET_OS_IPHONE
#import "PGTexturePVR.h"

#endif

PGVec2 egLoadTextureFromFile(GLuint target, NSString* name, PGTextureFileFormatR fileFormat, CGFloat scale, PGTextureFormatR format, PGTextureFilterR filter) {
    BOOL compressed = fileFormat == PGTextureFileFormat_compressed;
    NSString *extension = compressed ?
        #if TARGET_OS_IPHONE
            @"pvr"
        #else
            @"png"
        #endif
            : [PGTextureFileFormat value:fileFormat].extension;
            
    NSString *fileName = [NSString stringWithFormat:@"%@%@.%@",
                                                    name,
                                                    eqf(scale, 1) ? @"" : [NSString stringWithFormat:@"_%ix", (int) round(scale)],
                                                    extension];
    NSString *file = [CNBundle fileNameForResource:fileName];
    NSURL * nsUrl = [NSURL fileURLWithPath:file];
    CFURLRef url = (__bridge CFURLRef) nsUrl;
#if TARGET_OS_IPHONE
    if(compressed) {
        return egLoadCompressedTexture(target, nsUrl, filter);
    }
#endif
    CGImageSourceRef myImageSourceRef = CGImageSourceCreateWithURL(url, NULL);
    if(myImageSourceRef == nil) {
        NSLog(@"ERROR: Texture %@ not found", fileName);
        return PGVec2Make(0, 0);
    }
    CGImageRef myImageRef = CGImageSourceCreateImageAtIndex (myImageSourceRef, 0, NULL);

    size_t width = CGImageGetWidth(myImageRef);
    size_t height = CGImageGetHeight(myImageRef);
    CGRect rect = {{0, 0}, {width, height}};
    void *myData= calloc(width * 4, height);
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGContextRef myBitmapContext = CGBitmapContextCreate (myData,
            width, height, 8,
            width*4, space,
            kCGBitmapByteOrder32Host | kCGImageAlphaPremultipliedFirst);


    PGVec2 size = PGVec2Make(width, height);
    CGContextSetBlendMode(myBitmapContext, kCGBlendModeCopy);
    CGContextDrawImage(myBitmapContext, rect, myImageRef);

    CGContextRelease(myBitmapContext);
    CFRelease(myImageSourceRef);
    CFRelease(myImageRef);
    CFRelease(space);

    egLoadTextureFromData(target, format, filter, size, myData);
    egCheckError();
    return size;

}

void egLoadTextureFromData(GLuint target, PGTextureFormatR format, PGTextureFilterR filter, PGVec2 size, void *data) {
    void*					tempData;
    unsigned int*			inPixel32;
    unsigned short*			outPixel16;
    if(format == PGTextureFormat_RGB565) {
        //Convert "RRRRRRRRRGGGGGGGGBBBBBBBBAAAAAAAA" to "RRRRRGGGGGGBBBBB"
        tempData = malloc((size_t) (size.y * size.x * 2));
        inPixel32 = (unsigned int*)data;
        outPixel16 = (unsigned short*)tempData;
        for(unsigned int i = 0; i < size.x * size.y; ++i, ++inPixel32)
            *outPixel16++ = (unsigned short) (((((*inPixel32 >> 0) & 0xFF) >> 3) << 11) | ((((*inPixel32 >> 8) & 0xFF) >> 2) << 5) | ((((*inPixel32 >> 16) & 0xFF) >> 3) << 0));
        free(data);
        data = tempData;

    } else if(format == PGTextureFormat_RGB8) {
        //Convert "RRRRRRRRRGGGGGGGGBBBBBBBBAAAAAAAA" to "RRRRRRRRGGGGGGGGBBBBBBB"
        tempData = malloc((size_t) (size.y * size.x * 3));
        char *inData = (char*)data;
        char *outData = (char*)tempData;
        int j=0;
        for(unsigned int i = 0; i < size.x * size.y *4; i++) {
            outData[j++] = inData[i++];
            outData[j++] = inData[i++];
            outData[j++] = inData[i++];
        }
        free(data);
        data = tempData;
    } else if(format == PGTextureFormat_RGBA4) {
        //Convert "RRRRRRRRRGGGGGGGGBBBBBBBBAAAAAAAA" to "RRRRGGGGBBBBAAAA"
        tempData = malloc((size_t) (size.y * size.x * 2));
        inPixel32 = (unsigned int*)data;
        outPixel16 = (unsigned short*)tempData;
        for(unsigned int i = 0; i < size.x * size.y; ++i, ++inPixel32)
            *outPixel16++ =
                    (unsigned short) (((((*inPixel32 >> 0) & 0xFF) >> 4) << 12) | // R
                                                ((((*inPixel32 >> 8) & 0xFF) >> 4) << 8) | // G
                                                ((((*inPixel32 >> 16) & 0xFF) >> 4) << 4) | // B
                                                ((((*inPixel32 >> 24) & 0xFF) >> 4) << 0)); // A


        free(data);
        data = tempData;
    } else if(format == PGTextureFormat_RGB5A1) {
        //Convert "RRRRRRRRRGGGGGGGGBBBBBBBBAAAAAAAA" to "RRRRRGGGGGBBBBBA"
        /*
         Here was a bug.
         When you convert RGBA8888 texture to RGB5A1 texture and then render it on black background, you'll see a "ghost" image as if the texture is still RGBA8888. 
         On background lighter than the pixel color this effect disappers.
         This happens because the old convertion function doesn't premultiply old RGB with new A.
         As Result = sourceRGB + destination*(1-source A), then
         if Destination = 0000, then Result = source. Here comes the ghost!
         We need to check new alpha value first (it may be 1 or 0) and depending on it whether convert RGB values or just set pixel to 0 
         */
        tempData = malloc((size_t) (size.y * size.x * 2));
        inPixel32 = (unsigned int*)data;
        outPixel16 = (unsigned short*)tempData;
        for(unsigned int i = 0; i < size.x * size.y; ++i, ++inPixel32) {
            if ((*inPixel32 >> 31))// A can be 1 or 0
                *outPixel16++ =
                        (unsigned short) (((((*inPixel32 >> 0) & 0xFF) >> 3) << 11) | // R
                                                        ((((*inPixel32 >> 8) & 0xFF) >> 3) << 6) | // G
                                                        ((((*inPixel32 >> 16) & 0xFF) >> 3) << 1) | // B
                                                        1); // A
            else
                *outPixel16++ = 0;
        }

        free(data);
        data = tempData;
    }


    PGTextureFilter *filterValue = [PGTextureFilter value:filter];
    unsigned int magFilter = filterValue.magFilter;
    unsigned int minFilter = filterValue.minFilter;
    [[PGGlobal context] bindTextureTextureId:target];
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, magFilter);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, minFilter);
    if(format == PGTextureFormat_RGBA8) {
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (GLsizei)size.x, (GLsizei)size.y, 0, GL_BGRA, GL_UNSIGNED_BYTE, data);
    } else if(format == PGTextureFormat_RGBA4) {
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (GLsizei)size.x, (GLsizei)size.y, 0, GL_RGBA, GL_UNSIGNED_SHORT_4_4_4_4, data);
    } else if(format == PGTextureFormat_RGB5A1) {
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (GLsizei)size.x, (GLsizei)size.y, 0, GL_RGBA, GL_UNSIGNED_SHORT_5_5_5_1, data);
    } else if(format == PGTextureFormat_RGB565) {
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, (GLsizei)size.x, (GLsizei)size.y, 0, GL_RGB, GL_UNSIGNED_SHORT_5_6_5, data);
    } else if(format == PGTextureFormat_RGB8) {
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, (GLsizei)size.x, (GLsizei)size.y, 0, GL_RGB, GL_UNSIGNED_BYTE, data);
    } else {
        NSLog(@"ERROR: Unknown texture format: %@", [PGTextureFormat value:format]);
    }
    free(data);
    if(minFilter == GL_LINEAR_MIPMAP_LINEAR || minFilter == GL_LINEAR_MIPMAP_NEAREST
            || minFilter == GL_NEAREST_MIPMAP_LINEAR || minFilter == GL_NEAREST_MIPMAP_NEAREST)
    {
        glGenerateMipmap(GL_TEXTURE_2D);
    }
}

void egSaveTextureToFile(GLuint source, NSString* file) {
#if TARGET_OS_IPHONE
#else
    [[PGGlobal context] bindTextureTextureId:source];
    GLfloat width;
    GLfloat height;
    glGetTexLevelParameterfv(GL_TEXTURE_2D, 0, GL_TEXTURE_WIDTH, &width);
    glGetTexLevelParameterfv(GL_TEXTURE_2D, 0, GL_TEXTURE_HEIGHT, &height);
    GLint format;
    glGetTexLevelParameteriv(GL_TEXTURE_2D, 0, GL_TEXTURE_INTERNAL_FORMAT, &format);
    BOOL depth = format == GL_DEPTH_COMPONENT32F || format == GL_DEPTH_COMPONENT16 || format == GL_DEPTH_COMPONENT24 || format == GL_DEPTH_COMPONENT32;
    void * data = calloc((size_t) width*4, (size_t) height);

    if(depth) {
        glGetTexImage(GL_TEXTURE_2D, 0, GL_DEPTH_COMPONENT, GL_FLOAT, data);
        unsigned char*dt = data;
        for(int y = 0; y < height; y++)
            for(int x = 0; x < width; x++) {
                unsigned char v = (unsigned char) (255 * (*(float*)dt));
                *dt = v;
                dt++;
                *dt = v;
                dt++;
                *dt = v;
                dt++;
                *dt = 0xff;
                dt++;
            }
    } else {
        glGetTexImage(GL_TEXTURE_2D, 0, GL_BGRA, GL_UNSIGNED_BYTE, data);
    }

    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmapContext = CGBitmapContextCreate (data,
            (size_t) width, (size_t) height, 8,
            (size_t) (width*4), space,
            kCGBitmapByteOrder32Host | kCGImageAlphaPremultipliedFirst);
    CGContextRotateCTM(bitmapContext, M_PI);
    CFRelease(space);
    CFURLRef url = (__bridge CFURLRef)[NSURL fileURLWithPath:file];
    CGImageRef image = CGBitmapContextCreateImage(bitmapContext);
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL(url, kUTTypePNG, 1, NULL);

    CFStringRef myKeys[1];
    CFTypeRef   myValues[1];
    int orientation = 4;
    CFDictionaryRef myOptions = NULL;
    myKeys[0] = kCGImagePropertyOrientation;
    myValues[0] = CFNumberCreate(NULL, kCFNumberIntType, &orientation);
    myOptions = CFDictionaryCreate( NULL, (const void **)myKeys, myValues, 1,
            &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CGImageDestinationAddImage(destination, image, myOptions);
    CFRelease(myOptions);

    NSLog(@"Saving texture to %@", url);
    if (!CGImageDestinationFinalize(destination)) {
        @throw [NSString stringWithFormat:@"Failed to write image to %@", file];
    }

    CFRelease(destination);
    CFRelease(image);
    CGContextRelease(bitmapContext);
#endif
}

void egInitShadowTexture(PGVec2i size) {
#if TARGET_OS_IPHONE
    glTexImage2D(GL_TEXTURE_2D, 0, GL_DEPTH_COMPONENT, size.x, size.y, 0, GL_DEPTH_COMPONENT, GL_UNSIGNED_SHORT, 0);
#else
    glTexImage2D(GL_TEXTURE_2D, 0, GL_DEPTH_COMPONENT16, (GLsizei)size.x, (GLsizei)size.y,
            0, GL_DEPTH_COMPONENT, GL_FLOAT, 0);
#endif
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    if([[PGGlobal settings] shadowType] == PGShadowType_shadow2d) {
#if TARGET_OS_IPHONE
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_COMPARE_FUNC_EXT, GL_LEQUAL);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_COMPARE_MODE_EXT, GL_COMPARE_REF_TO_TEXTURE_EXT);
#else
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_COMPARE_FUNC, GL_LEQUAL);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_COMPARE_MODE, GL_COMPARE_REF_TO_TEXTURE);
#endif
    }
}