#import "objd.h"
#import "PGBillboard.h"
#import "PGVec.h"
@class PGVertexBufferDesc;
@class CNReact;
@class PGMutableVertexBuffer;
@class PGVBO;
@class PGVertexArray;
@class CNReactFlag;
@class PGColorSource;
@class PGGlobal;
@class PGContext;
@class CNSignal;
@class PGTexture;
@class PGDirector;
@class PGEmptyIndexSource;
@class PGMesh;
@class PGBillboardShaderSystem;
@class PGCullFace;
@class PGMatrixStack;
@class PGMMatrixModel;
@class PGMat4;
@protocol PGEvent;
@class PGRecognizer;
@class PGTap;

@class PGSprite;

@interface PGSprite : NSObject {
@protected
    CNReact* _visible;
    CNReact* _material;
    CNReact* _position;
    CNReact* _rect;
    PGMutableVertexBuffer* _vb;
    PGVertexArray* _vao;
    CNReactFlag* __changed;
    CNReactFlag* __materialChanged;
    CNSignal* _tap;
}
@property (nonatomic, readonly) CNReact* visible;
@property (nonatomic, readonly) CNReact* material;
@property (nonatomic, readonly) CNReact* position;
@property (nonatomic, readonly) CNReact* rect;
@property (nonatomic, readonly) CNSignal* tap;

+ (instancetype)spriteWithVisible:(CNReact*)visible material:(CNReact*)material position:(CNReact*)position rect:(CNReact*)rect;
- (instancetype)initWithVisible:(CNReact*)visible material:(CNReact*)material position:(CNReact*)position rect:(CNReact*)rect;
- (CNClassType*)type;
+ (PGSprite*)applyVisible:(CNReact*)visible material:(CNReact*)material position:(CNReact*)position anchor:(PGVec2)anchor;
+ (PGSprite*)applyMaterial:(CNReact*)material position:(CNReact*)position anchor:(PGVec2)anchor;
+ (CNReact*)rectReactMaterial:(CNReact*)material anchor:(PGVec2)anchor;
- (void)draw;
- (PGRect)rectInViewport;
- (BOOL)containsViewportVec2:(PGVec2)vec2;
- (BOOL)tapEvent:(id<PGEvent>)event;
- (PGRecognizer*)recognizer;
+ (PGSprite*)applyVisible:(CNReact*)visible material:(CNReact*)material position:(CNReact*)position;
+ (PGSprite*)applyMaterial:(CNReact*)material position:(CNReact*)position rect:(CNReact*)rect;
+ (PGSprite*)applyMaterial:(CNReact*)material position:(CNReact*)position;
- (NSString*)description;
+ (PGVertexBufferDesc*)vbDesc;
+ (CNClassType*)type;
@end


