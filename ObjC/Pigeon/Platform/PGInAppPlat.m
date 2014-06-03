#import "PGInAppPlat.h"
#import "CNChain.h"
#import "CNObserver.h"

@class PGInAppProductRequestDelegate;

static NSArray* _curDelegates;
static NSMutableDictionary* _PGInApp_products;

@interface PGInAppProductRequestDelegate : NSObject<SKProductsRequestDelegate>
- (instancetype)initWithCallback:(void (^)(id <CNSeq>))callback onError:(void (^)(NSString *))error;

+ (instancetype)delegateWithCallback:(void (^)(id <CNSeq>))callback onError:(void (^)(NSString *))error;

@end

@implementation PGInAppProductRequestDelegate {
    void(^_callback)(id<CNSeq>);
    void(^_onError)(NSString*);
}
- (instancetype)initWithCallback:(void (^)(id <CNSeq>))callback onError:(void (^)(NSString *))error {
    self = [super init];
    if (self) {
        _callback = callback;
        _onError = error;
    }

    return self;
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
//    NSLog(@"In-app purchases prices did receive response");
    for(NSString* id in response.invalidProductIdentifiers) {
        NSLog(@"Invalid in-app id: %@", id);
    }
    NSArray *products = [[[response.products chain] mapF:^PGInAppProduct *(SKProduct *x) {
        return [PGInAppProductPlat platWithProduct:x];
    }] toArray];
    [products forEach:^(PGInAppProductPlat* x) {
        [_PGInApp_products setObject:x forKey:x.id];
    }];
    _callback(products);
}

- (void)requestDidFinish:(SKRequest *)request {
//    NSLog(@"In-app purchases prices finished");
    @synchronized (_curDelegates) {
        _curDelegates = [_curDelegates arrayByRemovingObject:self];
    }
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"Error in request in-app purchases prices: %@", error);
    _onError(error.localizedDescription);
    @synchronized (_curDelegates) {
        _curDelegates = [_curDelegates arrayByRemovingObject:self];
    }
}


+ (instancetype)delegateWithCallback:(void (^)(id <CNSeq>))callback onError:(void (^)(NSString *))error {
    return [[self alloc] initWithCallback:callback onError:error];
}

@end


@interface PGInAppObserver : NSObject <SKPaymentTransactionObserver>
@end

@implementation PGInAppObserver
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for(SKPaymentTransaction * transaction in transactions) {
        [[PGInAppTransaction changed] postData:[PGInAppTransactionPlat platWithTransaction:transaction]];
    }
}
@end


@implementation PGInApp
static CNClassType* _PGInApp_type;
static PGInAppObserver* _PGInApp_observer;


+ (void)load {
    [super load];
    _PGInApp_observer = [[PGInAppObserver alloc] init];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:_PGInApp_observer];
}


+ (void)initialize {
    [super initialize];
    _curDelegates = [NSArray array];
    _PGInApp_type = [CNClassType classTypeWithCls:[PGInApp class]];
    _PGInApp_products = [NSMutableDictionary dictionary];
}

+ (void)getFromCacheOrLoadProduct:(NSString *)idd callback:(void (^)(PGInAppProduct *))callback onError:(void (^)(NSString *))error {
    PGInAppProduct* product = [_PGInApp_products objectForKey:idd];
    if(product != nil) {
        callback(product);
    } else {
        NSArray *ids = @[idd];
        [PGInApp loadProductsIds:ids
                        callback:^void(id <CNSeq> products) {
                            id o = [products head];
                            if(o != nil) callback(o);
                        }
                        onError:error];
    }
}

+ (void)loadProductsIds:(id <CNSeq>)ids callback:(void (^)(id <CNSeq>))callback onError:(void (^)(NSString *))error {
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[ids convertWithBuilder:[CNHashSetBuilder hashSetBuilderWithCapacity:0]]];
    PGInAppProductRequestDelegate *del = [PGInAppProductRequestDelegate delegateWithCallback:callback onError:error];
    @synchronized (_curDelegates) {
        _curDelegates = [_curDelegates arrayByAddingObject:del];
    }
    productsRequest.delegate = del;
    [productsRequest start];
}

- (CNClassType*)type {
    return [PGInApp type];
}

+ (CNClassType*)type {
    return _PGInApp_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    return YES;
}

- (NSUInteger)hash {
    return 0;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}
@end


@implementation PGInAppProductPlat {
    SKProduct* _product;
}
- (instancetype)initWithProduct:(SKProduct *)x {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:x.priceLocale];
    NSString *formattedString = [numberFormatter stringFromNumber:x.price];
    self = [super initWithId:x.productIdentifier name:x.localizedTitle price:formattedString];
    if (self) {
        _product = x;
    }

    return self;
}

+ (instancetype)platWithProduct:(SKProduct *)product {
    return [[self alloc] initWithProduct:product];
}

- (void)buyQuantity:(NSUInteger)quantity {
    SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:_product];
    payment.quantity = quantity;
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

@end

@implementation PGInAppTransactionPlat {
    SKPaymentTransaction * _transaction;
}
- (instancetype)initWithTransaction:(SKPaymentTransaction *)transaction {
    PGInAppTransactionStateR state;
    if(transaction.transactionState == SKPaymentTransactionStateFailed) {
        NSLog(@"In-App: %@: Error in transaction %@", transaction.payment.productIdentifier, transaction.error);
        state = PGInAppTransactionState_failed;
    } else if(transaction.transactionState == SKPaymentTransactionStatePurchasing) {
        NSLog(@"In-App: %@: purchasing", transaction.payment.productIdentifier);
        state = PGInAppTransactionState_purchasing;
    } else if(transaction.transactionState == SKPaymentTransactionStatePurchased) {
        NSLog(@"In-App: %@: purchased", transaction.payment.productIdentifier);
        state = PGInAppTransactionState_purchased;
    } else if(transaction.transactionState == SKPaymentTransactionStateRestored) {
        NSLog(@"In-App: %@: restored", transaction.payment.productIdentifier);
        state = PGInAppTransactionState_restored;
    } else {
        NSLog(@"In-App: %@: unknown state %li", transaction.payment.productIdentifier, (long)transaction.transactionState);
        state = PGInAppTransactionState_Nil;
    }
    self = [super initWithProductId:transaction.payment.productIdentifier
                           quantity:(NSUInteger)transaction.payment.quantity
                              state:state
                              error:transaction.error.localizedDescription
    ];
    if (self) {
        _transaction = transaction;
    }

    return self;
}

+ (instancetype)platWithTransaction:(SKPaymentTransaction *)transaction {
    return [[self alloc] initWithTransaction:transaction];
}


- (void)finish {
    [[SKPaymentQueue defaultQueue] finishTransaction:_transaction];
    [super finish];
}

@end