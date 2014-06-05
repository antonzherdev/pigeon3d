#import "objd.h"
#import "PGVec.h"
@class PGMat4;
@protocol PGVertexBuffer;
@protocol PGIndexSource;
@class PGVBO;
@class PGIBO;
@class PGVertexBufferDesc;
@class PGVertexArray;
@class PGShader;
@class PGShadowShaderSystem;
@class PGColorSource;
@class PGMaterialVertexArray;
@class PGPlatform;
@class PGShadowRenderTarget;
@class PGShaderSystem;
@class PGRouteVertexArray;
@class PGMaterial;
@class CNChain;
@class PGMutableVertexBuffer;
@class PGMutableIndexBuffer;
@class PGGlobal;
@class PGMatrixStack;
@class PGMMatrixModel;

@class PGMeshDataBuffer;
@class PGMeshDataModel;
@class PGMesh;
@class PGMeshModel;
@class PGMeshUnite;
@class PGMeshWriter;
typedef struct PGMeshData PGMeshData;

struct PGMeshData {
    PGVec2 uv;
    PGVec3 normal;
    PGVec3 position;
};
static inline PGMeshData PGMeshDataMake(PGVec2 uv, PGVec3 normal, PGVec3 position) {
    return (PGMeshData){uv, normal, position};
}
PGMeshData pgMeshDataMulMat4(PGMeshData self, PGMat4* mat4);
PGMeshData pgMeshDataUvAddVec2(PGMeshData self, PGVec2 vec2);
NSString* pgMeshDataDescription(PGMeshData self);
BOOL pgMeshDataIsEqualTo(PGMeshData self, PGMeshData to);
NSUInteger pgMeshDataHash(PGMeshData self);
CNPType* pgMeshDataType();
@interface PGMeshDataWrap : NSObject
@property (readonly, nonatomic) PGMeshData value;

+ (id)wrapWithValue:(PGMeshData)value;
- (id)initWithValue:(PGMeshData)value;
@end



@interface PGMeshDataBuffer : CNBuffer
+ (instancetype)meshDataBufferWithCount:(NSUInteger)count;
- (instancetype)initWithCount:(NSUInteger)count;
- (CNClassType*)type;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGMeshDataModel : NSObject {
@public
    CNPArray* _vertex;
    CNPArray* _index;
}
@property (nonatomic, readonly) CNPArray* vertex;
@property (nonatomic, readonly) CNPArray* index;

+ (instancetype)meshDataModelWithVertex:(CNPArray*)vertex index:(CNPArray*)index;
- (instancetype)initWithVertex:(CNPArray*)vertex index:(CNPArray*)index;
- (CNClassType*)type;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGMesh : NSObject {
@public
    id<PGVertexBuffer> _vertex;
    id<PGIndexSource> _index;
}
@property (nonatomic, readonly) id<PGVertexBuffer> vertex;
@property (nonatomic, readonly) id<PGIndexSource> index;

+ (instancetype)meshWithVertex:(id<PGVertexBuffer>)vertex index:(id<PGIndexSource>)index;
- (instancetype)initWithVertex:(id<PGVertexBuffer>)vertex index:(id<PGIndexSource>)index;
- (CNClassType*)type;
+ (PGMesh*)vec2VertexData:(PGVec2Buffer*)vertexData indexData:(CNPArray*)indexData;
+ (PGMesh*)applyVertexData:(PGMeshDataBuffer*)vertexData indexData:(CNPArray*)indexData;
+ (PGMesh*)applyDesc:(PGVertexBufferDesc*)desc vertexData:(CNPArray*)vertexData indexData:(CNPArray*)indexData;
- (PGVertexArray*)vaoShader:(PGShader*)shader;
- (PGVertexArray*)vaoShadow;
- (PGVertexArray*)vaoShadowMaterial:(PGColorSource*)material;
- (PGVertexArray*)vaoMaterial:(id)material shadow:(BOOL)shadow;
- (PGVertexArray*)vaoShaderSystem:(PGShaderSystem*)shaderSystem material:(id)material shadow:(BOOL)shadow;
- (void)drawMaterial:(PGMaterial*)material;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGMeshModel : NSObject {
@public
    NSArray* _arrays;
}
@property (nonatomic, readonly) NSArray* arrays;

+ (instancetype)meshModelWithArrays:(NSArray*)arrays;
- (instancetype)initWithArrays:(NSArray*)arrays;
- (CNClassType*)type;
+ (PGMeshModel*)applyMeshes:(NSArray*)meshes;
+ (PGMeshModel*)applyShadow:(BOOL)shadow meshes:(NSArray*)meshes;
- (void)draw;
- (void)drawOnly:(unsigned int)only;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGMeshUnite : NSObject {
@public
    CNPArray* _vertexSample;
    CNPArray* _indexSample;
    PGVertexArray*(^_createVao)(PGMesh*);
    PGMutableVertexBuffer* _vbo;
    PGMutableIndexBuffer* _ibo;
    PGMesh* _mesh;
    PGVertexArray* _vao;
    unsigned int __count;
}
@property (nonatomic, readonly) CNPArray* vertexSample;
@property (nonatomic, readonly) CNPArray* indexSample;
@property (nonatomic, readonly) PGVertexArray*(^createVao)(PGMesh*);
@property (nonatomic, readonly) PGMesh* mesh;
@property (nonatomic, readonly) PGVertexArray* vao;

+ (instancetype)meshUniteWithVertexSample:(CNPArray*)vertexSample indexSample:(CNPArray*)indexSample createVao:(PGVertexArray*(^)(PGMesh*))createVao;
- (instancetype)initWithVertexSample:(CNPArray*)vertexSample indexSample:(CNPArray*)indexSample createVao:(PGVertexArray*(^)(PGMesh*))createVao;
- (CNClassType*)type;
+ (PGMeshUnite*)applyMeshModel:(PGMeshDataModel*)meshModel createVao:(PGVertexArray*(^)(PGMesh*))createVao;
- (void)writeCount:(unsigned int)count f:(void(^)(PGMeshWriter*))f;
- (void)writeMat4Array:(id<CNIterable>)mat4Array;
- (PGMeshWriter*)writerCount:(unsigned int)count;
- (void)draw;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGMeshWriter : NSObject {
@public
    PGMutableVertexBuffer* _vbo;
    PGMutableIndexBuffer* _ibo;
    unsigned int _count;
    CNPArray* _vertexSample;
    CNPArray* _indexSample;
    PGMeshData* _vertex;
    unsigned int* _index;
    PGMeshData* __vp;
    unsigned int* __ip;
    unsigned int __indexShift;
}
@property (nonatomic, readonly) PGMutableVertexBuffer* vbo;
@property (nonatomic, readonly) PGMutableIndexBuffer* ibo;
@property (nonatomic, readonly) unsigned int count;
@property (nonatomic, readonly) CNPArray* vertexSample;
@property (nonatomic, readonly) CNPArray* indexSample;

+ (instancetype)meshWriterWithVbo:(PGMutableVertexBuffer*)vbo ibo:(PGMutableIndexBuffer*)ibo count:(unsigned int)count vertexSample:(CNPArray*)vertexSample indexSample:(CNPArray*)indexSample;
- (instancetype)initWithVbo:(PGMutableVertexBuffer*)vbo ibo:(PGMutableIndexBuffer*)ibo count:(unsigned int)count vertexSample:(CNPArray*)vertexSample indexSample:(CNPArray*)indexSample;
- (CNClassType*)type;
- (void)writeMat4:(PGMat4*)mat4;
- (void)writeVertex:(CNPArray*)vertex mat4:(PGMat4*)mat4;
- (void)writeVertex:(CNPArray*)vertex index:(CNPArray*)index mat4:(PGMat4*)mat4;
- (void)writeMap:(PGMeshData(^)(PGMeshData))map;
- (void)writeVertex:(CNPArray*)vertex map:(PGMeshData(^)(PGMeshData))map;
- (void)writeVertex:(CNPArray*)vertex index:(CNPArray*)index map:(PGMeshData(^)(PGMeshData))map;
- (void)flush;
- (void)dealloc;
- (NSString*)description;
+ (CNClassType*)type;
@end


