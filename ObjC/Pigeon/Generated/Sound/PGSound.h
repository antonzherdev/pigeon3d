#import "objd.h"
@class PGSimpleSoundPlat;
@class CNDispatchQueue;

@class PGSound;
@class PGSimpleSound;
@class PGParSound;



@interface PGSound : NSObject
+ (instancetype)sound;
- (instancetype)init;
- (CNClassType*)type;
+ (PGSimpleSound*)applyFile:(NSString*)file;
+ (PGSimpleSound*)applyFile:(NSString*)file volume:(float)volume;
+ (PGParSound*)parLimit:(NSInteger)limit file:(NSString*)file volume:(float)volume;
+ (PGParSound*)parLimit:(NSInteger)limit file:(NSString*)file;
- (void)play;
- (void)playLoops:(NSUInteger)loops;
- (void)playAlways;
- (void)stop;
- (BOOL)isPlaying;
- (void)pause;
- (void)resume;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGSimpleSound : PGSound {
@protected
    NSString* _file;
}
@property (nonatomic, readonly) NSString* file;

+ (instancetype)simpleSoundWithFile:(NSString*)file;
- (instancetype)initWithFile:(NSString*)file;
- (CNClassType*)type;
- (float)pan;
- (void)setPan:(float)pan;
- (float)volume;
- (void)setVolume:(float)volume;
- (CGFloat)time;
- (void)setTime:(CGFloat)time;
- (CGFloat)duration;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGParSound : PGSound {
@protected
    NSInteger _limit;
    PGSimpleSound*(^_create)();
    CNMArray* _sounds;
    CNMHashSet* _paused;
}
@property (nonatomic, readonly) NSInteger limit;
@property (nonatomic, readonly) PGSimpleSound*(^create)();

+ (instancetype)parSoundWithLimit:(NSInteger)limit create:(PGSimpleSound*(^)())create;
- (instancetype)initWithLimit:(NSInteger)limit create:(PGSimpleSound*(^)())create;
- (CNClassType*)type;
- (void)play;
- (void)playLoops:(NSUInteger)loops;
- (void)playAlways;
- (void)pause;
- (void)resume;
- (BOOL)isPlaying;
- (void)stop;
- (void)playWithVolume:(float)volume;
- (NSString*)description;
+ (CNClassType*)type;
@end


