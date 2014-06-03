#import "PGFence.h"
#import "GL.h"

@implementation PGFence {
    GLsync _id;
    BOOL _init;
    NSString *_name;
}
static CNClassType* _EGFence_type;

- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        _name = name;
        _init = NO;
    }

    return self;
}

+ (instancetype)fenceWithName:(NSString *)name {
    return [[self alloc] initWithName:name];
}


+ (void)initialize {
    [super initialize];
    if(self == [PGFence class]) _EGFence_type = [CNClassType classTypeWithCls:[PGFence class]];
}

- (void)set {
    if(_init) {
#if TARGET_OS_IPHONE
        glDeleteSyncAPPLE(_id);
#else
        glDeleteSync(_id);
#endif
    } else {
        _init = YES;
    }
#if TARGET_OS_IPHONE
    _id = glFenceSyncAPPLE(GL_SYNC_GPU_COMMANDS_COMPLETE_APPLE, 0);
#else
    _id = glFenceSync(GL_SYNC_GPU_COMMANDS_COMPLETE, 0);
#endif
}

- (void)clientWait {
    if(_init) {
#if TARGET_OS_IPHONE
#if DEBUG
        GLenum i = glClientWaitSyncAPPLE(_id, 0, 1000000000);
        if(i != GL_ALREADY_SIGNALED_APPLE) {
            NSLog(@"Client Wait Fence %@ = 0x%x", _name, i);
        }
#else
        glClientWaitSyncAPPLE(_id, 0, 1000000000);
#endif
#else
#if DEBUG
        GLenum i = glClientWaitSync(_id, 0, 1000000000);
        if(i != GL_ALREADY_SIGNALED) {
            NSLog(@"Client Wait Fence %@ = 0x%x", _name, i);
        }
#else
        glClientWaitSync(_id, 0, 1000000000);
#endif
#endif
    }
}

- (void)wait {
    if(_init) {
#if TARGET_OS_IPHONE
        glWaitSyncAPPLE(_id, 0, 1000000000);
#else
        glWaitSync(_id, 0, 1000000000);
#endif
    }
}

- (void)dealloc {
    if(_init) {
        GLsync id = _id;
        dispatch_async(dispatch_get_main_queue(), ^{
#if TARGET_OS_IPHONE
            glDeleteSyncAPPLE(id);
#else
            glDeleteSync(id);
#endif
        });
    }
}


- (CNClassType*)type {
    return [PGFence type];
}

+ (CNClassType*)type {
    return _EGFence_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    return YES;
}

- (NSUInteger)hash {
    return 0;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

- (void)syncF:(void (^)())f {
    [self clientWait];
    f();
    [self set];
}
@end


