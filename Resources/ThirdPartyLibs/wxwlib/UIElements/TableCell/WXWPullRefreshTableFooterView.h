//
//  WXWPullRefreshTableFooterView.h
//  Project
//
//  Created by XXX on 11-11-10.
//  Copyright (c) 2011年 _CompanyName_. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXWConstants.h"

@interface WXWPullRefreshTableFooterView : UIView {
  UILabel *_statusLabel;
	UIActivityIndicatorView *_activityView;
	
	PullFooterRefreshState _state;
}

@property(nonatomic, assign) PullFooterRefreshState state;

@end
