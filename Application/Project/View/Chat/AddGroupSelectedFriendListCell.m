//
//  AddGroupSelectedFriendListCell.m
//  Project
//
//  Created by XXX on 13-10-16.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "AddGroupSelectedFriendListCell.h"
#import "CommonHeader.h"
#import "WXWCommonUtils.h"
#import "WXWConstants.h"

@implementation AddGroupSelectedFriendListCell {
    UserBaseInfo *_userProfile;
    AddGroupFriendListCell *_friendListCell;
//    NSString *_downloadFile;
    
    UIImageView *_avataImageView;
    CGRect _rect;
}

@synthesize delegate = _delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withRect:(CGRect)rect
imageDisplayerDelegate:(id<WXWImageDisplayerDelegate>)imageDisplayerDelegate
                MOC:(NSManagedObjectContext *)MOC
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _rect = rect;
        _rect.size.width -=3;
        _rect.size.height -= 3;
        
        _avataImageView = [[UIImageView alloc] initWithFrame:_rect];
        _avataImageView.image = [CommonMethod drawImageToRect:IMAGE_WITH_IMAGE_NAME(@"communication_group_add_user.png") withRegionRect:_rect];

        [self addSubview:_avataImageView];
        self.backgroundColor = TRANSPARENT_COLOR;

        
        
       _userProfile = nil;
        _friendListCell = nil;
        
        _imageDisplayerDelegate = imageDisplayerDelegate;
        _MOC = MOC;
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

- (void)dealloc
{
    [_avataImageView release];
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateView:(UserBaseInfo *)userProfile withRect:(CGRect)rect
{  
    [self drawAvatar:userProfile.portraitName];
}

- (void)updateUserProfile:(AddGroupFriendListCell *)friendListCell withUserProfile:(UserBaseInfo *)userProfile  withDefault:(BOOL) isDefalut
{
    if (!isDefalut)        
        [CommonMethod viewAddGuestureRecognizer:self withTarget:self withSEL:@selector(viewTapped:)];
    
    if (userProfile) {
        _friendListCell = friendListCell;
        _userProfile = userProfile;
        [self updateView:userProfile withRect:_rect];
    }else{
        _friendListCell = nil;
        _userProfile = nil;
        _avataImageView.image = [CommonMethod drawImageToRect:IMAGE_WITH_IMAGE_NAME(@"communication_group_add_user.png") withRegionRect:_rect];

    }
}

- (void)viewTapped:(UIGestureRecognizer *)gesture {
    if (_friendListCell) {
        
    if (self.delegate && [self.delegate respondsToSelector:@selector(avataTapped:withUserProfile:)]) {
        [self.delegate avataTapped:_friendListCell withUserProfile:_userProfile];
    }
    }
}


//--------------------------------------------------------------------------------------------------------

- (void)drawAvatar:(NSString *)imageUrl {
    if (imageUrl && imageUrl.length > 0 ) {
        NSMutableArray *urls = [NSMutableArray array];
        [urls addObject:imageUrl];
        [self fetchImage:urls forceNew:NO];
    } else {
        _avataImageView.image = IMAGE_WITH_IMAGE_NAME(@"chat_person_cell_default.png");
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
        _avataImageView.image = IMAGE_WITH_IMAGE_NAME(@"chat_person_cell_default.png");
    }
}

- (void)imageFetchDone:(UIImage *)image url:(NSString *)url {
    if ([self currentUrlMatchCell:url]) {
        
        CATransition *imageFadein = [CATransition animation];
        imageFadein.duration = FADE_IN_DURATION;
        imageFadein.type = kCATransitionFade;
        [_avataImageView.layer addAnimation:imageFadein forKey:nil];
        //        self.headImageView.image = image;
        //        _itemImageView.image = [WXWCommonUtils cutCenterPartImage:image size:self.headImageView.frame.size];
        
        _avataImageView.image = [WXWCommonUtils cutCenterPartImage:image size:_avataImageView.frame.size];
        //        _portImageView.image = image;
    }
}

- (void)imageFetchFromeCacheDone:(UIImage *)image url:(NSString *)url {
    //    self.headImageView.image = [WXWCommonUtils cutCenterPartImage:image size:self.headImageView.frame.size];
    
    
    _avataImageView.image = [WXWCommonUtils cutCenterPartImage:image size:_avataImageView.frame.size];
}

- (void)imageFetchFailed:(NSError *)error url:(NSString *)url {
    
}

@end
