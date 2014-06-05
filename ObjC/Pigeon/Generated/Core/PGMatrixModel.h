#import "objd.h"
@class PGMat4;

@class PGMatrixStack;
@class PGMatrixModel;
@class PGImMatrixModel;
@class PGMMatrixModel;

@interface PGMatrixStack : NSObject {
@public
    CNImList* _stack;
    PGMMatrixModel* __value;
}
+ (instancetype)matrixStack;
- (instancetype)init;
- (CNClassType*)type;
- (PGMMatrixModel*)value;
- (void)setValue:(PGMatrixModel*)value;
- (void)clear;
- (void)push;
- (void)pop;
- (PGMat4*)m;
- (PGMat4*)w;
- (PGMat4*)c;
- (PGMat4*)p;
- (PGMat4*)mw;
- (PGMat4*)mwc;
- (PGMat4*)mwcp;
- (PGMat4*)wc;
- (PGMat4*)wcp;
- (PGMat4*)cp;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGMatrixModel : NSObject
+ (instancetype)matrixModel;
- (instancetype)init;
- (CNClassType*)type;
- (PGMat4*)m;
- (PGMat4*)w;
- (PGMat4*)c;
- (PGMat4*)p;
- (PGMat4*)mw;
- (PGMat4*)mwc;
- (PGMat4*)mwcp;
- (PGMat4*)cp;
- (PGMat4*)wcp;
- (PGMat4*)wc;
- (PGMMatrixModel*)mutable;
- (NSString*)description;
+ (PGMatrixModel*)identity;
+ (CNClassType*)type;
@end


@interface PGImMatrixModel : PGMatrixModel {
@public
    PGMat4* _m;
    PGMat4* _w;
    PGMat4* _c;
    PGMat4* _p;
}
@property (nonatomic, readonly) PGMat4* m;
@property (nonatomic, readonly) PGMat4* w;
@property (nonatomic, readonly) PGMat4* c;
@property (nonatomic, readonly) PGMat4* p;

+ (instancetype)imMatrixModelWithM:(PGMat4*)m w:(PGMat4*)w c:(PGMat4*)c p:(PGMat4*)p;
- (instancetype)initWithM:(PGMat4*)m w:(PGMat4*)w c:(PGMat4*)c p:(PGMat4*)p;
- (CNClassType*)type;
- (PGMMatrixModel*)mutable;
- (PGMat4*)mw;
- (PGMat4*)mwc;
- (PGMat4*)mwcp;
- (PGMat4*)cp;
- (PGMat4*)wcp;
- (PGMat4*)wc;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGMMatrixModel : PGMatrixModel {
@public
    PGMat4* __m;
    PGMat4* __w;
    PGMat4* __c;
    PGMat4* __p;
    PGMat4* __mw;
    PGMat4* __mwc;
    PGMat4* __mwcp;
}
@property (nonatomic, retain) PGMat4* _m;
@property (nonatomic, retain) PGMat4* _w;
@property (nonatomic, retain) PGMat4* _c;
@property (nonatomic, retain) PGMat4* _p;

+ (instancetype)matrixModel;
- (instancetype)init;
- (CNClassType*)type;
- (PGMat4*)m;
- (PGMat4*)w;
- (PGMat4*)c;
- (PGMat4*)p;
- (PGMat4*)mw;
- (PGMat4*)mwc;
- (PGMat4*)mwcp;
- (PGMat4*)cp;
- (PGMat4*)wcp;
- (PGMat4*)wc;
- (PGMMatrixModel*)copy;
+ (PGMMatrixModel*)applyMatrixModel:(PGMatrixModel*)matrixModel;
+ (PGMMatrixModel*)applyImMatrixModel:(PGImMatrixModel*)imMatrixModel;
+ (PGMMatrixModel*)applyM:(PGMat4*)m w:(PGMat4*)w c:(PGMat4*)c p:(PGMat4*)p;
- (PGMMatrixModel*)mutable;
- (PGImMatrixModel*)immutable;
- (PGMMatrixModel*)modifyM:(PGMat4*(^)(PGMat4*))m;
- (PGMMatrixModel*)modifyW:(PGMat4*(^)(PGMat4*))w;
- (PGMMatrixModel*)modifyC:(PGMat4*(^)(PGMat4*))c;
- (PGMMatrixModel*)modifyP:(PGMat4*(^)(PGMat4*))p;
- (void)clear;
- (void)setMatrixModel:(PGMatrixModel*)matrixModel;
- (NSString*)description;
+ (CNClassType*)type;
@end


