//
//  UIViewController+SharedObject.m
//  cpos
//
//  Created by user on 13-1-16.
//  Copyright (c) 2013年 jit. All rights reserved.
//

#import "UIViewController+SharedObject.h"
#import "MBProgressHUD.h"
#import "WXWTextPool.h"
#import "CommonHeader.h"


@implementation UIViewController (SharedObject)
- (void) confirmWithMessage:(NSString *) msg title:(NSString *) title
{
	[[[[UIAlertView alloc]
	   initWithTitle:title
	   message:msg
	   delegate:self
	   cancelButtonTitle:LocaleStringForKey(@"TEXT_OK", nil)
	   otherButtonTitles:nil] autorelease] show];
}

- (void) confirmWithMessage:(NSString *) msg
					  title:(NSString *) title
						tag:(NSInteger) tag
{
	UIAlertView *v = [[[UIAlertView alloc]
					   initWithTitle:title
					   message:msg
					   delegate:self
					   cancelButtonTitle:LocaleStringForKey(@"TEXT_OK", nil)
					   otherButtonTitles:nil] autorelease];
	v.tag = tag;
	[v show];
}

- (void) askWithMessage:(NSString *) msg
			   alertTag:(NSInteger) tag
{
	UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:LocaleStringForKey(@"TEXT_CONFRIM", nil)
													 message:msg
													delegate:self
										   cancelButtonTitle:LocaleStringForKey(@"TEXT_CANCEL", nil)
										   otherButtonTitles:LocaleStringForKey(@"TEXT_OK", nil), nil] autorelease];
	alert.tag = tag;
	[alert show];
}

- (BaseAppDelegate *) appDelegate
{
	return (BaseAppDelegate *) [[UIApplication sharedApplication] delegate];
}

- (UIView *) viewFromNib:(NSString *) nib
{
	assert(nib);
	NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:nib owner:self options:nil];
	UIView *v = (UIView *) [subviewArray objectAtIndex:0];
	return v;
}

- (UIView *) viewFromNib:(NSString *) nib withOrigin:(CGPoint) point
{
	UIView *v = [self viewFromNib:nib];
	CGRect f = v.frame;
	f.origin = point;
	v.frame = f;
	return v;
}

- (void) showProgressWithLabel:(NSString *) label
						  task:(int (^)(MBProgressHUD *)) task
					completion:(void (^)(int)) completion
{
	assert(task);
	MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	hud.labelText = label;
    hud.labelFont = FONT_SYSTEM_SIZE(12);
	[hud setMargin:10];

	dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
		int result = task(hud);
		dispatch_async(dispatch_get_main_queue(), ^{
			[MBProgressHUD hideHUDForView:self.view animated:YES];
			if(completion)
				completion(result);
		});
	});
}

- (void) showProgressWithLabel:(NSString *) label
				mainThreadTask:(void (^)(MBProgressHUD *)) task
{
	MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	[hud setMargin:50];
	[hud setLabelText:label];
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
	dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
		task(hud);
		[MBProgressHUD hideHUDForView:self.view animated:YES];
	});
}
@end
