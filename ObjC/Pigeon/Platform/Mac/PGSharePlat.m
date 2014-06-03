#import "PGSharePlat.h"

#import "PGShare.h"
@implementation PGShareDialog{
    PGShareContent* _content;
    void(^_completionHandler)(PGShareChannelR);
}
static CNClassType* _PGShareDialog_type;
@synthesize content = _content;
@synthesize completionHandler = _completionHandler;

+ (id)shareDialogWithContent:(PGShareContent *)content shareHandler:(void (^)(PGShareChannelR))shareHandler cancelHandler:(void (^)())cancelHandler {
    return [[PGShareDialog alloc] initWithContent:content shareHandler:shareHandler cancelHandler:^{
    }];
}

- (id)initWithContent:(PGShareContent *)content shareHandler:(void (^)(PGShareChannelR))shareHandler cancelHandler:(void (^)())cancelHandler {
    self = [super init];
    if(self) {
        _content = content;
        _completionHandler = shareHandler;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _PGShareDialog_type = [CNClassType classTypeWithCls:[PGShareDialog class]];
}

- (void)display {
    @throw @"Method display is abstract";
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

+ (BOOL)isSupported {
    return NO;
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

- (void)displayFacebook {

}

- (void)displayTwitter {

}
@end


