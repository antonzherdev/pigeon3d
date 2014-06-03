#import "PGEMail.h"

@implementation PGEMail
static PGEMail * _EGEMail_instance;
static CNClassType* _EGEMail_type;

+ (id)mail {
    return [[PGEMail alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGEMail_type = [CNClassType classTypeWithCls:[PGEMail class]];
    _EGEMail_instance = [PGEMail mail];
}

- (void)showInterfaceTo:(NSString *)to subject:(NSString *)subject text:(NSString *)text htmlText:(NSString *)text1 {
    NSString* mailtoAddress = [NSString stringWithFormat:@"mailto:%@?subject=%@&body=%@", to, [subject encodeForURL], [text encodeForURL]];
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:mailtoAddress]];
}

- (CNClassType*)type {
    return [PGEMail type];
}

+ (PGEMail *)instance {
    return _EGEMail_instance;
}

+ (CNClassType*)type {
    return _EGEMail_type;
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


