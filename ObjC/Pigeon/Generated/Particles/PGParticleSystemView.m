#import "PGParticleSystemView.h"

#import "PGParticleSystem.h"
#import "PGVertex.h"
#import "PGShader.h"
#import "PGMaterial.h"
#import "PGIndex.h"
#import "PGVertexArray.h"
#import "GL.h"
#import "PGBuffer.h"
#import "CNFuture.h"
#import "PGContext.h"
@implementation PGParticleSystemView
static CNClassType* _PGParticleSystemView_type;
@synthesize system = _system;
@synthesize vbDesc = _vbDesc;
@synthesize shader = _shader;
@synthesize material = _material;
@synthesize blendFunc = _blendFunc;
@synthesize maxCount = _maxCount;
@synthesize vertexCount = _vertexCount;
@synthesize index = _index;
@synthesize vaoRing = _vaoRing;

+ (instancetype)particleSystemViewWithSystem:(PGParticleSystem*)system vbDesc:(PGVertexBufferDesc*)vbDesc shader:(PGShader*)shader material:(id)material blendFunc:(PGBlendFunction*)blendFunc {
    return [[PGParticleSystemView alloc] initWithSystem:system vbDesc:vbDesc shader:shader material:material blendFunc:blendFunc];
}

- (instancetype)initWithSystem:(PGParticleSystem*)system vbDesc:(PGVertexBufferDesc*)vbDesc shader:(PGShader*)shader material:(id)material blendFunc:(PGBlendFunction*)blendFunc {
    self = [super init];
    __weak PGParticleSystemView* _weakSelf = self;
    if(self) {
        _system = system;
        _vbDesc = vbDesc;
        _shader = shader;
        _material = material;
        _blendFunc = blendFunc;
        _maxCount = system.maxCount;
        _vertexCount = [system vertexCount];
        __indexCount = [self indexCount];
        _index = [self createIndexSource];
        _vaoRing = [PGVertexArrayRing vertexArrayRingWithRingSize:3 creator:^PGSimpleVertexArray*(unsigned int _) {
            PGParticleSystemView* _self = _weakSelf;
            if(_self != nil) return [shader vaoVbo:[PGVBO mutDesc:vbDesc usage:GL_STREAM_DRAW] ibo:_self->_index];
            else return nil;
        }];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGParticleSystemView class]) _PGParticleSystemView_type = [CNClassType classTypeWithCls:[PGParticleSystemView class]];
}

- (unsigned int)indexCount {
    @throw @"Method indexCount is abstract";
}

- (id<PGIndexSource>)createIndexSource {
    @throw @"Method createIndexSource is abstract";
}

- (void)prepare {
    __vao = [_vaoRing next];
    [((PGVertexArray*)(__vao)) syncWait];
    {
        PGMutableVertexBuffer* vbo = [((PGVertexArray*)(__vao)) mutableVertexBuffer];
        if(vbo != nil) {
            __data = [((PGMutableVertexBuffer*)(vbo)) beginWriteCount:_vertexCount * _maxCount];
            if(__data != nil) __lastWriteFuture = [_system writeToArray:__data];
            else __lastWriteFuture = nil;
        }
    }
}

- (void)draw {
    if(__data != nil) {
        [((PGMappedBufferData*)(__data)) finish];
        if([((PGMappedBufferData*)(__data)) wasUpdated] && __lastWriteFuture != nil) {
            CNTry* r = [((CNFuture*)(__lastWriteFuture)) waitResultPeriod:1.0];
            if(r != nil && [((CNTry*)(r)) isSuccess]) {
                unsigned int n = unumui4([((CNTry*)(r)) get]);
                if(n > 0) {
                    PGEnablingState* __tmp__il__0t_1t_1t_1t_0self = PGGlobal.context.depthTest;
                    {
                        BOOL __il__0t_1t_1t_1t_0changed = [__tmp__il__0t_1t_1t_1t_0self disable];
                        {
                            PGCullFace* __tmp__il__0t_1t_1t_1t_0rp0self = PGGlobal.context.cullFace;
                            {
                                unsigned int __il__0t_1t_1t_1t_0rp0oldValue = [__tmp__il__0t_1t_1t_1t_0rp0self disable];
                                PGEnablingState* __il__0t_1t_1t_1t_0rp0rp0__tmp__il__0self = PGGlobal.context.blend;
                                {
                                    BOOL __il__0t_1t_1t_1t_0rp0rp0__il__0changed = [__il__0t_1t_1t_1t_0rp0rp0__tmp__il__0self enable];
                                    {
                                        [PGGlobal.context setBlendFunction:_blendFunc];
                                        [((PGVertexArray*)(__vao)) drawParam:_material start:0 end:((NSUInteger)(__indexCount * n))];
                                    }
                                    if(__il__0t_1t_1t_1t_0rp0rp0__il__0changed) [__il__0t_1t_1t_1t_0rp0rp0__tmp__il__0self disable];
                                }
                                if(__il__0t_1t_1t_1t_0rp0oldValue != GL_NONE) [__tmp__il__0t_1t_1t_1t_0rp0self setValue:__il__0t_1t_1t_1t_0rp0oldValue];
                            }
                        }
                        if(__il__0t_1t_1t_1t_0changed) [__tmp__il__0t_1t_1t_1t_0self enable];
                    }
                }
                [((PGVertexArray*)(__vao)) syncSet];
            } else {
                cnLogInfoText(([NSString stringWithFormat:@"Incorrect result in particle system: %@", r]));
            }
        }
    }
}

- (NSString*)description {
    return [NSString stringWithFormat:@"ParticleSystemView(%@, %@, %@, %@, %@)", _system, _vbDesc, _shader, _material, _blendFunc];
}

- (CNClassType*)type {
    return [PGParticleSystemView type];
}

+ (CNClassType*)type {
    return _PGParticleSystemView_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGParticleSystemViewIndexArray
static CNClassType* _PGParticleSystemViewIndexArray_type;

+ (instancetype)particleSystemViewIndexArrayWithSystem:(PGParticleSystem*)system vbDesc:(PGVertexBufferDesc*)vbDesc shader:(PGShader*)shader material:(id)material blendFunc:(PGBlendFunction*)blendFunc {
    return [[PGParticleSystemViewIndexArray alloc] initWithSystem:system vbDesc:vbDesc shader:shader material:material blendFunc:blendFunc];
}

- (instancetype)initWithSystem:(PGParticleSystem*)system vbDesc:(PGVertexBufferDesc*)vbDesc shader:(PGShader*)shader material:(id)material blendFunc:(PGBlendFunction*)blendFunc {
    self = [super initWithSystem:system vbDesc:vbDesc shader:shader material:material blendFunc:blendFunc];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGParticleSystemViewIndexArray class]) _PGParticleSystemViewIndexArray_type = [CNClassType classTypeWithCls:[PGParticleSystemViewIndexArray class]];
}

- (unsigned int)indexCount {
    return [((id<PGParticleSystemIndexArray>)(self.system)) indexCount];
}

- (id<PGIndexSource>)createIndexSource {
    unsigned int* ia = [((id<PGParticleSystemIndexArray>)(self.system)) createIndexArray];
    PGImmutableIndexBuffer* ib = [PGIBO applyPointer:ia count:[self indexCount] * self.maxCount];
    cnPointerFree(ia);
    return ib;
}

- (NSString*)description {
    return @"ParticleSystemViewIndexArray";
}

- (CNClassType*)type {
    return [PGParticleSystemViewIndexArray type];
}

+ (CNClassType*)type {
    return _PGParticleSystemViewIndexArray_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

