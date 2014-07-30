//
//  WXWPullRefreshTableHeaderView.h
//  Project
//
//  Created by XXX on 11-11-10.
//  Copyright (c) 2011年 _CompanyName_. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXWConstants.h"

@interface WXWPullRefreshTableHeaderView : UIView {
	UILabel *_lastUpdatedLabel;
	UILabel *_statusLabel;
	CALayer *_arrowImage;
	UIActivityIndicatorView *_activityView;
	
	PullHeaderRefreshState _state;
}

@property(nonatomic, assign) PullHeaderRefreshState state;
@property(nonatomic, retain) UIActivityIndicatorView *activityView;

- (void)setCurrentDate;

@end
