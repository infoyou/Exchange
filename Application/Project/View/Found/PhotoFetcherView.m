//
//  PhotoFetcherView.m
//  Project
//
//  Created by XXX on 11-11-18.
//  Copyright (c) 2011年 _CompanyName_. All rights reserved.
//

#import "PhotoFetcherView.h"
#import <QuartzCore/QuartzCore.h>
#import "TextPool.h"
#import "CommonUtils.h"
#import "WXWCommonUtils.h"

#define BUTTON_ALPHA   0.7f

@interface PhotoFetcherView()
@property (nonatomic, retain) UIBezierPath *shadowPath;
@end

@implementation PhotoFetcherView

@synthesize shadowPath = _shadowPath;

- (void)addOrRemovePhoto:(id)sender {
  if (_target && _photoManagementAction) {
    [_target performSelector:_photoManagementAction];
  }
}

- (void)initShadowPath:(CGRect)rect {
  self.shadowPath = [UIBezierPath bezierPathWithRect:rect];
}

- (UIEdgeInsets)imageEdgeInsets {
  switch ([WXWCommonUtils currentLanguage]) {
    case ZH_HANS_TY:
      return UIEdgeInsetsMake(-160, 66, -118, -10);
      
    default:
      return UIEdgeInsetsMake(-160, 65, -118, -10);
  }
}

- (id)initWithFrame:(CGRect)frame
             target:(id)target 
photoManagementAction:(SEL)photoManagementAction
userInteractionEnabled:(BOOL)userInteractionEnabled
{
    self = [super initWithFrame:frame];
    if (self) {
    
      _target = target;
      _photoManagementAction = photoManagementAction;
      
      self.backgroundColor = [[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.png"]] autorelease];
      
      _photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
      _photoButton.userInteractionEnabled = userInteractionEnabled;
      _photoButton.frame = CGRectMake((self.frame.size.width - ADD_PHOTO_BUTTON_SIDE_LENGTH)/2, MARGIN * 2, ADD_PHOTO_BUTTON_SIDE_LENGTH, ADD_PHOTO_BUTTON_SIDE_LENGTH);
      _photoButton.alpha = BUTTON_ALPHA;
      _photoButton.layer.masksToBounds = YES;
      _photoButton.layer.borderWidth = 1.0f;
      _photoButton.layer.borderColor = [UIColor whiteColor].CGColor;
      [self initShadowPath:_photoButton.bounds];
      
      // add gradient effect
      CGFloat alphaValues[] = {0.2, 0.15, 0.1, 0.05, 0.01, 0.0, 0.01, 0.05, 0.1, 0.15, 0.2};
      NSUInteger numberOfValues = sizeof(alphaValues) / sizeof(*alphaValues);
      NSMutableArray *cgColors = [NSMutableArray arrayWithCapacity:numberOfValues];
      for ( NSUInteger i = 0; i < numberOfValues; ++i ) {
        CGColorRef color = [[UIColor colorWithWhite:0.0 alpha:alphaValues[i]] CGColor];
        [cgColors addObject:(id)color];
      }
      
      CAGradientLayer *verticalGradientLayer = [CAGradientLayer layer];
      CAGradientLayer *horizentalGradientLayer = [CAGradientLayer layer];
      horizentalGradientLayer.startPoint = CGPointMake(0, 0.5);
      horizentalGradientLayer.endPoint = CGPointMake(1, 0.5);
      horizentalGradientLayer.colors = cgColors;
      //gradientLayer.transform = CGAffineTransformMakeRotation(M_PI_2);
      verticalGradientLayer.colors = cgColors;      
      CGRect layerFrame = CGRectMake(1, 1, _photoButton.layer.bounds.size.width - 2, _photoButton.layer.bounds.size.height - 2);
      verticalGradientLayer.frame = layerFrame;
      horizentalGradientLayer.frame = layerFrame;
      [_photoButton.layer addSublayer:verticalGradientLayer];
      [_photoButton.layer addSublayer:horizentalGradientLayer];
      
      // add image
      [_photoButton setImage:[UIImage imageNamed:@"addPhoto.png"] forState:UIControlStateNormal];
      _photoButton.imageEdgeInsets = [self imageEdgeInsets];
      [_photoButton setTitle:LocaleStringForKey(NSAddPhotoTitle, nil) forState:UIControlStateNormal];
      _photoButton.titleLabel.textColor = COLOR(126, 126, 126);
      _photoButton.titleLabel.font = BOLD_FONT(25);
      [_photoButton setTitleColor:COLOR(126, 126, 126) forState:UIControlStateNormal];
      [_photoButton setTitleColor:COLOR(60, 60, 60) forState:UIControlStateHighlighted];
      _photoButton.titleEdgeInsets = UIEdgeInsetsMake(10, -77, -100.0f, 0.0f);
      [_photoButton addTarget:self 
                       action:@selector(addOrRemovePhoto:)
             forControlEvents:UIControlEventTouchUpInside];
      [self addSubview:_photoButton];
    }
    return self;
}

- (void)applySelectedPhoto:(UIImage *)image {
  if (image) {
    [_photoButton setImage:image forState:UIControlStateNormal];
    _photoButton.imageEdgeInsets = ZERO_EDGE;
    [_photoButton setTitle:nil forState:UIControlStateNormal];
    _photoButton.titleEdgeInsets = ZERO_EDGE;
    _photoButton.alpha = 1.0f;
    
    _photoButton.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    _photoButton.layer.shadowOffset = CGSizeMake(5.0f, 5.0f);      
    _photoButton.layer.shadowOpacity = 0.8f;
    _photoButton.layer.masksToBounds = NO;
    _photoButton.layer.shadowPath = self.shadowPath.CGPath;    
  } else {
    
    [_photoButton setImage:[UIImage imageNamed:@"addPhoto.png"] forState:UIControlStateNormal];
    _photoButton.imageEdgeInsets = [self imageEdgeInsets];
    [_photoButton setTitle:LocaleStringForKey(NSAddPhotoTitle, nil) forState:UIControlStateNormal];
    _photoButton.titleEdgeInsets = UIEdgeInsetsMake(10, -77, -100.0f, 0.0f);
    _photoButton.alpha = BUTTON_ALPHA;
    
    _photoButton.layer.masksToBounds = YES;
    _photoButton.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    _photoButton.layer.shadowOpacity = 0.0f;
    _photoButton.layer.shadowPath = nil;
  }
  
}

- (void)dealloc {
  
  self.shadowPath = nil;
  
  [super dealloc];
}

@end
