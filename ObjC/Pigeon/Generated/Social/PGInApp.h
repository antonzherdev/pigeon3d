#import "objd.h"
@class CNSignal;

@class PGInAppProduct;
@class PGInAppTransaction;
@class PGInAppTransactionState;

typedef enum PGInAppTransactionStateR {
    PGInAppTransactionState_Nil = 0,
    PGInAppTransactionState_purchasing = 1,
    PGInAppTransactionState_purchased = 2,
    PGInAppTransactionState_failed = 3,
    PGInAppTransactionState_restored = 4
} PGInAppTransactionStateR;
@interface PGInAppTransactionState : CNEnum
+ (NSArray*)values;
+ (PGInAppTransactionState*)value:(PGInAppTransactionStateR)r;
@end


@interface PGInAppProduct : NSObject {
@public
    NSString* _id;
    NSString* _name;
    NSString* _price;
}
@property (nonatomic, readonly) NSString* id;
@property (nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) NSString* price;

+ (instancetype)inAppProductWithId:(NSString*)id name:(NSString*)name price:(NSString*)price;
- (instancetype)initWithId:(NSString*)id name:(NSString*)name price:(NSString*)price;
- (CNClassType*)type;
- (void)buy;
- (void)buyQuantity:(NSUInteger)quantity;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface PGInAppTransaction : NSObject {
@public
    NSString* _productId;
    NSUInteger _quantity;
    PGInAppTransactionStateR _state;
    NSString* _error;
}
@property (nonatomic, readonly) NSString* productId;
@property (nonatomic, readonly) NSUInteger quantity;
@property (nonatomic, readonly) PGInAppTransactionStateR state;
@property (nonatomic, readonly) NSString* error;

+ (instancetype)inAppTransactionWithProductId:(NSString*)productId quantity:(NSUInteger)quantity state:(PGInAppTransactionStateR)state error:(NSString*)error;
- (instancetype)initWithProductId:(NSString*)productId quantity:(NSUInteger)quantity state:(PGInAppTransactionStateR)state error:(NSString*)error;
- (CNClassType*)type;
- (void)finish;
- (NSString*)description;
+ (CNSignal*)changed;
+ (CNSignal*)finished;
+ (CNClassType*)type;
@end


