#import "PGInApp.h"

#import "CNObserver.h"
@implementation PGInAppProduct
static CNClassType* _PGInAppProduct_type;
@synthesize id = _id;
@synthesize name = _name;
@synthesize price = _price;

+ (instancetype)inAppProductWithId:(NSString*)id name:(NSString*)name price:(NSString*)price {
    return [[PGInAppProduct alloc] initWithId:id name:name price:price];
}

- (instancetype)initWithId:(NSString*)id name:(NSString*)name price:(NSString*)price {
    self = [super init];
    if(self) {
        _id = id;
        _name = name;
        _price = price;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGInAppProduct class]) _PGInAppProduct_type = [CNClassType classTypeWithCls:[PGInAppProduct class]];
}

- (void)buy {
    [self buyQuantity:1];
}

- (void)buyQuantity:(NSUInteger)quantity {
    @throw @"Method buy is abstract";
}

- (NSString*)description {
    return [NSString stringWithFormat:@"InAppProduct(%@, %@, %@)", _id, _name, _price];
}

- (CNClassType*)type {
    return [PGInAppProduct type];
}

+ (CNClassType*)type {
    return _PGInAppProduct_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGInAppTransaction
static CNSignal* _PGInAppTransaction_changed;
static CNSignal* _PGInAppTransaction_finished;
static CNClassType* _PGInAppTransaction_type;
@synthesize productId = _productId;
@synthesize quantity = _quantity;
@synthesize state = _state;
@synthesize error = _error;

+ (instancetype)inAppTransactionWithProductId:(NSString*)productId quantity:(NSUInteger)quantity state:(PGInAppTransactionStateR)state error:(NSString*)error {
    return [[PGInAppTransaction alloc] initWithProductId:productId quantity:quantity state:state error:error];
}

- (instancetype)initWithProductId:(NSString*)productId quantity:(NSUInteger)quantity state:(PGInAppTransactionStateR)state error:(NSString*)error {
    self = [super init];
    if(self) {
        _productId = productId;
        _quantity = quantity;
        _state = state;
        _error = error;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGInAppTransaction class]) {
        _PGInAppTransaction_type = [CNClassType classTypeWithCls:[PGInAppTransaction class]];
        _PGInAppTransaction_changed = [CNSignal signal];
        _PGInAppTransaction_finished = [CNSignal signal];
    }
}

- (void)finish {
    [_PGInAppTransaction_finished postData:self];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"InAppTransaction(%@, %lu, %@, %@)", _productId, (unsigned long)_quantity, [PGInAppTransactionState value:_state], _error];
}

- (CNClassType*)type {
    return [PGInAppTransaction type];
}

+ (CNSignal*)changed {
    return _PGInAppTransaction_changed;
}

+ (CNSignal*)finished {
    return _PGInAppTransaction_finished;
}

+ (CNClassType*)type {
    return _PGInAppTransaction_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

PGInAppTransactionState* PGInAppTransactionState_Values[5];
PGInAppTransactionState* PGInAppTransactionState_purchasing_Desc;
PGInAppTransactionState* PGInAppTransactionState_purchased_Desc;
PGInAppTransactionState* PGInAppTransactionState_failed_Desc;
PGInAppTransactionState* PGInAppTransactionState_restored_Desc;
@implementation PGInAppTransactionState

+ (instancetype)inAppTransactionStateWithOrdinal:(NSUInteger)ordinal name:(NSString*)name {
    return [[PGInAppTransactionState alloc] initWithOrdinal:ordinal name:name];
}

- (instancetype)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name {
    self = [super initWithOrdinal:ordinal name:name];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    PGInAppTransactionState_purchasing_Desc = [PGInAppTransactionState inAppTransactionStateWithOrdinal:0 name:@"purchasing"];
    PGInAppTransactionState_purchased_Desc = [PGInAppTransactionState inAppTransactionStateWithOrdinal:1 name:@"purchased"];
    PGInAppTransactionState_failed_Desc = [PGInAppTransactionState inAppTransactionStateWithOrdinal:2 name:@"failed"];
    PGInAppTransactionState_restored_Desc = [PGInAppTransactionState inAppTransactionStateWithOrdinal:3 name:@"restored"];
    PGInAppTransactionState_Values[0] = nil;
    PGInAppTransactionState_Values[1] = PGInAppTransactionState_purchasing_Desc;
    PGInAppTransactionState_Values[2] = PGInAppTransactionState_purchased_Desc;
    PGInAppTransactionState_Values[3] = PGInAppTransactionState_failed_Desc;
    PGInAppTransactionState_Values[4] = PGInAppTransactionState_restored_Desc;
}

+ (NSArray*)values {
    return (@[PGInAppTransactionState_purchasing_Desc, PGInAppTransactionState_purchased_Desc, PGInAppTransactionState_failed_Desc, PGInAppTransactionState_restored_Desc]);
}

+ (PGInAppTransactionState*)value:(PGInAppTransactionStateR)r {
    return PGInAppTransactionState_Values[r];
}

@end

