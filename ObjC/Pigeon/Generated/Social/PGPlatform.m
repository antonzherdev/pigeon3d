#import "PGPlatform.h"

#import "CNChain.h"
PGOSType* PGOSType_Values[3];
PGOSType* PGOSType_MacOS_Desc;
PGOSType* PGOSType_iOS_Desc;
@implementation PGOSType{
    BOOL _shadows;
    BOOL _touch;
}
@synthesize shadows = _shadows;
@synthesize touch = _touch;

+ (instancetype)typeWithOrdinal:(NSUInteger)ordinal name:(NSString*)name shadows:(BOOL)shadows touch:(BOOL)touch {
    return [[PGOSType alloc] initWithOrdinal:ordinal name:name shadows:shadows touch:touch];
}

- (instancetype)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name shadows:(BOOL)shadows touch:(BOOL)touch {
    self = [super initWithOrdinal:ordinal name:name];
    if(self) {
        _shadows = shadows;
        _touch = touch;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    PGOSType_MacOS_Desc = [PGOSType typeWithOrdinal:0 name:@"MacOS" shadows:YES touch:NO];
    PGOSType_iOS_Desc = [PGOSType typeWithOrdinal:1 name:@"iOS" shadows:YES touch:YES];
    PGOSType_Values[0] = nil;
    PGOSType_Values[1] = PGOSType_MacOS_Desc;
    PGOSType_Values[2] = PGOSType_iOS_Desc;
}

+ (NSArray*)values {
    return (@[PGOSType_MacOS_Desc, PGOSType_iOS_Desc]);
}

+ (PGOSType*)value:(PGOSTypeR)r {
    return PGOSType_Values[r];
}

@end

PGInterfaceIdiom* PGInterfaceIdiom_Values[4];
PGInterfaceIdiom* PGInterfaceIdiom_phone_Desc;
PGInterfaceIdiom* PGInterfaceIdiom_pad_Desc;
PGInterfaceIdiom* PGInterfaceIdiom_computer_Desc;
@implementation PGInterfaceIdiom{
    BOOL _isPhone;
    BOOL _isPad;
    BOOL _isComputer;
}
@synthesize isPhone = _isPhone;
@synthesize isPad = _isPad;
@synthesize isComputer = _isComputer;

+ (instancetype)interfaceIdiomWithOrdinal:(NSUInteger)ordinal name:(NSString*)name isPhone:(BOOL)isPhone isPad:(BOOL)isPad isComputer:(BOOL)isComputer {
    return [[PGInterfaceIdiom alloc] initWithOrdinal:ordinal name:name isPhone:isPhone isPad:isPad isComputer:isComputer];
}

- (instancetype)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name isPhone:(BOOL)isPhone isPad:(BOOL)isPad isComputer:(BOOL)isComputer {
    self = [super initWithOrdinal:ordinal name:name];
    if(self) {
        _isPhone = isPhone;
        _isPad = isPad;
        _isComputer = isComputer;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    PGInterfaceIdiom_phone_Desc = [PGInterfaceIdiom interfaceIdiomWithOrdinal:0 name:@"phone" isPhone:YES isPad:NO isComputer:NO];
    PGInterfaceIdiom_pad_Desc = [PGInterfaceIdiom interfaceIdiomWithOrdinal:1 name:@"pad" isPhone:NO isPad:YES isComputer:NO];
    PGInterfaceIdiom_computer_Desc = [PGInterfaceIdiom interfaceIdiomWithOrdinal:2 name:@"computer" isPhone:NO isPad:NO isComputer:YES];
    PGInterfaceIdiom_Values[0] = nil;
    PGInterfaceIdiom_Values[1] = PGInterfaceIdiom_phone_Desc;
    PGInterfaceIdiom_Values[2] = PGInterfaceIdiom_pad_Desc;
    PGInterfaceIdiom_Values[3] = PGInterfaceIdiom_computer_Desc;
}

+ (NSArray*)values {
    return (@[PGInterfaceIdiom_phone_Desc, PGInterfaceIdiom_pad_Desc, PGInterfaceIdiom_computer_Desc]);
}

+ (PGInterfaceIdiom*)value:(PGInterfaceIdiomR)r {
    return PGInterfaceIdiom_Values[r];
}

@end

PGDeviceType* PGDeviceType_Values[6];
PGDeviceType* PGDeviceType_iPhone_Desc;
PGDeviceType* PGDeviceType_iPad_Desc;
PGDeviceType* PGDeviceType_iPodTouch_Desc;
PGDeviceType* PGDeviceType_Simulator_Desc;
PGDeviceType* PGDeviceType_Mac_Desc;
@implementation PGDeviceType

+ (instancetype)deviceTypeWithOrdinal:(NSUInteger)ordinal name:(NSString*)name {
    return [[PGDeviceType alloc] initWithOrdinal:ordinal name:name];
}

- (instancetype)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name {
    self = [super initWithOrdinal:ordinal name:name];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    PGDeviceType_iPhone_Desc = [PGDeviceType deviceTypeWithOrdinal:0 name:@"iPhone"];
    PGDeviceType_iPad_Desc = [PGDeviceType deviceTypeWithOrdinal:1 name:@"iPad"];
    PGDeviceType_iPodTouch_Desc = [PGDeviceType deviceTypeWithOrdinal:2 name:@"iPodTouch"];
    PGDeviceType_Simulator_Desc = [PGDeviceType deviceTypeWithOrdinal:3 name:@"Simulator"];
    PGDeviceType_Mac_Desc = [PGDeviceType deviceTypeWithOrdinal:4 name:@"Mac"];
    PGDeviceType_Values[0] = nil;
    PGDeviceType_Values[1] = PGDeviceType_iPhone_Desc;
    PGDeviceType_Values[2] = PGDeviceType_iPad_Desc;
    PGDeviceType_Values[3] = PGDeviceType_iPodTouch_Desc;
    PGDeviceType_Values[4] = PGDeviceType_Simulator_Desc;
    PGDeviceType_Values[5] = PGDeviceType_Mac_Desc;
}

+ (NSArray*)values {
    return (@[PGDeviceType_iPhone_Desc, PGDeviceType_iPad_Desc, PGDeviceType_iPodTouch_Desc, PGDeviceType_Simulator_Desc, PGDeviceType_Mac_Desc]);
}

+ (PGDeviceType*)value:(PGDeviceTypeR)r {
    return PGDeviceType_Values[r];
}

@end

@implementation PGOS
static CNClassType* _PGOS_type;
@synthesize tp = _tp;
@synthesize version = _version;
@synthesize jailbreak = _jailbreak;

+ (instancetype)sWithTp:(PGOSTypeR)tp version:(PGVersion*)version jailbreak:(BOOL)jailbreak {
    return [[PGOS alloc] initWithTp:tp version:version jailbreak:jailbreak];
}

- (instancetype)initWithTp:(PGOSTypeR)tp version:(PGVersion*)version jailbreak:(BOOL)jailbreak {
    self = [super init];
    if(self) {
        _tp = tp;
        _version = version;
        _jailbreak = jailbreak;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGOS class]) _PGOS_type = [CNClassType classTypeWithCls:[PGOS class]];
}

- (BOOL)isIOS {
    return _tp == PGOSType_iOS;
}

- (BOOL)isIOSLessVersion:(NSString*)version {
    return _tp == PGOSType_iOS && [_version lessThan:version];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"OS(%@, %@, %d)", [PGOSType value:_tp], _version, _jailbreak];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[PGOS class]])) return NO;
    PGOS* o = ((PGOS*)(to));
    return _tp == o.tp && [_version isEqual:o.version] && _jailbreak == o.jailbreak;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [[PGOSType value:_tp] hash];
    hash = hash * 31 + [_version hash];
    hash = hash * 31 + _jailbreak;
    return hash;
}

- (CNClassType*)type {
    return [PGOS type];
}

+ (CNClassType*)type {
    return _PGOS_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGDevice
static CNClassType* _PGDevice_type;
@synthesize tp = _tp;
@synthesize interfaceIdiom = _interfaceIdiom;
@synthesize version = _version;
@synthesize screenSize = _screenSize;

+ (instancetype)deviceWithTp:(PGDeviceTypeR)tp interfaceIdiom:(PGInterfaceIdiomR)interfaceIdiom version:(PGVersion*)version screenSize:(PGVec2)screenSize {
    return [[PGDevice alloc] initWithTp:tp interfaceIdiom:interfaceIdiom version:version screenSize:screenSize];
}

- (instancetype)initWithTp:(PGDeviceTypeR)tp interfaceIdiom:(PGInterfaceIdiomR)interfaceIdiom version:(PGVersion*)version screenSize:(PGVec2)screenSize {
    self = [super init];
    if(self) {
        _tp = tp;
        _interfaceIdiom = interfaceIdiom;
        _version = version;
        _screenSize = screenSize;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGDevice class]) _PGDevice_type = [CNClassType classTypeWithCls:[PGDevice class]];
}

- (BOOL)isIPhoneLessVersion:(NSString*)version {
    return _tp == PGDeviceType_iPhone && [_version lessThan:version];
}

- (BOOL)isIPodTouchLessVersion:(NSString*)version {
    return _tp == PGDeviceType_iPodTouch && [_version lessThan:version];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Device(%@, %@, %@, %@)", [PGDeviceType value:_tp], [PGInterfaceIdiom value:_interfaceIdiom], _version, pgVec2Description(_screenSize)];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[PGDevice class]])) return NO;
    PGDevice* o = ((PGDevice*)(to));
    return _tp == o.tp && _interfaceIdiom == o.interfaceIdiom && [_version isEqual:o.version] && pgVec2IsEqualTo(_screenSize, o.screenSize);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [[PGDeviceType value:_tp] hash];
    hash = hash * 31 + [[PGInterfaceIdiom value:_interfaceIdiom] hash];
    hash = hash * 31 + [_version hash];
    hash = hash * 31 + pgVec2Hash(_screenSize);
    return hash;
}

- (CNClassType*)type {
    return [PGDevice type];
}

+ (CNClassType*)type {
    return _PGDevice_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGPlatform
static CNClassType* _PGPlatform_type;
@synthesize os = _os;
@synthesize device = _device;
@synthesize text = _text;
@synthesize shadows = _shadows;
@synthesize touch = _touch;
@synthesize interfaceIdiom = _interfaceIdiom;
@synthesize isPhone = _isPhone;
@synthesize isPad = _isPad;
@synthesize isComputer = _isComputer;

+ (instancetype)platformWithOs:(PGOS*)os device:(PGDevice*)device text:(NSString*)text {
    return [[PGPlatform alloc] initWithOs:os device:device text:text];
}

- (instancetype)initWithOs:(PGOS*)os device:(PGDevice*)device text:(NSString*)text {
    self = [super init];
    if(self) {
        _os = os;
        _device = device;
        _text = text;
        _shadows = [PGOSType value:os.tp].shadows;
        _touch = [PGOSType value:os.tp].touch;
        _interfaceIdiom = device.interfaceIdiom;
        _isPhone = [PGInterfaceIdiom value:_interfaceIdiom].isPhone;
        _isPad = [PGInterfaceIdiom value:_interfaceIdiom].isPad;
        _isComputer = [PGInterfaceIdiom value:_interfaceIdiom].isComputer;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGPlatform class]) _PGPlatform_type = [CNClassType classTypeWithCls:[PGPlatform class]];
}

- (PGVec2)screenSize {
    return _device.screenSize;
}

- (CGFloat)screenSizeRatio {
    return ((CGFloat)([self screenSize].x / [self screenSize].y));
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Platform(%@, %@, %@)", _os, _device, _text];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[PGPlatform class]])) return NO;
    PGPlatform* o = ((PGPlatform*)(to));
    return [_os isEqual:o.os] && [_device isEqual:o.device] && [_text isEqual:o.text];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [_os hash];
    hash = hash * 31 + [_device hash];
    hash = hash * 31 + [_text hash];
    return hash;
}

- (CNClassType*)type {
    return [PGPlatform type];
}

+ (CNClassType*)type {
    return _PGPlatform_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGVersion
static CNClassType* _PGVersion_type;
@synthesize parts = _parts;

+ (instancetype)versionWithParts:(NSArray*)parts {
    return [[PGVersion alloc] initWithParts:parts];
}

- (instancetype)initWithParts:(NSArray*)parts {
    self = [super init];
    if(self) _parts = parts;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGVersion class]) _PGVersion_type = [CNClassType classTypeWithCls:[PGVersion class]];
}

+ (PGVersion*)applyStr:(NSString*)str {
    return [PGVersion versionWithParts:[[[[str splitBy:@"."] chain] mapF:^id(NSString* _) {
        return numi([_ toInt]);
    }] toArray]];
}

- (NSInteger)compareTo:(PGVersion*)to {
    id<CNIterator> i = [_parts iterator];
    id<CNIterator> j = [((PGVersion*)(to)).parts iterator];
    while([i hasNext] && [j hasNext]) {
        NSInteger vi = unumi([i next]);
        NSInteger vj = unumi([j next]);
        if(vi != vj) return intCompareTo(vi, vj);
    }
    return 0;
}

- (BOOL)lessThan:(NSString*)than {
    return [self compareTo:[PGVersion applyStr:than]] < 0;
}

- (BOOL)moreThan:(NSString*)than {
    return [self compareTo:[PGVersion applyStr:than]] > 0;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Version(%@)", _parts];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[PGVersion class]])) return NO;
    PGVersion* o = ((PGVersion*)(to));
    return [_parts isEqual:o.parts];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [_parts hash];
    return hash;
}

- (CNClassType*)type {
    return [PGVersion type];
}

+ (CNClassType*)type {
    return _PGVersion_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

