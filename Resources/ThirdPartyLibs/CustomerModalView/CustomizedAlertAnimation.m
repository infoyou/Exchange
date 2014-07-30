//
//  CustomizedAlertAnimation.m
//  Project
//
//  Created by XXX on 13-9-30.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//
#import "CustomizedAlertAnimation.h"

#define kAnimateInDuration 0.4
#define kAnimateOutDuration 0.3

static CGFloat kTransitionDuration = 0.3;

@implementation CustomizedAlertAnimation

@synthesize view;

@synthesize delegate;

-(void)dealloc{
    if (delegate) {
        delegate = nil;
        
    }
    [view release];
    view = nil;
    [super dealloc];
}

-(id)customizedAlertAnimationWithUIview:(UIView *)v{
    if (self=[super init]) {
        view = v;
    }
    return self;
}

//get the transform of view based on the orientation of device.

- (CGAffineTransform)transformForOrientation{
    CGAffineTransform transform ;
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication ]statusBarOrientation];
    
    switch (orientation) {
        case UIInterfaceOrientationLandscapeLeft:
            transform =  CGAffineTransformMakeRotation(M_PI*1.5);
            break;
        case UIInterfaceOrientationLandscapeRight:
            transform = CGAffineTransformMakeRotation(M_PI/2);
            break;
        //这里写错了，感谢 阿秉 提出问题，当为倒置方向时才应该旋转
        //case UIInterfaceOrientationPortrait:
       case UIInterfaceOrientationPortraitUpsideDown:
            transform = CGAffineTransformMakeRotation(-M_PI);
            break;
        default:
            transform = CGAffineTransformIdentity;
            break;
    }
    
    return transform;
}


//  begin the animation

-(void)showAlertAnimation{
//    view.transform = CGAffineTransformScale([self transformForOrientation], 0.001, 0.001);
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:kTransitionDuration/1.5];
//    [UIView setAnimationDelegate:self];
//    [UIView setAnimationDidStopSelector:@selector(firstBouncesDidStop)];
//    view.transform = CGAffineTransformScale([self transformForOrientation], 1.1, 1.1);
//    [UIView commitAnimations];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)]];
    animation.keyTimes = @[ @0, @0.5, @1 ];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = .3;
    
    [view.layer addAnimation:animation forKey:@"showAlert"];
}


-(void)dismissAlertAnimation:(AlertDoneType)type{
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:kTransitionDuration/2];
//    [UIView setAnimationDelegate:self];
//    view.alpha = 0;
////    [UIView setAnimationDidStopSelector:@selector(dismissAlertAnimationDidStoped:)];
////    [UIView setAnimationDidStopSelector:@selector(animationFinish:animationID:finished:context:)];
//    
//    [UIView animateWithDuration:0.2
//                     animations:^{ view.alpha = 0.0; }
//                     completion:^(BOOL finished)
//    {
//        
//        [UIView commitAnimations];
//        [self dismissAlertAnimationDidStoped:type];
//    }];
//    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
//    
//    animation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)],
//                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95, 0.95, 1)],
//                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 0)]];
//    animation.keyTimes = @[ @0, @0.5, @.1 ];
//    animation.fillMode = kCAFillModeRemoved;
//    animation.duration = .3;
//    animation.delegate = self;
//    
//    [view.layer addAnimation:animation forKey:@"dismissAlert"];
//    [view removeFromSuperview];
    
    [UIView animateWithDuration:kAnimateOutDuration animations:^{view.alpha = 0.0;}];
    
    view.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1.0);
    
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    bounceAnimation.values = [NSArray arrayWithObjects:
                              [NSNumber numberWithFloat:1.0],
                              [NSNumber numberWithFloat:1.1],
                              [NSNumber numberWithFloat:0.5],
                              [NSNumber numberWithFloat:0.0], nil];
    bounceAnimation.duration = kAnimateOutDuration;
    bounceAnimation.removedOnCompletion = NO;
    bounceAnimation.delegate = self;
    [view.layer addAnimation:bounceAnimation forKey:@"bounce"];
    
    view.layer.transform = CATransform3DIdentity;
    
    [self dismissAlertAnimationDidStoped:type];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
//        view.alpha = 0.f;
        [view removeFromSuperview];
    }
}

#pragma  mark -- UIViewAnimation delegate

-(void)firstBouncesDidStop{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kTransitionDuration/2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(secondBouncesDidStop)];
    view.transform = CGAffineTransformScale([self transformForOrientation], 0.9, 0.9);
    [UIView commitAnimations];
    
}


-(void)secondBouncesDidStop{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:kTransitionDuration/2];
    view.transform = [self transformForOrientation];
    [UIView commitAnimations];
    
    //You can do somethings at the end of animation
    
    [self.delegate showCustomizedAlertAnimationIsOverWithUIView:view];
}
- (void)animationFinish:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    
}

-(void)dismissAlertAnimationDidStoped:(AlertDoneType)type{
//    [view removeFromSuperview];
    [self.delegate dismissCustomizedAlertAnimationIsOverWithUIView:view type:type];
}
@end
