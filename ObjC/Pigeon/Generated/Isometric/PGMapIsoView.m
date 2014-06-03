#import "PGMapIsoView.h"

#import "PGMapIso.h"
#import "PGMaterial.h"
#import "PGVertex.h"
#import "PGCameraIso.h"
#import "PGMat4.h"
#import "PGIndex.h"
#import "PGVertexArray.h"
#import "GL.h"
#import "PGContext.h"
@implementation PGMapSsoView
static CNClassType* _PGMapSsoView_type;
@synthesize map = _map;
@synthesize material = _material;
@synthesize plane = _plane;

+ (instancetype)mapSsoViewWithMap:(PGMapSso*)map material:(PGMaterial*)material {
    return [[PGMapSsoView alloc] initWithMap:map material:material];
}

- (instancetype)initWithMap:(PGMapSso*)map material:(PGMaterial*)material {
    self = [super init];
    if(self) {
        _map = map;
        _material = material;
        __lazy_axisVertexBuffer = [CNLazy lazyWithF:^id<PGVertexBuffer>() {
            return ({
                PGMat4* mi = [PGCameraIso.m inverse];
                [PGVBO vec4Data:[ arrs(PGVec4, 4) {[mi mulVec4:PGVec4Make(0.0, 0.0, 0.0, 1.0)], [mi mulVec4:PGVec4Make(1.0, 0.0, 0.0, 1.0)], [mi mulVec4:PGVec4Make(0.0, 1.0, 0.0, 1.0)], [mi mulVec4:PGVec4Make(0.0, 0.0, 1.0, 1.0)]}]];
            });
        }];
        _plane = ({
            PGRectI limits = map.limits;
            CGFloat l = (pgRectIX(limits) - map.size.x) - 0.5;
            CGFloat r = pgRectIX2(limits) + 1.5;
            CGFloat t = (pgRectIY(limits) - map.size.y) - 0.5;
            CGFloat b = pgRectIY2(limits) + 1.5;
            NSInteger w = pgRectIWidth(limits) + 7;
            NSInteger h = pgRectIHeight(limits) + 7;
            [PGMesh meshWithVertex:[PGVBO meshData:[ arrs(PGMeshData, 4) {PGMeshDataMake((PGVec2Make(0.0, 0.0)), (PGVec3Make(0.0, 1.0, 0.0)), (PGVec3Make(((float)(l)), 0.0, ((float)(b))))), PGMeshDataMake((PGVec2Make(((float)(w)), 0.0)), (PGVec3Make(0.0, 1.0, 0.0)), (PGVec3Make(((float)(r)), 0.0, ((float)(b))))), PGMeshDataMake((PGVec2Make(0.0, ((float)(h)))), (PGVec3Make(0.0, 1.0, 0.0)), (PGVec3Make(((float)(l)), 0.0, ((float)(t))))), PGMeshDataMake((PGVec2Make(((float)(w)), ((float)(h)))), (PGVec3Make(0.0, 1.0, 0.0)), (PGVec3Make(((float)(r)), 0.0, ((float)(t)))))}]] index:PGEmptyIndexSource.triangleStrip];
        });
        _planeVao = [_plane vaoMaterial:material shadow:NO];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGMapSsoView class]) _PGMapSsoView_type = [CNClassType classTypeWithCls:[PGMapSsoView class]];
}

- (id<PGVertexBuffer>)axisVertexBuffer {
    return [__lazy_axisVertexBuffer get];
}

- (void)drawLayout {
    [[PGColorSource applyColor:PGVec4Make(1.0, 0.0, 0.0, 1.0)] drawVertex:[self axisVertexBuffer] index:[PGArrayIndexSource arrayIndexSourceWithArray:[ arrui4(2) {0, 1}] mode:GL_LINES]];
    [[PGColorSource applyColor:PGVec4Make(0.0, 1.0, 0.0, 1.0)] drawVertex:[self axisVertexBuffer] index:[PGArrayIndexSource arrayIndexSourceWithArray:[ arrui4(2) {0, 2}] mode:GL_LINES]];
    [[PGColorSource applyColor:PGVec4Make(0.0, 0.0, 1.0, 1.0)] drawVertex:[self axisVertexBuffer] index:[PGArrayIndexSource arrayIndexSourceWithArray:[ arrui4(2) {0, 3}] mode:GL_LINES]];
}

- (void)draw {
    PGCullFace* __tmp__il__0self = PGGlobal.context.cullFace;
    {
        unsigned int __il__0oldValue = [__tmp__il__0self disable];
        [_planeVao draw];
        if(__il__0oldValue != GL_NONE) [__tmp__il__0self setValue:__il__0oldValue];
    }
}

- (NSString*)description {
    return [NSString stringWithFormat:@"MapSsoView(%@, %@)", _map, _material];
}

- (CNClassType*)type {
    return [PGMapSsoView type];
}

+ (CNClassType*)type {
    return _PGMapSsoView_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

