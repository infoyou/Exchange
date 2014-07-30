//
//  QPlusProgressHud.m
//  TestQPlusAPI
//
//  Created by ouyang on 13-5-10.
//  Copyright (c) 2013年 AiLiao. All rights reserved.
//

#import "QPlusProgressHud.h"
#import <UIKit/UIKit.h>

@implementation QPlusProgressHud


static UIView *_loadingMask = nil;
static UIActivityIndicatorView *_loadingIndicator = nil;

+ (void)showLoading {
    _loadingMask = [[UIView alloc]initWithFrame:[[UIScreen mainScreen]applicationFrame]];
    _loadingMask.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    _loadingIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [_loadingMask addSubview:_loadingIndicator];
    CGRect frame = _loadingIndicator.frame;
    frame.origin.x = (_loadingMask.frame.size.width - frame.size.width) / 2;
    frame.origin.y = (_loadingMask.frame.size.height - frame.size.height) / 2;
    _loadingIndicator.frame = frame;
    
    [_loadingIndicator startAnimating];
    [[UIApplication sharedApplication].keyWindow addSubview:_loadingMask];
}

+ (void)hideLoading {
    [_loadingIndicator stopAnimating];
    [_loadingMask removeFromSuperview];
    _loadingIndicator = nil;
    _loadingMask = nil;
}

@end
