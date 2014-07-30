//
//  DirectionMPMoviePlayerViewController.m
//  Project
//
//  Created by XXX on 13-11-25.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "DirectionMPMoviePlayerViewController.h"

@interface DirectionMPMoviePlayerViewController ()

@end

@implementation DirectionMPMoviePlayerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setExtendedLayoutIncludesOpaqueBars:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIDeviceOrientationIsLandscape(interfaceOrientation);
//    return YES;
}

- (NSUInteger)application:(UIApplication*)application supportedInterfaceOrientationsForWindow:(UIWindow*)window
{
    
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

@end
