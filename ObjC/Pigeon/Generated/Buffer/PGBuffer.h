#import "objd.h"
@class PGGlobal;
@class PGContext;
@class NSConditionLock;

@class PGBuffer;
@class PGMutableBuffer;
@class PGMappedBufferData;
@class PGBufferRing;

@interface PGBuffer : NSObject {
@protected
    CNPType* _dataType;
    unsigned int _bufferType;
    unsigned int _handle;
}
@property (nonatomic, readonly) CNPType* dataType;
@property (nonatomic, readonly) unsigned int bufferType;
@property (nonatomic, readonly) unsigned int handle;

+ (instancetype)bufferWithDataType:(CNPType*)dataType bufferType:(unsigned int)bufferType handle:(unsigned int)handle;
- (instancetype)initWithDataType:(CNPType*)dataType bufferType:(unsigned int)bufferType handle:(unsigned int)handle;
- (CNClassType*)type;
- (NSUInteger)length;
- (NSUInteger)count;
- (void)dealloc;
- (void)bind;
- (unsigned int)stride;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGMutableBuffer : PGBuffer {
@protected
    unsigned int _usage;
    NSUInteger __length;
    NSUInteger __count;
    PGMappedBufferData* _mappedData;
}
@property (nonatomic, readonly) unsigned int usage;

+ (instancetype)mutableBufferWithDataType:(CNPType*)dataType bufferType:(unsigned int)bufferType handle:(unsigned int)handle usage:(unsigned int)usage;
- (instancetype)initWithDataType:(CNPType*)dataType bufferType:(unsigned int)bufferType handle:(unsigned int)handle usage:(unsigned int)usage;
- (CNClassType*)type;
- (NSUInteger)length;
- (NSUInteger)count;
- (BOOL)isEmpty;
- (id)setData:(CNPArray*)data;
- (id)setArray:(void*)array count:(unsigned int)count;
- (void)writeCount:(unsigned int)count f:(void(^)(void*))f;
- (void)mapCount:(unsigned int)count access:(unsigned int)access f:(void(^)(void*))f;
- (PGMappedBufferData*)beginWriteCount:(unsigned int)count;
- (PGMappedBufferData*)mapCount:(unsigned int)count access:(unsigned int)access;
- (void)_finishMapping;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGMappedBufferData : NSObject {
@protected
    PGMutableBuffer* _buffer;
    void* _pointer;
    NSConditionLock* _lock;
    BOOL _finished;
    BOOL _updated;
}
@property (nonatomic, readonly) PGMutableBuffer* buffer;
@property (nonatomic, readonly) void* pointer;

+ (instancetype)mappedBufferDataWithBuffer:(PGMutableBuffer*)buffer pointer:(void*)pointer;
- (instancetype)initWithBuffer:(PGMutableBuffer*)buffer pointer:(void*)pointer;
- (CNClassType*)type;
- (BOOL)wasUpdated;
- (BOOL)beginWrite;
- (void)endWrite;
- (void)finish;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGBufferRing : NSObject {
@protected
    unsigned int _ringSize;
    id(^_creator)();
    CNMQueue* __ring;
}
@property (nonatomic, readonly) unsigned int ringSize;
@property (nonatomic, readonly) id(^creator)();

+ (instancetype)bufferRingWithRingSize:(unsigned int)ringSize creator:(id(^)())creator;
- (instancetype)initWithRingSize:(unsigned int)ringSize creator:(id(^)())creator;
- (CNClassType*)type;
- (id)next;
- (void)writeCount:(unsigned int)count f:(void(^)(void*))f;
- (void)mapCount:(unsigned int)count access:(unsigned int)access f:(void(^)(void*))f;
- (NSString*)description;
+ (CNClassType*)type;
@end


