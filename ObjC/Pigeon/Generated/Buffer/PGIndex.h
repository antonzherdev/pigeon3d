#import "objd.h"
#import "PGBuffer.h"
@class PGGlobal;
@class PGContext;

@class PGIndexSource_impl;
@class PGIBO;
@class PGIndexBuffer_impl;
@class PGImmutableIndexBuffer;
@class PGMutableIndexBuffer;
@class PGIndexBufferRing;
@class PGEmptyIndexSource;
@class PGArrayIndexSource;
@class PGIndexSourceGap;
@class PGMutableIndexSourceGap;
@protocol PGIndexSource;
@protocol PGIndexBuffer;

@protocol PGIndexSource<NSObject>
- (void)bind;
- (void)draw;
- (void)drawWithStart:(NSUInteger)start count:(NSUInteger)count;
- (BOOL)isMutable;
- (BOOL)isEmpty;
- (NSString*)description;
@end


@interface PGIndexSource_impl : NSObject<PGIndexSource>
+ (instancetype)indexSource_impl;
- (instancetype)init;
@end


@interface PGIBO : NSObject
- (CNClassType*)type;
+ (PGImmutableIndexBuffer*)applyPointer:(unsigned int*)pointer count:(unsigned int)count;
+ (PGImmutableIndexBuffer*)applyData:(CNPArray*)data;
+ (PGMutableIndexBuffer*)mutMode:(unsigned int)mode usage:(unsigned int)usage;
+ (PGMutableIndexBuffer*)mutUsage:(unsigned int)usage;
+ (CNClassType*)type;
@end


@protocol PGIndexBuffer<PGIndexSource>
- (unsigned int)handle;
- (unsigned int)mode;
- (NSUInteger)count;
- (void)draw;
- (void)drawWithStart:(NSUInteger)start count:(NSUInteger)count;
- (NSString*)description;
@end


@interface PGIndexBuffer_impl : PGIndexSource_impl<PGIndexBuffer>
+ (instancetype)indexBuffer_impl;
- (instancetype)init;
- (void)draw;
- (void)drawWithStart:(NSUInteger)start count:(NSUInteger)count;
@end


@interface PGImmutableIndexBuffer : PGGlBuffer<PGIndexBuffer> {
@protected
    unsigned int _mode;
    NSUInteger _length;
    NSUInteger _count;
}
@property (nonatomic, readonly) unsigned int mode;
@property (nonatomic, readonly) NSUInteger length;
@property (nonatomic, readonly) NSUInteger count;

+ (instancetype)immutableIndexBufferWithHandle:(unsigned int)handle mode:(unsigned int)mode length:(NSUInteger)length count:(NSUInteger)count;
- (instancetype)initWithHandle:(unsigned int)handle mode:(unsigned int)mode length:(NSUInteger)length count:(NSUInteger)count;
- (CNClassType*)type;
- (void)bind;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGMutableIndexBuffer : PGMutableGlBuffer<PGIndexBuffer> {
@protected
    unsigned int _mode;
}
@property (nonatomic, readonly) unsigned int mode;

+ (instancetype)mutableIndexBufferWithHandle:(unsigned int)handle mode:(unsigned int)mode usage:(unsigned int)usage;
- (instancetype)initWithHandle:(unsigned int)handle mode:(unsigned int)mode usage:(unsigned int)usage;
- (CNClassType*)type;
- (BOOL)isMutable;
- (void)bind;
- (BOOL)isEmpty;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGIndexBufferRing : PGBufferRing {
@protected
    unsigned int _mode;
    unsigned int _usage;
}
@property (nonatomic, readonly) unsigned int mode;
@property (nonatomic, readonly) unsigned int usage;

+ (instancetype)indexBufferRingWithRingSize:(unsigned int)ringSize mode:(unsigned int)mode usage:(unsigned int)usage;
- (instancetype)initWithRingSize:(unsigned int)ringSize mode:(unsigned int)mode usage:(unsigned int)usage;
- (CNClassType*)type;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGEmptyIndexSource : PGIndexSource_impl {
@protected
    unsigned int _mode;
}
@property (nonatomic, readonly) unsigned int mode;

+ (instancetype)emptyIndexSourceWithMode:(unsigned int)mode;
- (instancetype)initWithMode:(unsigned int)mode;
- (CNClassType*)type;
- (void)draw;
- (void)drawWithStart:(NSUInteger)start count:(NSUInteger)count;
- (NSString*)description;
+ (PGEmptyIndexSource*)triangleStrip;
+ (PGEmptyIndexSource*)triangleFan;
+ (PGEmptyIndexSource*)triangles;
+ (PGEmptyIndexSource*)lines;
+ (CNClassType*)type;
@end


@interface PGArrayIndexSource : PGIndexSource_impl {
@protected
    CNPArray* _array;
    unsigned int _mode;
}
@property (nonatomic, readonly) CNPArray* array;
@property (nonatomic, readonly) unsigned int mode;

+ (instancetype)arrayIndexSourceWithArray:(CNPArray*)array mode:(unsigned int)mode;
- (instancetype)initWithArray:(CNPArray*)array mode:(unsigned int)mode;
- (CNClassType*)type;
- (void)draw;
- (void)drawWithStart:(NSUInteger)start count:(NSUInteger)count;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGIndexSourceGap : PGIndexSource_impl {
@protected
    id<PGIndexSource> _source;
    unsigned int _start;
    unsigned int _count;
}
@property (nonatomic, readonly) id<PGIndexSource> source;
@property (nonatomic, readonly) unsigned int start;
@property (nonatomic, readonly) unsigned int count;

+ (instancetype)indexSourceGapWithSource:(id<PGIndexSource>)source start:(unsigned int)start count:(unsigned int)count;
- (instancetype)initWithSource:(id<PGIndexSource>)source start:(unsigned int)start count:(unsigned int)count;
- (CNClassType*)type;
- (void)bind;
- (void)draw;
- (void)drawWithStart:(NSUInteger)start count:(NSUInteger)count;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGMutableIndexSourceGap : PGIndexSource_impl {
@protected
    id<PGIndexSource> _source;
    unsigned int _start;
    unsigned int _count;
}
@property (nonatomic, readonly) id<PGIndexSource> source;
@property (nonatomic) unsigned int start;
@property (nonatomic) unsigned int count;

+ (instancetype)mutableIndexSourceGapWithSource:(id<PGIndexSource>)source;
- (instancetype)initWithSource:(id<PGIndexSource>)source;
- (CNClassType*)type;
- (void)bind;
- (void)draw;
- (void)drawWithStart:(NSUInteger)start count:(NSUInteger)count;
- (NSString*)description;
+ (CNClassType*)type;
@end


