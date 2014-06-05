#import "objd.h"
@class PGShareDialog;

@class PGShareItem;
@class PGShareContent;
@class PGShareChannel;

typedef enum PGShareChannelR {
    PGShareChannel_Nil = 0,
    PGShareChannel_facebook = 1,
    PGShareChannel_twitter = 2,
    PGShareChannel_email = 3,
    PGShareChannel_message = 4
} PGShareChannelR;
@interface PGShareChannel : CNEnum
+ (NSArray*)values;
+ (PGShareChannel*)value:(PGShareChannelR)r;
@end


@interface PGShareItem : NSObject {
@public
    NSString* _text;
    NSString* _subject;
}
@property (nonatomic, readonly) NSString* text;
@property (nonatomic, readonly) NSString* subject;

+ (instancetype)shareItemWithText:(NSString*)text subject:(NSString*)subject;
- (instancetype)initWithText:(NSString*)text subject:(NSString*)subject;
- (CNClassType*)type;
+ (PGShareItem*)applyText:(NSString*)text;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface PGShareContent : NSObject {
@public
    NSString* _text;
    NSString* _image;
    NSDictionary* _items;
}
@property (nonatomic, readonly) NSString* text;
@property (nonatomic, readonly) NSString* image;
@property (nonatomic, readonly) NSDictionary* items;

+ (instancetype)shareContentWithText:(NSString*)text image:(NSString*)image items:(NSDictionary*)items;
- (instancetype)initWithText:(NSString*)text image:(NSString*)image items:(NSDictionary*)items;
- (CNClassType*)type;
+ (PGShareContent*)applyText:(NSString*)text image:(NSString*)image;
- (PGShareContent*)addChannel:(PGShareChannelR)channel text:(NSString*)text;
- (PGShareContent*)addChannel:(PGShareChannelR)channel text:(NSString*)text subject:(NSString*)subject;
- (PGShareContent*)twitterText:(NSString*)text;
- (PGShareContent*)facebookText:(NSString*)text;
- (PGShareContent*)emailText:(NSString*)text subject:(NSString*)subject;
- (PGShareContent*)messageText:(NSString*)text;
- (NSString*)textChannel:(PGShareChannelR)channel;
- (NSString*)subjectChannel:(PGShareChannelR)channel;
- (NSString*)imageChannel:(PGShareChannelR)channel;
- (PGShareDialog*)dialog;
- (PGShareDialog*)dialogShareHandler:(void(^)(PGShareChannelR))shareHandler cancelHandler:(void(^)())cancelHandler;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


