#import "PGVec.h"

#ifndef PERLIN_H_
#define PERLIN_H_



#define SAMPLE_SIZE 1024

@interface PGPerlin1 : NSObject
@property(nonatomic, readonly) NSUInteger octaves;
@property(nonatomic, readonly) CGFloat frequency;
@property(nonatomic, readonly) CGFloat amplitude;
@property(nonatomic, readonly) unsigned int seed;

- (id)initWithOctaves:(NSUInteger)octaves frequency:(CGFloat)frequency amplitude:(CGFloat)amplitude seed:(unsigned int)seed;
+ (id)perlin1WithOctaves:(NSUInteger)octaves frequency:(CGFloat)frequency amplitude:(CGFloat)amplitude seed:(unsigned int)seed;
+ (PGPerlin1*)applyOctaves:(NSUInteger)octaves frequency:(CGFloat)frequency amplitude:(CGFloat)amplitude;
- (CGFloat) applyX:(CGFloat)x;
@end

@interface PGPerlin2 : NSObject
@property(nonatomic, readonly) NSUInteger octaves;
@property(nonatomic, readonly) CGFloat frequency;
@property(nonatomic, readonly) CGFloat amplitude;
@property(nonatomic, readonly) unsigned int seed;

- (id)initWithOctaves:(NSUInteger)octaves frequency:(CGFloat)frequency amplitude:(CGFloat)amplitude seed:(unsigned int)seed;
+ (id)perlin2WithOctaves:(NSUInteger)octaves frequency:(CGFloat)frequency amplitude:(CGFloat)amplitude seed:(unsigned int)seed;
+ (PGPerlin2*)applyOctaves:(NSUInteger)octaves frequency:(CGFloat)frequency amplitude:(CGFloat)amplitude;
- (CGFloat) applyVec2:(PGVec2)vec2;
@end

@interface PGPerlin3 : NSObject
@property(nonatomic, readonly) NSUInteger octaves;
@property(nonatomic, readonly) CGFloat frequency;
@property(nonatomic, readonly) CGFloat amplitude;
@property(nonatomic, readonly) unsigned int seed;

- (id)initWithOctaves:(NSUInteger)octaves frequency:(CGFloat)frequency amplitude:(CGFloat)amplitude seed:(unsigned int)seed;
+ (id)perlin3WithOctaves:(NSUInteger)octaves frequency:(CGFloat)frequency amplitude:(CGFloat)amplitude seed:(unsigned int)seed;
+ (PGPerlin3*)applyOctaves:(NSUInteger)octaves frequency:(CGFloat)frequency amplitude:(CGFloat)amplitude;
- (CGFloat) applyVec3:(PGVec3)vec3;
@end


#endif

