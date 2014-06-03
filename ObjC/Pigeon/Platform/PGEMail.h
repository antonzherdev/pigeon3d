#import "objd.h"

@class PGEMail;

#if TARGET_OS_IPHONE
#import <MessageUI/MFMailComposeViewController.h>

@interface EGEMail : NSObject <MFMailComposeViewControllerDelegate>
#else
@interface PGEMail : NSObject
#endif
+ (id)mail;
- (id)init;
- (CNClassType*)type;

- (void)showInterfaceTo:(NSString *)to subject:(NSString *)subject text:(NSString *)text htmlText:(NSString *)text1;
+ (PGEMail *)instance;
+ (CNClassType*)type;
@end


