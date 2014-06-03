#import "PGMat4.h"

//#if defined(__LP64__) && __LP64__
//#define GLM_PRECISION_HIGHP_FLOAT
//#endif

#include "glm.hpp"
#include "matrix_transform.hpp"
#import "type_ptr.hpp"


struct PGMat4Impl {
    glm::mat4 m;
};


@implementation PGMat4

static PGMat4 * _identity;
static PGMat4 * _null;


- (id)initWithImpl:(PGMat4Impl *)m {
    self = [super init];
    if (self) {
        _impl = m;
    }

    return self;
}

+ (id)mat4WithImpl:(PGMat4Impl *)m {
    return [[self alloc] initWithImpl:m];
}

+ (id)mat4WithArray:(float [16])m {
    PGMat4Impl * impl = new PGMat4Impl;
    impl->m = glm::make_mat4(m);
    return [PGMat4 mat4WithImpl:impl];
}


- (PGMat4 *)mulMatrix:(PGMat4 *)matrix {
    PGMat4Impl * impl = new PGMat4Impl;
    impl->m = _impl->m * matrix->_impl->m;
    return [PGMat4 mat4WithImpl:impl];
}

+ (void)initialize {
    [super initialize];
    PGMat4Impl * impl = new PGMat4Impl;
    impl->m = glm::mat4(1.0);
    _identity = [PGMat4 mat4WithImpl:impl];
    impl = new PGMat4Impl;
    impl->m = glm::mat4(0.0);
    _null = [PGMat4 mat4WithImpl:impl];
}


- (PGVec4)mulVec4:(PGVec4)vec4 {
    glm::vec4 v4 = _impl->m* glm::vec4(vec4.x, vec4.y, vec4.z, vec4.w);
    return {v4.x, v4.y, v4.z, v4.w};
}

- (PGVec4)mulVec3:(PGVec3)vec3 w:(float)w {
    glm::vec4 v4 = _impl->m* glm::vec4(vec3.x, vec3.y, vec3.z, w);
    return {v4.x, v4.y, v4.z, v4.w};
}


+ (PGMat4 *)identity {
    return _identity;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

+ (PGMat4 *)orthoLeft:(float)left right:(float)right bottom:(float)bottom top:(float)top zNear:(float)near zFar:(float)far {
    PGMat4Impl * impl = new PGMat4Impl;
    impl->m = glm::ortho(left, right, bottom, top, near, far);
    return [PGMat4 mat4WithImpl:impl];
}

- (void)dealloc {
    delete _impl;
}

+ (PGMat4 *)lookAtEye:(PGVec3)eye center:(PGVec3)center up:(PGVec3)up {
    PGMat4Impl * impl = new PGMat4Impl;
    impl->m = glm::lookAt(glm::vec3(eye.x, eye.y, eye.z), glm::vec3(center.x, center.y, center.z), glm::vec3(up.x, up.y, up.z));
    return [PGMat4 mat4WithImpl:impl];
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    PGMat4 * o = ((PGMat4 *)(other));
    return memcmp(_impl, o->_impl, sizeof(float[16])) == 0;
}

+ (PGMat4 *)null {
    return _null;
}

- (float const *)array {
    return glm::value_ptr(_impl->m);
}

- (PGMat4 *)rotateAngle:(float)angle x:(float)x y:(float)y z:(float)z {
    PGMat4Impl * impl = new PGMat4Impl;
    impl->m = glm::rotate(_impl->m, angle, glm::vec3(x, y, z));
    return [PGMat4 mat4WithImpl:impl];
}

- (PGMat4 *)scaleX:(float)x y:(float)y z:(float)z {
    PGMat4Impl * impl = new PGMat4Impl;
    impl->m = glm::scale(_impl->m, glm::vec3(x, y, z));
    return [PGMat4 mat4WithImpl:impl];
}

- (PGMat4 *)translateX:(float)x y:(float)y z:(float)z {
    PGMat4Impl * impl = new PGMat4Impl;
    impl->m = glm::translate(_impl->m, glm::vec3(x, y, z));
    return [PGMat4 mat4WithImpl:impl];
}

- (PGMat4 *)translateVec3:(PGVec3)vec3 {
    PGMat4Impl * impl = new PGMat4Impl;
    impl->m = glm::translate(_impl->m, glm::vec3(vec3.x, vec3.y, vec3.z));
    return [PGMat4 mat4WithImpl:impl];
}



- (NSString*)description {
    float const *m = [self array];
    return [NSString stringWithFormat:
            @"[%f, %f, %f, %f,\n"
                    " %f, %f, %f, %f,\n"
                    " %f, %f, %f, %f,\n"
                    " %f, %f, %f, %f]",
            m[0], m[4], m[8],  m[12],
            m[1], m[5], m[9],  m[13],
            m[2], m[6], m[10], m[14],
            m[3], m[7], m[11], m[15]];
}

- (PGVec4)divBySelfVec4:(PGVec4)vec4 {
    glm::vec4 v4 = glm::vec4(vec4.x, vec4.y, vec4.z, vec4.w) / _impl->m;
    return {v4.x, v4.y, v4.z, v4.w};
}

- (PGMat4 *)inverse {
    PGMat4Impl * impl = new PGMat4Impl;
    impl->m = glm::inverse(_impl->m);
    return [PGMat4 mat4WithImpl:impl];
}

- (PGRect)mulRect:(PGRect)rect {
    glm::vec4 v0 = _impl->m* glm::vec4(rect.p.x, rect.p.y, 0, 1);
    PGVec2 p3 = {rect.p.x + rect.size.x, rect.p.y + rect.size.y};
    glm::vec4 v3 = _impl->m* glm::vec4(p3.x, p3.y, 0, 1);
    return {v0.x, v0.y, v3.x - v0.x, v3.y - v0.y};
}

- (PGRect)mulRect:(PGRect)rect z:(float)z {
    glm::vec4 v0 = _impl->m* glm::vec4(rect.p.x, rect.p.y, z, 1);
    PGVec2 p3 = {rect.p.x + rect.size.x, rect.p.y + rect.size.y};
    glm::vec4 v3 = _impl->m* glm::vec4(p3.x, p3.y, z, 1);
    return {v0.x, v0.y, v3.x - v0.x, v3.y - v0.y};
}

- (PGVec3)mulVec3:(PGVec3)vec3 {
    glm::vec4 v4 = _impl->m* glm::vec4(vec3.x, vec3.y, vec3.z, 1);
    return {v4.x, v4.y, v4.z};
}
@end


struct PGMat3Impl {
    glm::mat3 m;
};


@implementation PGMat3

static PGMat3 * _mat3_identity;
static PGMat3 * _mat3_null;


- (id)initWithImplMat3:(PGMat3Impl *)m {
    self = [super init];
    if (self) {
        _impl = m;
    }

    return self;
}

+ (id)mat3WithImpl:(PGMat3Impl *)m {
    return [[self alloc] initWithImplMat3:m];
}

+ (id)mat3WithArray:(float [9])m {
    PGMat3Impl * impl = new PGMat3Impl;
    impl->m = glm::make_mat3(m);
    return [PGMat3 mat3WithImpl:impl];
}

+ (void)initialize {
    [super initialize];
    PGMat3Impl * impl = new PGMat3Impl;
    impl->m = glm::mat3(1.0);
    _mat3_identity = [PGMat3 mat3WithImpl:impl];
    impl = new PGMat3Impl;
    impl->m = glm::mat3(0.0);
    _mat3_null = [PGMat3 mat3WithImpl:impl];
}


- (PGVec3)mulVec3:(PGVec3)vec3 {
    glm::vec3 v3 = _impl->m* glm::vec3(vec3.x, vec3.y, vec3.z);
    return {v3.x, v3.y, v3.z};
}

+ (PGMat3 *)identity {
    return _mat3_identity;
}

+ (PGMat3 *)null {
    return _mat3_null;
}

- (float const *)array {
    return glm::value_ptr(_impl->m);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    float const *m = [self array];
    return [NSString stringWithFormat:
            @"[%f, %f, %f,\n"
                    " %f, %f, %f,\n"
                    " %f, %f, %f]",
            m[0], m[3], m[6],
            m[1], m[4], m[7],
            m[2], m[5], m[8]];
}

- (PGVec2)mulVec2:(PGVec2)vec2 {
    glm::vec3 v3 = _impl->m* glm::vec3(vec2.x, vec2.y, 1.0);
    return {v3.x, v3.y};
}
@end