//
//  WXWNavigationController.m
//  Project
//
//  Created by XXX on 11-11-8.
//  Copyright (c) 2011年 _CompanyName_. All rights reserved.
//

#import "WXWNavigationController.h"
#import "WXWRootViewController.h" 
#import "WXWConstants.h"
#import "UINavigationBar-WXWCategory.h"
#import "DirectionMPMoviePlayerViewController.h"

@implementation WXWNavigationController 

#pragma mark - user action
- (void)back:(id)sender {
  [self popViewControllerAnimated:YES];
}

#pragma mark - lifecycle methods
- (id)initWithRootViewController:(UIViewController *)rootViewController {
  self = [super initWithRootViewController:rootViewController];
  if (self) {
    //self.navigationBar.tintColor = NAVIGATION_BAR_COLOR;
    //self.navigationBar.backgroundColor = NAVIGATION_BAR_COLOR;
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;//UIStatusBarStyleBlackOpaque;
  }
  return self;
}

- (void)dealloc {
  
  [super dealloc];
}

#pragma mark - override methods
- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
  WXWRootViewController *vc = (WXWRootViewController *)[super popViewControllerAnimated:animated];
  
  [vc cancelConnectionAndImageLoading];  
  
  return vc;
}

- (BOOL)shouldAutorotate {
    if ([[self topViewController] isKindOfClass:[DirectionMPMoviePlayerViewController class]]) {
        return YES;
    }
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return [[self topViewController] supportedInterfaceOrientations];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
//    return (toInterfaceOrientation != UIInterfaceOrientationMaskPortraitUpsideDown);
    if ([[self topViewController] isKindOfClass:[DirectionMPMoviePlayerViewController class]]) {
        return YES;
    }
    return NO;
}

@end
