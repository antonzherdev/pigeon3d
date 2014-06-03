#import "PGShare.h"

#import "PGSharePlat.h"
PGShareChannel* PGShareChannel_Values[5];
PGShareChannel* PGShareChannel_facebook_Desc;
PGShareChannel* PGShareChannel_twitter_Desc;
PGShareChannel* PGShareChannel_email_Desc;
PGShareChannel* PGShareChannel_message_Desc;
@implementation PGShareChannel

+ (instancetype)shareChannelWithOrdinal:(NSUInteger)ordinal name:(NSString*)name {
    return [[PGShareChannel alloc] initWithOrdinal:ordinal name:name];
}

- (instancetype)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name {
    self = [super initWithOrdinal:ordinal name:name];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    PGShareChannel_facebook_Desc = [PGShareChannel shareChannelWithOrdinal:0 name:@"facebook"];
    PGShareChannel_twitter_Desc = [PGShareChannel shareChannelWithOrdinal:1 name:@"twitter"];
    PGShareChannel_email_Desc = [PGShareChannel shareChannelWithOrdinal:2 name:@"email"];
    PGShareChannel_message_Desc = [PGShareChannel shareChannelWithOrdinal:3 name:@"message"];
    PGShareChannel_Values[0] = nil;
    PGShareChannel_Values[1] = PGShareChannel_facebook_Desc;
    PGShareChannel_Values[2] = PGShareChannel_twitter_Desc;
    PGShareChannel_Values[3] = PGShareChannel_email_Desc;
    PGShareChannel_Values[4] = PGShareChannel_message_Desc;
}

+ (NSArray*)values {
    return (@[PGShareChannel_facebook_Desc, PGShareChannel_twitter_Desc, PGShareChannel_email_Desc, PGShareChannel_message_Desc]);
}

+ (PGShareChannel*)value:(PGShareChannelR)r {
    return PGShareChannel_Values[r];
}

@end

@implementation PGShareItem
static CNClassType* _PGShareItem_type;
@synthesize text = _text;
@synthesize subject = _subject;

+ (instancetype)shareItemWithText:(NSString*)text subject:(NSString*)subject {
    return [[PGShareItem alloc] initWithText:text subject:subject];
}

- (instancetype)initWithText:(NSString*)text subject:(NSString*)subject {
    self = [super init];
    if(self) {
        _text = text;
        _subject = subject;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGShareItem class]) _PGShareItem_type = [CNClassType classTypeWithCls:[PGShareItem class]];
}

+ (PGShareItem*)applyText:(NSString*)text {
    return [PGShareItem shareItemWithText:text subject:nil];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"ShareItem(%@, %@)", _text, _subject];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[PGShareItem class]])) return NO;
    PGShareItem* o = ((PGShareItem*)(to));
    return [_text isEqual:o.text] && [_subject isEqual:o.subject];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [_text hash];
    hash = hash * 31 + [_subject hash];
    return hash;
}

- (CNClassType*)type {
    return [PGShareItem type];
}

+ (CNClassType*)type {
    return _PGShareItem_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGShareContent
static CNClassType* _PGShareContent_type;
@synthesize text = _text;
@synthesize image = _image;
@synthesize items = _items;

+ (instancetype)shareContentWithText:(NSString*)text image:(NSString*)image items:(NSDictionary*)items {
    return [[PGShareContent alloc] initWithText:text image:image items:items];
}

- (instancetype)initWithText:(NSString*)text image:(NSString*)image items:(NSDictionary*)items {
    self = [super init];
    if(self) {
        _text = text;
        _image = image;
        _items = items;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGShareContent class]) _PGShareContent_type = [CNClassType classTypeWithCls:[PGShareContent class]];
}

+ (PGShareContent*)applyText:(NSString*)text image:(NSString*)image {
    return [PGShareContent shareContentWithText:text image:image items:(@{})];
}

- (PGShareContent*)addChannel:(PGShareChannelR)channel text:(NSString*)text {
    return [self addChannel:channel text:text subject:nil];
}

- (PGShareContent*)addChannel:(PGShareChannelR)channel text:(NSString*)text subject:(NSString*)subject {
    return [PGShareContent shareContentWithText:_text image:_image items:[_items addItem:tuple([PGShareChannel value:channel], [PGShareItem shareItemWithText:text subject:subject])]];
}

- (PGShareContent*)twitterText:(NSString*)text {
    return [self addChannel:PGShareChannel_twitter text:text];
}

- (PGShareContent*)facebookText:(NSString*)text {
    return [self addChannel:PGShareChannel_facebook text:text];
}

- (PGShareContent*)emailText:(NSString*)text subject:(NSString*)subject {
    return [self addChannel:PGShareChannel_email text:text subject:subject];
}

- (PGShareContent*)messageText:(NSString*)text {
    return [self addChannel:PGShareChannel_message text:text];
}

- (NSString*)textChannel:(PGShareChannelR)channel {
    PGShareItem* __tmp = [_items applyKey:[PGShareChannel value:channel]];
    if(__tmp != nil) return ((PGShareItem*)([_items applyKey:[PGShareChannel value:channel]])).text;
    else return _text;
}

- (NSString*)subjectChannel:(PGShareChannelR)channel {
    return ((PGShareItem*)([_items applyKey:[PGShareChannel value:channel]])).subject;
}

- (NSString*)imageChannel:(PGShareChannelR)channel {
    return _image;
}

- (PGShareDialog*)dialog {
    return [PGShareDialog shareDialogWithContent:self shareHandler:^void(PGShareChannelR _) {
    } cancelHandler:^void() {
    }];
}

- (PGShareDialog*)dialogShareHandler:(void(^)(PGShareChannelR))shareHandler cancelHandler:(void(^)())cancelHandler {
    return [PGShareDialog shareDialogWithContent:self shareHandler:shareHandler cancelHandler:cancelHandler];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"ShareContent(%@, %@, %@)", _text, _image, _items];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[PGShareContent class]])) return NO;
    PGShareContent* o = ((PGShareContent*)(to));
    return [_text isEqual:o.text] && [_image isEqual:o.image] && [_items isEqual:o.items];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [_text hash];
    hash = hash * 31 + [_image hash];
    hash = hash * 31 + [_items hash];
    return hash;
}

- (CNClassType*)type {
    return [PGShareContent type];
}

+ (CNClassType*)type {
    return _PGShareContent_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

