#import "objd.h"
#import "PGVec.h"
@class CNChain;

@class PGOS;
@class PGDevice;
@class PGPlatform;
@class PGVersion;
@class PGOSType;
@class PGInterfaceIdiom;
@class PGDeviceType;

typedef enum PGOSTypeR {
    PGOSType_Nil = 0,
    PGOSType_MacOS = 1,
    PGOSType_iOS = 2
} PGOSTypeR;
@interface PGOSType : CNEnum
@property (nonatomic, readonly) BOOL shadows;
@property (nonatomic, readonly) BOOL touch;

+ (NSArray*)values;
+ (PGOSType*)value:(PGOSTypeR)r;
@end


typedef enum PGInterfaceIdiomR {
    PGInterfaceIdiom_Nil = 0,
    PGInterfaceIdiom_phone = 1,
    PGInterfaceIdiom_pad = 2,
    PGInterfaceIdiom_computer = 3
} PGInterfaceIdiomR;
@interface PGInterfaceIdiom : CNEnum
@property (nonatomic, readonly) BOOL isPhone;
@property (nonatomic, readonly) BOOL isPad;
@property (nonatomic, readonly) BOOL isComputer;

+ (NSArray*)values;
+ (PGInterfaceIdiom*)value:(PGInterfaceIdiomR)r;
@end


typedef enum PGDeviceTypeR {
    PGDeviceType_Nil = 0,
    PGDeviceType_iPhone = 1,
    PGDeviceType_iPad = 2,
    PGDeviceType_iPodTouch = 3,
    PGDeviceType_Simulator = 4,
    PGDeviceType_Mac = 5
} PGDeviceTypeR;
@interface PGDeviceType : CNEnum
+ (NSArray*)values;
+ (PGDeviceType*)value:(PGDeviceTypeR)r;
@end


@interface PGOS : NSObject {
@protected
    PGOSTypeR _tp;
    PGVersion* _version;
    BOOL _jailbreak;
}
@property (nonatomic, readonly) PGOSTypeR tp;
@property (nonatomic, readonly) PGVersion* version;
@property (nonatomic, readonly) BOOL jailbreak;

+ (instancetype)sWithTp:(PGOSTypeR)tp version:(PGVersion*)version jailbreak:(BOOL)jailbreak;
- (instancetype)initWithTp:(PGOSTypeR)tp version:(PGVersion*)version jailbreak:(BOOL)jailbreak;
- (CNClassType*)type;
- (BOOL)isIOS;
- (BOOL)isIOSLessVersion:(NSString*)version;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface PGDevice : NSObject {
@protected
    PGDeviceTypeR _tp;
    PGInterfaceIdiomR _interfaceIdiom;
    PGVersion* _version;
    PGVec2 _screenSize;
}
@property (nonatomic, readonly) PGDeviceTypeR tp;
@property (nonatomic, readonly) PGInterfaceIdiomR interfaceIdiom;
@property (nonatomic, readonly) PGVersion* version;
@property (nonatomic, readonly) PGVec2 screenSize;

+ (instancetype)deviceWithTp:(PGDeviceTypeR)tp interfaceIdiom:(PGInterfaceIdiomR)interfaceIdiom version:(PGVersion*)version screenSize:(PGVec2)screenSize;
- (instancetype)initWithTp:(PGDeviceTypeR)tp interfaceIdiom:(PGInterfaceIdiomR)interfaceIdiom version:(PGVersion*)version screenSize:(PGVec2)screenSize;
- (CNClassType*)type;
- (BOOL)isIPhoneLessVersion:(NSString*)version;
- (BOOL)isIPodTouchLessVersion:(NSString*)version;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface PGPlatform : NSObject {
@protected
    PGOS* _os;
    PGDevice* _device;
    NSString* _text;
    BOOL _shadows;
    BOOL _touch;
    PGInterfaceIdiomR _interfaceIdiom;
    BOOL _isPhone;
    BOOL _isPad;
    BOOL _isComputer;
}
@property (nonatomic, readonly) PGOS* os;
@property (nonatomic, readonly) PGDevice* device;
@property (nonatomic, readonly) NSString* text;
@property (nonatomic, readonly) BOOL shadows;
@property (nonatomic, readonly) BOOL touch;
@property (nonatomic, readonly) PGInterfaceIdiomR interfaceIdiom;
@property (nonatomic, readonly) BOOL isPhone;
@property (nonatomic, readonly) BOOL isPad;
@property (nonatomic, readonly) BOOL isComputer;

+ (instancetype)platformWithOs:(PGOS*)os device:(PGDevice*)device text:(NSString*)text;
- (instancetype)initWithOs:(PGOS*)os device:(PGDevice*)device text:(NSString*)text;
- (CNClassType*)type;
- (PGVec2)screenSize;
- (CGFloat)screenSizeRatio;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface PGVersion : NSObject<CNComparable> {
@protected
    NSArray* _parts;
}
@property (nonatomic, readonly) NSArray* parts;

+ (instancetype)versionWithParts:(NSArray*)parts;
- (instancetype)initWithParts:(NSArray*)parts;
- (CNClassType*)type;
+ (PGVersion*)applyStr:(NSString*)str;
- (NSInteger)compareTo:(PGVersion*)to;
- (BOOL)lessThan:(NSString*)than;
- (BOOL)moreThan:(NSString*)than;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


