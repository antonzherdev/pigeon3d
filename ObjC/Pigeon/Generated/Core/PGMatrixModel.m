#import "PGMatrixModel.h"

#import "PGMat4.h"
@implementation PGMatrixStack
static CNClassType* _PGMatrixStack_type;

+ (instancetype)matrixStack {
    return [[PGMatrixStack alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) {
        _stack = [CNImList apply];
        __value = [PGMMatrixModel matrixModel];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGMatrixStack class]) _PGMatrixStack_type = [CNClassType classTypeWithCls:[PGMatrixStack class]];
}

- (PGMMatrixModel*)value {
    return __value;
}

- (void)setValue:(PGMatrixModel*)value {
    [__value setMatrixModel:value];
}

- (void)clear {
    [__value clear];
    _stack = [CNImList apply];
}

- (void)push {
    _stack = [CNImList applyItem:[__value immutable] tail:_stack];
}

- (void)pop {
    [__value setMatrixModel:((PGImMatrixModel*)(nonnil([_stack head])))];
    _stack = [_stack tail];
}

- (void)applyModify:(void(^)(PGMMatrixModel*))modify f:(void(^)())f {
    [self push];
    modify([self value]);
    f();
    [self pop];
}

- (void)identityF:(void(^)())f {
    [self push];
    [[self value] clear];
    f();
    [self pop];
}

- (PGMat4*)m {
    return [__value m];
}

- (PGMat4*)w {
    return [__value w];
}

- (PGMat4*)c {
    return [__value c];
}

- (PGMat4*)p {
    return [__value p];
}

- (PGMat4*)mw {
    return [__value mw];
}

- (PGMat4*)mwc {
    return [__value mwc];
}

- (PGMat4*)mwcp {
    return [__value mwcp];
}

- (PGMat4*)wc {
    return [__value wc];
}

- (PGMat4*)wcp {
    return [__value wcp];
}

- (PGMat4*)cp {
    return [__value cp];
}

- (NSString*)description {
    return @"MatrixStack";
}

- (CNClassType*)type {
    return [PGMatrixStack type];
}

+ (CNClassType*)type {
    return _PGMatrixStack_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGMatrixModel
static PGMatrixModel* _PGMatrixModel_identity;
static CNClassType* _PGMatrixModel_type;

+ (instancetype)matrixModel {
    return [[PGMatrixModel alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGMatrixModel class]) {
        _PGMatrixModel_type = [CNClassType classTypeWithCls:[PGMatrixModel class]];
        _PGMatrixModel_identity = [PGImMatrixModel imMatrixModelWithM:[PGMat4 identity] w:[PGMat4 identity] c:[PGMat4 identity] p:[PGMat4 identity]];
    }
}

- (PGMat4*)m {
    @throw @"Method m is abstract";
}

- (PGMat4*)w {
    @throw @"Method w is abstract";
}

- (PGMat4*)c {
    @throw @"Method c is abstract";
}

- (PGMat4*)p {
    @throw @"Method p is abstract";
}

- (PGMat4*)mw {
    return [[self w] mulMatrix:[self m]];
}

- (PGMat4*)mwc {
    return [[self c] mulMatrix:[[self w] mulMatrix:[self m]]];
}

- (PGMat4*)mwcp {
    return [[self p] mulMatrix:[[self c] mulMatrix:[[self w] mulMatrix:[self m]]]];
}

- (PGMat4*)cp {
    return [[self p] mulMatrix:[self c]];
}

- (PGMat4*)wcp {
    return [[self p] mulMatrix:[[self c] mulMatrix:[self w]]];
}

- (PGMat4*)wc {
    return [[self c] mulMatrix:[self w]];
}

- (PGMMatrixModel*)mutable {
    @throw @"Method mutable is abstract";
}

- (NSString*)description {
    return @"MatrixModel";
}

- (CNClassType*)type {
    return [PGMatrixModel type];
}

+ (PGMatrixModel*)identity {
    return _PGMatrixModel_identity;
}

+ (CNClassType*)type {
    return _PGMatrixModel_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGImMatrixModel
static CNClassType* _PGImMatrixModel_type;
@synthesize m = _m;
@synthesize w = _w;
@synthesize c = _c;
@synthesize p = _p;

+ (instancetype)imMatrixModelWithM:(PGMat4*)m w:(PGMat4*)w c:(PGMat4*)c p:(PGMat4*)p {
    return [[PGImMatrixModel alloc] initWithM:m w:w c:c p:p];
}

- (instancetype)initWithM:(PGMat4*)m w:(PGMat4*)w c:(PGMat4*)c p:(PGMat4*)p {
    self = [super init];
    if(self) {
        _m = m;
        _w = w;
        _c = c;
        _p = p;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGImMatrixModel class]) _PGImMatrixModel_type = [CNClassType classTypeWithCls:[PGImMatrixModel class]];
}

- (PGMMatrixModel*)mutable {
    return [PGMMatrixModel applyM:_m w:_w c:_c p:_p];
}

- (PGMat4*)mw {
    return [_w mulMatrix:_m];
}

- (PGMat4*)mwc {
    return [_c mulMatrix:[_w mulMatrix:_m]];
}

- (PGMat4*)mwcp {
    return [_p mulMatrix:[_c mulMatrix:[_w mulMatrix:_m]]];
}

- (PGMat4*)cp {
    return [_p mulMatrix:_c];
}

- (PGMat4*)wcp {
    return [_p mulMatrix:[_c mulMatrix:_w]];
}

- (PGMat4*)wc {
    return [_c mulMatrix:_w];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"ImMatrixModel(%@, %@, %@, %@)", _m, _w, _c, _p];
}

- (CNClassType*)type {
    return [PGImMatrixModel type];
}

+ (CNClassType*)type {
    return _PGImMatrixModel_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGMMatrixModel
static CNClassType* _PGMMatrixModel_type;
@synthesize _m = __m;
@synthesize _w = __w;
@synthesize _c = __c;
@synthesize _p = __p;

+ (instancetype)matrixModel {
    return [[PGMMatrixModel alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) {
        __m = [PGMat4 identity];
        __w = [PGMat4 identity];
        __c = [PGMat4 identity];
        __p = [PGMat4 identity];
        __mw = nil;
        __mwc = nil;
        __mwcp = nil;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGMMatrixModel class]) _PGMMatrixModel_type = [CNClassType classTypeWithCls:[PGMMatrixModel class]];
}

- (PGMat4*)m {
    return __m;
}

- (PGMat4*)w {
    return __w;
}

- (PGMat4*)c {
    return __c;
}

- (PGMat4*)p {
    return __p;
}

- (PGMat4*)mw {
    if(__mw == nil) __mw = [__w mulMatrix:__m];
    return ((PGMat4*)(nonnil(__mw)));
}

- (PGMat4*)mwc {
    if(__mwc == nil) __mwc = [__c mulMatrix:[self mw]];
    return ((PGMat4*)(nonnil(__mwc)));
}

- (PGMat4*)mwcp {
    if(__mwcp == nil) __mwcp = [__p mulMatrix:[self mwc]];
    return ((PGMat4*)(nonnil(__mwcp)));
}

- (PGMat4*)cp {
    return [__p mulMatrix:__c];
}

- (PGMat4*)wcp {
    return [__p mulMatrix:[__c mulMatrix:__w]];
}

- (PGMat4*)wc {
    return [__c mulMatrix:__w];
}

- (PGMMatrixModel*)copy {
    return [PGMMatrixModel applyM:[self m] w:[self w] c:[self c] p:[self p]];
}

+ (PGMMatrixModel*)applyMatrixModel:(PGMatrixModel*)matrixModel {
    return [matrixModel mutable];
}

+ (PGMMatrixModel*)applyImMatrixModel:(PGImMatrixModel*)imMatrixModel {
    return [imMatrixModel mutable];
}

+ (PGMMatrixModel*)applyM:(PGMat4*)m w:(PGMat4*)w c:(PGMat4*)c p:(PGMat4*)p {
    PGMMatrixModel* mm = [PGMMatrixModel matrixModel];
    mm._m = m;
    mm._w = w;
    mm._c = c;
    mm._p = p;
    return mm;
}

- (PGMMatrixModel*)mutable {
    return self;
}

- (PGImMatrixModel*)immutable {
    return [PGImMatrixModel imMatrixModelWithM:[self m] w:[self w] c:[self c] p:[self p]];
}

- (PGMMatrixModel*)modifyM:(PGMat4*(^)(PGMat4*))m {
    __m = m(__m);
    __mw = nil;
    __mwc = nil;
    __mwcp = nil;
    return self;
}

- (PGMMatrixModel*)modifyW:(PGMat4*(^)(PGMat4*))w {
    __w = w(__w);
    __mw = nil;
    __mwc = nil;
    __mwcp = nil;
    return self;
}

- (PGMMatrixModel*)modifyC:(PGMat4*(^)(PGMat4*))c {
    __c = c(__c);
    __mwc = nil;
    __mwcp = nil;
    return self;
}

- (PGMMatrixModel*)modifyP:(PGMat4*(^)(PGMat4*))p {
    __p = p(__p);
    __mwcp = nil;
    return self;
}

- (void)clear {
    __m = [PGMat4 identity];
    __w = [PGMat4 identity];
    __c = [PGMat4 identity];
    __p = [PGMat4 identity];
    __mw = nil;
    __mwc = nil;
    __mwcp = nil;
}

- (void)setMatrixModel:(PGMatrixModel*)matrixModel {
    __m = [matrixModel m];
    __w = [matrixModel w];
    __c = [matrixModel c];
    __p = [matrixModel p];
    __mw = nil;
    __mwc = nil;
    __mwcp = nil;
}

- (NSString*)description {
    return @"MMatrixModel";
}

- (CNClassType*)type {
    return [PGMMatrixModel type];
}

+ (CNClassType*)type {
    return _PGMMatrixModel_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

