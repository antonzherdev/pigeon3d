#import "PGVec.h"
#import "PGTexture.h"

@class PGTextureFilter;
@class PGTextureFormat;
@class PGTextureFileFormat;

PGVec2 egLoadTextureFromFile(GLuint target, NSString* file, PGTextureFileFormatR fileFormat, CGFloat scale, PGTextureFormatR format, PGTextureFilterR filter);
void egLoadTextureFromData(GLuint target, PGTextureFormatR format, PGTextureFilterR filter, PGVec2 size, void *data);
void egSaveTextureToFile(GLuint source, NSString* file);
void egInitShadowTexture(PGVec2i size);