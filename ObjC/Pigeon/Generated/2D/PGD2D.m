#import "PGD2D.h"

#import "PGVertex.h"
#import "PGSprite.h"
#import "GL.h"
#import "PGVertexArray.h"
#import "PGIndex.h"
#import "PGSimpleShaderSystem.h"
#import "PGCircle.h"
#import "PGMaterial.h"
#import "PGTexture.h"
#import "PGContext.h"
#import "PGMatrixModel.h"
#import "PGMat4.h"
@implementation PGD2D
static PGBillboardBufferDataBuffer* _PGD2D_vertexes;
static PGMutableVertexBuffer* _PGD2D_vb;
static PGVertexArray* _PGD2D_vaoForColor;
static PGVertexArray* _PGD2D_vaoForTexture;
static PGMutableVertexBuffer* _PGD2D_lineVb;
static PGMeshData* _PGD2D_lineVertexes;
static PGVertexArray* _PGD2D_lineVao;
static CNLazy* _PGD2D__lazy_circleVaoWithSegment;
static CNLazy* _PGD2D__lazy_circleVaoWithoutSegment;
static CNClassType* _PGD2D_type;

+ (void)initialize {
    [super initialize];
    if(self == [PGD2D class]) {
        _PGD2D_type = [CNClassType classTypeWithCls:[PGD2D class]];
        _PGD2D_vertexes = [PGBillboardBufferDataBuffer billboardBufferDataBufferWithCount:4];
        _PGD2D_vb = [PGVBO mutDesc:[PGSprite vbDesc] usage:GL_STREAM_DRAW];
        _PGD2D_vaoForColor = [[PGMesh meshWithVertex:_PGD2D_vb index:[PGEmptyIndexSource triangleStrip]] vaoShader:[PGBillboardShaderSystem shaderForKey:[PGBillboardShaderKey billboardShaderKeyWithTexture:NO alpha:NO shadow:NO modelSpace:PGBillboardShaderSpace_camera]]];
        _PGD2D_vaoForTexture = [[PGMesh meshWithVertex:_PGD2D_vb index:[PGEmptyIndexSource triangleStrip]] vaoShader:[PGBillboardShaderSystem shaderForKey:[PGBillboardShaderKey billboardShaderKeyWithTexture:YES alpha:NO shadow:NO modelSpace:PGBillboardShaderSpace_camera]]];
        _PGD2D_lineVb = [PGVBO mutMeshUsage:GL_STREAM_DRAW];
        _PGD2D_lineVertexes = ({
            PGMeshData* pp = cnPointerApplyTpCount(pgMeshDataType(), 2);
            PGMeshData* p = pp;
            p->uv = PGVec2Make(0.0, 0.0);
            p->normal = PGVec3Make(0.0, 0.0, 1.0);
            p++;
            p->uv = PGVec2Make(1.0, 1.0);
            p->normal = PGVec3Make(0.0, 0.0, 1.0);
            pp;
        });
        _PGD2D_lineVao = [[PGMesh meshWithVertex:_PGD2D_lineVb index:[PGEmptyIndexSource lines]] vaoShader:[PGSimpleShaderSystem colorShader]];
        _PGD2D__lazy_circleVaoWithSegment = [CNLazy lazyWithF:^PGVertexArray*() {
            return [[PGMesh meshWithVertex:[PGVBO vec2Data:({
                PGVec2Buffer* b = [PGVec2Buffer vec2BufferWithCount:4];
                if(b->__position >= b->_count) @throw @"Out of bound";
                *(((float*)(b->__pointer))) = -1.0;
                *(((float*)(b->__pointer)) + 1) = -1.0;
                {
                    b->__pointer = ((PGVec2*)(b->__pointer)) + 1;
                    b->__position++;
                }
                if(b->__position >= b->_count) @throw @"Out of bound";
                *(((float*)(b->__pointer))) = -1.0;
                *(((float*)(b->__pointer)) + 1) = 1.0;
                {
                    b->__pointer = ((PGVec2*)(b->__pointer)) + 1;
                    b->__position++;
                }
                if(b->__position >= b->_count) @throw @"Out of bound";
                *(((float*)(b->__pointer))) = 1.0;
                *(((float*)(b->__pointer)) + 1) = -1.0;
                {
                    b->__pointer = ((PGVec2*)(b->__pointer)) + 1;
                    b->__position++;
                }
                if(b->__position >= b->_count) @throw @"Out of bound";
                *(((float*)(b->__pointer))) = 1.0;
                *(((float*)(b->__pointer)) + 1) = 1.0;
                {
                    b->__pointer = ((PGVec2*)(b->__pointer)) + 1;
                    b->__position++;
                }
                b;
            })] index:[PGEmptyIndexSource triangleStrip]] vaoShader:[PGCircleShader withSegment]];
        }];
        _PGD2D__lazy_circleVaoWithoutSegment = [CNLazy lazyWithF:^PGVertexArray*() {
            return [[PGMesh meshWithVertex:[PGVBO vec2Data:({
                PGVec2Buffer* b = [PGVec2Buffer vec2BufferWithCount:4];
                if(b->__position >= b->_count) @throw @"Out of bound";
                *(((float*)(b->__pointer))) = -1.0;
                *(((float*)(b->__pointer)) + 1) = -1.0;
                {
                    b->__pointer = ((PGVec2*)(b->__pointer)) + 1;
                    b->__position++;
                }
                if(b->__position >= b->_count) @throw @"Out of bound";
                *(((float*)(b->__pointer))) = -1.0;
                *(((float*)(b->__pointer)) + 1) = 1.0;
                {
                    b->__pointer = ((PGVec2*)(b->__pointer)) + 1;
                    b->__position++;
                }
                if(b->__position >= b->_count) @throw @"Out of bound";
                *(((float*)(b->__pointer))) = 1.0;
                *(((float*)(b->__pointer)) + 1) = -1.0;
                {
                    b->__pointer = ((PGVec2*)(b->__pointer)) + 1;
                    b->__position++;
                }
                if(b->__position >= b->_count) @throw @"Out of bound";
                *(((float*)(b->__pointer))) = 1.0;
                *(((float*)(b->__pointer)) + 1) = 1.0;
                {
                    b->__pointer = ((PGVec2*)(b->__pointer)) + 1;
                    b->__position++;
                }
                b;
            })] index:[PGEmptyIndexSource triangleStrip]] vaoShader:[PGCircleShader withoutSegment]];
        }];
    }
}

+ (PGVertexArray*)circleVaoWithSegment {
    return [_PGD2D__lazy_circleVaoWithSegment get];
}

+ (PGVertexArray*)circleVaoWithoutSegment {
    return [_PGD2D__lazy_circleVaoWithoutSegment get];
}

+ (void)install {
}

+ (void)drawSpriteMaterial:(PGColorSource*)material at:(PGVec3)at rect:(PGRect)rect {
    [PGD2D drawSpriteMaterial:material at:at quad:pgRectStripQuad(rect)];
}

+ (void)drawSpriteMaterial:(PGColorSource*)material at:(PGVec3)at quad:(PGQuad)quad {
    [PGD2D drawSpriteMaterial:material at:at quad:quad uv:pgRectUpsideDownStripQuad((({
        PGTexture* __tmp_0p3l = material->_texture;
        ((__tmp_0p3l != nil) ? [((PGTexture*)(material->_texture)) uv] : pgRectApplyXYWidthHeight(0.0, 0.0, 1.0, 1.0));
    })))];
}

+ (void)drawSpriteMaterial:(PGColorSource*)material at:(PGVec3)at quad:(PGQuad)quad uv:(PGQuad)uv {
    [_PGD2D_vertexes reset];
    {
        if(_PGD2D_vertexes->__position >= _PGD2D_vertexes->_count) @throw @"Out of bound";
        *(((PGBillboardBufferData*)(_PGD2D_vertexes->__pointer))) = PGBillboardBufferDataMake(at, quad.p0, material->_color, uv.p0);
        _PGD2D_vertexes->__pointer = ((PGBillboardBufferData*)(_PGD2D_vertexes->__pointer)) + 1;
        _PGD2D_vertexes->__position++;
        if(_PGD2D_vertexes->__position >= _PGD2D_vertexes->_count) @throw @"Out of bound";
        *(((PGBillboardBufferData*)(_PGD2D_vertexes->__pointer))) = PGBillboardBufferDataMake(at, quad.p1, material->_color, uv.p1);
        _PGD2D_vertexes->__pointer = ((PGBillboardBufferData*)(_PGD2D_vertexes->__pointer)) + 1;
        _PGD2D_vertexes->__position++;
        if(_PGD2D_vertexes->__position >= _PGD2D_vertexes->_count) @throw @"Out of bound";
        *(((PGBillboardBufferData*)(_PGD2D_vertexes->__pointer))) = PGBillboardBufferDataMake(at, quad.p2, material->_color, uv.p2);
        _PGD2D_vertexes->__pointer = ((PGBillboardBufferData*)(_PGD2D_vertexes->__pointer)) + 1;
        _PGD2D_vertexes->__position++;
        if(_PGD2D_vertexes->__position >= _PGD2D_vertexes->_count) @throw @"Out of bound";
        *(((PGBillboardBufferData*)(_PGD2D_vertexes->__pointer))) = PGBillboardBufferDataMake(at, quad.p3, material->_color, uv.p3);
        _PGD2D_vertexes->__pointer = ((PGBillboardBufferData*)(_PGD2D_vertexes->__pointer)) + 1;
        _PGD2D_vertexes->__position++;
    }
    [_PGD2D_vb setData:_PGD2D_vertexes];
    {
        PGCullFace* __tmp__il__3self = [PGGlobal context]->_cullFace;
        {
            unsigned int __il__3oldValue = [__tmp__il__3self disable];
            if(material->_texture == nil) [_PGD2D_vaoForColor drawParam:material];
            else [_PGD2D_vaoForTexture drawParam:material];
            if(__il__3oldValue != GL_NONE) [__tmp__il__3self setValue:__il__3oldValue];
        }
    }
}

+ (void)writeSpriteIn:(PGBillboardBufferDataBuffer*)in material:(PGColorSource*)material at:(PGVec3)at quad:(PGQuad)quad uv:(PGQuad)uv {
    if(in->__position >= in->_count) @throw @"Out of bound";
    *(((PGBillboardBufferData*)(in->__pointer))) = PGBillboardBufferDataMake(at, quad.p0, material->_color, uv.p0);
    in->__pointer = ((PGBillboardBufferData*)(in->__pointer)) + 1;
    in->__position++;
    if(in->__position >= in->_count) @throw @"Out of bound";
    *(((PGBillboardBufferData*)(in->__pointer))) = PGBillboardBufferDataMake(at, quad.p1, material->_color, uv.p1);
    in->__pointer = ((PGBillboardBufferData*)(in->__pointer)) + 1;
    in->__position++;
    if(in->__position >= in->_count) @throw @"Out of bound";
    *(((PGBillboardBufferData*)(in->__pointer))) = PGBillboardBufferDataMake(at, quad.p2, material->_color, uv.p2);
    in->__pointer = ((PGBillboardBufferData*)(in->__pointer)) + 1;
    in->__position++;
    if(in->__position >= in->_count) @throw @"Out of bound";
    *(((PGBillboardBufferData*)(in->__pointer))) = PGBillboardBufferDataMake(at, quad.p3, material->_color, uv.p3);
    in->__pointer = ((PGBillboardBufferData*)(in->__pointer)) + 1;
    in->__position++;
}

+ (void)writeQuadIndexIn:(CNInt4Buffer*)in i:(unsigned int)i {
    [in setV:((int)(i))];
    [in setV:((int)(i + 1))];
    [in setV:((int)(i + 2))];
    [in setV:((int)(i + 1))];
    [in setV:((int)(i + 2))];
    [in setV:((int)(i + 3))];
}

+ (void)drawLineMaterial:(PGColorSource*)material p0:(PGVec2)p0 p1:(PGVec2)p1 {
    PGMeshData* v = _PGD2D_lineVertexes;
    v->position = pgVec3ApplyVec2Z(p0, 0.0);
    v++;
    v->position = pgVec3ApplyVec2Z(p1, 0.0);
    [_PGD2D_lineVb setArray:_PGD2D_lineVertexes count:2];
    {
        PGCullFace* __tmp__il__5self = [PGGlobal context]->_cullFace;
        {
            unsigned int __il__5oldValue = [__tmp__il__5self disable];
            [_PGD2D_lineVao drawParam:material];
            if(__il__5oldValue != GL_NONE) [__tmp__il__5self setValue:__il__5oldValue];
        }
    }
}

+ (void)drawCircleBackColor:(PGVec4)backColor strokeColor:(PGVec4)strokeColor at:(PGVec3)at radius:(float)radius relative:(PGVec2)relative segmentColor:(PGVec4)segmentColor start:(CGFloat)start end:(CGFloat)end {
    PGCullFace* __tmp__il__0self = [PGGlobal context]->_cullFace;
    {
        unsigned int __il__0oldValue = [__tmp__il__0self disable];
        [[PGD2D circleVaoWithSegment] drawParam:[PGCircleParam circleParamWithColor:backColor strokeColor:strokeColor position:at radius:[PGD2D radiusPR:radius] relative:relative segment:[PGCircleSegment circleSegmentWithColor:segmentColor start:((float)(start)) end:((float)(end))]]];
        if(__il__0oldValue != GL_NONE) [__tmp__il__0self setValue:__il__0oldValue];
    }
}

+ (void)drawCircleBackColor:(PGVec4)backColor strokeColor:(PGVec4)strokeColor at:(PGVec3)at radius:(float)radius relative:(PGVec2)relative {
    PGCullFace* __tmp__il__0self = [PGGlobal context]->_cullFace;
    {
        unsigned int __il__0oldValue = [__tmp__il__0self disable];
        [[PGD2D circleVaoWithoutSegment] drawParam:[PGCircleParam circleParamWithColor:backColor strokeColor:strokeColor position:at radius:[PGD2D radiusPR:radius] relative:relative segment:nil]];
        if(__il__0oldValue != GL_NONE) [__tmp__il__0self setValue:__il__0oldValue];
    }
}

+ (PGVec2)radiusPR:(float)r {
    float l = pgVec2Length((pgVec4Xy(([[[[PGGlobal matrix] value] wcp] mulVec4:PGVec4Make(r, 0.0, 0.0, 0.0)]))));
    PGVec2i vps = [[PGGlobal context] viewport].size;
    if(vps.y <= vps.x) return PGVec2Make((l * vps.y) / vps.x, l);
    else return PGVec2Make(l, (l * vps.x) / vps.y);
}

- (CNClassType*)type {
    return [PGD2D type];
}

+ (CNClassType*)type {
    return _PGD2D_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

