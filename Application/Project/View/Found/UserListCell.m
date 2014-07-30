//
//  UserListCell.m
//  Project
//
//  Created by user on 13-9-24.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "UserListCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+expanded.h"
#import "GlobalConstants.h"
#import "CommonHeader.h"
#import "CommunicationPersonalInfoViewController.h"

#define IMAGEVIEW_WIDTH   60.f
#define IMAGEVIEW_HEIGHT  55.f

#define VERLABEL_WIDTH  100.f
#define VERLABEL_HEIGHT 15.f

CellMargin UserSRCM = {10.f, 10.f, 10.f, 10.f};

@implementation UserListCell {
    Alumni *_userProfile;
}

- (CGFloat)cellHeight {
    return 85.f;
}

- (CGFloat)cellWidth {
    return 320.f;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initSubViews];
        
        [CommonMethod viewAddGuestureRecognizer:self withTarget:self withSEL:@selector(viewTapped:)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.frame];
        imageView.image =IMAGE_WITH_IMAGE_NAME(@"communication_group_list_cell_background.png");
        self.backgroundView = imageView;
        [imageView release];
        
    }
    return self;
}

-(void)prepareForReuse
{
    /*
     @property (nonatomic, retain) UILabel *titLabel;
     @property (nonatomic, retain) UILabel *desLabel;
     @property (nonatomic, retain) UILabel *bottomLineLabel;
     @property (nonatomic, retain) UILabel *verLabel;
     @property (nonatomic, retain) GHImageView *portImageView;
     */
    
    self.titLabel.text = @"";
    self.desLabel.text = @"";
    self.bottomLineLabel.text = @"";
    self.verLabel.text = @"";
    self.portImageView.image = IMAGE_WITH_IMAGE_NAME(@"chat_person_cell_default.png");
}

- (void)viewTapped:(UISwipeGestureRecognizer *)recognizer
{
    CommunicationPersonalInfoViewController *vc = [[CommunicationPersonalInfoViewController alloc] initWithMOC:nil parentVC:nil userId:_userProfile.userId  withDelegate:self isFromChatVC:FALSE];
    [CommonMethod pushViewController:vc withAnimated:YES];
}

- (void)initSubViews {
    
//    self.backgroundColor = [UIColor clearColor];
//    self.layer.masksToBounds = NO;
//    //    //设置阴影的高度
//    self.layer.shadowOffset = CGSizeMake(0, 0);
//    //设置透明度
//    self.layer.shadowOpacity = 0.4;
//    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    
    _portImageView = [[GHImageView alloc] initWithFrame:CGRectMake(UserSRCM.left, UserSRCM.top, IMAGEVIEW_WIDTH, IMAGEVIEW_HEIGHT) defaultImage:@"chat_person_cell_default.png"];
    _portImageView.backgroundColor = [UIColor whiteColor];
    
    _portImageView.layer.borderColor = [UIColor colorWithWhite:.95 alpha:1.].CGColor;
    _portImageView.layer.borderWidth = 2;
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self cellWidth], 75)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:backView];
    
//    backView.layer.masksToBounds = NO;
//    //    //设置阴影的高度
//    backView.layer.shadowOffset = CGSizeMake(0, 1);
//    //设置透明度
//    backView.layer.shadowOpacity = 0.7;
//    backView.layer.shadowPath = [UIBezierPath bezierPathWithRect:backView.bounds].CGPath;
    
    //    CAGradientLayer *shadow = [CAGradientLayer layer];
    //    [shadow setStartPoint:CGPointMake(0.5, 1.0)];
    //    [shadow setEndPoint:CGPointMake(0.5, 0.0)];
    //    shadow.frame = CGRectMake(0, _portImageView.bounds.size.height, _portImageView.bounds.size.width, 2);
    //    shadow.colors = [NSArray arrayWithObjects:(id)[[UIColor grayColor] CGColor], (id)[[UIColor clearColor] CGColor], nil];
    //    [_portImageView.layer insertSublayer:shadow atIndex:0];
    
    [backView addSubview:_portImageView];
    
    CGFloat titleLabelOriginX = UserSRCM.left * 2 + IMAGEVIEW_WIDTH;
    CGFloat titleLabelWidth = [self cellWidth] - titleLabelOriginX - UserSRCM.right;
    
    _titLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelOriginX, UserSRCM.top, titleLabelWidth, 20)];
    _titLabel.backgroundColor = [UIColor clearColor];
    _titLabel.font = [UIFont systemFontOfSize:18];
    _titLabel.textColor = [UIColor darkTextColor];
    [self.contentView addSubview:_titLabel];
    
    _desLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelOriginX, UserSRCM.top + _titLabel.frame.size.height, titleLabelWidth, 20)];
    _desLabel.backgroundColor = [UIColor clearColor];
    _desLabel.font = [UIFont systemFontOfSize:14];
    _desLabel.textColor = [UIColor darkTextColor];
    [backView addSubview:_desLabel];
    
    CGRect rect = _desLabel.frame;
    
    _bottomLineLabel = [CommonMethod addLabel:CGRectMake(0, SEARCH_RESULT_CELL_HEIGHT - 1, self.frame.size.width, 1) withTitle:@"" withFont:FONT_SYSTEM_SIZE(20)];
    _bottomLineLabel.backgroundColor = [UIColor lightGrayColor];
    
    [backView addSubview:_bottomLineLabel];
    
//    CGFloat versionLabelOriginX = [self cellWidth] - VERLABEL_WIDTH - UserSRCM.right;
//    CGFloat versionLabelOriginY = [self cellHeight] - VERLABEL_HEIGHT - UserSRCM.bottom - 5;
//    
//    _verLabel = [[UILabel alloc] initWithFrame:CGRectMake(versionLabelOriginX, versionLabelOriginY, VERLABEL_WIDTH, VERLABEL_HEIGHT)];
//    _verLabel.backgroundColor = [UIColor clearColor];
//    _verLabel.font = [UIFont systemFontOfSize:10];
//    _verLabel.textColor = [UIColor lightGrayColor];
//    _verLabel.textAlignment = NSTextAlignmentRight;
//    [backView addSubview:_verLabel];
    
    //    UIImageView *footerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, [self cellHeight] - 8, [self cellWidth], 8)];
    //    footerImage.backgroundColor = [UIColor colorWithHexString:@"0xe5ddd1"];
    ////    footerImage.backgroundColor = [UIColor clearColor];
    //    footerImage.image = [UIImage imageNamed:@""];
    //
    ////    footerImage.layer.shadowOffset = CGSizeMake(-1, -1);
    ////    footerImage.layer.masksToBounds = NO;
    ////    footerImage.layer.shadowOpacity = .5f;
    ////    footerImage.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    //
    //    [self.contentView addSubview:footerImage];
    //    [footerImage release];
    [backView release];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (void)updateCell:(Alumni *)userProfile{
    _userProfile = userProfile;
    
    [self.portImageView updateImage:_userProfile.imageUrl];
    self.titLabel.text = [NSString stringWithFormat:@"%@", _userProfile.userName];
    self.desLabel.text = [NSString stringWithFormat:@"%@",_userProfile.companyName];
    self.verLabel.text = [[HardwareInfo getInstance] deviceShortInfo];
}

- (void)dealloc {
//    [_portImageView release];
    [_titLabel release];
    [_desLabel release];
    [_verLabel release];
    [super dealloc];
}

@end
