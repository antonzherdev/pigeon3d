#import "PGMaterial.h"

#import "PGShader.h"
#import "PGMesh.h"
#import "PGVertex.h"
#import "PGIndex.h"
#import "PGTexture.h"
#import "PGSimpleShaderSystem.h"
#import "PGStandardShaderSystem.h"
#import "GL.h"
#import "PGContext.h"
@implementation PGMaterial
static CNClassType* _PGMaterial_type;

+ (instancetype)material {
    return [[PGMaterial alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGMaterial class]) _PGMaterial_type = [CNClassType classTypeWithCls:[PGMaterial class]];
}

- (PGShaderSystem*)shaderSystem {
    @throw @"Method shaderSystem is abstract";
}

- (void)drawMesh:(PGMesh*)mesh {
    [[self shaderSystem] drawParam:self vertex:mesh.vertex index:mesh.index];
}

- (void)drawVertex:(id<PGVertexBuffer>)vertex index:(id<PGIndexSource>)index {
    [[self shaderSystem] drawParam:self vertex:vertex index:index];
}

- (PGShader*)shader {
    return [[self shaderSystem] shaderForParam:self];
}

+ (PGMaterial*)applyColor:(PGVec4)color {
    return [PGStandardMaterial applyDiffuse:[PGColorSource applyColor:color]];
}

+ (PGMaterial*)applyTexture:(PGTexture*)texture {
    return [PGStandardMaterial applyDiffuse:[PGColorSource applyTexture:texture]];
}

- (NSString*)description {
    return @"Material";
}

- (CNClassType*)type {
    return [PGMaterial type];
}

+ (CNClassType*)type {
    return _PGMaterial_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

PGBlendMode* PGBlendMode_Values[5];
PGBlendMode* PGBlendMode_first_Desc;
PGBlendMode* PGBlendMode_second_Desc;
PGBlendMode* PGBlendMode_multiply_Desc;
PGBlendMode* PGBlendMode_darken_Desc;
@implementation PGBlendMode{
    NSString*(^_blend)(NSString*, NSString*);
}
@synthesize blend = _blend;

+ (instancetype)blendModeWithOrdinal:(NSUInteger)ordinal name:(NSString*)name blend:(NSString*(^)(NSString*, NSString*))blend {
    return [[PGBlendMode alloc] initWithOrdinal:ordinal name:name blend:blend];
}

- (instancetype)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name blend:(NSString*(^)(NSString*, NSString*))blend {
    self = [super initWithOrdinal:ordinal name:name];
    if(self) _blend = [blend copy];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    PGBlendMode_first_Desc = [PGBlendMode blendModeWithOrdinal:0 name:@"first" blend:^NSString*(NSString* a, NSString* b) {
        return a;
    }];
    PGBlendMode_second_Desc = [PGBlendMode blendModeWithOrdinal:1 name:@"second" blend:^NSString*(NSString* a, NSString* b) {
        return b;
    }];
    PGBlendMode_multiply_Desc = [PGBlendMode blendModeWithOrdinal:2 name:@"multiply" blend:^NSString*(NSString* a, NSString* b) {
        return [NSString stringWithFormat:@"%@ * %@", a, b];
    }];
    PGBlendMode_darken_Desc = [PGBlendMode blendModeWithOrdinal:3 name:@"darken" blend:^NSString*(NSString* a, NSString* b) {
        return [NSString stringWithFormat:@"min(%@, %@)", a, b];
    }];
    PGBlendMode_Values[0] = nil;
    PGBlendMode_Values[1] = PGBlendMode_first_Desc;
    PGBlendMode_Values[2] = PGBlendMode_second_Desc;
    PGBlendMode_Values[3] = PGBlendMode_multiply_Desc;
    PGBlendMode_Values[4] = PGBlendMode_darken_Desc;
}

+ (NSArray*)values {
    return (@[PGBlendMode_first_Desc, PGBlendMode_second_Desc, PGBlendMode_multiply_Desc, PGBlendMode_darken_Desc]);
}

+ (PGBlendMode*)value:(PGBlendModeR)r {
    return PGBlendMode_Values[r];
}

@end

@implementation PGColorSource
static CNClassType* _PGColorSource_type;
@synthesize color = _color;
@synthesize texture = _texture;
@synthesize blendMode = _blendMode;
@synthesize alphaTestLevel = _alphaTestLevel;

+ (instancetype)colorSourceWithColor:(PGVec4)color texture:(PGTexture*)texture blendMode:(PGBlendModeR)blendMode alphaTestLevel:(float)alphaTestLevel {
    return [[PGColorSource alloc] initWithColor:color texture:texture blendMode:blendMode alphaTestLevel:alphaTestLevel];
}

- (instancetype)initWithColor:(PGVec4)color texture:(PGTexture*)texture blendMode:(PGBlendModeR)blendMode alphaTestLevel:(float)alphaTestLevel {
    self = [super init];
    if(self) {
        _color = color;
        _texture = texture;
        _blendMode = blendMode;
        _alphaTestLevel = alphaTestLevel;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGColorSource class]) _PGColorSource_type = [CNClassType classTypeWithCls:[PGColorSource class]];
}

+ (PGColorSource*)applyColor:(PGVec4)color texture:(PGTexture*)texture {
    return [PGColorSource colorSourceWithColor:color texture:texture blendMode:PGBlendMode_multiply alphaTestLevel:-1.0];
}

+ (PGColorSource*)applyColor:(PGVec4)color texture:(PGTexture*)texture alphaTestLevel:(float)alphaTestLevel {
    return [PGColorSource colorSourceWithColor:color texture:texture blendMode:PGBlendMode_multiply alphaTestLevel:alphaTestLevel];
}

+ (PGColorSource*)applyColor:(PGVec4)color texture:(PGTexture*)texture blendMode:(PGBlendModeR)blendMode {
    return [PGColorSource colorSourceWithColor:color texture:texture blendMode:blendMode alphaTestLevel:-1.0];
}

+ (PGColorSource*)applyColor:(PGVec4)color {
    return [PGColorSource colorSourceWithColor:color texture:nil blendMode:PGBlendMode_first alphaTestLevel:-1.0];
}

+ (PGColorSource*)applyTexture:(PGTexture*)texture {
    return [PGColorSource colorSourceWithColor:PGVec4Make(1.0, 1.0, 1.0, 1.0) texture:texture blendMode:PGBlendMode_second alphaTestLevel:-1.0];
}

- (PGShaderSystem*)shaderSystem {
    return PGSimpleShaderSystem.instance;
}

- (PGColorSource*)setColor:(PGVec4)color {
    return [PGColorSource colorSourceWithColor:color texture:_texture blendMode:_blendMode alphaTestLevel:_alphaTestLevel];
}

- (PGRect)uv {
    if(_texture != nil) return [((PGTexture*)(nonnil(_texture))) uv];
    else return pgRectApplyXYWidthHeight(0.0, 0.0, 1.0, 1.0);
}

- (NSString*)description {
    return [NSString stringWithFormat:@"ColorSource(%@, %@, %@, %f)", pgVec4Description(_color), _texture, [PGBlendMode value:_blendMode], _alphaTestLevel];
}

- (CNClassType*)type {
    return [PGColorSource type];
}

+ (CNClassType*)type {
    return _PGColorSource_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGStandardMaterial
static CNClassType* _PGStandardMaterial_type;
@synthesize diffuse = _diffuse;
@synthesize specularColor = _specularColor;
@synthesize specularSize = _specularSize;
@synthesize normalMap = _normalMap;

+ (instancetype)standardMaterialWithDiffuse:(PGColorSource*)diffuse specularColor:(PGVec4)specularColor specularSize:(CGFloat)specularSize normalMap:(PGNormalMap*)normalMap {
    return [[PGStandardMaterial alloc] initWithDiffuse:diffuse specularColor:specularColor specularSize:specularSize normalMap:normalMap];
}

- (instancetype)initWithDiffuse:(PGColorSource*)diffuse specularColor:(PGVec4)specularColor specularSize:(CGFloat)specularSize normalMap:(PGNormalMap*)normalMap {
    self = [super init];
    if(self) {
        _diffuse = diffuse;
        _specularColor = specularColor;
        _specularSize = specularSize;
        _normalMap = normalMap;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGStandardMaterial class]) _PGStandardMaterial_type = [CNClassType classTypeWithCls:[PGStandardMaterial class]];
}

+ (PGStandardMaterial*)applyDiffuse:(PGColorSource*)diffuse {
    return [PGStandardMaterial standardMaterialWithDiffuse:diffuse specularColor:PGVec4Make(0.0, 0.0, 0.0, 1.0) specularSize:0.0 normalMap:nil];
}

- (PGShaderSystem*)shaderSystem {
    return PGStandardShaderSystem.instance;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"StandardMaterial(%@, %@, %f, %@)", _diffuse, pgVec4Description(_specularColor), _specularSize, _normalMap];
}

- (CNClassType*)type {
    return [PGStandardMaterial type];
}

+ (CNClassType*)type {
    return _PGStandardMaterial_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGNormalMap
static CNClassType* _PGNormalMap_type;
@synthesize texture = _texture;
@synthesize tangent = _tangent;

+ (instancetype)normalMapWithTexture:(PGTexture*)texture tangent:(BOOL)tangent {
    return [[PGNormalMap alloc] initWithTexture:texture tangent:tangent];
}

- (instancetype)initWithTexture:(PGTexture*)texture tangent:(BOOL)tangent {
    self = [super init];
    if(self) {
        _texture = texture;
        _tangent = tangent;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGNormalMap class]) _PGNormalMap_type = [CNClassType classTypeWithCls:[PGNormalMap class]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"NormalMap(%@, %d)", _texture, _tangent];
}

- (CNClassType*)type {
    return [PGNormalMap type];
}

+ (CNClassType*)type {
    return _PGNormalMap_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGBlendFunction
static PGBlendFunction* _PGBlendFunction_standard;
static PGBlendFunction* _PGBlendFunction_premultiplied;
static CNClassType* _PGBlendFunction_type;
@synthesize source = _source;
@synthesize destination = _destination;

+ (instancetype)blendFunctionWithSource:(unsigned int)source destination:(unsigned int)destination {
    return [[PGBlendFunction alloc] initWithSource:source destination:destination];
}

- (instancetype)initWithSource:(unsigned int)source destination:(unsigned int)destination {
    self = [super init];
    if(self) {
        _source = source;
        _destination = destination;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGBlendFunction class]) {
        _PGBlendFunction_type = [CNClassType classTypeWithCls:[PGBlendFunction class]];
        _PGBlendFunction_standard = [PGBlendFunction blendFunctionWithSource:GL_SRC_ALPHA destination:GL_ONE_MINUS_SRC_ALPHA];
        _PGBlendFunction_premultiplied = [PGBlendFunction blendFunctionWithSource:GL_ONE destination:GL_ONE_MINUS_SRC_ALPHA];
    }
}

- (void)applyDraw:(void(^)())draw {
    PGEnablingState* __tmp__il__0self = PGGlobal.context.blend;
    {
        BOOL __il__0changed = [__tmp__il__0self enable];
        {
            [PGGlobal.context setBlendFunction:self];
            draw();
        }
        if(__il__0changed) [__tmp__il__0self disable];
    }
}

- (void)bind {
    glBlendFunc(_source, _destination);
}

- (NSString*)description {
    return [NSString stringWithFormat:@"BlendFunction(%u, %u)", _source, _destination];
}

- (CNClassType*)type {
    return [PGBlendFunction type];
}

+ (PGBlendFunction*)standard {
    return _PGBlendFunction_standard;
}

+ (PGBlendFunction*)premultiplied {
    return _PGBlendFunction_premultiplied;
}

+ (CNClassType*)type {
    return _PGBlendFunction_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

