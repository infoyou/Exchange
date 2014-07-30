//
//  WXWPullRefreshTableHeaderView.m
//  Project
//
//  Created by XXX on 11-11-10.
//  Copyright (c) 2011年 _CompanyName_. All rights reserved.
//

#import "WXWPullRefreshTableHeaderView.h"
#import <QuartzCore/QuartzCore.h>
#import "WXWConstants.h"
#import "WXWTextPool.h"
#import "WXWLabel.h"
#import "WXWCommonUtils.h"

#define kReleaseToReloadStatus  0
#define kPullToReloadStatus     1
#define kLoadingStatus          2

#define TEXT_COLOR              COLOR(87,108,137)
#define BORDER_COLOR            COLOR(87,108,137)
#define FLIP_ANIMATION_DURATION 0.18f


@implementation WXWPullRefreshTableHeaderView

@synthesize state = _state;
@synthesize activityView = _activityView;

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		
		WXWLabel *label = [[WXWLabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f) 
                                              textColor:BASE_INFO_COLOR
                                            shadowColor:[UIColor whiteColor]];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = BOLD_FONT(12);
		label.textAlignment = UITextAlignmentCenter;
		[self addSubview:label];
		_lastUpdatedLabel=label;
		[label release];
		
		if ([[NSUserDefaults standardUserDefaults] objectForKey:@"EGORefreshTableView_LastRefresh"]) {
			_lastUpdatedLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"EGORefreshTableView_LastRefresh"];
		} else {
			[self setCurrentDate];
		}
		
		label = [[WXWLabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 48.0f, self.frame.size.width, 20.0f) 
                                     textColor:BASE_INFO_COLOR
                                   shadowColor:[UIColor whiteColor]];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = BOLD_FONT(13);
		label.textAlignment = UITextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
		[label release];
		
		CALayer *layer = [[CALayer alloc] init];
		layer.frame = CGRectMake(25.0f, frame.size.height - 65.0f, 30.0f, 55.0f);
		layer.contentsGravity = kCAGravityResizeAspect;
		layer.contents = (id)[UIImage imageNamed:@"blueArrow.png"].CGImage;
		
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			layer.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		
		[[self layer] addSublayer:layer];
		_arrowImage=layer;
		[layer release];
		layer = nil;
		
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		view.frame = CGRectMake(25.0f, frame.size.height - 38.0f, 20.0f, 20.0f);
		[self addSubview:view];
		_activityView = view;
		[view release];
		view = nil;
		
		[self setState:PULL_HEADER_NORMAL];
		
    }
    return self;
}

- (void)setState:(PullHeaderRefreshState)aState{
	
	switch (aState) {
		case PULL_HEADER_PULLING:
			
			_statusLabel.text = LocaleStringForKey(NSReleaseToRefresh, nil);
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			
			break;
            
		case PULL_HEADER_NORMAL:
			
			if (_state == PULL_HEADER_PULLING) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			
			_statusLabel.text = LocaleStringForKey(NSPullDownToRefresh, nil);
			[_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = NO;
			_arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			
			break;
            
		case PULL_HEADER_LOADING:
			
			_statusLabel.text = LocaleStringForKey(NSLoadingTitle, nil);
			[_activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = YES;
			[CATransaction commit];
			
			break;
		default:
			break;
	}
	
	_state = aState;
}

- (void)setCurrentDate {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setAMSymbol:@"AM"];
	[formatter setPMSymbol:@"PM"];
	[formatter setDateFormat:@"MM/dd/yyyy hh:mm:ss a"];
	_lastUpdatedLabel.text = [NSString stringWithFormat:@"%@ %@", LocaleStringForKey(NSLastUpdate, nil),[formatter stringFromDate:[NSDate date]]];
	[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"EGORefreshTableView_LastRefresh"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	[formatter release];
}

- (void)dealloc {
	_activityView = nil;
	_statusLabel = nil;
	_arrowImage = nil;
	_lastUpdatedLabel = nil;
    [super dealloc];
}

@end