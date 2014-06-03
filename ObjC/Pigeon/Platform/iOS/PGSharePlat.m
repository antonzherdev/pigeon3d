#import "PGSharePlat.h"

#import "PGShare.h"
#import "PGAlert.h"
#import <Social/Social.h>

@interface PGShareDialog(iOS)<UIActivityItemSource>
@end

@implementation PGShareDialog{
    PGShareContent* _content;
    void(^_shareHandler)(PGShareChannelR);
    void(^_cancelHandler)();
}
static CNClassType* _PGShareDialog_type;


+ (id)shareDialogWithContent:(PGShareContent *)content shareHandler:(void (^)(PGShareChannelR))shareHandler cancelHandler:(void (^)())cancelHandler {
    return [[PGShareDialog alloc] initWithContent:content shareHandler:shareHandler cancelHandler:cancelHandler];
}

- (id)initWithContent:(PGShareContent *)content shareHandler:(void (^)(PGShareChannelR))shareHandler cancelHandler:(void (^)())cancelHandler {
    self = [super init];
    if(self) {
        _content = content;
        _shareHandler = shareHandler;
        _cancelHandler = cancelHandler;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _PGShareDialog_type = [CNClassType classTypeWithCls:[PGShareDialog class]];
}

- (void)display {
    UIImage *image = nil;
    if(_content.image != nil) image = [UIImage imageNamed:_content.image];
    UIActivityViewController * vc = [[UIActivityViewController alloc] initWithActivityItems:image == nil ? @[self] : @[self, image]
                                                                      applicationActivities:nil];
    vc.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,
            UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypePostToWeibo,
            UIActivityTypeSaveToCameraRoll,
            @"com.apple.UIKit.activity.AirDrop",
            @"com.apple.UIKit.activity.AddToReadingList",
            @"com.apple.UIKit.activity.AddToReadingList",
            @"com.apple.UIKit.activity.PostToFlickr",
            @"com.apple.UIKit.activity.PostToVimeo",
            @"com.apple.UIKit.activity.PostToTencentWeibo",
    ];
    [vc setCompletionHandler:^(NSString *activityType, BOOL completed) {
        if(completed) {
            _shareHandler([self channelForActivityType:activityType]);
        } else {
            _cancelHandler();
        }
    }];
    [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:vc animated:YES completion:nil];
}

+ (BOOL)isSupported {
    return YES;
}

- (CNClassType*)type {
    return [PGShareDialog type];
}

+ (CNClassType*)type {
    return _PGShareDialog_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    PGShareDialog* o = ((PGShareDialog*)(other));
    return [self.content isEqual:o.content] && [self.completionHandler isEqual:o.completionHandler];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.content hash];
    hash = hash * 31 + [self.completionHandler hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"content=%@", self.content];
    [description appendString:@">"];
    return description;
}

- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController {
    return _content.text;
}

- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType {
    return [_content textChannel:[self channelForActivityType:activityType]];
}

- (UIImage *)activityViewController:(UIActivityViewController *)activityViewController thumbnailImageForActivityType:(NSString *)activityType suggestedSize:(CGSize)size {
    return nil;
}

- (NSString *)activityViewController:(UIActivityViewController *)activityViewController subjectForActivityType:(NSString *)activityType {
    return  [_content subjectChannel:[self channelForActivityType:activityType]];
}

- (NSString *)activityViewController:(UIActivityViewController *)activityViewController dataTypeIdentifierForActivityType:(NSString *)activityType {
    return nil;
}


- (PGShareChannelR)channelForActivityType:(NSString *)type {
    if([type isEqualToString:UIActivityTypePostToTwitter]) return PGShareChannel_twitter;
    if([type isEqualToString:UIActivityTypePostToFacebook]) return PGShareChannel_facebook;
    if([type isEqualToString:UIActivityTypeMail]) return PGShareChannel_email;
    if([type isEqualToString:UIActivityTypeMessage]) return PGShareChannel_message;
    return PGShareChannel_Nil;
}

- (void)displayFacebook {
    [self displayService:SLServiceTypeFacebook channel:PGShareChannel_facebook];
}

- (void)displayService:(NSString *)type channel:(PGShareChannelR)channel {
//    if([SLComposeViewController isAvailableForServiceType:type]) //check if Facebook Account is linked
//    {
        SLComposeViewController*controller = [SLComposeViewController composeViewControllerForServiceType:type]; //Tell him with what social plattform to use it, e.g. facebook or twitter
        if(controller == nil) {
             [PGAlert showErrorTitle:@"Error" message:@"Unknown error. Maybe the service is not configured."];
            _cancelHandler();
        } else {
            [controller setInitialText:[_content textChannel:channel]]; //the message you want to post
            id img = [_content imageChannel:channel];
            if(img != nil) {
                [controller addImage:[UIImage imageNamed:img]];
            }

            [controller setCompletionHandler:^(SLComposeViewControllerResult result) {
                if(result == SLComposeViewControllerResultDone) {
                    _shareHandler(channel);
                } else {
                    _cancelHandler();
                }
            }];
            [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:controller animated:YES completion:nil];
        }

//    }
}

- (void)displayTwitter {
    [self displayService:SLServiceTypeTwitter channel:PGShareChannel_twitter];
}

@end


