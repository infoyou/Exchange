//
//  UIWebViewController.h
//  Module
//
//  Created by XXX on 14-1-14.
//  Copyright (c) 2012年 _MyCompanyName_. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXWRootViewController.h"

@interface UIWebViewController : WXWRootViewController <UIWebViewDelegate,UIActionSheetDelegate>
{
    NSString *strUrl;
    NSString *strTitle;
    
    UIWebView *_webView;
}

@property (nonatomic, assign) BOOL needBackImag;
@property (nonatomic, retain) NSString *strUrl;
@property (nonatomic, retain) NSString *strTitle;
@property (nonatomic, assign) BOOL needShowImageSave;

@end
