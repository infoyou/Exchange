//
//  CircleMarketingMemberBriefView.m
//  Project
//
//  Created by XXX on 13-10-26.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "CircleMarketingMemberBriefView.h"

#import "CommonHeader.h"
#import "EventApplyMemberList.h"
#import "ASIHTTPRequest.h"

@interface CircleMarketingMemberBriefView()

@property (nonatomic , assign) int userID;

@end

@implementation CircleMarketingMemberBriefView {
    UIImageView *_headerImageView;
    UILabel *_nameLabel;
    UIButton *_headerImageButton;
    
    EventApplyMemberList *_userProfile;
    
    NSString *_downloadFile;
}

@synthesize userID = _userID;
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame withUserProfile:(EventApplyMemberList *)profile
{
    
    _userProfile = profile;
    _userID = [profile.userId integerValue];
    //    UserBaseInfo *ubf = [CommonMethod userBaseInfoWithUserProfile:profile];
    
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = TRANSPARENT_COLOR;
        
        switch (1) {
            case 1:
                
                [self initControls:self withUserProfile:_userProfile];
                [CommonMethod viewAddGuestureRecognizer:_headerImageButton withTarget:self withSEL:@selector(viewTapped:)];
                
                break;
           
            default:
                break;
        }
        
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (void)initControls:(UIView *)parentView  withUserProfile:(EventApplyMemberList *)profile
{
    int startX = 0;
    int startY = 0;
    int width = COMMUNICATION_MEMBER_HEADER_BRIEF_VIEW_WIDTH;
    int height = width;
    
    NSString *headerImageURL = @"";
    NSString *userName = @"";
    
    if (profile) {
            headerImageURL = profile.userImageURL;
        userName = profile.userName;
        }
    
    
    //    if (userInfoArray  && userInfoArray.count) {
    //
    //        NSDictionary *value = [userInfoArray objectAtIndex:0];
    //
    //        NSArray *values = [value objectForKey:@"value"];
    //
    //        headerImageURL = values[0];
    //        userName = values[1];
    //
    //        DLog(@"%@:%@", userName, headerImageURL);
    //
    //    }
    
    //---------------------------
    _headerImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _headerImageButton.frame=CGRectMake(startX, startY, width, height);
    _headerImageButton.backgroundColor = TRANSPARENT_COLOR;
    _headerImageButton.layer.cornerRadius = 5.0f;
    _headerImageButton.layer.borderWidth = 0.5f;
    //    _headerImageButton.layer.allowsEdgeAntialiasing = TRUE;
    _headerImageButton.layer.borderColor = TRANSPARENT_COLOR.CGColor;
    _headerImageButton.layer.masksToBounds = YES;
    
    
    
    [parentView addSubview:_headerImageButton];
    
    switch (1) {
        case 1:
            //---------------------------
            startY += height;
            height = COMMUNICATION_MEMBER_HEADER_BRIEF_VIEW_HEIGHT -COMMUNICATION_MEMBER_HEADER_BRIEF_VIEW_WIDTH;
            _nameLabel = [CommonMethod addLabel:CGRectMake(startX, startY, width, height) withTitle:@"" withFont:FONT_SYSTEM_SIZE(12)];
            _nameLabel.backgroundColor = TRANSPARENT_COLOR;
            [_nameLabel setText:userName];
            [_nameLabel setTextColor:[UIColor darkGrayColor]];
            [_nameLabel setTextAlignment:NSTextAlignmentCenter];
            [_nameLabel setNumberOfLines:1];
            //    [_titleLabel sizeToFit];
            
            
            [parentView addSubview:_nameLabel];
            break;
               default:
            break;
    }
    
    if (![headerImageURL isEqualToString:@""]) {
        [self loadProductImage:headerImageURL  withItemId:[NSString stringWithFormat:@"%d",[profile.userId integerValue]] ];
        
    }
}

- (void)viewTapped:(UISwipeGestureRecognizer *)recognizer
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(memberHeaderBriefViewClicked: withUserID:)]) {
        [self.delegate memberHeaderBriefViewClicked:self withUserID:_userID];
    }
}


#pragma mark -- load barcode by httprequest

- (void) loadProductImage:(NSString *)imageURL withItemId:(NSString *)itemId
{
    _downloadFile = [CommonMethod getLocalDownloadFileName:imageURL withId:itemId];
    
    if (_downloadFile)
        [CommonMethod loadImageWithURL:imageURL delegateFor:self localName:_downloadFile finished:^{
            [self updateImage];
        }];
}


- (void)updateImage
{
    UIImage *productImage = [UIImage imageWithContentsOfFile:_downloadFile];;
    [_headerImageButton setBackgroundImage:productImage forState:UIControlStateNormal];
}

#pragma mark -- ASIHttp delegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    NSLog(@"download finished!");
    [self updateImage];
}
@end
