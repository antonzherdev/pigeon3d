#import "objd.h"
#import "PGShader.h"
#import "PGVec.h"
@class PGVertexBufferDesc;
@class PGGlobal;
@class PGMatrixStack;
@class PGMMatrixModel;
@class PGMat4;

@class PGCircleShaderBuilder;
@class PGCircleParam;
@class PGCircleSegment;
@class PGCircleShader;

@interface PGCircleShaderBuilder : PGShaderTextBuilder_impl {
@public
    BOOL _segment;
}
@property (nonatomic, readonly) BOOL segment;

+ (instancetype)circleShaderBuilderWithSegment:(BOOL)segment;
- (instancetype)initWithSegment:(BOOL)segment;
- (CNClassType*)type;
- (NSString*)vertex;
- (NSString*)fragment;
- (PGShaderProgram*)program;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGCircleParam : NSObject {
@public
    PGVec4 _color;
    PGVec4 _strokeColor;
    PGVec3 _position;
    PGVec2 _radius;
    PGVec2 _relative;
    PGCircleSegment* _segment;
}
@property (nonatomic, readonly) PGVec4 color;
@property (nonatomic, readonly) PGVec4 strokeColor;
@property (nonatomic, readonly) PGVec3 position;
@property (nonatomic, readonly) PGVec2 radius;
@property (nonatomic, readonly) PGVec2 relative;
@property (nonatomic, readonly) PGCircleSegment* segment;

+ (instancetype)circleParamWithColor:(PGVec4)color strokeColor:(PGVec4)strokeColor position:(PGVec3)position radius:(PGVec2)radius relative:(PGVec2)relative segment:(PGCircleSegment*)segment;
- (instancetype)initWithColor:(PGVec4)color strokeColor:(PGVec4)strokeColor position:(PGVec3)position radius:(PGVec2)radius relative:(PGVec2)relative segment:(PGCircleSegment*)segment;
- (CNClassType*)type;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGCircleSegment : NSObject {
@public
    PGVec4 _color;
    float _start;
    float _end;
}
@property (nonatomic, readonly) PGVec4 color;
@property (nonatomic, readonly) float start;
@property (nonatomic, readonly) float end;

+ (instancetype)circleSegmentWithColor:(PGVec4)color start:(float)start end:(float)end;
- (instancetype)initWithColor:(PGVec4)color start:(float)start end:(float)end;
- (CNClassType*)type;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGCircleShader : PGShader {
@public
    BOOL _segment;
    PGShaderAttribute* _model;
    PGShaderUniformVec4* _pos;
    PGShaderUniformMat4* _p;
    PGShaderUniformVec2* _radius;
    PGShaderUniformVec4* _color;
    PGShaderUniformVec4* _strokeColor;
    PGShaderUniformVec4* _sectorColor;
    PGShaderUniformF4* _startTg;
    PGShaderUniformF4* _endTg;
}
@property (nonatomic, readonly) BOOL segment;
@property (nonatomic, readonly) PGShaderAttribute* model;
@property (nonatomic, readonly) PGShaderUniformVec4* pos;
@property (nonatomic, readonly) PGShaderUniformMat4* p;
@property (nonatomic, readonly) PGShaderUniformVec2* radius;
@property (nonatomic, readonly) PGShaderUniformVec4* color;
@property (nonatomic, readonly) PGShaderUniformVec4* strokeColor;
@property (nonatomic, readonly) PGShaderUniformVec4* sectorColor;
@property (nonatomic, readonly) PGShaderUniformF4* startTg;
@property (nonatomic, readonly) PGShaderUniformF4* endTg;

+ (instancetype)circleShaderWithSegment:(BOOL)segment;
- (instancetype)initWithSegment:(BOOL)segment;
- (CNClassType*)type;
- (void)loadAttributesVbDesc:(PGVertexBufferDesc*)vbDesc;
- (void)loadUniformsParam:(PGCircleParam*)param;
- (NSString*)description;
+ (PGCircleShader*)withSegment;
+ (PGCircleShader*)withoutSegment;
+ (CNClassType*)type;
@end


