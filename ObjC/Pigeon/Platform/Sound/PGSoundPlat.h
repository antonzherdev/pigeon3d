#import "objd.h"
#import <AVFoundation/AVFoundation.h>
#import "PGSound.h"
@class PGSimpleSoundPlat;

@interface PGSimpleSoundPlat : PGSimpleSound
@property (nonatomic) float pan;
@property (nonatomic) float volume;
@property (nonatomic) CGFloat time;

+ (id)sound;
- (id)init;

- (id)initWithPlayer:(AVAudioPlayer *)player;

+ (id)soundWithPlayer:(AVAudioPlayer *)player;

- (CNClassType*)type;
+ (PGSimpleSoundPlat *)simpleSoundPlatWithFile:(NSString*)file;
- (BOOL)isPlaying;
- (CGFloat)duration;
- (void)play;
- (void)playLoops:(NSUInteger)loops;
- (void)playAlways;
- (void)pause;
- (void)stop;
+ (CNClassType*)type;

- (void)setRate:(float)rate;
@end


