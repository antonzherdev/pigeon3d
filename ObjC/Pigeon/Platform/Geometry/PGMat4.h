#import "objd.h"
#import "PGVec.h"


struct PGMat4Impl;
typedef struct PGMat4Impl PGMat4Impl;
@interface PGMat4 : NSObject {
@private
    struct PGMat4Impl *_impl;
}

- (id)initWithImpl:(PGMat4Impl *)m;

+ (id)mat4WithImpl:(PGMat4Impl *)m;
+ (id)mat4WithArray:(float[16])m;

- (PGMat4 *)mulMatrix:(PGMat4 *)matrix;
- (PGVec4)mulVec4:(PGVec4)vec4;
- (PGVec4)mulVec3:(PGVec3)vec3 w:(float)w;

+ (PGMat4 *)identity;

- (float const *)array;

+ (PGMat4 *)orthoLeft:(float)left right:(float)right bottom:(float)bottom top:(float)top zNear:(float)near zFar:(float)far;

- (PGMat4 *)rotateAngle:(float)angle x:(float)x y:(float)y z:(float)z;

+ (PGMat4 *)lookAtEye:(PGVec3)vec3 center:(PGVec3)center up:(PGVec3)up;

- (PGMat4 *)scaleX:(float)x y:(float)y z:(float)z;

+ (PGMat4 *)null;

- (PGMat4 *)translateX:(float)x y:(float)y z:(float)z;
- (PGMat4 *)translateVec3:(PGVec3)vec3;

- (PGVec4)divBySelfVec4:(PGVec4)vec4;

- (PGMat4 *)inverse;

- (PGRect)mulRect:(PGRect)rect;

- (PGRect)mulRect:(PGRect)rect z:(float)z;

- (PGVec3)mulVec3:(PGVec3)vec3;
@end

struct PGMat3Impl;
typedef struct PGMat3Impl PGMat3Impl;
@interface PGMat3 : NSObject {
@private
    struct PGMat3Impl *_impl;
}
- (id)initWithImplMat3:(PGMat3Impl *)m;

+ (id)mat3WithImpl:(PGMat3Impl *)m;
+ (id)mat3WithArray:(float[9])m;

- (PGVec3)mulVec3:(PGVec3)vec3;

+ (PGMat3 *)identity;
+ (PGMat3 *)null;
- (float const *)array;

- (PGVec2)mulVec2:(PGVec2)vec2;
@end

