//
//  CircleMarkegingApplyWindow.h
//  Project
//
//  Created by XXX on 13-10-26.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomizedAlertAnimation.h"
#import "EventApplyList.h"
#import "EventDetailList.h"
#import "EventList.h"

typedef enum {
    AlertType_Default = 1 << 3,
    AlertType_TableView,
    AlertType_TextView,
}AlertType;

@class CircleMarkegingApplyWindow;
@protocol CircleMarkegingApplyWindowDelegate <NSObject>

@optional
- (void)circleMarkegingApplyWindowDismiss:(CircleMarkegingApplyWindow *)alertView applyList:(NSArray *)applyArray;
- (void)circleMarkegingApplyWindowCancelDismiss:(CircleMarkegingApplyWindow *)alertView;
- (void)circleMarketingApplyWindow:(CircleMarkegingApplyWindow *)alertView didEndEditing:(NSString *)text;

@end

@interface CircleMarkegingApplyWindow : UIWindow <CustomizedAlertAnimationDelegate>

@property(strong,nonatomic) UIView *myView;
@property(strong,nonatomic) UIActivityIndicatorView *activityIndicator;
@property(strong,nonatomic) CustomizedAlertAnimation *animation;
@property(assign,nonatomic) id<CircleMarkegingApplyWindowDelegate> applyDelegate;

- (id)initWithType:(AlertType)type;

- (void)show;
- (void)updateInfo:(EventList *)detail;
- (void)resetContentView:(NSString *)text;
- (void)setMessage:(NSString *)message title:(NSString *)title;

@end
