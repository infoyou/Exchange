//
//  UIViewController+SharedObject.h
//  cpos
//
//  Created by user on 13-1-16.
//  Copyright (c) 2013年 jit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseAppDelegate.h"
#import "MBProgressHUD.h"
#import "WXWTextPool.h"

@interface UIViewController (SharedObject)
- (BaseAppDelegate *) appDelegate;
- (UIView *) viewFromNib:(NSString *) nib;
- (UIView *) viewFromNib:(NSString *) nib withOrigin:(CGPoint) point;
- (void) showProgressWithLabel:(NSString *) label
						  task:(int (^)(MBProgressHUD *)) task
					completion:(void (^)(int)) completion;
- (void) showProgressWithLabel:(NSString *) label
				mainThreadTask:(void (^)(MBProgressHUD *)) task;
- (void) confirmWithMessage:(NSString *) msg title:(NSString *) title;
- (void) confirmWithMessage:(NSString *) msg
					  title:(NSString *) title
						tag:(NSInteger) tag;
- (void) askWithMessage:(NSString *) msg
			   alertTag:(NSInteger) tag;
@end