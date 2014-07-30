//
//  CircleMarketingMemberBriefView.h
//  Project
//
//  Created by XXX on 13-10-26.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventApplyMemberList.h"

@protocol CircleMarketingMemberBriefViewDelegate;
@interface CircleMarketingMemberBriefView : UIView

@property (nonatomic, assign) id<CircleMarketingMemberBriefViewDelegate> delegate;


- (id)initWithFrame:(CGRect)frame withUserProfile:(EventApplyMemberList *)profile;

@end


@protocol CircleMarketingMemberBriefViewDelegate <NSObject>

- (void)memberHeaderBriefViewClicked:(CircleMarketingMemberBriefView *)view withUserID:(int)userID;

@end
