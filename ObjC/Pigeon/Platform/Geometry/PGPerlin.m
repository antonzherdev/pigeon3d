/* coherent noise function over 1, 2 or 3 dimensions */
/* (copyright Ken Perlin) */

#include <stdlib.h>
#include <stdio.h>
#include <math.h>


#include "PGPerlin.h"

#define B SAMPLE_SIZE
#define BM (SAMPLE_SIZE-1)

#define N 0x1000
//#define NP 12   /* 2^N */
//#define NM 0xfff

#define s_curve(t) ( t * t * (3.0f - 2.0f * t) )
#define lerp(t, a, b) ( a + t * (b - a) )

#define setup(i,b0,b1,r0,r1)\
	t = vec[i] + N;\
	b0 = ((int)t) & BM;\
	b1 = (b0+1) & BM;\
	r0 = t - (int)t;\
	r1 = r0 - 1.0f;


@implementation PGPerlin1 {
    NSUInteger _octaves;
    CGFloat _frequency;
    CGFloat _amplitude;
    unsigned _seed;
    NSInteger p[SAMPLE_SIZE + SAMPLE_SIZE + 2];
    CGFloat g1[SAMPLE_SIZE + SAMPLE_SIZE + 2];
}
@synthesize octaves = _octaves;
@synthesize frequency = _frequency;
@synthesize amplitude = _amplitude;
@synthesize seed = _seed;

- (id)initWithOctaves:(NSUInteger)octaves frequency:(CGFloat)frequency amplitude:(CGFloat)amplitude seed:(unsigned int)seed {
    self = [super init];
    if (self) {
        _octaves = octaves;
        _frequency = frequency;
        _amplitude = amplitude;
        _seed = seed;


        srand(seed);
        NSInteger i, j, k;
        for (i = 0 ; i < B ; i++) {
            p[i] = i;
            g1[i] = (float)((rand() % (B + B)) - B) / B;
        }
        while (--i) {
            k = p[i];
            p[i] = p[j = rand() % B];
            p[j] = k;
        }

        for (i = 0 ; i < B + 2 ; i++) {
            p[B + i] = p[i];
            g1[B + i] = g1[i];
        }
    }

    return self;
}

+ (id)perlin1WithOctaves:(NSUInteger)octaves frequency:(CGFloat)frequency amplitude:(CGFloat)amplitude seed:(unsigned int)seed {
    return [[self alloc] initWithOctaves:octaves frequency:frequency amplitude:amplitude seed:seed];
}

+ (PGPerlin1*)applyOctaves:(NSUInteger)octaves frequency:(CGFloat)frequency amplitude:(CGFloat)amplitude {
    return [PGPerlin1 perlin1WithOctaves:octaves frequency:frequency amplitude:amplitude seed:(unsigned int) time(NULL)];
}

- (CGFloat)applyX:(CGFloat)x {
    CGFloat result = 0.0f;
    CGFloat amp = _amplitude;
    x *= _frequency;

    for(int i=0; i < _octaves; i++) {
        result += [self noise:x]*amp;
        x *= 2.0f;
        amp*=0.5f;
    }

    return result;
}


-(CGFloat)noise:(CGFloat)arg {
    NSInteger bx0, bx1;
    CGFloat rx0, rx1, sx, t, u, v, vec[1];

    vec[0] = arg;

    setup(0, bx0,bx1, rx0,rx1);
    sx = s_curve(rx0);

    u = rx0 * g1[ p[ bx0 ] ];
    v = rx1 * g1[ p[ bx1 ] ];

    return lerp(sx, u, v);
}
@end


@implementation PGPerlin2 {
    NSUInteger _octaves;
    CGFloat _frequency;
    CGFloat _amplitude;
    unsigned _seed;
    NSInteger p[SAMPLE_SIZE + SAMPLE_SIZE + 2];
    CGFloat g2[SAMPLE_SIZE + SAMPLE_SIZE + 2][2];
}
@synthesize octaves = _octaves;
@synthesize frequency = _frequency;
@synthesize amplitude = _amplitude;
@synthesize seed = _seed;

+ (PGPerlin2*)applyOctaves:(NSUInteger)octaves frequency:(CGFloat)frequency amplitude:(CGFloat)amplitude {
    return [PGPerlin2 perlin2WithOctaves:octaves frequency:frequency amplitude:amplitude seed:(unsigned int) time(NULL)];
}


- (id)initWithOctaves:(NSUInteger)octaves frequency:(CGFloat)frequency amplitude:(CGFloat)amplitude seed:(unsigned int)seed {
    self = [super init];
    if (self) {
        NSInteger i, j, k;

        for (i = 0 ; i < B ; i++) {
            p[i] = i;
            for (j = 0 ; j < 2 ; j++)
                g2[i][j] = (float)((rand() % (B + B)) - B) / B;
            [self normalize2:g2[i]];
        }

        while (--i) {
            k = p[i];
            p[i] = p[j = rand() % B];
            p[j] = k;
        }

        for (i = 0 ; i < B + 2 ; i++) {
            p[B + i] = p[i];
            for (j = 0 ; j < 2 ; j++)
                g2[B + i][j] = g2[i][j];
        }
    }

    return self;
}

- (void)normalize2:(CGFloat[2]) v
{
    float s;

    s = (float)sqrt(v[0] * v[0] + v[1] * v[1]);
    s = 1.0f/s;
    v[0] = v[0] * s;
    v[1] = v[1] * s;
}


+ (id)perlin2WithOctaves:(NSUInteger)octaves frequency:(CGFloat)frequency amplitude:(CGFloat)amplitude seed:(unsigned int)seed {
    return [[self alloc] initWithOctaves:octaves frequency:frequency amplitude:amplitude seed:seed];
}

- (CGFloat)applyVec2:(PGVec2)vec2 {
    CGFloat result = 0.0f;
    CGFloat amp = _amplitude;

    vec2.x*=_frequency;
    vec2.y*=_frequency;

    for( int i=0; i<_octaves; i++ )
    {
        result += [self noise2:vec2]*amp;
        vec2.x *= 2.0f;
        vec2.y *= 2.0f;
        amp*=0.5f;
    }


    return result;
}


-(CGFloat)noise2:(PGVec2)arg {
    NSInteger bx0, bx1, by0, by1, b00, b10, b01, b11;
    CGFloat rx0, rx1, ry0, ry1, *q, sx, sy, a, b, t, u, v, vec[2];
    NSInteger i, j;
    vec[0] = arg.x;
    vec[1] = arg.y;

    setup(0,bx0,bx1,rx0,rx1);
    setup(1,by0,by1,ry0,ry1);

    i = p[bx0];
    j = p[bx1];

    b00 = p[i + by0];
    b10 = p[j + by0];
    b01 = p[i + by1];
    b11 = p[j + by1];

    sx = s_curve(rx0);
    sy = s_curve(ry0);

#define at2(rx,ry) ( rx * q[0] + ry * q[1] )

    q = g2[b00];
    u = at2(rx0,ry0);
    q = g2[b10];
    v = at2(rx1,ry0);
    a = lerp(sx, u, v);

    q = g2[b01];
    u = at2(rx0,ry1);
    q = g2[b11];
    v = at2(rx1,ry1);
    b = lerp(sx, u, v);

    return lerp(sy, a, b);
}
@end

@implementation PGPerlin3 {
    NSUInteger _octaves;
    CGFloat _frequency;
    CGFloat _amplitude;
    unsigned _seed;
    NSInteger p[SAMPLE_SIZE + SAMPLE_SIZE + 2];
    CGFloat g3[SAMPLE_SIZE + SAMPLE_SIZE + 2][3];
}
@synthesize octaves = _octaves;
@synthesize frequency = _frequency;
@synthesize amplitude = _amplitude;
@synthesize seed = _seed;


+ (PGPerlin3*)applyOctaves:(NSUInteger)octaves frequency:(CGFloat)frequency amplitude:(CGFloat)amplitude {
    return [PGPerlin3 perlin3WithOctaves:octaves frequency:frequency amplitude:amplitude seed:(unsigned int) time(NULL)];
}


- (id)initWithOctaves:(NSUInteger)octaves frequency:(CGFloat)frequency amplitude:(CGFloat)amplitude seed:(unsigned int)seed {
    self = [super init];
    if (self) {
        NSInteger i, j, k;

        for (i = 0 ; i < B ; i++)
        {
            p[i] = i;
            for(j = 0 ; j < 3 ; j++)
                g3[i][j] = (float)((rand() % (B + B)) - B) / B;
            [self normalize3:g3[i]];
        }

        while (--i) {
            k = p[i];
            p[i] = p[j = rand() % B];
            p[j] = k;
        }

        for (i = 0 ; i < B + 2 ; i++) {
            p[B + i] = p[i];
            for (j = 0 ; j < 3 ; j++)
                g3[B + i][j] = g3[i][j];
        }
    }

    return self;
}

- (void)normalize3:(CGFloat[3]) v
{
    float s;

    s = (float)sqrt(v[0] * v[0] + v[1] * v[1] + v[2] * v[2]);
    s = 1.0f/s;

    v[0] = v[0] * s;
    v[1] = v[1] * s;
    v[2] = v[2] * s;
}


+ (id)perlin3WithOctaves:(NSUInteger)octaves frequency:(CGFloat)frequency amplitude:(CGFloat)amplitude seed:(unsigned int)seed {
    return [[self alloc] initWithOctaves:octaves frequency:frequency amplitude:amplitude seed:seed];
}

- (CGFloat)applyVec3:(PGVec3)vec3 {
    CGFloat result = 0.0f;
    CGFloat amp = _amplitude;

    vec3.x*=_frequency;
    vec3.y*=_frequency;
    vec3.z*=_frequency;

    for( int i=0; i<_octaves; i++ )
    {
        result += [self noise3:vec3]*amp;
        vec3.x *= 2.0f;
        vec3.y *= 2.0f;
        vec3.z *= 2.0f;
        amp*=0.5f;
    }


    return result;
}


-(CGFloat)noise3:(PGVec3)arg {
    NSInteger bx0, bx1, by0, by1, bz0, bz1, b00, b10, b01, b11;
    CGFloat rx0, rx1, ry0, ry1, rz0, rz1, *q, sy, sz, a, b, c, d, t, u, v, vec[3];
    NSInteger i, j;

    vec[0] = arg.x;
    vec[1] = arg.y;
    vec[2] = arg.z;


    setup(0, bx0,bx1, rx0,rx1);
    setup(1, by0,by1, ry0,ry1);
    setup(2, bz0,bz1, rz0,rz1);

    i = p[ bx0 ];
    j = p[ bx1 ];

    b00 = p[ i + by0 ];
    b10 = p[ j + by0 ];
    b01 = p[ i + by1 ];
    b11 = p[ j + by1 ];

    t  = s_curve(rx0);
    sy = s_curve(ry0);
    sz = s_curve(rz0);

#define at3(rx,ry,rz) ( rx * q[0] + ry * q[1] + rz * q[2] )

    q = g3[ b00 + bz0 ] ; u = at3(rx0,ry0,rz0);
    q = g3[ b10 + bz0 ] ; v = at3(rx1,ry0,rz0);
    a = lerp(t, u, v);

    q = g3[ b01 + bz0 ] ; u = at3(rx0,ry1,rz0);
    q = g3[ b11 + bz0 ] ; v = at3(rx1,ry1,rz0);
    b = lerp(t, u, v);

    c = lerp(sy, a, b);

    q = g3[ b00 + bz1 ] ; u = at3(rx0,ry0,rz1);
    q = g3[ b10 + bz1 ] ; v = at3(rx1,ry0,rz1);
    a = lerp(t, u, v);

    q = g3[ b01 + bz1 ] ; u = at3(rx0,ry1,rz1);
    q = g3[ b11 + bz1 ] ; v = at3(rx1,ry1,rz1);
    b = lerp(t, u, v);

    d = lerp(sy, a, b);

    return lerp(sz, c, d);
}
@end