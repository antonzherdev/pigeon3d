#import "PGCircle.h"

#import "PGVertex.h"
#import "GL.h"
#import "PGContext.h"
#import "PGMatrixModel.h"
#import "PGMat4.h"
#import "math.h"
@implementation PGCircleShaderBuilder
static CNClassType* _PGCircleShaderBuilder_type;
@synthesize segment = _segment;

+ (instancetype)circleShaderBuilderWithSegment:(BOOL)segment {
    return [[PGCircleShaderBuilder alloc] initWithSegment:segment];
}

- (instancetype)initWithSegment:(BOOL)segment {
    self = [super init];
    if(self) _segment = segment;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGCircleShaderBuilder class]) _PGCircleShaderBuilder_type = [CNClassType classTypeWithCls:[PGCircleShaderBuilder class]];
}

- (NSString*)vertex {
    return [NSString stringWithFormat:@"%@\n"
        "%@ lowp vec2 model;\n"
        "\n"
        "uniform highp vec4 position;\n"
        "uniform mat4 p;\n"
        "uniform lowp vec2 radius;\n"
        "%@ highp vec2 coord;\n"
        "\n"
        "void main(void) {\n"
        "    highp vec4 pos = p*position;\n"
        "    pos.xy += model*radius;\n"
        "    gl_Position = pos;\n"
        "    coord = model;\n"
        "}", [self vertexHeader], [self ain], [self out]];
}

- (NSString*)fragment {
    return [NSString stringWithFormat:@"%@\n"
        "\n"
        "%@ highp vec2 coord;\n"
        "uniform lowp vec4 color;\n"
        "uniform lowp vec4 strokeColor;\n"
        "%@\n"
        "\n"
        "void main(void) {\n"
        "    lowp float tg = atan(coord.y, coord.x);\n"
        "    highp float dt = dot(coord, coord);\n"
        "    lowp float alpha = 0.0;\n"
        "   %@\n"
        "}", [self fragmentHeader], [self in], ((_segment) ? @"uniform lowp vec4 sectorColor;\n"
        "uniform lowp float startTg;\n"
        "uniform lowp float endTg;" : @""), ((_segment) ? [NSString stringWithFormat:@"    if(endTg < startTg) {\n"
        "        alpha = sectorColor.w * clamp(\n"
        "            1.0 - smoothstep(0.95, 1.0, dt)\n"
        "            - (clamp(smoothstep(endTg - 0.1, endTg, tg) + 1.0 - smoothstep(startTg, startTg + 0.1, tg), 1.0, 2.0) - 1.0)\n"
        "            , 0.0, 1.0);\n"
        "    } else {\n"
        "        alpha = sectorColor.w * clamp(\n"
        "            1.0 - smoothstep(0.95, 1.0, dt)\n"
        "            - (1.0 - smoothstep(startTg, startTg + 0.1, tg))\n"
        "            - (smoothstep(endTg - 0.1, endTg, tg))\n"
        "            , 0.0, 1.0);\n"
        "    }\n"
        "    %@ = vec4(mix(\n"
        "        mix(color.xyz, sectorColor.xyz, alpha),\n"
        "        strokeColor.xyz, strokeColor.w*(smoothstep(0.75, 0.8, dt) - smoothstep(0.95, 1.0, dt))),\n"
        "        color.w * (1.0 - smoothstep(0.95, 1.0, dt)));\n"
        "   ", [self fragColor]] : [NSString stringWithFormat:@"    %@ = vec4(mix(color.xyz, strokeColor.xyz, strokeColor.w*(smoothstep(0.75, 0.8, dt) - smoothstep(0.95, 1.0, dt))),\n"
        "        color.w * (1.0 - smoothstep(0.95, 1.0, dt)));\n"
        "   ", [self fragColor]])];
}

- (PGShaderProgram*)program {
    return [PGShaderProgram applyName:@"Circle" vertex:[self vertex] fragment:[self fragment]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"CircleShaderBuilder(%d)", _segment];
}

- (CNClassType*)type {
    return [PGCircleShaderBuilder type];
}

+ (CNClassType*)type {
    return _PGCircleShaderBuilder_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGCircleParam
static CNClassType* _PGCircleParam_type;
@synthesize color = _color;
@synthesize strokeColor = _strokeColor;
@synthesize position = _position;
@synthesize radius = _radius;
@synthesize relative = _relative;
@synthesize segment = _segment;

+ (instancetype)circleParamWithColor:(PGVec4)color strokeColor:(PGVec4)strokeColor position:(PGVec3)position radius:(PGVec2)radius relative:(PGVec2)relative segment:(PGCircleSegment*)segment {
    return [[PGCircleParam alloc] initWithColor:color strokeColor:strokeColor position:position radius:radius relative:relative segment:segment];
}

- (instancetype)initWithColor:(PGVec4)color strokeColor:(PGVec4)strokeColor position:(PGVec3)position radius:(PGVec2)radius relative:(PGVec2)relative segment:(PGCircleSegment*)segment {
    self = [super init];
    if(self) {
        _color = color;
        _strokeColor = strokeColor;
        _position = position;
        _radius = radius;
        _relative = relative;
        _segment = segment;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGCircleParam class]) _PGCircleParam_type = [CNClassType classTypeWithCls:[PGCircleParam class]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"CircleParam(%@, %@, %@, %@, %@, %@)", pgVec4Description(_color), pgVec4Description(_strokeColor), pgVec3Description(_position), pgVec2Description(_radius), pgVec2Description(_relative), _segment];
}

- (CNClassType*)type {
    return [PGCircleParam type];
}

+ (CNClassType*)type {
    return _PGCircleParam_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGCircleSegment
static CNClassType* _PGCircleSegment_type;
@synthesize color = _color;
@synthesize start = _start;
@synthesize end = _end;

+ (instancetype)circleSegmentWithColor:(PGVec4)color start:(float)start end:(float)end {
    return [[PGCircleSegment alloc] initWithColor:color start:start end:end];
}

- (instancetype)initWithColor:(PGVec4)color start:(float)start end:(float)end {
    self = [super init];
    if(self) {
        _color = color;
        _start = start;
        _end = end;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGCircleSegment class]) _PGCircleSegment_type = [CNClassType classTypeWithCls:[PGCircleSegment class]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"CircleSegment(%@, %f, %f)", pgVec4Description(_color), _start, _end];
}

- (CNClassType*)type {
    return [PGCircleSegment type];
}

+ (CNClassType*)type {
    return _PGCircleSegment_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGCircleShader
static PGCircleShader* _PGCircleShader_withSegment;
static PGCircleShader* _PGCircleShader_withoutSegment;
static CNClassType* _PGCircleShader_type;
@synthesize segment = _segment;
@synthesize model = _model;
@synthesize pos = _pos;
@synthesize p = _p;
@synthesize radius = _radius;
@synthesize color = _color;
@synthesize strokeColor = _strokeColor;
@synthesize sectorColor = _sectorColor;
@synthesize startTg = _startTg;
@synthesize endTg = _endTg;

+ (instancetype)circleShaderWithSegment:(BOOL)segment {
    return [[PGCircleShader alloc] initWithSegment:segment];
}

- (instancetype)initWithSegment:(BOOL)segment {
    self = [super initWithProgram:[[PGCircleShaderBuilder circleShaderBuilderWithSegment:segment] program]];
    if(self) {
        _segment = segment;
        _model = [self attributeForName:@"model"];
        _pos = [self uniformVec4Name:@"position"];
        _p = [self uniformMat4Name:@"p"];
        _radius = [self uniformVec2Name:@"radius"];
        _color = [self uniformVec4Name:@"color"];
        _strokeColor = [self uniformVec4Name:@"strokeColor"];
        _sectorColor = ((segment) ? [self uniformVec4Name:@"sectorColor"] : nil);
        _startTg = ((segment) ? [self uniformF4Name:@"startTg"] : nil);
        _endTg = ((segment) ? [self uniformF4Name:@"endTg"] : nil);
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGCircleShader class]) {
        _PGCircleShader_type = [CNClassType classTypeWithCls:[PGCircleShader class]];
        _PGCircleShader_withSegment = [PGCircleShader circleShaderWithSegment:YES];
        _PGCircleShader_withoutSegment = [PGCircleShader circleShaderWithSegment:NO];
    }
}

- (void)loadAttributesVbDesc:(PGVertexBufferDesc*)vbDesc {
    [_model setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc->_model))];
}

- (void)loadUniformsParam:(PGCircleParam*)param {
    [_pos applyVec4:pgVec4AddVec2(([[[[PGGlobal matrix] value] wc] mulVec4:pgVec4ApplyVec3W(((PGCircleParam*)(param))->_position, 1.0)]), ((PGCircleParam*)(param))->_relative)];
    [_p applyMatrix:[[[PGGlobal matrix] value] p]];
    [_radius applyVec2:((PGCircleParam*)(param))->_radius];
    [_color applyVec4:((PGCircleParam*)(param))->_color];
    [_strokeColor applyVec4:((PGCircleParam*)(param))->_strokeColor];
    if(_segment) {
        PGCircleSegment* sec = ((PGCircleParam*)(param))->_segment;
        if(sec != nil) {
            [((PGShaderUniformVec4*)(_sectorColor)) applyVec4:((PGCircleSegment*)(sec))->_color];
            if(((PGCircleSegment*)(sec))->_start < ((PGCircleSegment*)(sec))->_end) {
                [((PGShaderUniformF4*)(_startTg)) applyF4:[self clampP:((PGCircleSegment*)(sec))->_start]];
                [((PGShaderUniformF4*)(_endTg)) applyF4:[self clampP:((PGCircleSegment*)(sec))->_end]];
            } else {
                [((PGShaderUniformF4*)(_startTg)) applyF4:[self clampP:((PGCircleSegment*)(sec))->_end]];
                [((PGShaderUniformF4*)(_endTg)) applyF4:[self clampP:((PGCircleSegment*)(sec))->_start]];
            }
        }
    }
}

- (float)clampP:(float)p {
    if(p < -M_PI) {
        return ((float)(2 * M_PI + p));
    } else {
        if(p > M_PI) return ((float)(-2 * M_PI + p));
        else return p;
    }
}

- (NSString*)description {
    return [NSString stringWithFormat:@"CircleShader(%d)", _segment];
}

- (CNClassType*)type {
    return [PGCircleShader type];
}

+ (PGCircleShader*)withSegment {
    return _PGCircleShader_withSegment;
}

+ (PGCircleShader*)withoutSegment {
    return _PGCircleShader_withoutSegment;
}

+ (CNClassType*)type {
    return _PGCircleShader_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

