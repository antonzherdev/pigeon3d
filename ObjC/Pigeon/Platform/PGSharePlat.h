#import "objd.h"
#import "PGShare.h"

@class PGShareContent;

@class PGShareDialog;
@class PGShareChannel;

@interface PGShareDialog : NSObject
@property (nonatomic, readonly) PGShareContent* content;
@property (nonatomic, readonly) void(^completionHandler)(PGShareChannelR);

+ (id)shareDialogWithContent:(PGShareContent*)content shareHandler:(void (^)(PGShareChannelR))shareHandler cancelHandler:(void (^)())cancelHandler;

- (id)initWithContent:(PGShareContent *)content shareHandler:(void (^)(PGShareChannelR))shareHandler cancelHandler:(void (^)())cancelHandler;
- (CNClassType*)type;
- (void)display;
+ (CNClassType*)type;

- (void)displayFacebook;

+ (BOOL)isSupported;

- (void)displayTwitter;
@end


