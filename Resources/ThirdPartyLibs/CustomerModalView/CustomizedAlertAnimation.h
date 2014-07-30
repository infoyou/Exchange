//
//  CustomizedAlertAnimation.h
//  Project
//
//  Created by XXX on 13-9-30.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    ALERT_DONE_TYPE_CANCEL = 1,
    ALERT_DONE_TYPE_OK = 2,
    ALERT_DONE_TYPE_OPTION = 3,
}AlertDoneType;

@protocol CustomizedAlertAnimationDelegate;


@interface CustomizedAlertAnimation : NSObject

@property (strong, nonatomic) UIView *view;
@property (assign, nonatomic) AlertDoneType type;
@property (assign, nonatomic) id<CustomizedAlertAnimationDelegate> delegate;

-(id)customizedAlertAnimationWithUIview:(UIView *)v;

-(void)showAlertAnimation;

-(void)dismissAlertAnimation:(AlertDoneType)type;
@end



@protocol CustomizedAlertAnimationDelegate

-(void)showCustomizedAlertAnimationIsOverWithUIView:(UIView *)v;

-(void)dismissCustomizedAlertAnimationIsOverWithUIView:(UIView *)v type:(AlertDoneType)type;
@end