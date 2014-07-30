//
//  CommunicatMemberHeaderBriefView.h
//  Project
//
//  Created by XXX on 13-9-25.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserProfile.h"

enum MEMBER_HEADER_BRIEF_VIEW_TYPE {
    MEMBER_HEADER_BRIEF_VIEW_TYPE_NORMAL = 1,
    MEMBER_HEADER_BRIEF_VIEW_TYPE_ADD,
    MEMBER_HEADER_BRIEF_VIEW_TYPE_MIN,
};


@protocol CommunicatMemberHeaderBriefViewDelegate;

@interface CommunicatMemberHeaderBriefView : UIView

@property (nonatomic, assign) id<CommunicatMemberHeaderBriefViewDelegate> delegate;
@property (nonatomic) int userID;

- (id)initWithFrame:(CGRect)frame withType:(enum MEMBER_HEADER_BRIEF_VIEW_TYPE)type withUserProfile:(UserProfile *)profile;

- (UserProfile *)userProfile;
- (void)showDeleteButton:(BOOL)show;
- (BOOL)isDelete;
@end


@protocol CommunicatMemberHeaderBriefViewDelegate <NSObject>

- (void)memberHeaderBriefViewClicked:(CommunicatMemberHeaderBriefView *)view withUserID:(int)userID withHeaderType:(enum MEMBER_HEADER_BRIEF_VIEW_TYPE)type;

@end