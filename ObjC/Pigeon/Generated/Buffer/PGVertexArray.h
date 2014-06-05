#import "objd.h"
@class PGMutableVertexBuffer;
@protocol PGVertexBuffer;
@protocol PGIndexSource;
@class PGGlobal;
@class PGContext;
@class PGRenderTarget;
@class PGShader;
@class CNChain;
@class PGFence;

@class PGVertexArray;
@class PGRouteVertexArray;
@class PGSimpleVertexArray;
@class PGMaterialVertexArray;
@class PGVertexArrayRing;

@interface PGVertexArray : NSObject {
@public
    CNLazy* __lazy_mutableVertexBuffer;
}
+ (instancetype)vertexArray;
- (instancetype)init;
- (CNClassType*)type;
- (PGMutableVertexBuffer*)mutableVertexBuffer;
- (void)drawParam:(id)param start:(NSUInteger)start end:(NSUInteger)end;
- (void)drawParam:(id)param;
- (void)draw;
- (void)syncWait;
- (void)syncSet;
- (void)syncF:(void(^)())f;
- (NSArray*)vertexBuffers;
- (id<PGIndexSource>)index;
- (void)vertexWriteCount:(unsigned int)count f:(void(^)(void*))f;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGRouteVertexArray : PGVertexArray {
@public
    PGVertexArray* _standard;
    PGVertexArray* _shadow;
}
@property (nonatomic, readonly) PGVertexArray* standard;
@property (nonatomic, readonly) PGVertexArray* shadow;

+ (instancetype)routeVertexArrayWithStandard:(PGVertexArray*)standard shadow:(PGVertexArray*)shadow;
- (instancetype)initWithStandard:(PGVertexArray*)standard shadow:(PGVertexArray*)shadow;
- (CNClassType*)type;
- (PGVertexArray*)mesh;
- (void)drawParam:(id)param;
- (void)drawParam:(id)param start:(NSUInteger)start end:(NSUInteger)end;
- (void)draw;
- (void)syncF:(void(^)())f;
- (void)syncWait;
- (void)syncSet;
- (NSArray*)vertexBuffers;
- (id<PGIndexSource>)index;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGSimpleVertexArray : PGVertexArray {
@public
    unsigned int _handle;
    PGShader* _shader;
    NSArray* _vertexBuffers;
    id<PGIndexSource> _index;
    BOOL _isMutable;
    PGFence* _fence;
}
@property (nonatomic, readonly) unsigned int handle;
@property (nonatomic, readonly) PGShader* shader;
@property (nonatomic, readonly) NSArray* vertexBuffers;
@property (nonatomic, readonly) id<PGIndexSource> index;
@property (nonatomic, readonly) BOOL isMutable;

+ (instancetype)simpleVertexArrayWithHandle:(unsigned int)handle shader:(PGShader*)shader vertexBuffers:(NSArray*)vertexBuffers index:(id<PGIndexSource>)index;
- (instancetype)initWithHandle:(unsigned int)handle shader:(PGShader*)shader vertexBuffers:(NSArray*)vertexBuffers index:(id<PGIndexSource>)index;
- (CNClassType*)type;
+ (PGSimpleVertexArray*)applyShader:(PGShader*)shader buffers:(NSArray*)buffers index:(id<PGIndexSource>)index;
- (void)bind;
- (void)unbind;
- (void)dealloc;
- (NSUInteger)count;
- (void)drawParam:(id)param;
- (void)drawParam:(id)param start:(NSUInteger)start end:(NSUInteger)end;
- (void)draw;
- (void)syncF:(void(^)())f;
- (void)syncWait;
- (void)syncSet;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGMaterialVertexArray : PGVertexArray {
@public
    PGVertexArray* _vao;
    id _material;
}
@property (nonatomic, readonly) PGVertexArray* vao;
@property (nonatomic, readonly) id material;

+ (instancetype)materialVertexArrayWithVao:(PGVertexArray*)vao material:(id)material;
- (instancetype)initWithVao:(PGVertexArray*)vao material:(id)material;
- (CNClassType*)type;
- (void)draw;
- (void)drawParam:(id)param;
- (void)drawParam:(id)param start:(NSUInteger)start end:(NSUInteger)end;
- (void)syncF:(void(^)())f;
- (void)syncWait;
- (void)syncSet;
- (NSArray*)vertexBuffers;
- (id<PGIndexSource>)index;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGVertexArrayRing : NSObject {
@public
    unsigned int _ringSize;
    PGVertexArray*(^_creator)(unsigned int);
    CNMQueue* __ring;
}
@property (nonatomic, readonly) unsigned int ringSize;
@property (nonatomic, readonly) PGVertexArray*(^creator)(unsigned int);

+ (instancetype)vertexArrayRingWithRingSize:(unsigned int)ringSize creator:(PGVertexArray*(^)(unsigned int))creator;
- (instancetype)initWithRingSize:(unsigned int)ringSize creator:(PGVertexArray*(^)(unsigned int))creator;
- (CNClassType*)type;
- (PGVertexArray*)next;
- (void)syncF:(void(^)(PGVertexArray*))f;
- (NSString*)description;
+ (CNClassType*)type;
@end


