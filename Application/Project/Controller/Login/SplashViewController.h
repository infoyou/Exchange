//
//  SplashViewController.h
//  Project
//
//  Created by XXX on 13-2-2.
//
//

#import "WXWRootViewController.h"

@protocol SplashViewControllerDelegate;
@interface SplashViewController : WXWRootViewController

@property (nonatomic, assign) id<SplashViewControllerDelegate> delegate;
@end


@protocol SplashViewControllerDelegate <NSObject>

- (void)endSplash:(SplashViewController *)vc;
-(void)closeSplash:(SplashViewController *)vc;

@end
