//
//  WXWPullRefreshTableFooterView.m
//  Project
//
//  Created by XXX on 11-11-10.
//  Copyright (c) 2011年 _CompanyName_. All rights reserved.
//

#import "WXWPullRefreshTableFooterView.h"
#import <QuartzCore/QuartzCore.h>
#import "WXWTextPool.h"
#import "WXWLabel.h"
#import "WXWCommonUtils.h"

#define kReleaseToReloadStatus	0
#define kPullToReloadStatus		1
#define kLoadingStatus			2

#define FRAME_Y					10.0f
#define TEXT_HEIGHT				20.0f

#define ACTIVITY_VIEW_X			95.0f
#define ACTIVITY_VIEW_WIDTH		20.0f


#define TEXT_COLOR                COLOR(87,108,137)
#define BORDER_COLOR              COLOR(87,108,137)
#define FLIP_ANIMATION_DURATION   0.18f



@implementation WXWPullRefreshTableFooterView
@synthesize state = _state;

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
	if (self) {
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		
		WXWLabel *label = [[WXWLabel alloc] initWithFrame:CGRectMake(0.0f, FRAME_Y, 320, TEXT_HEIGHT) 
                                          textColor:BASE_INFO_COLOR 
                                        shadowColor:[UIColor whiteColor]];
		label.font = BOLD_FONT(13);
		label.textAlignment = UITextAlignmentCenter;
		[self addSubview:label];
		_statusLabel = label;
		[label release];
		label = nil;
		
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		view.frame = CGRectMake(ACTIVITY_VIEW_X, FRAME_Y, ACTIVITY_VIEW_WIDTH, TEXT_HEIGHT);
		[self addSubview:view];
		_activityView = view;
		[view release];
		view = nil;
		
		[self setState:PULL_FOOTER_NORMAL];
	}
	return self;
}

- (void)setState:(PullFooterRefreshState)aState{
	
	switch (aState) {
		case PULL_FOOTER_NORMAL:
		{
			_statusLabel.text = LocaleStringForKey(NSLoadMoreTitle, nil);
			[_activityView stopAnimating];
			break;
		}
		case PULL_FOOTER_LOADING:
		{
			_statusLabel.text = LocaleStringForKey(NSLoadingTitle, nil);
			[_activityView startAnimating];
			break;
		}
        case PULL_FOOTER_NO_RESULT:
        {
            _statusLabel.text = LocaleStringForKey(NSLoadNoResultTitle, nil);
            [_activityView stopAnimating];
            break;
        }
		default:
			break;
	}
	
	CGRect originalFrame = self.frame;
	CGRect oldStatusLabelFrame = _statusLabel.frame;
  
  self.frame = CGRectMake(originalFrame.origin.x, originalFrame.origin.y, 320, self.frame.size.height);
  _statusLabel.frame = CGRectMake(0.0f, oldStatusLabelFrame.origin.y, oldStatusLabelFrame.size.width, oldStatusLabelFrame.size.height);
  
	_state = aState;
}

- (void)dealloc {
	_activityView = nil;
	
	_statusLabel = nil;
	
	[super dealloc];
}

@end
