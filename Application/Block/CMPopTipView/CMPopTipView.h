
#import <UIKit/UIKit.h>

typedef enum {
	PointDirectionUp = 0,
	PointDirectionDown
} PointDirection;

typedef enum {
    CMPopTipAnimationSlide = 0,
    CMPopTipAnimationPop
} CMPopTipAnimation;

@protocol CMPopTipViewDelegate;

@interface CMPopTipView : UIView {
    
	UIColor					*backgroundColor;
	id<CMPopTipViewDelegate>	delegate;
	NSString				*message;
	id						targetObject;
	UIColor					*textColor;
	UIFont					*textFont;
    UIColor                 *borderColor;
    CGFloat                 borderWidth;
    CMPopTipAnimation       animation;
    
@private
	CGSize					bubbleSize;
	CGFloat					cornerRadius;
	BOOL					highlight;
	CGFloat					sidePadding;
	CGFloat					topMargin;
	PointDirection			pointDirection;
	CGFloat					pointerSize;
	CGPoint					targetPoint;
}

@property (nonatomic, retain)			UIColor					*backgroundColor;
@property (nonatomic, assign)		id<CMPopTipViewDelegate>	delegate;
@property (nonatomic, assign)			BOOL					disableTapToDismiss;
@property (nonatomic, retain)			NSString				*message;
@property (nonatomic, retain)           UIView	                *customView;
@property (nonatomic, retain, readonly)	id						targetObject;
@property (nonatomic, retain)			UIColor					*textColor;
@property (nonatomic, retain)			UIFont					*textFont;
@property (nonatomic, assign)			UITextAlignment			textAlignment;
@property (nonatomic, retain)			UIColor					*borderColor;
@property (nonatomic, assign)			CGFloat					borderWidth;
@property (nonatomic, assign)           CMPopTipAnimation       animation;
@property (nonatomic, assign)           CGFloat                 maxWidth;

/* Contents can be either a message or a UIView */
- (id)initWithMessage:(NSString *)messageToShow;
- (id)initWithCustomView:(UIView *)aView;

- (void)presentPointingAtView:(UIView *)targetView inView:(UIView *)containerView animated:(BOOL)animated;
- (void)presentPointingAtBarButtonItem:(UIBarButtonItem *)barButtonItem animated:(BOOL)animated;
- (void)dismissAnimated:(BOOL)animated;
- (void)autoDismissAnimated:(BOOL)animated atTimeInterval:(NSTimeInterval)timeInvertal;
- (PointDirection) getPointDirection;

@end

@protocol CMPopTipViewDelegate <NSObject>
- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView;
@end