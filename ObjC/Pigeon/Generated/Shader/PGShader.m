#import "PGShader.h"

#import "GL.h"
#import "PGVertex.h"
#import "PGIndex.h"
#import "PGMesh.h"
#import "PGVertexArray.h"
#import "PGMat4.h"
@implementation PGShaderProgram
static NSInteger _PGShaderProgram_version;
static CNClassType* _PGShaderProgram_type;
@synthesize name = _name;
@synthesize handle = _handle;

+ (instancetype)shaderProgramWithName:(NSString*)name handle:(unsigned int)handle {
    return [[PGShaderProgram alloc] initWithName:name handle:handle];
}

- (instancetype)initWithName:(NSString*)name handle:(unsigned int)handle {
    self = [super init];
    if(self) {
        _name = name;
        _handle = handle;
        if([self class] == [PGShaderProgram class]) [self _init];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGShaderProgram class]) {
        _PGShaderProgram_type = [CNClassType classTypeWithCls:[PGShaderProgram class]];
        _PGShaderProgram_version = ((NSInteger)(egGLSLVersion()));
    }
}

+ (PGShaderProgram*)applyName:(NSString*)name vertex:(NSString*)vertex fragment:(NSString*)fragment {
    unsigned int vertexShader = [PGShaderProgram compileShaderForShaderType:GL_VERTEX_SHADER source:vertex];
    unsigned int fragmentShader = [PGShaderProgram compileShaderForShaderType:GL_FRAGMENT_SHADER source:fragment];
    PGShaderProgram* program = [PGShaderProgram linkFromShadersName:name vertex:vertexShader fragment:fragmentShader];
    glDeleteShader(vertexShader);
    glDeleteShader(fragmentShader);
    return program;
}

+ (PGShaderProgram*)linkFromShadersName:(NSString*)name vertex:(unsigned int)vertex fragment:(unsigned int)fragment {
    unsigned int handle = glCreateProgram();
    glAttachShader(handle, vertex);
    glAttachShader(handle, fragment);
    glLinkProgram(handle);
    {
        NSString* _ = egGetProgramError(handle);
        if(_ != nil) @throw [@"Error in shader program linking: " stringByAppendingFormat:@"%@", _];
    }
    return [PGShaderProgram shaderProgramWithName:name handle:handle];
}

+ (unsigned int)compileShaderForShaderType:(unsigned int)shaderType source:(NSString*)source {
    unsigned int shader = glCreateShader(shaderType);
    egShaderSource(shader, source);
    glCompileShader(shader);
    {
        NSString* _ = egGetShaderError(shader);
        if(_ != nil) @throw [[@"Error in shader compiling : " stringByAppendingFormat:@"%@", _] stringByAppendingString:source];
    }
    return shader;
}

- (void)_init {
    egLabelShaderProgram(_handle, _name);
}

- (void)dealloc {
    [[PGGlobal context] deleteShaderProgramId:_handle];
}

- (PGShaderAttribute*)attributeForName:(NSString*)name {
    int h = egGetAttribLocation(_handle, name);
    if(h < 0) @throw [@"Could not found attribute for name " stringByAppendingString:name];
    PGShaderAttribute* ret = [PGShaderAttribute shaderAttributeWithHandle:((unsigned int)(h))];
    return ret;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"ShaderProgram(%@, %u)", _name, _handle];
}

- (CNClassType*)type {
    return [PGShaderProgram type];
}

+ (NSInteger)version {
    return _PGShaderProgram_version;
}

+ (CNClassType*)type {
    return _PGShaderProgram_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGShader
static CNClassType* _PGShader_type;
@synthesize program = _program;

+ (instancetype)shaderWithProgram:(PGShaderProgram*)program {
    return [[PGShader alloc] initWithProgram:program];
}

- (instancetype)initWithProgram:(PGShaderProgram*)program {
    self = [super init];
    if(self) _program = program;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGShader class]) _PGShader_type = [CNClassType classTypeWithCls:[PGShader class]];
}

- (void)drawParam:(id)param vertex:(id<PGVertexBuffer>)vertex index:(id<PGIndexSource>)index {
    [[PGGlobal context] bindShaderProgramProgram:_program];
    [vertex bind];
    [self loadAttributesVbDesc:[vertex desc]];
    [self loadUniformsParam:param];
    [index bind];
    [index draw];
}

- (void)drawParam:(id)param mesh:(PGMesh*)mesh {
    [self drawParam:param vertex:mesh->_vertex index:mesh->_index];
}

- (void)drawParam:(id)param vao:(PGSimpleVertexArray*)vao {
    [vao bind];
    [[PGGlobal context] bindShaderProgramProgram:_program];
    [self loadUniformsParam:param];
    [vao->_index draw];
    [vao unbind];
}

- (void)drawParam:(id)param vao:(PGSimpleVertexArray*)vao start:(NSUInteger)start end:(NSUInteger)end {
    [vao bind];
    [[PGGlobal context] bindShaderProgramProgram:_program];
    [self loadUniformsParam:param];
    [vao->_index drawWithStart:start count:end];
    [vao unbind];
}

- (void)loadAttributesVbDesc:(PGVertexBufferDesc*)vbDesc {
    @throw @"Method loadAttributes is abstract";
}

- (void)loadUniformsParam:(id)param {
    @throw @"Method loadUniforms is abstract";
}

- (int)uniformName:(NSString*)name {
    int h = egGetUniformLocation(_program->_handle, name);
    if(h < 0) @throw [@"Could not found attribute for name " stringByAppendingString:name];
    return h;
}

- (id)uniformOptName:(NSString*)name {
    int h = egGetUniformLocation(_program->_handle, name);
    if(h < 0) return nil;
    else return numi4(h);
}

- (PGShaderUniformMat4*)uniformMat4Name:(NSString*)name {
    return [PGShaderUniformMat4 shaderUniformMat4WithHandle:((unsigned int)([self uniformName:name]))];
}

- (PGShaderUniformVec4*)uniformVec4Name:(NSString*)name {
    return [PGShaderUniformVec4 shaderUniformVec4WithHandle:((unsigned int)([self uniformName:name]))];
}

- (PGShaderUniformVec3*)uniformVec3Name:(NSString*)name {
    return [PGShaderUniformVec3 shaderUniformVec3WithHandle:((unsigned int)([self uniformName:name]))];
}

- (PGShaderUniformVec2*)uniformVec2Name:(NSString*)name {
    return [PGShaderUniformVec2 shaderUniformVec2WithHandle:((unsigned int)([self uniformName:name]))];
}

- (PGShaderUniformF4*)uniformF4Name:(NSString*)name {
    return [PGShaderUniformF4 shaderUniformF4WithHandle:((unsigned int)([self uniformName:name]))];
}

- (PGShaderUniformI4*)uniformI4Name:(NSString*)name {
    return [PGShaderUniformI4 shaderUniformI4WithHandle:((unsigned int)([self uniformName:name]))];
}

- (PGShaderUniformMat4*)uniformMat4OptName:(NSString*)name {
    id _ = [self uniformOptName:name];
    if(_ != nil) return [PGShaderUniformMat4 shaderUniformMat4WithHandle:unumui4(_)];
    else return nil;
}

- (PGShaderUniformVec4*)uniformVec4OptName:(NSString*)name {
    id _ = [self uniformOptName:name];
    if(_ != nil) return [PGShaderUniformVec4 shaderUniformVec4WithHandle:unumui4(_)];
    else return nil;
}

- (PGShaderUniformVec3*)uniformVec3OptName:(NSString*)name {
    id _ = [self uniformOptName:name];
    if(_ != nil) return [PGShaderUniformVec3 shaderUniformVec3WithHandle:unumui4(_)];
    else return nil;
}

- (PGShaderUniformVec2*)uniformVec2OptName:(NSString*)name {
    id _ = [self uniformOptName:name];
    if(_ != nil) return [PGShaderUniformVec2 shaderUniformVec2WithHandle:unumui4(_)];
    else return nil;
}

- (PGShaderUniformF4*)uniformF4OptName:(NSString*)name {
    id _ = [self uniformOptName:name];
    if(_ != nil) return [PGShaderUniformF4 shaderUniformF4WithHandle:unumui4(_)];
    else return nil;
}

- (PGShaderUniformI4*)uniformI4OptName:(NSString*)name {
    id _ = [self uniformOptName:name];
    if(_ != nil) return [PGShaderUniformI4 shaderUniformI4WithHandle:unumui4(_)];
    else return nil;
}

- (PGShaderAttribute*)attributeForName:(NSString*)name {
    return [_program attributeForName:name];
}

- (PGSimpleVertexArray*)vaoVbo:(id<PGVertexBuffer>)vbo ibo:(id<PGIndexSource>)ibo {
    PGSimpleVertexArray* vao = [PGSimpleVertexArray applyShader:self buffers:(@[vbo]) index:ibo];
    [vao bind];
    [vbo bind];
    [ibo bind];
    [self loadAttributesVbDesc:[vbo desc]];
    [vao unbind];
    return vao;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Shader(%@)", _program];
}

- (CNClassType*)type {
    return [PGShader type];
}

+ (CNClassType*)type {
    return _PGShader_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGShaderAttribute
static CNClassType* _PGShaderAttribute_type;
@synthesize handle = _handle;

+ (instancetype)shaderAttributeWithHandle:(unsigned int)handle {
    return [[PGShaderAttribute alloc] initWithHandle:handle];
}

- (instancetype)initWithHandle:(unsigned int)handle {
    self = [super init];
    if(self) _handle = handle;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGShaderAttribute class]) _PGShaderAttribute_type = [CNClassType classTypeWithCls:[PGShaderAttribute class]];
}

- (void)setFromBufferWithStride:(NSUInteger)stride valuesCount:(NSUInteger)valuesCount valuesType:(unsigned int)valuesType shift:(NSUInteger)shift {
    glEnableVertexAttribArray(((int)(_handle)));
    egVertexAttribPointer(_handle, ((unsigned int)(valuesCount)), valuesType, GL_FALSE, ((unsigned int)(stride)), ((unsigned int)(shift)));
}

- (NSString*)description {
    return [NSString stringWithFormat:@"ShaderAttribute(%u)", _handle];
}

- (CNClassType*)type {
    return [PGShaderAttribute type];
}

+ (CNClassType*)type {
    return _PGShaderAttribute_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGShaderUniformMat4
static CNClassType* _PGShaderUniformMat4_type;
@synthesize handle = _handle;

+ (instancetype)shaderUniformMat4WithHandle:(unsigned int)handle {
    return [[PGShaderUniformMat4 alloc] initWithHandle:handle];
}

- (instancetype)initWithHandle:(unsigned int)handle {
    self = [super init];
    if(self) {
        _handle = handle;
        __last = [PGMat4 null];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGShaderUniformMat4 class]) _PGShaderUniformMat4_type = [CNClassType classTypeWithCls:[PGShaderUniformMat4 class]];
}

- (void)applyMatrix:(PGMat4*)matrix {
    if(!([matrix isEqual:__last])) {
        __last = matrix;
        glUniformMatrix4fv(_handle, 1, GL_FALSE, matrix.array);
    }
}

- (NSString*)description {
    return [NSString stringWithFormat:@"ShaderUniformMat4(%u)", _handle];
}

- (CNClassType*)type {
    return [PGShaderUniformMat4 type];
}

+ (CNClassType*)type {
    return _PGShaderUniformMat4_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGShaderUniformVec4
static CNClassType* _PGShaderUniformVec4_type;
@synthesize handle = _handle;

+ (instancetype)shaderUniformVec4WithHandle:(unsigned int)handle {
    return [[PGShaderUniformVec4 alloc] initWithHandle:handle];
}

- (instancetype)initWithHandle:(unsigned int)handle {
    self = [super init];
    if(self) {
        _handle = handle;
        __last = PGVec4Make(0.0, 0.0, 0.0, 0.0);
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGShaderUniformVec4 class]) _PGShaderUniformVec4_type = [CNClassType classTypeWithCls:[PGShaderUniformVec4 class]];
}

- (void)applyVec4:(PGVec4)vec4 {
    if(!(pgVec4IsEqualTo(vec4, __last))) {
        egUniformVec4(_handle, vec4);
        __last = vec4;
    }
}

- (NSString*)description {
    return [NSString stringWithFormat:@"ShaderUniformVec4(%u)", _handle];
}

- (CNClassType*)type {
    return [PGShaderUniformVec4 type];
}

+ (CNClassType*)type {
    return _PGShaderUniformVec4_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGShaderUniformVec3
static CNClassType* _PGShaderUniformVec3_type;
@synthesize handle = _handle;

+ (instancetype)shaderUniformVec3WithHandle:(unsigned int)handle {
    return [[PGShaderUniformVec3 alloc] initWithHandle:handle];
}

- (instancetype)initWithHandle:(unsigned int)handle {
    self = [super init];
    if(self) {
        _handle = handle;
        __last = PGVec3Make(0.0, 0.0, 0.0);
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGShaderUniformVec3 class]) _PGShaderUniformVec3_type = [CNClassType classTypeWithCls:[PGShaderUniformVec3 class]];
}

- (void)applyVec3:(PGVec3)vec3 {
    if(!(pgVec3IsEqualTo(vec3, __last))) {
        egUniformVec3(_handle, vec3);
        __last = vec3;
    }
}

- (NSString*)description {
    return [NSString stringWithFormat:@"ShaderUniformVec3(%u)", _handle];
}

- (CNClassType*)type {
    return [PGShaderUniformVec3 type];
}

+ (CNClassType*)type {
    return _PGShaderUniformVec3_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGShaderUniformVec2
static CNClassType* _PGShaderUniformVec2_type;
@synthesize handle = _handle;

+ (instancetype)shaderUniformVec2WithHandle:(unsigned int)handle {
    return [[PGShaderUniformVec2 alloc] initWithHandle:handle];
}

- (instancetype)initWithHandle:(unsigned int)handle {
    self = [super init];
    if(self) {
        _handle = handle;
        __last = PGVec2Make(0.0, 0.0);
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGShaderUniformVec2 class]) _PGShaderUniformVec2_type = [CNClassType classTypeWithCls:[PGShaderUniformVec2 class]];
}

- (void)applyVec2:(PGVec2)vec2 {
    if(!(pgVec2IsEqualTo(vec2, __last))) {
        egUniformVec2(_handle, vec2);
        __last = vec2;
    }
}

- (NSString*)description {
    return [NSString stringWithFormat:@"ShaderUniformVec2(%u)", _handle];
}

- (CNClassType*)type {
    return [PGShaderUniformVec2 type];
}

+ (CNClassType*)type {
    return _PGShaderUniformVec2_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGShaderUniformF4
static CNClassType* _PGShaderUniformF4_type;
@synthesize handle = _handle;

+ (instancetype)shaderUniformF4WithHandle:(unsigned int)handle {
    return [[PGShaderUniformF4 alloc] initWithHandle:handle];
}

- (instancetype)initWithHandle:(unsigned int)handle {
    self = [super init];
    if(self) {
        _handle = handle;
        __last = 0.0;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGShaderUniformF4 class]) _PGShaderUniformF4_type = [CNClassType classTypeWithCls:[PGShaderUniformF4 class]];
}

- (void)applyF4:(float)f4 {
    if(!(eqf4(f4, __last))) {
        glUniform1f(_handle, f4);
        __last = f4;
    }
}

- (NSString*)description {
    return [NSString stringWithFormat:@"ShaderUniformF4(%u)", _handle];
}

- (CNClassType*)type {
    return [PGShaderUniformF4 type];
}

+ (CNClassType*)type {
    return _PGShaderUniformF4_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGShaderUniformI4
static CNClassType* _PGShaderUniformI4_type;
@synthesize handle = _handle;

+ (instancetype)shaderUniformI4WithHandle:(unsigned int)handle {
    return [[PGShaderUniformI4 alloc] initWithHandle:handle];
}

- (instancetype)initWithHandle:(unsigned int)handle {
    self = [super init];
    if(self) {
        _handle = handle;
        __last = 0;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGShaderUniformI4 class]) _PGShaderUniformI4_type = [CNClassType classTypeWithCls:[PGShaderUniformI4 class]];
}

- (void)applyI4:(int)i4 {
    if(i4 != __last) {
        glUniform1i(_handle, i4);
        __last = i4;
    }
}

- (NSString*)description {
    return [NSString stringWithFormat:@"ShaderUniformI4(%u)", _handle];
}

- (CNClassType*)type {
    return [PGShaderUniformI4 type];
}

+ (CNClassType*)type {
    return _PGShaderUniformI4_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGShaderSystem
static CNClassType* _PGShaderSystem_type;

+ (instancetype)shaderSystem {
    return [[PGShaderSystem alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGShaderSystem class]) _PGShaderSystem_type = [CNClassType classTypeWithCls:[PGShaderSystem class]];
}

- (void)drawParam:(id)param vertex:(id<PGVertexBuffer>)vertex index:(id<PGIndexSource>)index {
    PGShader* shader = [self shaderForParam:param];
    [shader drawParam:param vertex:vertex index:index];
}

- (void)drawParam:(id)param vao:(PGSimpleVertexArray*)vao {
    PGShader* shader = [self shaderForParam:param];
    [shader drawParam:param vao:vao];
}

- (void)drawParam:(id)param mesh:(PGMesh*)mesh {
    PGShader* shader = [self shaderForParam:param];
    [shader drawParam:param mesh:mesh];
}

- (PGShader*)shaderForParam:(id)param {
    return [self shaderForParam:param renderTarget:[PGGlobal context]->_renderTarget];
}

- (PGShader*)shaderForParam:(id)param renderTarget:(PGRenderTarget*)renderTarget {
    @throw @"Method shaderFor is abstract";
}

- (PGVertexArray*)vaoParam:(id)param vbo:(id<PGVertexBuffer>)vbo ibo:(id<PGIndexSource>)ibo {
    return [[self shaderForParam:param] vaoVbo:vbo ibo:ibo];
}

- (NSString*)description {
    return @"ShaderSystem";
}

- (CNClassType*)type {
    return [PGShaderSystem type];
}

+ (CNClassType*)type {
    return _PGShaderSystem_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGShaderTextBuilder_impl

+ (instancetype)shaderTextBuilder_impl {
    return [[PGShaderTextBuilder_impl alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

- (NSString*)versionString {
    return [NSString stringWithFormat:@"#version %ld", (long)[self version]];
}

- (NSString*)vertexHeader {
    return [NSString stringWithFormat:@"#version %ld", (long)[self version]];
}

- (NSString*)fragmentHeader {
    return [NSString stringWithFormat:@"#version %ld\n"
        "%@", (long)[self version], [self fragColorDeclaration]];
}

- (NSString*)fragColorDeclaration {
    if([self isFragColorDeclared]) return @"";
    else return @"out lowp vec4 fragColor;";
}

- (BOOL)isFragColorDeclared {
    return [PGShaderProgram version] < 110;
}

- (NSInteger)version {
    return [PGShaderProgram version];
}

- (NSString*)ain {
    if([self version] < 150) return @"attribute";
    else return @"in";
}

- (NSString*)in {
    if([self version] < 150) return @"varying";
    else return @"in";
}

- (NSString*)out {
    if([self version] < 150) return @"varying";
    else return @"out";
}

- (NSString*)fragColor {
    if([self version] > 100) return @"fragColor";
    else return @"gl_FragColor";
}

- (NSString*)texture2D {
    if([self version] > 100) return @"texture";
    else return @"texture2D";
}

- (NSString*)shadowExt {
    if([self version] == 100 && [[PGGlobal settings] shadowType] == PGShadowType_shadow2d) return @"#extension GL_EXT_shadow_samplers : require";
    else return @"";
}

- (NSString*)sampler2DShadow {
    if([[PGGlobal settings] shadowType] == PGShadowType_shadow2d) return @"sampler2DShadow";
    else return @"sampler2D";
}

- (NSString*)shadow2DTexture:(NSString*)texture vec3:(NSString*)vec3 {
    if([[PGGlobal settings] shadowType] == PGShadowType_shadow2d) return [NSString stringWithFormat:@"%@(%@, %@)", [self shadow2DEXT], texture, vec3];
    else return [NSString stringWithFormat:@"(%@(%@, %@.xy).x < %@.z ? 0.0 : 1.0)", [self texture2D], texture, vec3, vec3];
}

- (NSString*)blendMode:(PGBlendModeR)mode a:(NSString*)a b:(NSString*)b {
    return [PGBlendMode value:mode].blend(a, b);
}

- (NSString*)shadow2DEXT {
    if([self version] == 100) return @"shadow2DEXT";
    else return @"texture";
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

