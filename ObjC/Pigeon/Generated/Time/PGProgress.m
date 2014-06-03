#import "PGProgress.h"

@implementation PGProgress
static CNClassType* _PGProgress_type;

+ (void)initialize {
    [super initialize];
    if(self == [PGProgress class]) _PGProgress_type = [CNClassType classTypeWithCls:[PGProgress class]];
}

+ (float(^)(float))progressF4:(float)f4 f42:(float)f42 {
    float k = f42 - f4;
    if(eqf4(k, 0)) return ^float(float t) {
        return f4;
    };
    else return ^float(float t) {
        return k * t + f4;
    };
}

+ (PGVec2(^)(float))progressVec2:(PGVec2)vec2 vec22:(PGVec2)vec22 {
    float(^x)(float) = [PGProgress progressF4:vec2.x f42:vec22.x];
    float(^y)(float) = [PGProgress progressF4:vec2.y f42:vec22.y];
    return ^PGVec2(float t) {
        return PGVec2Make(x(t), y(t));
    };
}

+ (PGVec3(^)(float))progressVec3:(PGVec3)vec3 vec32:(PGVec3)vec32 {
    float(^x)(float) = [PGProgress progressF4:vec3.x f42:vec32.x];
    float(^y)(float) = [PGProgress progressF4:vec3.y f42:vec32.y];
    float(^z)(float) = [PGProgress progressF4:vec3.z f42:vec32.z];
    return ^PGVec3(float t) {
        return PGVec3Make(x(t), y(t), z(t));
    };
}

+ (PGVec4(^)(float))progressVec4:(PGVec4)vec4 vec42:(PGVec4)vec42 {
    float(^x)(float) = [PGProgress progressF4:vec4.x f42:vec42.x];
    float(^y)(float) = [PGProgress progressF4:vec4.y f42:vec42.y];
    float(^z)(float) = [PGProgress progressF4:vec4.z f42:vec42.z];
    float(^w)(float) = [PGProgress progressF4:vec4.w f42:vec42.w];
    return ^PGVec4(float t) {
        return PGVec4Make(x(t), y(t), z(t), w(t));
    };
}

+ (id(^)(float))gapOptT1:(float)t1 t2:(float)t2 {
    float l = t2 - t1;
    return ^id(float t) {
        if(float4Between(t, t1, t2)) return numf4((t - t1) / l);
        else return nil;
    };
}

+ (float(^)(float))gapT1:(float)t1 t2:(float)t2 {
    float l = t2 - t1;
    return ^float(float t) {
        if(t <= t1) {
            return 0.0;
        } else {
            if(t >= t2) return 1.0;
            else return (t - t1) / l;
        }
    };
}

+ (float(^)(float))trapeziumT1:(float)t1 t2:(float)t2 {
    return ^float(float t) {
        if(t <= t1) {
            return t / t1;
        } else {
            if(t >= t2) return 1 - (t - t2) / (1 - t2);
            else return 1.0;
        }
    };
}

+ (float(^)(float))trapeziumT1:(float)t1 {
    return [PGProgress trapeziumT1:t1 t2:((float)(1.0 - t1))];
}

+ (float(^)(float))divOn:(float)on {
    return ^float(float t) {
        return t / on;
    };
}

- (CNClassType*)type {
    return [PGProgress type];
}

+ (CNClassType*)type {
    return _PGProgress_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

