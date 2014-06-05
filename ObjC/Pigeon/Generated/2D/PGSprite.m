#import "PGSprite.h"

#import "PGVertex.h"
#import "CNReact.h"
#import "GL.h"
#import "PGVertexArray.h"
#import "PGMaterial.h"
#import "PGContext.h"
#import "CNObserver.h"
#import "PGTexture.h"
#import "PGDirector.h"
#import "PGIndex.h"
#import "PGMesh.h"
#import "PGBillboardView.h"
#import "PGMatrixModel.h"
#import "PGMat4.h"
#import "PGInput.h"
@implementation PGSprite
static PGVertexBufferDesc* _PGSprite_vbDesc;
static CNClassType* _PGSprite_type;
@synthesize visible = _visible;
@synthesize material = _material;
@synthesize position = _position;
@synthesize rect = _rect;
@synthesize tap = _tap;

+ (instancetype)spriteWithVisible:(CNReact*)visible material:(CNReact*)material position:(CNReact*)position rect:(CNReact*)rect {
    return [[PGSprite alloc] initWithVisible:visible material:material position:position rect:rect];
}

- (instancetype)initWithVisible:(CNReact*)visible material:(CNReact*)material position:(CNReact*)position rect:(CNReact*)rect {
    self = [super init];
    if(self) {
        _visible = visible;
        _material = material;
        _position = position;
        _rect = rect;
        _vb = [PGVBO mutDesc:_PGSprite_vbDesc usage:GL_DYNAMIC_DRAW];
        __changed = [CNReactFlag reactFlagWithInitial:YES reacts:(@[((CNReact*)([material mapF:^PGTexture*(PGColorSource* _) {
    return ((PGColorSource*)(_))->_texture;
}])), ((CNReact*)(position)), ((CNReact*)(rect)), ((CNReact*)([PGGlobal context]->_viewSize))])];
        __materialChanged = [CNReactFlag reactFlagWithInitial:YES reacts:(@[material])];
        _tap = [CNSignal signal];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGSprite class]) {
        _PGSprite_type = [CNClassType classTypeWithCls:[PGSprite class]];
        _PGSprite_vbDesc = [PGVertexBufferDesc vertexBufferDescWithDataType:pgBillboardBufferDataType() position:0 uv:((int)(9 * 4)) normal:-1 color:((int)(5 * 4)) model:((int)(3 * 4))];
    }
}

+ (PGSprite*)applyVisible:(CNReact*)visible material:(CNReact*)material position:(CNReact*)position anchor:(PGVec2)anchor {
    return [PGSprite spriteWithVisible:visible material:material position:position rect:[PGSprite rectReactMaterial:material anchor:anchor]];
}

+ (PGSprite*)applyMaterial:(CNReact*)material position:(CNReact*)position anchor:(PGVec2)anchor {
    return [PGSprite applyVisible:[CNReact applyValue:@YES] material:material position:position anchor:anchor];
}

+ (CNReact*)rectReactMaterial:(CNReact*)material anchor:(PGVec2)anchor {
    return [material mapF:^id(PGColorSource* m) {
        PGVec2 s = pgVec2DivF([((PGTexture*)(nonnil(((PGColorSource*)(m))->_texture))) size], [[PGDirector current] scale]);
        return wrap(PGRect, (PGRectMake((pgVec2MulVec2(s, (pgVec2DivI((pgVec2AddI(anchor, 1)), -2)))), s)));
    }];
}

- (void)draw {
    if(!(unumb([_visible value]))) return ;
    if(unumb([__materialChanged value])) {
        _vao = [[PGMesh meshWithVertex:_vb index:[PGEmptyIndexSource triangleStrip]] vaoShaderSystem:[PGBillboardShaderSystem projectionSpace] material:[_material value] shadow:NO];
        [__materialChanged clear];
    }
    if(unumb([__changed value])) {
        PGBillboardBufferDataBuffer* vertexes = [PGBillboardBufferDataBuffer billboardBufferDataBufferWithCount:4];
        PGColorSource* m = [_material value];
        {
            PGVec3 __tmp__il__2t_2at = uwrap(PGVec3, [_position value]);
            PGQuad __tmp__il__2t_2quad = pgRectStripQuad((pgRectMulF((pgRectDivVec2((uwrap(PGRect, [_rect value])), (uwrap(PGVec2, [[PGGlobal context]->_scaledViewSize value])))), 2.0)));
            PGQuad __tmp__il__2t_2uv = pgRectUpsideDownStripQuad((({
                PGTexture* __tmp_2t_2rp4l = m->_texture;
                ((__tmp_2t_2rp4l != nil) ? [((PGTexture*)(m->_texture)) uv] : pgRectApplyXYWidthHeight(0.0, 0.0, 1.0, 1.0));
            })));
            {
                if(vertexes->__position >= vertexes->_count) @throw @"Out of bound";
                *(((PGBillboardBufferData*)(vertexes->__pointer))) = PGBillboardBufferDataMake(__tmp__il__2t_2at, __tmp__il__2t_2quad.p0, m->_color, __tmp__il__2t_2uv.p0);
                vertexes->__pointer = ((PGBillboardBufferData*)(vertexes->__pointer)) + 1;
                vertexes->__position++;
                if(vertexes->__position >= vertexes->_count) @throw @"Out of bound";
                *(((PGBillboardBufferData*)(vertexes->__pointer))) = PGBillboardBufferDataMake(__tmp__il__2t_2at, __tmp__il__2t_2quad.p1, m->_color, __tmp__il__2t_2uv.p1);
                vertexes->__pointer = ((PGBillboardBufferData*)(vertexes->__pointer)) + 1;
                vertexes->__position++;
                if(vertexes->__position >= vertexes->_count) @throw @"Out of bound";
                *(((PGBillboardBufferData*)(vertexes->__pointer))) = PGBillboardBufferDataMake(__tmp__il__2t_2at, __tmp__il__2t_2quad.p2, m->_color, __tmp__il__2t_2uv.p2);
                vertexes->__pointer = ((PGBillboardBufferData*)(vertexes->__pointer)) + 1;
                vertexes->__position++;
                if(vertexes->__position >= vertexes->_count) @throw @"Out of bound";
                *(((PGBillboardBufferData*)(vertexes->__pointer))) = PGBillboardBufferDataMake(__tmp__il__2t_2at, __tmp__il__2t_2quad.p3, m->_color, __tmp__il__2t_2uv.p3);
                vertexes->__pointer = ((PGBillboardBufferData*)(vertexes->__pointer)) + 1;
                vertexes->__position++;
            }
        }
        [_vb setData:vertexes];
        [__changed clear];
    }
    {
        PGCullFace* __tmp__il__3self = [PGGlobal context]->_cullFace;
        {
            unsigned int __il__3oldValue = [__tmp__il__3self disable];
            [((PGVertexArray*)(_vao)) draw];
            if(__il__3oldValue != GL_NONE) [__tmp__il__3self setValue:__il__3oldValue];
        }
    }
}

- (PGRect)rectInViewport {
    PGVec4 pp = [[[[PGGlobal matrix] value] wcp] mulVec4:pgVec4ApplyVec3W((uwrap(PGVec3, [_position value])), 1.0)];
    return pgRectAddVec2((pgRectMulF((pgRectDivVec2((uwrap(PGRect, [_rect value])), (uwrap(PGVec2, [[PGGlobal context]->_scaledViewSize value])))), 2.0)), pgVec4Xy(pp));
}

- (BOOL)containsViewportVec2:(PGVec2)vec2 {
    return unumb([_visible value]) && pgRectContainsVec2([self rectInViewport], vec2);
}

- (BOOL)tapEvent:(id<PGEvent>)event {
    if([self containsViewportVec2:[event locationInViewport]]) {
        [_tap post];
        return YES;
    } else {
        return NO;
    }
}

- (PGRecognizer*)recognizer {
    return [PGRecognizer applyTp:[PGTap apply] on:^BOOL(id<PGEvent> _) {
        return [self tapEvent:_];
    }];
}

+ (PGSprite*)applyVisible:(CNReact*)visible material:(CNReact*)material position:(CNReact*)position {
    return [PGSprite spriteWithVisible:visible material:material position:position rect:[PGSprite rectReactMaterial:material anchor:PGVec2Make(0.0, 0.0)]];
}

+ (PGSprite*)applyMaterial:(CNReact*)material position:(CNReact*)position rect:(CNReact*)rect {
    return [PGSprite spriteWithVisible:[CNReact applyValue:@YES] material:material position:position rect:rect];
}

+ (PGSprite*)applyMaterial:(CNReact*)material position:(CNReact*)position {
    return [PGSprite spriteWithVisible:[CNReact applyValue:@YES] material:material position:position rect:[PGSprite rectReactMaterial:material anchor:PGVec2Make(0.0, 0.0)]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Sprite(%@, %@, %@, %@)", _visible, _material, _position, _rect];
}

- (CNClassType*)type {
    return [PGSprite type];
}

+ (PGVertexBufferDesc*)vbDesc {
    return _PGSprite_vbDesc;
}

+ (CNClassType*)type {
    return _PGSprite_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

