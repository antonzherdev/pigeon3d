#import "objd.h"
#import "PGVec.h"
#import "PGContext.h"
#import "PGMaterial.h"
@protocol PGVertexBuffer;
@protocol PGIndexSource;
@class PGMesh;
@class PGSimpleVertexArray;
@class PGVertexBufferDesc;
@class PGMat4;
@class PGVertexArray;

@class PGShaderProgram;
@class PGShader;
@class PGShaderAttribute;
@class PGShaderUniformMat4;
@class PGShaderUniformVec4;
@class PGShaderUniformVec3;
@class PGShaderUniformVec2;
@class PGShaderUniformF4;
@class PGShaderUniformI4;
@class PGShaderSystem;
@class PGShaderTextBuilder_impl;
@protocol PGShaderTextBuilder;

@interface PGShaderProgram : NSObject {
@protected
    NSString* _name;
    unsigned int _handle;
}
@property (nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) unsigned int handle;

+ (instancetype)shaderProgramWithName:(NSString*)name handle:(unsigned int)handle;
- (instancetype)initWithName:(NSString*)name handle:(unsigned int)handle;
- (CNClassType*)type;
+ (PGShaderProgram*)loadFromFilesName:(NSString*)name vertex:(NSString*)vertex fragment:(NSString*)fragment;
+ (PGShaderProgram*)applyName:(NSString*)name vertex:(NSString*)vertex fragment:(NSString*)fragment;
+ (PGShaderProgram*)linkFromShadersName:(NSString*)name vertex:(unsigned int)vertex fragment:(unsigned int)fragment;
+ (unsigned int)compileShaderForShaderType:(unsigned int)shaderType source:(NSString*)source;
- (void)_init;
- (void)dealloc;
- (PGShaderAttribute*)attributeForName:(NSString*)name;
- (NSString*)description;
+ (NSInteger)version;
+ (CNClassType*)type;
@end


@interface PGShader : NSObject {
@protected
    PGShaderProgram* _program;
}
@property (nonatomic, readonly) PGShaderProgram* program;

+ (instancetype)shaderWithProgram:(PGShaderProgram*)program;
- (instancetype)initWithProgram:(PGShaderProgram*)program;
- (CNClassType*)type;
- (void)drawParam:(id)param vertex:(id<PGVertexBuffer>)vertex index:(id<PGIndexSource>)index;
- (void)drawParam:(id)param mesh:(PGMesh*)mesh;
- (void)drawParam:(id)param vao:(PGSimpleVertexArray*)vao;
- (void)drawParam:(id)param vao:(PGSimpleVertexArray*)vao start:(NSUInteger)start end:(NSUInteger)end;
- (void)loadAttributesVbDesc:(PGVertexBufferDesc*)vbDesc;
- (void)loadUniformsParam:(id)param;
- (PGShaderUniformMat4*)uniformMat4Name:(NSString*)name;
- (PGShaderUniformVec4*)uniformVec4Name:(NSString*)name;
- (PGShaderUniformVec3*)uniformVec3Name:(NSString*)name;
- (PGShaderUniformVec2*)uniformVec2Name:(NSString*)name;
- (PGShaderUniformF4*)uniformF4Name:(NSString*)name;
- (PGShaderUniformI4*)uniformI4Name:(NSString*)name;
- (PGShaderUniformMat4*)uniformMat4OptName:(NSString*)name;
- (PGShaderUniformVec4*)uniformVec4OptName:(NSString*)name;
- (PGShaderUniformVec3*)uniformVec3OptName:(NSString*)name;
- (PGShaderUniformVec2*)uniformVec2OptName:(NSString*)name;
- (PGShaderUniformF4*)uniformF4OptName:(NSString*)name;
- (PGShaderUniformI4*)uniformI4OptName:(NSString*)name;
- (PGShaderAttribute*)attributeForName:(NSString*)name;
- (PGSimpleVertexArray*)vaoVbo:(id<PGVertexBuffer>)vbo ibo:(id<PGIndexSource>)ibo;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGShaderAttribute : NSObject {
@protected
    unsigned int _handle;
}
@property (nonatomic, readonly) unsigned int handle;

+ (instancetype)shaderAttributeWithHandle:(unsigned int)handle;
- (instancetype)initWithHandle:(unsigned int)handle;
- (CNClassType*)type;
- (void)setFromBufferWithStride:(NSUInteger)stride valuesCount:(NSUInteger)valuesCount valuesType:(unsigned int)valuesType shift:(NSUInteger)shift;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGShaderUniformMat4 : NSObject {
@protected
    unsigned int _handle;
    PGMat4* __last;
}
@property (nonatomic, readonly) unsigned int handle;

+ (instancetype)shaderUniformMat4WithHandle:(unsigned int)handle;
- (instancetype)initWithHandle:(unsigned int)handle;
- (CNClassType*)type;
- (void)applyMatrix:(PGMat4*)matrix;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGShaderUniformVec4 : NSObject {
@protected
    unsigned int _handle;
    PGVec4 __last;
}
@property (nonatomic, readonly) unsigned int handle;

+ (instancetype)shaderUniformVec4WithHandle:(unsigned int)handle;
- (instancetype)initWithHandle:(unsigned int)handle;
- (CNClassType*)type;
- (void)applyVec4:(PGVec4)vec4;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGShaderUniformVec3 : NSObject {
@protected
    unsigned int _handle;
    PGVec3 __last;
}
@property (nonatomic, readonly) unsigned int handle;

+ (instancetype)shaderUniformVec3WithHandle:(unsigned int)handle;
- (instancetype)initWithHandle:(unsigned int)handle;
- (CNClassType*)type;
- (void)applyVec3:(PGVec3)vec3;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGShaderUniformVec2 : NSObject {
@protected
    unsigned int _handle;
    PGVec2 __last;
}
@property (nonatomic, readonly) unsigned int handle;

+ (instancetype)shaderUniformVec2WithHandle:(unsigned int)handle;
- (instancetype)initWithHandle:(unsigned int)handle;
- (CNClassType*)type;
- (void)applyVec2:(PGVec2)vec2;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGShaderUniformF4 : NSObject {
@protected
    unsigned int _handle;
    float __last;
}
@property (nonatomic, readonly) unsigned int handle;

+ (instancetype)shaderUniformF4WithHandle:(unsigned int)handle;
- (instancetype)initWithHandle:(unsigned int)handle;
- (CNClassType*)type;
- (void)applyF4:(float)f4;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGShaderUniformI4 : NSObject {
@protected
    unsigned int _handle;
    int __last;
}
@property (nonatomic, readonly) unsigned int handle;

+ (instancetype)shaderUniformI4WithHandle:(unsigned int)handle;
- (instancetype)initWithHandle:(unsigned int)handle;
- (CNClassType*)type;
- (void)applyI4:(int)i4;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGShaderSystem : NSObject
+ (instancetype)shaderSystem;
- (instancetype)init;
- (CNClassType*)type;
- (void)drawParam:(id)param vertex:(id<PGVertexBuffer>)vertex index:(id<PGIndexSource>)index;
- (void)drawParam:(id)param vao:(PGSimpleVertexArray*)vao;
- (void)drawParam:(id)param mesh:(PGMesh*)mesh;
- (PGShader*)shaderForParam:(id)param;
- (PGShader*)shaderForParam:(id)param renderTarget:(PGRenderTarget*)renderTarget;
- (PGVertexArray*)vaoParam:(id)param vbo:(id<PGVertexBuffer>)vbo ibo:(id<PGIndexSource>)ibo;
- (NSString*)description;
+ (CNClassType*)type;
@end


@protocol PGShaderTextBuilder<NSObject>
- (NSString*)versionString;
- (NSString*)vertexHeader;
- (NSString*)fragmentHeader;
- (NSString*)fragColorDeclaration;
- (BOOL)isFragColorDeclared;
- (NSInteger)version;
- (NSString*)ain;
- (NSString*)in;
- (NSString*)out;
- (NSString*)fragColor;
- (NSString*)texture2D;
- (NSString*)shadowExt;
- (NSString*)sampler2DShadow;
- (NSString*)shadow2DTexture:(NSString*)texture vec3:(NSString*)vec3;
- (NSString*)blendMode:(PGBlendModeR)mode a:(NSString*)a b:(NSString*)b;
- (NSString*)shadow2DEXT;
- (NSString*)description;
@end


@interface PGShaderTextBuilder_impl : NSObject<PGShaderTextBuilder>
+ (instancetype)shaderTextBuilder_impl;
- (instancetype)init;
@end


