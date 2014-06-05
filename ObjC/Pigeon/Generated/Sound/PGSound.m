#import "PGSound.h"

#import "PGSoundPlat.h"
#import "CNDispatchQueue.h"
@implementation PGSound
static CNClassType* _PGSound_type;

+ (instancetype)sound {
    return [[PGSound alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGSound class]) _PGSound_type = [CNClassType classTypeWithCls:[PGSound class]];
}

+ (PGSimpleSound*)applyFile:(NSString*)file {
    return [PGSimpleSoundPlat simpleSoundPlatWithFile:file];
}

+ (PGSimpleSound*)applyFile:(NSString*)file volume:(float)volume {
    PGSimpleSoundPlat* s = [PGSimpleSoundPlat simpleSoundPlatWithFile:file];
    [s setVolume:volume];
    return s;
}

+ (PGParSound*)parLimit:(NSInteger)limit file:(NSString*)file volume:(float)volume {
    return [PGParSound parSoundWithLimit:limit create:^PGSimpleSound*() {
        return [PGSound applyFile:file volume:volume];
    }];
}

+ (PGParSound*)parLimit:(NSInteger)limit file:(NSString*)file {
    return [PGSound parLimit:limit file:file volume:1.0];
}

- (void)play {
    @throw @"Method play is abstract";
}

- (void)playLoops:(NSUInteger)loops {
    @throw @"Method play is abstract";
}

- (void)playAlways {
    @throw @"Method playAlways is abstract";
}

- (void)stop {
    @throw @"Method stop is abstract";
}

- (BOOL)isPlaying {
    @throw @"Method isPlaying is abstract";
}

- (void)pause {
    @throw @"Method pause is abstract";
}

- (void)resume {
    @throw @"Method resume is abstract";
}

- (NSString*)description {
    return @"Sound";
}

- (CNClassType*)type {
    return [PGSound type];
}

+ (CNClassType*)type {
    return _PGSound_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGSimpleSound
static CNClassType* _PGSimpleSound_type;
@synthesize file = _file;

+ (instancetype)simpleSoundWithFile:(NSString*)file {
    return [[PGSimpleSound alloc] initWithFile:file];
}

- (instancetype)initWithFile:(NSString*)file {
    self = [super init];
    if(self) _file = file;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGSimpleSound class]) _PGSimpleSound_type = [CNClassType classTypeWithCls:[PGSimpleSound class]];
}

- (float)pan {
    @throw @"Method pan is abstract";
}

- (void)setPan:(float)pan {
    @throw @"Method set is abstract";
}

- (float)volume {
    @throw @"Method volume is abstract";
}

- (void)setVolume:(float)volume {
    @throw @"Method set is abstract";
}

- (CGFloat)time {
    @throw @"Method time is abstract";
}

- (void)setTime:(CGFloat)time {
    @throw @"Method set is abstract";
}

- (CGFloat)duration {
    @throw @"Method duration is abstract";
}

- (NSString*)description {
    return [NSString stringWithFormat:@"SimpleSound(%@)", _file];
}

- (CNClassType*)type {
    return [PGSimpleSound type];
}

+ (CNClassType*)type {
    return _PGSimpleSound_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGParSound
static CNClassType* _PGParSound_type;
@synthesize limit = _limit;
@synthesize create = _create;

+ (instancetype)parSoundWithLimit:(NSInteger)limit create:(PGSimpleSound*(^)())create {
    return [[PGParSound alloc] initWithLimit:limit create:create];
}

- (instancetype)initWithLimit:(NSInteger)limit create:(PGSimpleSound*(^)())create {
    self = [super init];
    if(self) {
        _limit = limit;
        _create = [create copy];
        _sounds = [CNMArray array];
        _paused = [CNMHashSet hashSet];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGParSound class]) _PGParSound_type = [CNClassType classTypeWithCls:[PGParSound class]];
}

- (void)play {
    [[CNDispatchQueue aDefault] asyncF:^void() {
        @synchronized(self) {
            [((PGSimpleSound*)([self sound])) play];
        }
    }];
}

- (void)playLoops:(NSUInteger)loops {
    [[CNDispatchQueue aDefault] asyncF:^void() {
        @synchronized(self) {
            [((PGSimpleSound*)([self sound])) playLoops:loops];
        }
    }];
}

- (void)playAlways {
    [[CNDispatchQueue aDefault] asyncF:^void() {
        @synchronized(self) {
            [((PGSimpleSound*)([self sound])) playAlways];
        }
    }];
}

- (void)pause {
    [[CNDispatchQueue aDefault] asyncF:^void() {
        @synchronized(self) {
            for(PGSimpleSound* sound in _sounds) {
                if([((PGSimpleSound*)(sound)) isPlaying]) {
                    [((PGSimpleSound*)(sound)) pause];
                    [_paused appendItem:sound];
                }
            }
        }
    }];
}

- (void)resume {
    [[CNDispatchQueue aDefault] asyncF:^void() {
        @synchronized(self) {
            {
                id<CNIterator> __il__0rp0_0i = [_paused iterator];
                while([__il__0rp0_0i hasNext]) {
                    PGSound* _ = [__il__0rp0_0i next];
                    [((PGSound*)(_)) resume];
                }
            }
            [_paused clear];
        }
    }];
}

- (BOOL)isPlaying {
    @synchronized(self) {
        return [_sounds existsWhere:^BOOL(PGSimpleSound* _) {
            return [((PGSimpleSound*)(_)) isPlaying];
        }];
    }
}

- (void)stop {
    @synchronized(self) {
        for(PGSimpleSound* _ in _sounds) {
            [((PGSimpleSound*)(_)) stop];
        }
    }
}

- (void)playWithVolume:(float)volume {
    [[CNDispatchQueue aDefault] asyncF:^void() {
        @synchronized(self) {
            PGSimpleSound* s = [self sound];
            if(s != nil) {
                [((PGSimpleSound*)(s)) setVolume:volume];
                [((PGSimpleSound*)(s)) play];
            }
        }
    }];
}

- (PGSimpleSound*)sound {
    PGSimpleSound* s = [_sounds findWhere:^BOOL(PGSimpleSound* _) {
        return !([((PGSimpleSound*)(_)) isPlaying]);
    }];
    if(s != nil) {
        return ((PGSimpleSound*)(s));
    } else {
        if([_sounds count] >= _limit) {
            return nil;
        } else {
            PGSimpleSound* newSound = _create();
            [_sounds appendItem:newSound];
            return newSound;
        }
    }
}

- (NSString*)description {
    return [NSString stringWithFormat:@"ParSound(%ld)", (long)_limit];
}

- (CNClassType*)type {
    return [PGParSound type];
}

+ (CNClassType*)type {
    return _PGParSound_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

