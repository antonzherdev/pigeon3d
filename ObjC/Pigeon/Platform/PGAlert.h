#import "objd.h"

@class PGAlert;

@interface PGAlert : NSObject
+ (id)alert;
- (id)init;
- (CNClassType*)type;

+ (void)showErrorTitle:(NSString *)title message:(NSString *)message callback:(void (^)())callback;
+ (CNClassType*)type;

+ (void)showErrorTitle:(NSString *)error message:(NSString *)message;
@end


