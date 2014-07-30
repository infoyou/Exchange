//
//  AddGroupFriendListCell.m
//  Project
//
//  Created by XXX on 13-10-29.
//  Copyright (c) 2013å¹´ com.jit. All rights reserved.
//

#import "AddGroupFriendListCell.h"
#import "GlobalConstants.h"
#import "CommonHeader.h"
#import "CommunicationPersonalInfoViewController.h"

CellMargin groupFLCM = {10.f, 10.f, 10.f, 10.f};

@interface AddGroupFriendListCell() <QCheckBoxDelegate,WXWImageDisplayerDelegate>
@property (nonatomic, retain) NSString *localImageURL;
@end

@implementation AddGroupFriendListCell {
    UserBaseInfo *_userProfile;
    
    BOOL _isDefault;
}

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
  withUserInfoArray:(UserBaseInfo *)userInfo
     withIsLastCell:(BOOL)isLastCell
        withChecked:(BOOL)isCheck
         withEnable:(BOOL)enable
imageDisplayerDelegate:(id<WXWImageDisplayerDelegate>)imageDisplayerDelegate
                MOC:(NSManagedObjectContext *)MOC
{
    if (self = [self initWithStyle:style reuseIdentifier:reuseIdentifier withUserInfoArray:userInfo withIsLastCell:isLastCell withChecked:isCheck withEnable:enable]) {
        _imageDisplayerDelegate = self;
        _MOC = MOC;
    }
    
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withUserInfoArray:(UserBaseInfo *)userProfile  withIsLastCell:(BOOL)isLastCell withChecked:(BOOL)isCheck    withEnable:(BOOL)enable{
    if (self = [self initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _userProfile = userProfile;
        [self initSubviewsWithUserInfo:userProfile];
        //-----------------
        if (!isLastCell) {
            UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,ADD_GROUP_FRIEND_LIST_CELL_HEIGHT - 1, self.contentView.frame.size.width, 1)];
            [lineLabel setBackgroundColor:[UIColor lightGrayColor]];
            [self addSubview:lineLabel];
            [lineLabel release];
        }
        
        [self setChecked:isCheck withEnable:enable];
        
        if (!isCheck && enable) {
            [CommonMethod viewAddGuestureRecognizer:self withTarget:self withSEL:@selector(viewTapped:)];
        }else{
            if (!enable) {
                [_checkBox updateStatus:FALSE selected:FALSE];
            }else
                
                [_checkBox updateStatus:FALSE selected:TRUE];
        }
        
    }
    
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc {
    [_portImageView release];
    [_nameLabel release];
    [_descLabel release];
    [super dealloc];
}

- (void)initSubviewsWithUserInfo:(UserBaseInfo *)userProfile {
    
    int height = 22;
    int width = 22;
    int startX = groupFLCM.left;
    int startY = (ADD_GROUP_FRIEND_LIST_CELL_HEIGHT - height) / 2.0f;
    
    //----------------------------------------------------------------------------------------
    
    //    UserBaseInfo *baseInfo = [CommonMethod userBaseInfoWithUserProfile:userProfile];
    UserBaseInfo *baseInfo = userProfile;
    
    NSString * headerImageURL = baseInfo.portraitName;
    NSString * userName = baseInfo.chName;
    NSString *companyDesc = [NSString stringWithFormat:@"%@-%@-%@", baseInfo.company, baseInfo.department, baseInfo.position];
    
//    DLog(@"%@:%@", headerImageURL, userName);
    
    //--------------------------------------------------------------------------------
    
    _checkBox = [[QCheckBox alloc] initWithDelegate:self];
    _checkBox.frame = CGRectMake(startX, startY, width, height);
    [_checkBox addTarget:self action:@selector(checkBoxButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_checkBox];
    
    //----------------------------------------------------------------------------------------
    _portImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_checkBox.frame.origin.x + _checkBox.frame.size.width + 5, (ADD_GROUP_FRIEND_LIST_CELL_HEIGHT - IMAGEVIEW_HEIGHT ) / 2.0f, IMAGEVIEW_WIDTH, IMAGEVIEW_HEIGHT)];
    //    _portImageView.backgroundColor = RANDOM_COLOR;
    //    _portImageView.layer.cornerRadius=5.0f;
    
    //    _portImageView.tag = BASE_TAG + index;
    _portImageView.userInteractionEnabled = YES;
    _portImageView.image = IMAGE_WITH_IMAGE_NAME(@"chat_person_cell_default.png");
    
    UITapGestureRecognizer *tap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)] autorelease];
    [_portImageView addGestureRecognizer:tap];
    
    [self.contentView addSubview:_portImageView];
    
    //----------------------------------------------------------------------------------------
    CGFloat nameLabelOriginX = _portImageView.frame.origin.x + IMAGEVIEW_WIDTH + 10;
    CGFloat nameLabelWidth = self.frame.size.width - _portImageView.frame.size.width - groupFLCM.left - groupFLCM.right - 10;
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabelOriginX, groupFLCM.top - 5, nameLabelWidth, 30)];
    _nameLabel.font = FONT_HEITI_MEDUIM_SIZE(16);
    [_nameLabel setTextColor:[UIColor colorWithRed:64.0f/255.0f green:64.0f/255.0f blue:64.0f/255.0f alpha:1.0f]];
    _nameLabel.backgroundColor = TRANSPARENT_COLOR;
   
    if (_userProfile.isActivation == 0) {
        [_nameLabel setText:[NSString stringWithFormat:@"%@ [未激活]", userName]];
    } else {
        [_nameLabel setText:userName];
    }
    
    [self.contentView addSubview:_nameLabel];
    
    
    //----------------------------------------------------------------------------------------
    nameLabelWidth -= 40;
    CGSize maxSize = CGSizeMake(nameLabelWidth, 21*2);
    CGFloat descLabelOriginY = _nameLabel.frame.origin.y + _nameLabel.frame.size.height;
    
    _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabelOriginX, descLabelOriginY-5, nameLabelWidth, 25)];
    _descLabel.backgroundColor = TRANSPARENT_COLOR;

    _descLabel.font = FONT_SYSTEM_SIZE(12);
    [_descLabel setTextColor:[UIColor colorWithRed:128.0f/255.0f green:128.0f/255.0f blue:128.0f/255.0f alpha:1.0f]];
    
    CGSize labelSize = [companyDesc sizeWithFont:_descLabel.font constrainedToSize:maxSize lineBreakMode: UILineBreakModeTailTruncation];
    
    _descLabel.frame = CGRectMake(_descLabel.frame.origin.x, _descLabel.frame.origin.y, labelSize.width, labelSize.height);
    _descLabel.numberOfLines= 2;
    [_descLabel setText:companyDesc];
    [self.contentView addSubview:_descLabel];
    
    //-------------------
    
    self.localImageURL = [[[CommonMethod getLocalImageFolder] stringByAppendingString:@"/"] stringByAppendingString:[CommonMethod convertURLToLocal:headerImageURL withId:[NSString stringWithFormat:@"%d", _userProfile.userID]]];
    
    [self drawAvatar:headerImageURL];
}

- (void)imageTapped:(UIGestureRecognizer *)gesture {
    
    CommunicationPersonalInfoViewController *vc =
    [[CommunicationPersonalInfoViewController alloc] initWithMOC:_MOC parentVC:nil userId:_userProfile.userID withDelegate:nil isFromChatVC:FALSE];
    //    [vc initWithUserId:_userProfile.userID withDelegate:nil];
    [CommonMethod pushViewController:vc withAnimated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)checkBoxButtonClicked:(id)sender
{
    if (_checkBox.checked) {
        if (_delegate && [_delegate respondsToSelector:@selector(addGroupFriendListCell:withUserProfile:)]) {
            [_delegate addGroupFriendListCell:self withUserProfile:_userProfile];
        }
        
    }else{
        if (_delegate && [_delegate respondsToSelector:@selector(deleteGroupFriendListCell:withUserProfile:)]) {
            [_delegate deleteGroupFriendListCell:self withUserProfile:_userProfile];
        }
        
    }
}

- (void)viewTapped:(UIGestureRecognizer *)gesture {
    
    if (_checkBox.checked) {
        if (_delegate && [_delegate respondsToSelector:@selector(deleteGroupFriendListCell:withUserProfile:)]) {
            [_delegate deleteGroupFriendListCell:self withUserProfile:_userProfile];
        }
        
        _checkBox.checked = NO;
    }else{
        if (_delegate && [_delegate respondsToSelector:@selector(addGroupFriendListCell:withUserProfile:)]) {
            [_delegate addGroupFriendListCell:self withUserProfile:_userProfile];
        }
        
        _checkBox.checked = YES;
    }
}


- (void)setChecked:(BOOL)isCheck
{
    _checkBox.checked = isCheck;
    
    [self setNeedsDisplay];
}

- (void)setChecked:(BOOL)isCheck withEnable:(BOOL)enable
{
    _checkBox.checked = isCheck;
    
    [self setNeedsDisplay];
}

-(UserBaseInfo *)getUserProfile
{
    return _userProfile;
}

- (void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked {
    NSLog(@"did tap on CheckBox:%@ checked:%d", checkbox.titleLabel.text, checked);
}


- (void)updateImage
{
    //    UIImage *productImage = [UIImage imageWithContentsOfFile:_downloadFile];;
    //    [_portImageView setImage:productImage];
}


- (void)drawAvatar:(NSString *)imageUrl {
    if (imageUrl && imageUrl.length > 0 ) {
        NSMutableArray *urls = [NSMutableArray array];
        [urls addObject:imageUrl];
//        [self fetchImage:urls forceNew:NO];
        
        
        if ( [CommonMethod isExist:self.localImageURL]) {
            //            [self fetchImage:imageUrl forceNew:NO];
            [self fetchImageFromLocal:self.localImageURL];
        }else{
            [self fetchImage:urls forceNew:YES];
        }
        
        
        
    } else {
//        _portImageView.image = nil;
        
        _portImageView.image = IMAGE_WITH_IMAGE_NAME(@"chat_person_cell_default.png");
    }
}

//- (void)updateImage
//{
//    UIImage *productImage = [[UIImage alloc] initWithContentsOfFile:_downloadFile];
//    [_itemImageView setImage:productImage];
//    [productImage release];
//}
//
//
//#pragma mark -- ASIHttp delegate
//- (void)requestFinished:(ASIHTTPRequest *)request
//{
//
//    NSLog(@"download finished!");
//    [self updateImage];
//}

#pragma mark - WXWImageFetcherDelegate methods
- (void)imageFetchStarted:(NSString *)url {
    if ([self currentUrlMatchCell:url]) {
        //        _portImageView.image = nil;
        _portImageView.image = IMAGE_WITH_IMAGE_NAME(@"chat_person_cell_default.png");
        
        [_imageDisplayerDelegate registerImageUrl:url];
    }
}

- (void)imageFetchDone:(UIImage *)image url:(NSString *)url {
    if ([self currentUrlMatchCell:url]) {
        
        CATransition *imageFadein = [CATransition animation];
        imageFadein.duration = FADE_IN_DURATION;
        imageFadein.type = kCATransitionFade;
        [_portImageView.layer addAnimation:imageFadein forKey:nil];
        //        self.headImageView.image = image;
        //        _itemImageView.image = [WXWCommonUtils cutCenterPartImage:image size:self.headImageView.frame.size];
        
        _portImageView.image = [WXWCommonUtils cutCenterPartImage:image size:_portImageView.frame.size];
        //        _portImageView.image = image;
        
        
        [_imageDisplayerDelegate saveDisplayedImage:image];
        
    }
}
- (void)fetchImageFromLocal:(NSString *)imageUrl
{
    [_imageDisplayerDelegate registerImageUrl:imageUrl];
 
        UIImage *image = [WXWCommonUtils cutCenterPartImage:[UIImage imageWithContentsOfFile:imageUrl] size:_portImageView.frame.size];
        
        image = [WXWCommonUtils cutCenterPartImage:image size:_portImageView.frame.size];
        _portImageView.image = image;

    
}

- (void)imageFetchFromeCacheDone:(UIImage *)image url:(NSString *)url {
    //    self.headImageView.image = [WXWCommonUtils cutCenterPartImage:image size:self.headImageView.frame.size];
    
    
    _portImageView.image = [WXWCommonUtils cutCenterPartImage:image size:_portImageView.frame.size];
}

- (void)imageFetchFailed:(NSError *)error url:(NSString *)url {
    
}

- (void)saveDisplayedImage:(UIImage *)image
{
    DLog(@"%@", self.localImageURL)
    ;    [CommonMethod writeImage:image toFileAtPath:self.localImageURL];
}
- (void)registerImageUrl:(NSString *)url
{
    
}


@end
