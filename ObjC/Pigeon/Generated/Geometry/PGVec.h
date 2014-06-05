#import "objd.h"
@class PGMat4;
@class PGMat3;
@class CNChain;
@class CNSortBuilder;

@class PGVec2Buffer;
typedef struct PGVec2 PGVec2;
typedef struct PGVec2i PGVec2i;
typedef struct PGVec3 PGVec3;
typedef struct PGVec4 PGVec4;
typedef struct PGTriangle PGTriangle;
typedef struct PGQuad PGQuad;
typedef struct PGQuadrant PGQuadrant;
typedef struct PGRect PGRect;
typedef struct PGRectI PGRectI;
typedef struct PGLine2 PGLine2;
typedef struct PGLine3 PGLine3;
typedef struct PGPlane PGPlane;
typedef struct PGPlaneCoord PGPlaneCoord;
typedef struct PGQuad3 PGQuad3;

struct PGVec2 {
    float x;
    float y;
};
static inline PGVec2 PGVec2Make(float x, float y) {
    return (PGVec2){x, y};
}
PGVec2 pgVec2ApplyVec2i(PGVec2i vec2i);
PGVec2 pgVec2ApplyF(CGFloat f);
PGVec2 pgVec2ApplyF4(float f4);
PGVec2 pgVec2Min();
PGVec2 pgVec2Max();
PGVec2 pgVec2AddVec2(PGVec2 self, PGVec2 vec2);
PGVec2 pgVec2AddF4(PGVec2 self, float f4);
PGVec2 pgVec2AddF(PGVec2 self, CGFloat f);
PGVec2 pgVec2AddI(PGVec2 self, NSInteger i);
PGVec2 pgVec2SubVec2(PGVec2 self, PGVec2 vec2);
PGVec2 pgVec2SubF4(PGVec2 self, float f4);
PGVec2 pgVec2SubF(PGVec2 self, CGFloat f);
PGVec2 pgVec2SubI(PGVec2 self, NSInteger i);
PGVec2 pgVec2MulVec2(PGVec2 self, PGVec2 vec2);
PGVec2 pgVec2MulF4(PGVec2 self, float f4);
PGVec2 pgVec2MulF(PGVec2 self, CGFloat f);
PGVec2 pgVec2MulI(PGVec2 self, NSInteger i);
PGVec2 pgVec2DivVec2(PGVec2 self, PGVec2 vec2);
PGVec2 pgVec2DivF4(PGVec2 self, float f4);
PGVec2 pgVec2DivF(PGVec2 self, CGFloat f);
PGVec2 pgVec2DivI(PGVec2 self, NSInteger i);
PGVec2 pgVec2Negate(PGVec2 self);
float pgVec2DegreeAngle(PGVec2 self);
float pgVec2Angle(PGVec2 self);
float pgVec2DotVec2(PGVec2 self, PGVec2 vec2);
float pgVec2CrossVec2(PGVec2 self, PGVec2 vec2);
float pgVec2LengthSquare(PGVec2 self);
float pgVec2Length(PGVec2 self);
PGVec2 pgVec2MidVec2(PGVec2 self, PGVec2 vec2);
float pgVec2DistanceToVec2(PGVec2 self, PGVec2 vec2);
PGVec2 pgVec2SetLength(PGVec2 self, float length);
PGVec2 pgVec2Normalize(PGVec2 self);
NSInteger pgVec2CompareTo(PGVec2 self, PGVec2 to);
PGRect pgVec2RectToVec2(PGVec2 self, PGVec2 vec2);
PGRect pgVec2RectInCenterWithSize(PGVec2 self, PGVec2 size);
PGVec2 pgVec2Rnd();
BOOL pgVec2IsEmpty(PGVec2 self);
PGVec2i pgVec2Round(PGVec2 self);
PGVec2 pgVec2MinVec2(PGVec2 self, PGVec2 vec2);
PGVec2 pgVec2MaxVec2(PGVec2 self, PGVec2 vec2);
PGVec2 pgVec2Abs(PGVec2 self);
float pgVec2Ratio(PGVec2 self);
NSString* pgVec2Description(PGVec2 self);
BOOL pgVec2IsEqualTo(PGVec2 self, PGVec2 to);
NSUInteger pgVec2Hash(PGVec2 self);
CNPType* pgVec2Type();
@interface PGVec2Wrap : NSObject
@property (readonly, nonatomic) PGVec2 value;

+ (id)wrapWithValue:(PGVec2)value;
- (id)initWithValue:(PGVec2)value;
@end



@interface PGVec2Buffer : CNBuffer
+ (instancetype)vec2BufferWithCount:(NSUInteger)count;
- (instancetype)initWithCount:(NSUInteger)count;
- (CNClassType*)type;
- (PGVec2)get;
- (void)setV:(PGVec2)v;
- (NSString*)description;
+ (CNClassType*)type;
@end


struct PGVec2i {
    NSInteger x;
    NSInteger y;
};
static inline PGVec2i PGVec2iMake(NSInteger x, NSInteger y) {
    return (PGVec2i){x, y};
}
PGVec2i pgVec2iApplyVec2(PGVec2 vec2);
PGVec2 pgVec2iAddVec2(PGVec2i self, PGVec2 vec2);
PGVec2i pgVec2iAddVec2i(PGVec2i self, PGVec2i vec2i);
PGVec2 pgVec2iSubVec2(PGVec2i self, PGVec2 vec2);
PGVec2i pgVec2iSubVec2i(PGVec2i self, PGVec2i vec2i);
PGVec2i pgVec2iMulI(PGVec2i self, NSInteger i);
PGVec2 pgVec2iMulF(PGVec2i self, CGFloat f);
PGVec2 pgVec2iMulF4(PGVec2i self, float f4);
PGVec2 pgVec2iDivF4(PGVec2i self, float f4);
PGVec2 pgVec2iDivF(PGVec2i self, CGFloat f);
PGVec2i pgVec2iDivI(PGVec2i self, NSInteger i);
PGVec2i pgVec2iNegate(PGVec2i self);
NSInteger pgVec2iCompareTo(PGVec2i self, PGVec2i to);
PGRectI pgVec2iRectToVec2i(PGVec2i self, PGVec2i vec2i);
NSInteger pgVec2iDotVec2i(PGVec2i self, PGVec2i vec2i);
NSInteger pgVec2iLengthSquare(PGVec2i self);
float pgVec2iLength(PGVec2i self);
float pgVec2iRatio(PGVec2i self);
NSString* pgVec2iDescription(PGVec2i self);
BOOL pgVec2iIsEqualTo(PGVec2i self, PGVec2i to);
NSUInteger pgVec2iHash(PGVec2i self);
CNPType* pgVec2iType();
@interface PGVec2iWrap : NSObject
@property (readonly, nonatomic) PGVec2i value;

+ (id)wrapWithValue:(PGVec2i)value;
- (id)initWithValue:(PGVec2i)value;
@end



struct PGVec3 {
    float x;
    float y;
    float z;
};
static inline PGVec3 PGVec3Make(float x, float y, float z) {
    return (PGVec3){x, y, z};
}
PGVec3 pgVec3ApplyVec2(PGVec2 vec2);
PGVec3 pgVec3ApplyVec2Z(PGVec2 vec2, float z);
PGVec3 pgVec3ApplyVec2iZ(PGVec2i vec2i, float z);
PGVec3 pgVec3ApplyF4(float f4);
PGVec3 pgVec3ApplyF(CGFloat f);
PGVec3 pgVec3AddVec3(PGVec3 self, PGVec3 vec3);
PGVec3 pgVec3SubVec3(PGVec3 self, PGVec3 vec3);
PGVec3 pgVec3Sqr(PGVec3 self);
PGVec3 pgVec3Negate(PGVec3 self);
PGVec3 pgVec3MulK(PGVec3 self, float k);
float pgVec3DotVec3(PGVec3 self, PGVec3 vec3);
PGVec3 pgVec3CrossVec3(PGVec3 self, PGVec3 vec3);
float pgVec3LengthSquare(PGVec3 self);
CGFloat pgVec3Length(PGVec3 self);
PGVec3 pgVec3SetLength(PGVec3 self, float length);
PGVec3 pgVec3Normalize(PGVec3 self);
PGVec2 pgVec3Xy(PGVec3 self);
PGVec3 pgVec3Rnd();
BOOL pgVec3IsEmpty(PGVec3 self);
NSString* pgVec3Description(PGVec3 self);
BOOL pgVec3IsEqualTo(PGVec3 self, PGVec3 to);
NSUInteger pgVec3Hash(PGVec3 self);
CNPType* pgVec3Type();
@interface PGVec3Wrap : NSObject
@property (readonly, nonatomic) PGVec3 value;

+ (id)wrapWithValue:(PGVec3)value;
- (id)initWithValue:(PGVec3)value;
@end



struct PGVec4 {
    float x;
    float y;
    float z;
    float w;
};
static inline PGVec4 PGVec4Make(float x, float y, float z, float w) {
    return (PGVec4){x, y, z, w};
}
PGVec4 pgVec4ApplyF(CGFloat f);
PGVec4 pgVec4ApplyF4(float f4);
PGVec4 pgVec4ApplyVec3W(PGVec3 vec3, float w);
PGVec4 pgVec4ApplyVec2ZW(PGVec2 vec2, float z, float w);
PGVec4 pgVec4AddVec2(PGVec4 self, PGVec2 vec2);
PGVec4 pgVec4AddVec3(PGVec4 self, PGVec3 vec3);
PGVec4 pgVec4AddVec4(PGVec4 self, PGVec4 vec4);
PGVec3 pgVec4Xyz(PGVec4 self);
PGVec2 pgVec4Xy(PGVec4 self);
PGVec4 pgVec4MulK(PGVec4 self, float k);
PGVec4 pgVec4DivMat4(PGVec4 self, PGMat4* mat4);
PGVec4 pgVec4DivF4(PGVec4 self, float f4);
PGVec4 pgVec4DivF(PGVec4 self, CGFloat f);
PGVec4 pgVec4DivI(PGVec4 self, NSInteger i);
float pgVec4LengthSquare(PGVec4 self);
CGFloat pgVec4Length(PGVec4 self);
PGVec4 pgVec4SetLength(PGVec4 self, float length);
PGVec4 pgVec4Normalize(PGVec4 self);
NSString* pgVec4Description(PGVec4 self);
BOOL pgVec4IsEqualTo(PGVec4 self, PGVec4 to);
NSUInteger pgVec4Hash(PGVec4 self);
CNPType* pgVec4Type();
@interface PGVec4Wrap : NSObject
@property (readonly, nonatomic) PGVec4 value;

+ (id)wrapWithValue:(PGVec4)value;
- (id)initWithValue:(PGVec4)value;
@end



struct PGTriangle {
    PGVec2 p0;
    PGVec2 p1;
    PGVec2 p2;
};
static inline PGTriangle PGTriangleMake(PGVec2 p0, PGVec2 p1, PGVec2 p2) {
    return (PGTriangle){p0, p1, p2};
}
BOOL pgTriangleContainsVec2(PGTriangle self, PGVec2 vec2);
NSString* pgTriangleDescription(PGTriangle self);
BOOL pgTriangleIsEqualTo(PGTriangle self, PGTriangle to);
NSUInteger pgTriangleHash(PGTriangle self);
CNPType* pgTriangleType();
@interface PGTriangleWrap : NSObject
@property (readonly, nonatomic) PGTriangle value;

+ (id)wrapWithValue:(PGTriangle)value;
- (id)initWithValue:(PGTriangle)value;
@end



struct PGQuad {
    PGVec2 p0;
    PGVec2 p1;
    PGVec2 p2;
    PGVec2 p3;
};
static inline PGQuad PGQuadMake(PGVec2 p0, PGVec2 p1, PGVec2 p2, PGVec2 p3) {
    return (PGQuad){p0, p1, p2, p3};
}
PGQuad pgQuadApplySize(float size);
PGQuad pgQuadAddVec2(PGQuad self, PGVec2 vec2);
PGQuad pgQuadAddXY(PGQuad self, float x, float y);
PGQuad pgQuadMulValue(PGQuad self, float value);
PGQuad pgQuadMulMat3(PGQuad self, PGMat3* mat3);
PGQuadrant pgQuadQuadrant(PGQuad self);
PGVec2 pgQuadApplyIndex(PGQuad self, NSUInteger index);
PGRect pgQuadBoundingRect(PGQuad self);
NSArray* pgQuadLines(PGQuad self);
NSArray* pgQuadPs(PGQuad self);
PGVec2 pgQuadClosestPointForVec2(PGQuad self, PGVec2 vec2);
BOOL pgQuadContainsVec2(PGQuad self, PGVec2 vec2);
PGQuad pgQuadMapF(PGQuad self, PGVec2(^f)(PGVec2));
PGVec2 pgQuadCenter(PGQuad self);
NSString* pgQuadDescription(PGQuad self);
BOOL pgQuadIsEqualTo(PGQuad self, PGQuad to);
NSUInteger pgQuadHash(PGQuad self);
PGQuad pgQuadIdentity();
CNPType* pgQuadType();
@interface PGQuadWrap : NSObject
@property (readonly, nonatomic) PGQuad value;

+ (id)wrapWithValue:(PGQuad)value;
- (id)initWithValue:(PGQuad)value;
@end



struct PGQuadrant {
    PGQuad quads[4];
};
static inline PGQuadrant PGQuadrantMake(PGQuad quads[4]) {
    return (PGQuadrant){{quads[0], quads[1], quads[2], quads[3]}};
}
PGQuad pgQuadrantRndQuad(PGQuadrant self);
NSString* pgQuadrantDescription(PGQuadrant self);
BOOL pgQuadrantIsEqualTo(PGQuadrant self, PGQuadrant to);
NSUInteger pgQuadrantHash(PGQuadrant self);
CNPType* pgQuadrantType();
@interface PGQuadrantWrap : NSObject
@property (readonly, nonatomic) PGQuadrant value;

+ (id)wrapWithValue:(PGQuadrant)value;
- (id)initWithValue:(PGQuadrant)value;
@end



struct PGRect {
    PGVec2 p;
    PGVec2 size;
};
static inline PGRect PGRectMake(PGVec2 p, PGVec2 size) {
    return (PGRect){p, size};
}
PGRect pgRectApplyXYWidthHeight(float x, float y, float width, float height);
PGRect pgRectApplyXYSize(float x, float y, PGVec2 size);
PGRect pgRectApplyRectI(PGRectI rectI);
float pgRectX(PGRect self);
float pgRectY(PGRect self);
float pgRectX2(PGRect self);
float pgRectY2(PGRect self);
float pgRectWidth(PGRect self);
float pgRectHeight(PGRect self);
BOOL pgRectContainsVec2(PGRect self, PGVec2 vec2);
PGRect pgRectAddVec2(PGRect self, PGVec2 vec2);
PGRect pgRectSubVec2(PGRect self, PGVec2 vec2);
PGRect pgRectMulF(PGRect self, CGFloat f);
PGRect pgRectMulVec2(PGRect self, PGVec2 vec2);
BOOL pgRectIntersectsRect(PGRect self, PGRect rect);
PGRect pgRectThickenHalfSize(PGRect self, PGVec2 halfSize);
PGRect pgRectDivVec2(PGRect self, PGVec2 vec2);
PGRect pgRectDivF(PGRect self, CGFloat f);
PGRect pgRectDivF4(PGRect self, float f4);
PGVec2 pgRectPh(PGRect self);
PGVec2 pgRectPw(PGRect self);
PGVec2 pgRectPhw(PGRect self);
PGRect pgRectMoveToCenterForSize(PGRect self, PGVec2 size);
PGQuad pgRectQuad(PGRect self);
PGQuad pgRectStripQuad(PGRect self);
PGQuad pgRectUpsideDownStripQuad(PGRect self);
PGRect pgRectCenterX(PGRect self);
PGRect pgRectCenterY(PGRect self);
PGVec2 pgRectCenter(PGRect self);
PGVec2 pgRectClosestPointForVec2(PGRect self, PGVec2 vec2);
PGVec2 pgRectPXY(PGRect self, float x, float y);
NSString* pgRectDescription(PGRect self);
BOOL pgRectIsEqualTo(PGRect self, PGRect to);
NSUInteger pgRectHash(PGRect self);
CNPType* pgRectType();
@interface PGRectWrap : NSObject
@property (readonly, nonatomic) PGRect value;

+ (id)wrapWithValue:(PGRect)value;
- (id)initWithValue:(PGRect)value;
@end



struct PGRectI {
    PGVec2i p;
    PGVec2i size;
};
static inline PGRectI PGRectIMake(PGVec2i p, PGVec2i size) {
    return (PGRectI){p, size};
}
PGRectI pgRectIApplyXYWidthHeight(float x, float y, float width, float height);
PGRectI pgRectIApplyRect(PGRect rect);
NSInteger pgRectIX(PGRectI self);
NSInteger pgRectIY(PGRectI self);
NSInteger pgRectIX2(PGRectI self);
NSInteger pgRectIY2(PGRectI self);
NSInteger pgRectIWidth(PGRectI self);
NSInteger pgRectIHeight(PGRectI self);
PGRectI pgRectIMoveToCenterForSize(PGRectI self, PGVec2 size);
NSString* pgRectIDescription(PGRectI self);
BOOL pgRectIIsEqualTo(PGRectI self, PGRectI to);
NSUInteger pgRectIHash(PGRectI self);
CNPType* pgRectIType();
@interface PGRectIWrap : NSObject
@property (readonly, nonatomic) PGRectI value;

+ (id)wrapWithValue:(PGRectI)value;
- (id)initWithValue:(PGRectI)value;
@end



struct PGLine2 {
    PGVec2 p0;
    PGVec2 u;
};
static inline PGLine2 PGLine2Make(PGVec2 p0, PGVec2 u) {
    return (PGLine2){p0, u};
}
PGLine2 pgLine2ApplyP0P1(PGVec2 p0, PGVec2 p1);
PGVec2 pgLine2RT(PGLine2 self, float t);
id pgLine2CrossPointLine2(PGLine2 self, PGLine2 line2);
float pgLine2Angle(PGLine2 self);
float pgLine2DegreeAngle(PGLine2 self);
PGLine2 pgLine2SetLength(PGLine2 self, float length);
PGLine2 pgLine2Normalize(PGLine2 self);
PGVec2 pgLine2Mid(PGLine2 self);
PGVec2 pgLine2P1(PGLine2 self);
PGLine2 pgLine2AddVec2(PGLine2 self, PGVec2 vec2);
PGLine2 pgLine2SubVec2(PGLine2 self, PGVec2 vec2);
PGVec2 pgLine2N(PGLine2 self);
PGVec2 pgLine2ProjectionVec2(PGLine2 self, PGVec2 vec2);
id pgLine2ProjectionOnSegmentVec2(PGLine2 self, PGVec2 vec2);
PGRect pgLine2BoundingRect(PGLine2 self);
PGLine2 pgLine2Positive(PGLine2 self);
NSString* pgLine2Description(PGLine2 self);
BOOL pgLine2IsEqualTo(PGLine2 self, PGLine2 to);
NSUInteger pgLine2Hash(PGLine2 self);
CNPType* pgLine2Type();
@interface PGLine2Wrap : NSObject
@property (readonly, nonatomic) PGLine2 value;

+ (id)wrapWithValue:(PGLine2)value;
- (id)initWithValue:(PGLine2)value;
@end



struct PGLine3 {
    PGVec3 r0;
    PGVec3 u;
};
static inline PGLine3 PGLine3Make(PGVec3 r0, PGVec3 u) {
    return (PGLine3){r0, u};
}
PGVec3 pgLine3RT(PGLine3 self, float t);
PGVec3 pgLine3RPlane(PGLine3 self, PGPlane plane);
NSString* pgLine3Description(PGLine3 self);
BOOL pgLine3IsEqualTo(PGLine3 self, PGLine3 to);
NSUInteger pgLine3Hash(PGLine3 self);
CNPType* pgLine3Type();
@interface PGLine3Wrap : NSObject
@property (readonly, nonatomic) PGLine3 value;

+ (id)wrapWithValue:(PGLine3)value;
- (id)initWithValue:(PGLine3)value;
@end



struct PGPlane {
    PGVec3 p0;
    PGVec3 n;
};
static inline PGPlane PGPlaneMake(PGVec3 p0, PGVec3 n) {
    return (PGPlane){p0, n};
}
BOOL pgPlaneContainsVec3(PGPlane self, PGVec3 vec3);
PGPlane pgPlaneAddVec3(PGPlane self, PGVec3 vec3);
PGPlane pgPlaneMulMat4(PGPlane self, PGMat4* mat4);
NSString* pgPlaneDescription(PGPlane self);
BOOL pgPlaneIsEqualTo(PGPlane self, PGPlane to);
NSUInteger pgPlaneHash(PGPlane self);
CNPType* pgPlaneType();
@interface PGPlaneWrap : NSObject
@property (readonly, nonatomic) PGPlane value;

+ (id)wrapWithValue:(PGPlane)value;
- (id)initWithValue:(PGPlane)value;
@end



struct PGPlaneCoord {
    PGPlane plane;
    PGVec3 x;
    PGVec3 y;
};
static inline PGPlaneCoord PGPlaneCoordMake(PGPlane plane, PGVec3 x, PGVec3 y) {
    return (PGPlaneCoord){plane, x, y};
}
PGPlaneCoord pgPlaneCoordApplyPlaneX(PGPlane plane, PGVec3 x);
PGVec3 pgPlaneCoordPVec2(PGPlaneCoord self, PGVec2 vec2);
PGPlaneCoord pgPlaneCoordAddVec3(PGPlaneCoord self, PGVec3 vec3);
PGPlaneCoord pgPlaneCoordSetX(PGPlaneCoord self, PGVec3 x);
PGPlaneCoord pgPlaneCoordSetY(PGPlaneCoord self, PGVec3 y);
PGPlaneCoord pgPlaneCoordMulMat4(PGPlaneCoord self, PGMat4* mat4);
NSString* pgPlaneCoordDescription(PGPlaneCoord self);
BOOL pgPlaneCoordIsEqualTo(PGPlaneCoord self, PGPlaneCoord to);
NSUInteger pgPlaneCoordHash(PGPlaneCoord self);
CNPType* pgPlaneCoordType();
@interface PGPlaneCoordWrap : NSObject
@property (readonly, nonatomic) PGPlaneCoord value;

+ (id)wrapWithValue:(PGPlaneCoord)value;
- (id)initWithValue:(PGPlaneCoord)value;
@end



struct PGQuad3 {
    PGPlaneCoord planeCoord;
    PGQuad quad;
};
static inline PGQuad3 PGQuad3Make(PGPlaneCoord planeCoord, PGQuad quad) {
    return (PGQuad3){planeCoord, quad};
}
PGVec3 pgQuad3P0(PGQuad3 self);
PGVec3 pgQuad3P1(PGQuad3 self);
PGVec3 pgQuad3P2(PGQuad3 self);
PGVec3 pgQuad3P3(PGQuad3 self);
NSArray* pgQuad3Ps(PGQuad3 self);
PGQuad3 pgQuad3MulMat4(PGQuad3 self, PGMat4* mat4);
NSString* pgQuad3Description(PGQuad3 self);
BOOL pgQuad3IsEqualTo(PGQuad3 self, PGQuad3 to);
NSUInteger pgQuad3Hash(PGQuad3 self);
CNPType* pgQuad3Type();
@interface PGQuad3Wrap : NSObject
@property (readonly, nonatomic) PGQuad3 value;

+ (id)wrapWithValue:(PGQuad3)value;
- (id)initWithValue:(PGQuad3)value;
@end



