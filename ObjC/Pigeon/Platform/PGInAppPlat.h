#import "objd.h"
#import <StoreKit/StoreKit.h>
#import "PGInApp.h"

@class PGInApp;

@interface PGInApp : NSObject
- (CNClassType*)type;

+ (void)loadProductsIds:(id <CNSeq>)ids callback:(void (^)(id <CNSeq>))callback onError:(void (^)(NSString *))error;

+ (void)getFromCacheOrLoadProduct:(NSString *)id callback:(void (^)(PGInAppProduct *))callback onError:(void (^)(NSString *))error;
+ (CNClassType*)type;
@end


@interface PGInAppProductPlat : PGInAppProduct
@property(nonatomic, strong) SKProduct *product;

- (instancetype)initWithProduct:(SKProduct *)product;

+ (instancetype)platWithProduct:(SKProduct *)product;

@end


@interface PGInAppTransactionPlat : PGInAppTransaction
- (instancetype)initWithTransaction:(SKPaymentTransaction *)transaction;

+ (instancetype)platWithTransaction:(SKPaymentTransaction *)transaction;

@end
