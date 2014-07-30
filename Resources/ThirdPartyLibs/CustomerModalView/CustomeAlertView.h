//
//  CustomeAlertView.h
//  Project
//
//  Created by XXX on 13-9-30.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Foundation/Foundation.h>

#import "CustomizedAlertAnimation.h"

#define CUSTOMIZED_COLOR        @"color"
#define CUSTOMIZED_TIP          @"tip"
#define CUSTOMIZED_TIP_ARRAY    @"tipArray"
#define CUSTOMIZED_TITLE        @"title"

@protocol CustomeAlertViewDelegate ;
@interface CustomeAlertView : UIWindow  <CustomizedAlertAnimationDelegate>
@property(strong,nonatomic)UIView *myView;
@property(strong,nonatomic)UIActivityIndicatorView *activityIndicator;
@property(strong,nonatomic)CustomizedAlertAnimation *animation;
@property(assign,nonatomic)id<CustomeAlertViewDelegate> delegate;

- (void)show;


- (void)updateInfo:(NSDictionary *)info;
- (void)updateInfoWithColor:(NSDictionary *)info;

@end


@protocol CustomeAlertViewDelegate

- (void)CustomeAlertViewDismiss:(CustomeAlertView *) alertView;

@end
