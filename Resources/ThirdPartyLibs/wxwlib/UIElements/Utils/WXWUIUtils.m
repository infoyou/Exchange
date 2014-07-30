//
//  WXWUIUtils.m
//  Project
//
//  Created by XXX on 12-5-30.
//  Copyright (c) 2011年 _CompanyName_. All rights reserved.
//

#import "WXWUIUtils.h"
#import <stdlib.h>
#import <QuartzCore/QuartzCore.h>
#import "WXWCommonUtils.h"
#import "WXWTextPool.h"
#import "WXWPullRefreshTableFooterView.h"
#import "WXWPullRefreshTableHeaderView.h"
#import "WXWGradientView.h"
#import "WXWSystemInfoManager.h"

#define ANIMATION_DURATION      0.5f

#define INFOLABEL_WIDTH         150.0f
#define INFOLABEL_HEIGHT        150.0f

#define INFOIMG_WIDTH           40.0f
#define INFOIMG_HEIGHT          40.0f

#define NOTIFY_ICON_SIDE_LENGTH 32.0f

#define ASYNC_LOADING_VIEW_HEIGHT 40.0f
#define OPERA_FACEBOOK_HEIGHT     38.0f
#define OPERA_FACEBOOK_WIDTH      38.0f
#define OPERA_FACEBOOK_COUNT      28

#define ACTIVITY_BACKGROUND_WIDTH   120.0f
#define ACTIVITY_BACKGROUND_HEIGHT	120.0f
#define LOADING_LABEL_WIDTH         100.0f
#define LOADING_LABEL_HEIGHT        40.0f


#define ASYNC_LOADING_KEY       @"ASYNC_LOADING_KEY"


@implementation WXWUIUtils
#pragma mark - activity view
static UIView	*activityBackgroundView = nil;
static UIActivityIndicatorView *activityView = nil;
static UILabel  *loadingLabel = nil;
static UIView   *ownerOfActivityView = nil;

#pragma mark - fade-in fade-out notification
static BOOL	showingNotification = NO;
static UILabel *infoLabel = nil;
//static UIImageView *msgIcon = nil;
static UIImageView *infoImgView = nil;
static UIView *infoBackgroundView = nil;
static float animationDelay = 0.0f;
static UIActivityIndicatorView *nobackgroundActivityView = nil;

static WXWGradientView *infoGradientBackgroundView = nil;

#pragma mark - page index indicator
static UIView *indicatorBackgroundView = nil;
static UILabel *indexIndicatorLabel = nil;

#pragma mark - alert
static UIAlertView *alertView = nil;

#pragma mark - no background view activity view
+ (void)showNoBackgroundActivityView:(UIView *)view {
  
  nobackgroundActivityView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
  nobackgroundActivityView.center = view.center;
  [view addSubview:nobackgroundActivityView];
  [nobackgroundActivityView startAnimating];
}

+ (void)closeNoBackgroundActivityView {
  
  if (nobackgroundActivityView) {
    if (nobackgroundActivityView.isAnimating) {
      [nobackgroundActivityView stopAnimating];
    }
    
    [nobackgroundActivityView removeFromSuperview];
    nobackgroundActivityView = nil;
  }
}

#pragma mark - show notification on screen top
+ (BOOL)showingNotification {
  return showingNotification;
}

+ (void)hideNotification {
  infoGradientBackgroundView.hidden = YES;
}

+ (void)showNotificationOnTopWithMsg:(NSString *)msg
                             msgType:(MessageType)msgType
                  belowNavigationBar:(BOOL)belowNavigationBar {
  
  if (showingNotification || [WXWSystemInfoManager instance].sessionExpired) {
    return;
  }
  
  infoGradientBackgroundView.hidden = NO;
  
  if (nil == infoGradientBackgroundView) {
    UIColor *infoBarTopColor = nil;
    UIColor *infoBarBottomColor = nil;
    
    switch (msgType) {
      case ERROR_TY:
        //msgIcon = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error.png"]] autorelease];
//        infoBarTopColor = COLOR(194, 15, 15);
            //        infoBarBottomColor = COLOR(145, 14, 14);
            
            infoBarTopColor = COLOR(255, 255, 255);
            infoBarBottomColor = COLOR(255, 255, 255);
        break;
      case WARNING_TY:
        // msgIcon = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"warning.png"]] autorelease];
//        infoBarTopColor = COLOR(194, 15, 15);
            //        infoBarBottomColor = COLOR(145, 14, 14);
            
            infoBarTopColor = COLOR(255, 255, 255);
            infoBarBottomColor = COLOR(255, 255, 255);
        break;
        
      case INFO_TY:
        //msgIcon = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"info.png"]] autorelease];
//        infoBarTopColor = COLOR(230, 230, 230);
//        infoBarBottomColor = COLOR(180, 180, 180);
            
            
            infoBarTopColor = COLOR(255, 255, 255);
            infoBarBottomColor = COLOR(255, 255, 255);
        break;
        
      case SUCCESS_TY:
        //msgIcon = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success.png"]] autorelease];
//            0xf55d22
//        infoBarTopColor = COLOR(245, 93, 34);
            //        infoBarBottomColor = COLOR(255, 255, 255);
            
            infoBarTopColor = COLOR(255, 255, 255);
            infoBarBottomColor = COLOR(255, 255, 255);
        break;
        
      default:
        break;
    }
    //msgIcon.frame = CGRectMake(MARGIN, MARGIN, NOTIFY_ICON_SIDE_LENGTH, NOTIFY_ICON_SIDE_LENGTH);
    //[infoGradientBackgroundView addSubview:msgIcon];
    
    infoGradientBackgroundView = [[WXWGradientView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)
                                                              topColor:infoBarTopColor
                                                           bottomColor:infoBarBottomColor];
    infoGradientBackgroundView.layer.shadowColor = [UIColor blackColor].CGColor;
    infoGradientBackgroundView.layer.shadowOpacity = 0.9f;
    infoGradientBackgroundView.layer.shadowOffset = CGSizeMake(0, 2.0f);
    
    [APP_DELEGATE.window addSubview:infoGradientBackgroundView];
    
    [APP_DELEGATE.window bringSubviewToFront:infoGradientBackgroundView];
  }
  
	if (nil == infoLabel) {
		infoLabel = [[UILabel alloc] init];
		infoLabel.backgroundColor = TRANSPARENT_COLOR;
    switch (msgType) {
      case ERROR_TY:
      case WARNING_TY:
//        infoLabel.textColor = [UIColor whiteColor];
            //        infoLabel.shadowColor = [UIColor blackColor];
            infoLabel.textColor = COLOR(245, 93, 34);
            infoLabel.shadowColor = [UIColor whiteColor];
        break;
        
      case INFO_TY:
      case SUCCESS_TY:
        infoLabel.textColor = COLOR(245, 93, 34);
        infoLabel.shadowColor = [UIColor whiteColor];
        break;
        
      default:
        break;
    }
		
		infoLabel.font = BOLD_FONT(15);
		infoLabel.shadowOffset = CGSizeMake(0.0f, 0.5f);
		infoLabel.lineBreakMode = NSLineBreakByWordWrapping;
    infoLabel.numberOfLines = 5;
    
    [infoGradientBackgroundView addSubview:infoLabel];
  }
  
  infoLabel.text = msg;
  CGFloat width = 320 - /*NOTIFY_ICON_SIDE_LENGTH -*/ MARGIN * 2 - MARGIN * 2;
  CGSize size = [infoLabel.text sizeWithFont:infoLabel.font
                           constrainedToSize:CGSizeMake(width,CGFLOAT_MAX)
                               lineBreakMode:NSLineBreakByWordWrapping];
  
  CGFloat backgroundHeight = 0;
  if (size.height <= MARGIN * 2 + NOTIFY_ICON_SIDE_LENGTH) {
    backgroundHeight = MARGIN * 2 + NOTIFY_ICON_SIDE_LENGTH;
  } else {
    backgroundHeight = MARGIN * 2 + size.height;
  }
  
  CGFloat y = 0;
  
  if ([UIApplication sharedApplication].isStatusBarHidden) {
    y -= SYS_STATUS_BAR_HEIGHT;
  } else {
    y += SYS_STATUS_BAR_HEIGHT;
  }
  
  if (![WXWSystemInfoManager instance].navigationBarHidden && belowNavigationBar) {
    y += NAVIGATION_BAR_HEIGHT;
  }

  infoGradientBackgroundView.frame = CGRectMake(0, y, 320, 0);
  
  infoGradientBackgroundView.alpha = 0.0f;
  
  /*
   msgIcon.frame = CGRectMake(msgIcon.frame.origin.x, msgIcon.frame.origin.y, msgIcon.frame.size.width, 0);
   msgIcon.alpha = 0.0f;
   */
  
  infoLabel.frame = CGRectMake(MARGIN * 2/* + NOTIFY_ICON_SIDE_LENGTH*/, backgroundHeight/2 - size.height/2, width, 0.0f);
  infoLabel.alpha = 0.0f;
  
  if (msgType == INFO_TY) {
    animationDelay = 3.0f;
  } else {
    animationDelay = 2.0f;
  }
  
	// fade in fade out animation
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(showNotificationDidStop:finished:context:)];
	[UIView setAnimationDuration:0.3f];
  
    infoGradientBackgroundView.frame = CGRectMake(0,
                                                y,
                                                320, backgroundHeight);
    infoGradientBackgroundView.alpha = 1.0f;
  
  /*
   msgIcon.frame = CGRectMake(msgIcon.frame.origin.x, msgIcon.frame.origin.y, msgIcon.frame.size.width, NOTIFY_ICON_SIDE_LENGTH);
   msgIcon.alpha = 1.0f;
   */
  
    infoLabel.frame = CGRectMake(infoLabel.frame.origin.x, infoLabel.frame.origin.y, infoLabel.frame.size.width, size.height);
    infoLabel.alpha = 1.0f;
  
    [UIView commitAnimations];
	
    showingNotification = YES;
}

+ (void)showNotificationOnTopWithMsg:(NSString *)msg
                             msgType:(MessageType)msgType
                  belowNavigationBar:(BOOL)belowNavigationBar
                      animationEnded:(void (^)(void))animationEnded {
    if (showingNotification || [WXWSystemInfoManager instance].sessionExpired) {
        return;
    }
    
    infoGradientBackgroundView.hidden = NO;
    
    if (nil == infoGradientBackgroundView) {
        UIColor *infoBarTopColor = nil;
        UIColor *infoBarBottomColor = nil;
        
        switch (msgType) {
            case ERROR_TY:
                //msgIcon = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error.png"]] autorelease];
                infoBarTopColor = COLOR(194, 15, 15);
                infoBarBottomColor = COLOR(145, 14, 14);
                break;
            case WARNING_TY:
                // msgIcon = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"warning.png"]] autorelease];
                infoBarTopColor = COLOR(194, 15, 15);
                infoBarBottomColor = COLOR(145, 14, 14);
                break;
                
            case INFO_TY:
                //msgIcon = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"info.png"]] autorelease];
                //        infoBarTopColor = COLOR(230, 230, 230);
                //        infoBarBottomColor = COLOR(180, 180, 180);
                
                
                infoBarTopColor = COLOR(255, 255, 255);
                infoBarBottomColor = COLOR(255, 255, 255);
                break;
                
            case SUCCESS_TY:
                //msgIcon = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success.png"]] autorelease];
                //            0xf55d22
                infoBarTopColor = COLOR(245, 93, 34);
                infoBarBottomColor = COLOR(255, 255, 255);
                break;
                
            default:
                break;
        }
        //msgIcon.frame = CGRectMake(MARGIN, MARGIN, NOTIFY_ICON_SIDE_LENGTH, NOTIFY_ICON_SIDE_LENGTH);
        //[infoGradientBackgroundView addSubview:msgIcon];
        
        infoGradientBackgroundView = [[WXWGradientView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)
                                                                   topColor:infoBarTopColor
                                                                bottomColor:infoBarBottomColor];
        infoGradientBackgroundView.layer.shadowColor = [UIColor blackColor].CGColor;
        infoGradientBackgroundView.layer.shadowOpacity = 0.9f;
        infoGradientBackgroundView.layer.shadowOffset = CGSizeMake(0, 2.0f);
        
        [APP_DELEGATE.window addSubview:infoGradientBackgroundView];
        
        [APP_DELEGATE.window bringSubviewToFront:infoGradientBackgroundView];
    }
    
	if (nil == infoLabel) {
		infoLabel = [[UILabel alloc] init];
		infoLabel.backgroundColor = TRANSPARENT_COLOR;
        switch (msgType) {
            case ERROR_TY:
            case WARNING_TY:
                infoLabel.textColor = [UIColor whiteColor];
                infoLabel.shadowColor = [UIColor blackColor];
                break;
                
            case INFO_TY:
            case SUCCESS_TY:
                infoLabel.textColor = COLOR(245, 93, 34);
                infoLabel.shadowColor = [UIColor whiteColor];
                break;
                
            default:
                break;
        }
		
		infoLabel.font = BOLD_FONT(15);
		infoLabel.shadowOffset = CGSizeMake(0.0f, 0.5f);
		infoLabel.lineBreakMode = NSLineBreakByWordWrapping;
        infoLabel.numberOfLines = 5;
        
        [infoGradientBackgroundView addSubview:infoLabel];
    }
    
    infoLabel.text = msg;
    CGFloat width = 320 - /*NOTIFY_ICON_SIDE_LENGTH -*/ MARGIN * 2 - MARGIN * 2;
    CGSize size = [infoLabel.text sizeWithFont:infoLabel.font
                             constrainedToSize:CGSizeMake(width,CGFLOAT_MAX)
                                 lineBreakMode:NSLineBreakByWordWrapping];
    
    CGFloat backgroundHeight = 0;
    if (size.height <= MARGIN * 2 + NOTIFY_ICON_SIDE_LENGTH) {
        backgroundHeight = MARGIN * 2 + NOTIFY_ICON_SIDE_LENGTH;
    } else {
        backgroundHeight = MARGIN * 2 + size.height;
    }
    
    CGFloat y = 0;
    
    if ([UIApplication sharedApplication].isStatusBarHidden) {
        y -= SYS_STATUS_BAR_HEIGHT;
    } else {
        y += SYS_STATUS_BAR_HEIGHT;
    }
    
    if (![WXWSystemInfoManager instance].navigationBarHidden && belowNavigationBar) {
        y += NAVIGATION_BAR_HEIGHT;
    }
    
    infoGradientBackgroundView.frame = CGRectMake(0, y, 320, 0);
    
    infoGradientBackgroundView.alpha = 0.0f;
    
    /*
     msgIcon.frame = CGRectMake(msgIcon.frame.origin.x, msgIcon.frame.origin.y, msgIcon.frame.size.width, 0);
     msgIcon.alpha = 0.0f;
     */
    
    infoLabel.frame = CGRectMake(MARGIN * 2/* + NOTIFY_ICON_SIDE_LENGTH*/, backgroundHeight/2 - size.height/2, width, 0.0f);
    infoLabel.alpha = 0.0f;
    
    if (msgType == INFO_TY) {
        animationDelay = 1.0f;
    } else {
        animationDelay = 1.0f;
    }
    
    [UIView animateWithDuration:.3f
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        infoGradientBackgroundView.frame = CGRectMake(0,
                                                      y,
                                                      320, backgroundHeight);
        infoGradientBackgroundView.alpha = 1.0f;
        
        infoLabel.frame = CGRectMake(infoLabel.frame.origin.x, infoLabel.frame.origin.y, infoLabel.frame.size.width, size.height);
        infoLabel.alpha = 1.0f;
                         
    } completion:^(BOOL completion){
        
        showingNotification = YES;
        
        [UIView animateWithDuration:.3f
                              delay:animationDelay
                            options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
            infoLabel.frame = CGRectMake(infoLabel.frame.origin.x,
                                         infoLabel.frame.origin.y - infoLabel.frame.size.height,
                                         infoLabel.frame.size.width,
                                         infoLabel.frame.size.height);
            infoLabel.alpha = 0.0f;
            
            infoGradientBackgroundView.frame = CGRectMake(0,
                                                          infoGradientBackgroundView.frame.origin.y,
                                                          infoGradientBackgroundView.frame.size.width,
                                                          0);
            infoGradientBackgroundView.alpha = 0.0f;

        } completion:^(BOOL finished){
            
            [self removeNotificationLabel];
            
            animationEnded();
        }];
        
    }];
}

+ (void)showNotificationOnTopWithMsg:(NSString *)msg
                      alternativeMsg:(NSString *)alternativeMsg
                             msgType:(MessageType)msgType
                  belowNavigationBar:(BOOL)belowNavigationBar
                      animationEnded:(void (^)(void))animationEnded {
    if ((nil == msg || msg.length == 0) && (nil == alternativeMsg || alternativeMsg.length == 0)) {
        return;
    }
    
    NSString *content = nil;
    if (nil == msg || msg.length == 0) {
        content = alternativeMsg;
    } else {
        content = msg;
    }
    
    [self showNotificationOnTopWithMsg:content msgType:msgType belowNavigationBar:belowNavigationBar animationEnded:animationEnded];
}

+ (void)showNotificationOnTopWithMsg:(NSString *)msg
                      alternativeMsg:(NSString *)alternativeMsg
                             msgType:(MessageType)msgType
                  belowNavigationBar:(BOOL)belowNavigationBar {
  
  if ((nil == msg || msg.length == 0) && (nil == alternativeMsg || alternativeMsg.length == 0)) {
    return;
  }
  
  NSString *content = nil;
  if (nil == msg || msg.length == 0) {
    content = alternativeMsg;
  } else {
    content = msg;
  }
  
  [self showNotificationOnTopWithMsg:content msgType:msgType belowNavigationBar:belowNavigationBar];
  
}

+ (void)showNotificationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
  [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDelay:animationDelay];
	[UIView setAnimationDuration: 0.3f];
	[UIView setAnimationDidStopSelector:@selector(removeNotificationLabel)];
  /*
   msgIcon.frame = CGRectMake(msgIcon.frame.origin.x, msgIcon.frame.origin.y, msgIcon.frame.size.width, 0.0f);
   msgIcon.alpha = 0.0f;
   */
  
  infoLabel.frame = CGRectMake(infoLabel.frame.origin.x, infoLabel.frame.origin.y - infoLabel.frame.size.height, infoLabel.frame.size.width, infoLabel.frame.size.height);
  infoLabel.alpha = 0.0f;
  
  infoGradientBackgroundView.frame = CGRectMake(0,
                                                infoGradientBackgroundView.frame.origin.y,
                                                infoGradientBackgroundView.frame.size.width,
                                                0);
  infoGradientBackgroundView.alpha = 0.0f;
  
  [UIView commitAnimations];
}

+ (void)removeNotificationLabel {
  /*
   [msgIcon removeFromSuperview];
   msgIcon = nil;
   */
  
  [infoLabel removeFromSuperview];
	RELEASE_OBJ(infoLabel);
  
  [infoGradientBackgroundView removeFromSuperview];
  RELEASE_OBJ(infoGradientBackgroundView);
	
	showingNotification = NO;
}

#pragma mark - show notification fade-in fade-out
+ (void)removeNotification {
	[infoLabel removeFromSuperview];
	RELEASE_OBJ(infoLabel);
	
	[infoImgView removeFromSuperview];
  RELEASE_OBJ(infoImgView);
  
  [infoBackgroundView removeFromSuperview];
  RELEASE_OBJ(infoBackgroundView);
	
	showingNotification = NO;
}

+ (void)fcAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDelay:animationDelay];
	[UIView setAnimationDuration: 0.5f];
	[UIView setAnimationDidStopSelector:@selector(removeNotification)];
	
	infoLabel.alpha = 0.0f;
	infoImgView.alpha = 0.0f;
  infoBackgroundView.alpha = 0.0f;
  
  // we should keep the info background view not rotate during shrink animation in landscape, so we specify the
  // CGAffineTransform as infoBackgroundView.transform in CGAffineTransformScale function
  infoBackgroundView.transform = CGAffineTransformScale(infoBackgroundView.transform, 0.1f, 0.1f);
	[UIView commitAnimations];
}


+ (void)addInfoLabelToWindow:(MessageType)msgType
                   detailMsg:(NSString *)detailMsg {
  
  if (nil == infoBackgroundView) {
    infoBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, INFOLABEL_WIDTH, INFOLABEL_HEIGHT)];
    infoBackgroundView.center = APP_DELEGATE.window.center;
    infoBackgroundView.layer.cornerRadius = 6.0f;
    infoBackgroundView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
  }
  
	if (nil == infoLabel) {
		infoLabel = [[UILabel alloc] init];
    
		infoLabel.backgroundColor = TRANSPARENT_COLOR;
		infoLabel.textColor = [UIColor whiteColor];
		infoLabel.font = BOLD_FONT(15);
		infoLabel.shadowOffset = CGSizeMake(1, 1);
		infoLabel.shadowColor = [UIColor blackColor];
		infoLabel.textAlignment = UITextAlignmentCenter;
		infoLabel.lineBreakMode = NSLineBreakByWordWrapping;
    infoLabel.numberOfLines = 5;
		infoLabel.layer.cornerRadius = 6.0f;
    
    [infoBackgroundView addSubview:infoLabel];
  }
  
  CGSize size = [detailMsg sizeWithFont:infoLabel.font
                      constrainedToSize:CGSizeMake(INFOLABEL_WIDTH, INFOLABEL_HEIGHT)
                          lineBreakMode:NSLineBreakByWordWrapping];
  
  if (size.height <= INFOLABEL_HEIGHT / 2) {
    infoLabel.frame = CGRectMake(0, 0, INFOLABEL_WIDTH, size.height);
    infoLabel.center = CGPointMake(infoLabel.center.x, INFOLABEL_HEIGHT / 2);
  } else {
    infoLabel.frame = CGRectMake(0, INFOLABEL_HEIGHT - size.height - MARGIN, INFOLABEL_WIDTH, size.height);
  }
  
  infoLabel.text = detailMsg;
  
  [APP_DELEGATE.window addSubview:infoBackgroundView];
  
  [APP_DELEGATE.window bringSubviewToFront:infoBackgroundView];
}

+ (void)addInfoImgView:(MessageType)msgType {
  
	if (nil == infoImgView) {
		infoImgView = [[UIImageView alloc] init];
    infoImgView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin |
		UIViewAutoresizingFlexibleTopMargin |
		UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin;
    
    switch (msgType) {
      case SUCCESS_TY:
        infoImgView.image = [UIImage imageNamed:@"success.png"];
        break;
        
      case INFO_TY:
        infoImgView.image = [UIImage imageNamed:@"info.png"];
        break;
        
      case WARNING_TY:
        infoImgView.image = [UIImage imageNamed:@"warning.png"];
        break;
        
      case ERROR_TY:
        infoImgView.image = [UIImage imageNamed:@"error.png"];
        break;
        
      default:
        break;
    }
    
    infoImgView.frame = CGRectMake(0, 0, INFOIMG_WIDTH, INFOIMG_HEIGHT);
    infoImgView.center = CGPointMake(infoBackgroundView.bounds.size.width/2,
                                     infoBackgroundView.bounds.size.height/2 - INFOLABEL_HEIGHT/2 + MARGIN + INFOIMG_HEIGHT/2);
    
    [infoBackgroundView addSubview:infoImgView];
	}
  
  /*
   // set rotation radians according to the current device orientation
   CGAffineTransform rotate = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(0));
   infoBackgroundView.transform = rotate;
   switch ([WXWCommonUtils currentOrientation]) {
   case UIInterfaceOrientationLandscapeLeft:
   {
   infoBackgroundView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(-90));
   break;
   }
   case UIInterfaceOrientationLandscapeRight:
   {
   infoBackgroundView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(90));
   break;
   }
   case UIInterfaceOrientationPortraitUpsideDown:
   {
   infoBackgroundView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(180));
   break;
   }
   default:
   break;
   }
   */
  
  // set animation delay
  if (msgType == INFO_TY) {
    animationDelay = 3.0f;
  } else if (msgType == ERROR_TY) {
    animationDelay = 2.0f;
  } /*else {
     animationDelay = ANIMATION_DURATION;
     }
     */
  
	// fade in fade out animation
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(fcAnimationDidStop:finished:context:)];
	infoLabel.alpha = 0.0f;
	infoImgView.alpha = 0.0f;
	
	[UIView setAnimationDuration:1.0f];
	infoLabel.alpha = 1.0f;
	infoImgView.alpha = 1.0f;
	[UIView commitAnimations];
	
	showingNotification = YES;
}

+ (void)arrangeMessageViews {
  
  if (infoLabel && infoImgView) {
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.2f];
    
    /*
     infoBackgroundView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(0));
     switch ([WXWCommonUtils currentOrientation]) {
     case UIInterfaceOrientationLandscapeLeft:
     {
     infoBackgroundView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(-90));
     break;
     }
     case UIInterfaceOrientationLandscapeRight:
     {
     infoBackgroundView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(90));
     break;
     }
     case UIInterfaceOrientationPortraitUpsideDown:
     {
     infoBackgroundView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(180));
     break;
     }
     default:
     break;
     }
     */
    [UIView commitAnimations];
  }
}

+ (void)showNotificationWithMsg:(NSString *)msg msgType:(MessageType)msgType {
  
  if (nil == infoLabel) {
    [self addInfoLabelToWindow:msgType detailMsg:msg];
  }
  
  if (nil == infoImgView) {
    [self addInfoImgView:msgType];
  }
}

#pragma mark - alert view
+ (void)alert:(NSString*)title message:(NSString*)message {
  
	if (alertView) return;
  
	alertView = [[UIAlertView alloc] initWithTitle:title
                                         message:message
                                        delegate:self
                               cancelButtonTitle:LocaleStringForKey(NSCloseTitle, nil)
                               otherButtonTitles:nil];
  [alertView show];
  RELEASE_OBJ(alertView);
}


#pragma mark - refreshment triggered by headerView, load latest posts

+ (BOOL)shouldLoadNewItems:(UIScrollView *)scrollView
                headerView:(WXWPullRefreshTableHeaderView *)headerView
                 reloading:(BOOL)reloading {
	if (scrollView.isDragging) {
		if (headerView.state == PULL_HEADER_PULLING && scrollView.contentOffset.y > -(HEADER_TRIGGER_OFFSET) && scrollView.contentOffset.y < 0.0f && !reloading) {
			[headerView setState:PULL_HEADER_NORMAL];
      
      return NO;
		} else if (headerView.state == PULL_HEADER_NORMAL && scrollView.contentOffset.y < -(HEADER_TRIGGER_OFFSET) && !reloading) {
			[headerView setState:PULL_HEADER_PULLING];
      
      return YES;
		}
	}
  
  return NO;
}

+ (void)dataSourceDidFinishLoadingNewData:(UITableView *)tableView
                               headerView:(WXWPullRefreshTableHeaderView *)headerView {
  
  [UIView animateWithDuration:0.3f
                   animations:^{
                     [tableView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
                   }];

  [headerView setState:PULL_HEADER_NORMAL];
  [headerView setCurrentDate];  //  should check if data reload was successful

}

+ (void)animationForScrollViewDidEndDragging:(UIScrollView *)scrollView
                                   tableView:(UITableView *)tableView
                                  headerView:(WXWPullRefreshTableHeaderView *)headerView {
	
	[headerView setState:PULL_HEADER_LOADING];
  
  [UIView animateWithDuration:0.2f
                   animations:^{
                     	tableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
                   }];	
}

#pragma mark - refreshment triggered by footer view, load older posts
+ (BOOL)shouldLoadOlderItems:(UIScrollView *)scrollView
             tableViewHeight:(CGFloat)tableViewHeight
                  footerView:(WXWPullRefreshTableFooterView *)footerView
                   reloading:(BOOL)reloading {
	if (scrollView.isDragging) {
    
    CGFloat offset = 0;
    if ([WXWCommonUtils screenHeightIs4Inch]) {
      offset = FOOTER_TRIGGER_40_OFFSET_MAX;
    } else {
      offset = FOOTER_TRIGGER_35_OFFSET_MAX;
    }
    
		if ((footerView.state == PULL_FOOTER_NORMAL) &&
        (tableViewHeight - scrollView.contentOffset.y <= offset) &&
        scrollView.contentOffset.y > 0 &&					// means scroll down, if user scrolls up, no need to load old post
        !reloading) {
			[footerView setState:PULL_FOOTER_LOADING];
      return YES;
		}
	}
  
  return NO;
}

+ (void)dataSourceDidFinishLoadingOldData:(UITableView *)tableView footerView:(WXWPullRefreshTableFooterView *)footerView {
  
  [UIView animateWithDuration:0.3f
                   animations:^{
                     [tableView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
                   }];
	[footerView setState:PULL_FOOTER_NORMAL]; //  should check if data reload was successful
}

+ (void)animationForScrollViewDidEndDragging:(UIScrollView *)scrollView
                                   tableView:(UITableView *)tableView
                                  footerView:(WXWPullRefreshTableFooterView *)footerView {
  
	[footerView setState:PULL_FOOTER_LOADING];
  [UIView animateWithDuration:0.2f
                   animations:^{
                     tableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
                   }];
}

#pragma mark - line
+ (void)draw1PxStroke:(CGContextRef)context
           startPoint:(CGPoint)startPoint
             endPoint:(CGPoint)endPoint
                color:(CGColorRef)color
         shadowOffset:(CGSize)shadowOffset
          shadowColor:(UIColor *)shadowColor {
  
  CGContextSaveGState(context);
  CGContextSetLineCap(context, kCGLineCapSquare);
  CGContextSetStrokeColorWithColor(context, color);
  CGContextSetLineWidth(context, 1.0);
  CGContextMoveToPoint(context, startPoint.x + 0.5, startPoint.y + 0.5);
  CGContextAddLineToPoint(context, endPoint.x + 0.5, endPoint.y + 0.5);
  
  CGContextSetShadowWithColor(context, shadowOffset, 2.0, shadowColor.CGColor);
  
  CGContextStrokePath(context);
  CGContextRestoreGState(context);
}

+ (void)draw1PxDashLine:(CGContextRef)context
             startPoint:(CGPoint)startPoint
               endPoint:(CGPoint)endPoint
               colorRef:(CGColorRef)colorRef
           shadowOffset:(CGSize)shadowOffset
            shadowColor:(UIColor *)shadowColor
                pattern:(CGFloat[])pattern {
  
  CGContextSaveGState(context);
  
  CGContextSetStrokeColorWithColor(context, colorRef);
  
  CGContextSetLineDash(context, 0, pattern, 2);
  
  CGContextMoveToPoint(context, startPoint.x, startPoint.y);
  
  CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
  
  CGContextSetLineWidth(context, 1.0f);
  
  CGContextSetShadowWithColor(context, shadowOffset, 1.0f, shadowColor.CGColor);
  
  CGContextStrokePath(context);
  
}

#pragma mark - height for news detail view UI elements
+ (CGFloat)reportTitleHeight:(NSString *)title {
  CGSize size = [title sizeWithFont:FONT(17)
                  constrainedToSize:CGSizeMake(300, CGFLOAT_MAX)
                      lineBreakMode:NSLineBreakByWordWrapping];
  if (size.height > 0) {
    return size.height + MARGIN * 2;
  } else {
    return 0;
  }
  
}

+ (CGFloat)contentHeight:(NSString *)content width:(CGFloat)width {
  CGSize size = [content sizeWithFont:FONT(15)
                    constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
                        lineBreakMode:NSLineBreakByWordWrapping];
  
  if (size.height > 0) {
    return size.height + MARGIN * 2;
  } else {
    return 0;
  }
}

#pragma mark - page index indicator for news swipe browser
+ (void)showPageIndex:(NSInteger)currentIndex totalCount:(NSInteger)totalCount {
  
  if (nil == indexIndicatorLabel && nil == indicatorBackgroundView) {
    indexIndicatorLabel = [[[UILabel alloc] init] autorelease];
    indexIndicatorLabel.backgroundColor = TRANSPARENT_COLOR;
    indexIndicatorLabel.font = BOLD_FONT(12);
    indexIndicatorLabel.textColor = [UIColor whiteColor];
    indexIndicatorLabel.textAlignment = UITextAlignmentCenter;
    indexIndicatorLabel.text = [NSString stringWithFormat:@"%d/%d", currentIndex, totalCount];
    CGSize size = [indexIndicatorLabel.text sizeWithFont:indexIndicatorLabel.font
                                                forWidth:CGFLOAT_MAX
                                           lineBreakMode:NSLineBreakByWordWrapping];
    indicatorBackgroundView = [[[UIView alloc] initWithFrame:CGRectMake((APP_WINDOW.frame.size.width - (size.width + MARGIN * 4))/2, 450.0f, size.width + MARGIN * 4, size.height)] autorelease];
    indicatorBackgroundView.backgroundColor = [UIColor blackColor];
    indicatorBackgroundView.layer.cornerRadius = size.height/2;
    indicatorBackgroundView.alpha = 0.0f;
    
    indexIndicatorLabel.frame = CGRectMake(MARGIN * 2, 0, size.width, size.height);
    [indicatorBackgroundView addSubview:indexIndicatorLabel];
    
    [APP_WINDOW addSubview:indicatorBackgroundView];
    
    [UIView animateWithDuration:FADE_IN_DURATION
                     animations:^{
                       indicatorBackgroundView.alpha = 0.7f;
                     }
                     completion:^(BOOL finished) {
                       [UIView animateWithDuration:FADE_IN_DURATION
                                             delay:2.0f
                                           options:0
                                        animations:^{
                                          indicatorBackgroundView.alpha = 0.0f;
                                        }
                                        completion:^(BOOL finished) {
                                          [indexIndicatorLabel removeFromSuperview];
                                          [indicatorBackgroundView removeFromSuperview];
                                          
                                          indexIndicatorLabel = nil;
                                          indicatorBackgroundView = nil;
                                        }];
                     }];
  } else {
    indexIndicatorLabel.text = [NSString stringWithFormat:@"%d/%d", currentIndex, totalCount];
    CGSize size = [indexIndicatorLabel.text sizeWithFont:indexIndicatorLabel.font
                                                forWidth:CGFLOAT_MAX
                                           lineBreakMode:NSLineBreakByWordWrapping];
    indexIndicatorLabel.frame = CGRectMake(MARGIN * 2, 0, size.width, size.height);
    indicatorBackgroundView.frame = CGRectMake((APP_WINDOW.frame.size.width - (size.width + MARGIN * 4))/2, 450.0f, size.width + MARGIN * 4, size.height);
  }
  
}

#pragma mark - show activity view
+ (BOOL)activityViewIsAnimating {
	if (activityView && activityView.isAnimating) {
		return YES;
	} else {
		return NO;
	}
}

+ (void)closeActivityView {
	
	if (activityView) {
		if ([activityView isAnimating]) {
			[activityView stopAnimating];
      RELEASE_OBJ(activityView);
		}
		
		// enable user action after loading finish
    if (ownerOfActivityView) {
      ownerOfActivityView.userInteractionEnabled = YES;
      [ownerOfActivityView release];
      ownerOfActivityView = nil;
    }
    
    if (activityBackgroundView) {
      
      activityBackgroundView.alpha = 1.0f;
      
      [UIView animateWithDuration:ANIMATION_DURATION
                       animations:^{
                         activityBackgroundView.alpha = 0.0f;
                       }];
    }
	}
	
  if (loadingLabel) {
    loadingLabel.text = NULL_PARAM_VALUE;
    loadingLabel = nil;
  }
  
  [WXWCommonUtils saveBoolValueToLocal:NO key:LOADING_NOTIFY_LOCAL_KEY];
}

+ (void)setOwnerOfActivityView:(UIView *)ownerView {
	ownerOfActivityView = [ownerView retain];
	ownerOfActivityView.userInteractionEnabled = NO;
}

+ (void)drawActivityView:(NSString *)text {
	
	if (nil == activityBackgroundView) {
		activityBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, ACTIVITY_BACKGROUND_WIDTH, ACTIVITY_BACKGROUND_HEIGHT)];
		activityBackgroundView.layer.cornerRadius = 6.0f;
		activityBackgroundView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.6f];
		activityBackgroundView.center = APP_DELEGATE.window.center;
	}
  
  if (nil == activityView) {
    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    CGRect activityViewFrame = activityView.frame;
    if (text && [text length] > 0) {
      activityView.frame = CGRectMake(activityBackgroundView.bounds.size.width/2 - 18,
                                      activityBackgroundView.bounds.size.height/2 - 30,
                                      activityViewFrame.size.width,
                                      activityViewFrame.size.height);
    } else {
      activityView.frame = CGRectMake(activityBackgroundView.bounds.size.width/2 - 18,
                                      activityBackgroundView.bounds.size.height/2 - 20,
                                      activityViewFrame.size.width,
                                      activityViewFrame.size.height);
    }
  }
	
  if (text && [text length] > 0) {
    
    if (nil == loadingLabel) {
      loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, LOADING_LABEL_WIDTH, LOADING_LABEL_HEIGHT)];
      loadingLabel.textAlignment = UITextAlignmentCenter;
      loadingLabel.backgroundColor = TRANSPARENT_COLOR;
      loadingLabel.font = BOLD_FONT(13);
      loadingLabel.textColor = [UIColor whiteColor];
      loadingLabel.text = text;
      loadingLabel.center = APP_DELEGATE.window.center;
      loadingLabel.numberOfLines = 2;
      loadingLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    
    loadingLabel.text = text;
    CGFloat limitedHeight = activityBackgroundView.bounds.size.height - activityView.frame.origin.y - activityView.frame.size.height;
    CGSize size = [text sizeWithFont:loadingLabel.font
                   constrainedToSize:CGSizeMake(activityBackgroundView.bounds.size.width - MARGIN * 2,
                                                limitedHeight)
                       lineBreakMode:NSLineBreakByWordWrapping];
    loadingLabel.frame = CGRectMake((activityBackgroundView.bounds.size.width - size.width)/2.0f,
                                    (activityView.frame.origin.y + activityView.frame.size.height + (limitedHeight - size.height)/2.0f),
                                    size.width, size.height);
  }
	
	[activityView startAnimating];
	
	[activityBackgroundView addSubview:activityView];
  
  if (text && [text length] > 0) {
    [activityBackgroundView addSubview:loadingLabel];
  }
  
	activityBackgroundView.alpha = 0.0f;
  
  // set rotation radians according to the current device orientation
  activityBackgroundView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(0));
	switch ([WXWCommonUtils currentOrientation]) {
		case UIInterfaceOrientationLandscapeLeft:
		{
      activityBackgroundView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(-90));
      break;
		}
		case UIInterfaceOrientationLandscapeRight:
		{
      activityBackgroundView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(90));
      break;
		}
		case UIInterfaceOrientationPortraitUpsideDown:
		{
      activityBackgroundView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(180));
      break;
		}
		default:
      break;
	}
  
	[APP_DELEGATE.window addSubview:activityBackgroundView];
	[APP_DELEGATE.window bringSubviewToFront:activityBackgroundView];
	
	[UIView beginAnimations:@"showBusyBeeAnimation" context:nil];
	[UIView setAnimationDuration:0.5f];
	activityBackgroundView.alpha = 1.0f;
	[UIView commitAnimations];
  
  // save the loading in process flag to check loading status when app becomes active,
  // the loading activity view should be closed when app becomes active
  
  [WXWCommonUtils saveBoolValueToLocal:YES key:LOADING_NOTIFY_LOCAL_KEY];
}

+ (void)showActivityView:(UIView *)currentView text:(NSString *)text {
 
	// block user action during loading
	[self setOwnerOfActivityView:currentView];
	
	[self drawActivityView:text];
}

+ (void)arrangeActivityViewRotation {
  if (activityView && activityView.isAnimating) {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.2f];
    
    activityBackgroundView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(0));
    switch ([WXWCommonUtils currentOrientation]) {
      case UIInterfaceOrientationLandscapeLeft:
      {
        activityBackgroundView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(-90));
        break;
      }
      case UIInterfaceOrientationLandscapeRight:
      {
        activityBackgroundView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(90));
        break;
      }
      case UIInterfaceOrientationPortraitUpsideDown:
      {
        activityBackgroundView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(180));
        break;
      }
      default:
        break;
    }
    [UIView commitAnimations];
  }
}

#pragma mark - UISearchBar utilities
+ (void)clearSearchBarBackgroundColor:(UISearchBar *)searchBar {
  searchBar.backgroundColor = TRANSPARENT_COLOR;
  [[searchBar.subviews objectAtIndex:0] removeFromSuperview];
  for (UIView *subView in searchBar.subviews) {
    if ([subView isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
      [subView removeFromSuperview];
      break;
    }
  }
}

#pragma mark - core graphic utilities

+ (void)drawGradient:(CGRect)rect
           fromColor:(UIColor *)from
             toColor:(UIColor *)to {
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  CGContextSaveGState(ctx);
  
  CGContextAddRect(ctx, rect);
  CGContextClip(ctx);
  
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  CGFloat locations[] = { 0.0, 1.0 };
  
  CGColorRef startColor = from.CGColor;
  CGColorRef endColor = to.CGColor;
  NSArray *colors = [NSArray arrayWithObjects:(id)startColor, (id)endColor, nil];
  
  CGGradientRef gradient = CGGradientCreateWithColors(colorSpace,
                                                      (CFArrayRef) colors, locations);
  
  CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
  CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
  
  CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, 0);
  CGGradientRelease(gradient);
  CGColorSpaceRelease(colorSpace);
  
  CGContextRestoreGState(ctx);
}

+ (void)drawLineAtPosition:(LinePosition)position
                      rect:(CGRect)rect
                     color:(UIColor *)color {
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  CGContextSaveGState(ctx);
  
  float y = 0;
  switch (position) {
    case LinePositionTop:
      y = CGRectGetMinY(rect) + 0.5;
      break;
    case LinePositionBottom:
      y = CGRectGetMaxY(rect) - 0.5;
    default:
      break;
  }
  CGContextMoveToPoint(ctx, CGRectGetMinX(rect), y);
  CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), y);
  
  CGContextSetStrokeColorWithColor(ctx, color.CGColor);
  CGContextSetLineWidth(ctx, 1.5);
  CGContextStrokePath(ctx);
  
  CGContextRestoreGState(ctx);
}

+ (void)drawLineAtHeight:(float)height
                    rect:(CGRect)rect
                   color:(UIColor *)color
                   width:(float)width {
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  CGContextSaveGState(ctx);
  
  float y = height;
  
  CGContextMoveToPoint(ctx, CGRectGetMinX(rect), y);
  CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), y);
  
  CGContextSetStrokeColorWithColor(ctx, color.CGColor);
  CGContextSetLineWidth(ctx, width);
  CGContextStrokePath(ctx);
  
  CGContextRestoreGState(ctx);
}

+ (void)drawGradient:(CGGradientRef)gradient rect:(CGRect)rect
{
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  CGContextSaveGState(ctx);
  
  CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
  CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
  
  CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, 0);
  
  CGContextRestoreGState(ctx);
}

@end

@implementation UIColor(WEKit)

// http://stackoverflow.com/questions/1560081/how-can-i-create-a-uicolor-from-a-hex-string
+ (UIColor *) colorWithHex:(int)hex {
  return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0
                         green:((float)((hex & 0xFF00) >> 8))/255.0
                          blue:((float)(hex & 0xFF))/255.0 alpha:1.0];
}
@end
