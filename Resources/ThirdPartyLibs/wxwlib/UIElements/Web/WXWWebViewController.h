//
//  WXWWebViewController.h
//  Project
//
//  Created by XXX on 11-11-22.
//  Copyright (c) 2011年 _CompanyName_. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXWRootViewController.h"

@interface WXWWebViewController : WXWRootViewController <UIWebViewDelegate> {
	UIWebView *_webView;
	
	NSString *urlStr;
	
	UIToolbar *toolbar;
  
    UIBarButtonItem *_preBtn;
    UIBarButtonItem *_nextBtn;
  
    BOOL _needRefreshButton;
    BOOL _needCloseButton;
    BOOL _needNavigationButtons;
    BOOL _blockViewWhenLoading;
    BOOL _isLocal;
}

@property (nonatomic, copy) NSString *urlStr;
@property (nonatomic, retain) UIToolbar *toolbar;

- (id)initWithNeedCloseButton:(BOOL)needCloseButton
               needNavigation:(BOOL)needNavigation
               needHomeButton:(BOOL)needHomeButton
                      isLocal:(BOOL)isLocal;

- (id)initWithNeedCloseButton:(BOOL)needCloseButton
               needNavigation:(BOOL)needNavigation
         blockViewWhenLoading:(BOOL)blockViewWhenLoading
               needHomeButton:(BOOL)needHomeButton
                      isLocal:(BOOL)isLocal;

- (void)hideToolbar;
- (void)showToolbar;

@end
