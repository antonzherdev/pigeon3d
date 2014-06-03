#import "objd.h"
#import "PGVec.h"

@class PGProgress;

@interface PGProgress : NSObject
- (CNClassType*)type;
+ (float(^)(float))progressF4:(float)f4 f42:(float)f42;
+ (PGVec2(^)(float))progressVec2:(PGVec2)vec2 vec22:(PGVec2)vec22;
+ (PGVec3(^)(float))progressVec3:(PGVec3)vec3 vec32:(PGVec3)vec32;
+ (PGVec4(^)(float))progressVec4:(PGVec4)vec4 vec42:(PGVec4)vec42;
+ (id(^)(float))gapOptT1:(float)t1 t2:(float)t2;
+ (float(^)(float))gapT1:(float)t1 t2:(float)t2;
+ (float(^)(float))trapeziumT1:(float)t1 t2:(float)t2;
+ (float(^)(float))trapeziumT1:(float)t1;
+ (float(^)(float))divOn:(float)on;
+ (CNClassType*)type;
@end


