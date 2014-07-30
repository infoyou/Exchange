//
//  BusinessItemViewCell.m
//  Project
//
//  Created by XXX on 13-9-4.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "BusinessItemViewCell.h"
#import "CommonHeader.h"
#import "BusinessItemDetailViewController.h"

#define LOCATION_IMAGE_VIEW_WIDTH  14.f
#define LOCATION_IMAGE_VIEW_HEIGHT 18.f

@interface BusinessItemViewCell () <WXWImageDisplayerDelegate>
@property (nonatomic, retain) NSString *localImageURL;
@end

@implementation BusinessItemViewCell {
    UIImageView *_itemImageView;
    
    UILabel *_itemNameLabel;
    
    UILabel *_locationLabel;
    UILabel *_typeLabel;
    UILabel *_volumeLabel;
    UILabel *_salePriceLabel;
    UILabel *_saleTimeLabel;
    
    UILabel *_locationValueLabel;
    UILabel *_typeValueLabel;
    UILabel *_volumeValueLabel;
    UILabel *_areaValueLabel;
    UILabel *_salePriceValueLabel;
    UILabel *_saleTimeValueLabel;
    UIImageView *_locationImageView;
    
    NSString *_downloadFile;
    
    NSDictionary *_detailDict;
}

- (void)dealloc {
    RELEASE_OBJ(_itemImageView);
    RELEASE_OBJ(_locationImageView);
    RELEASE_OBJ(_itemNameLabel);
    RELEASE_OBJ(_locationLabel);
    RELEASE_OBJ(_locationValueLabel);
    RELEASE_OBJ(_detailDict);
    RELEASE_OBJ(_salePriceLabel);
    RELEASE_OBJ(_salePriceValueLabel);
    RELEASE_OBJ(_saleTimeLabel);
    RELEASE_OBJ(_saleTimeValueLabel);
    RELEASE_OBJ(_volumeLabel);
    RELEASE_OBJ(_volumeValueLabel);
    RELEASE_OBJ(_typeLabel);
    RELEASE_OBJ(_typeValueLabel);
    RELEASE_OBJ(_areaValueLabel);
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = TRANSPARENT_COLOR;
        //        self.backgroundView = [[[UIImageView alloc] initWithImage:ImageWithName(@"business_main_cell_bg")] autorelease];
        [self initControls:self.contentView];
        
        //        [CommonMethod viewAddGuestureRecognizer:self withTarget:self withSEL:@selector(viewTapped:)];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier imageDisplayerDelegate:(id<WXWImageDisplayerDelegate>)imageDisplayerDelegate MOC:(NSManagedObjectContext *)MOC {
    //    _imageDisplayerDelegate = imageDisplayerDelegate;
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _imageDisplayerDelegate = self;
        
        _MOC = MOC;
        
        self.backgroundColor = TRANSPARENT_COLOR;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //        [self initViews];
        [self initControls:self.contentView];
        
        //        [CommonMethod viewAddGuestureRecognizer:self withTarget:self withSEL:@selector(viewTapped:)];
    }
    return self;
}

- (void)viewTapped:(UISwipeGestureRecognizer *)recognizer
{
    
    BusinessItemDetailViewController *vc = [[[BusinessItemDetailViewController alloc] initWithMOC:_MOC projectID:self.projectID] autorelease];
    
    [CommonMethod pushViewController:vc withAnimated:YES];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
}

- (void)layoutSubviews {
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 300, 147)];
    bg.image = ImageWithName(@"business_main_cell_bg.png");
    self.backgroundView = bg;
    [bg release];
}

- (void)initControls:(UIView *)parentView
{
    int marginX = 14;
    int marginY = 7;
    int distX = 5;
    int startX = marginX;
    int startY = marginY;;
    //    int height = BUSINESS_ITEM_VIEW_CELL_HEIGHT - 5*marginY;
    //    int width = self.frame.size.width / 3.0f;
    int width = 133;
    int height = 142;
    
    _itemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(startX, startY, width, height)];
    [_itemImageView setImage:IMAGE_WITH_IMAGE_NAME(@"business_main_default_image.png")];
    
    [parentView addSubview:_itemImageView];
    
    //-----------------------------------------------
    
    _locationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_itemImageView.frame.origin.x + 10, _itemImageView.frame.size.height - LOCATION_IMAGE_VIEW_HEIGHT , LOCATION_IMAGE_VIEW_WIDTH, LOCATION_IMAGE_VIEW_HEIGHT)];
    _locationImageView.image = ImageWithName(@"business_button_location");
    [parentView addSubview:_locationImageView];
    
    //-----------------------------------------------
    height = 30;
    startX = _locationImageView.frame.origin.x + LOCATION_IMAGE_VIEW_WIDTH + 5;
    _itemNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(startX, _locationImageView.frame.origin.y + (_locationImageView.frame.size.height - height) / 2, _itemImageView.frame.size.width -startX +  _locationImageView.frame.origin.x - 10,  height)];
    [_itemNameLabel setTextColor:WHITE_COLOR];
    [_itemNameLabel setBackgroundColor:TRANSPARENT_COLOR];
    [_itemNameLabel setFont:FONT_BOLD_SYSTEM_SIZE(12)];
    
    [parentView addSubview:_itemNameLabel];
    //-------------------------------位置----------------
    startX = _itemImageView.frame.origin.x + _itemImageView.frame.size.width + distX;
    startY = _itemImageView.frame.origin.y + 20;
    width = 200;
    height = 20;
    int distY = 2;
    
    _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(startX, startY, width, height)];
    [_locationLabel setText:LocaleStringForKey(@"位置:", nil)];
    [_locationLabel setTextAlignment:NSTextAlignmentLeft];
    [_locationLabel setFont:FONT_SYSTEM_SIZE(14)];
    [_locationLabel setTextColor:[UIColor colorWithHexString:@"0x333333"]];
    [_locationLabel sizeToFit];
    
    [parentView addSubview:_locationLabel];
    
    //-----------------------------------------------
    _locationValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(_locationLabel.frame.origin.x+_locationLabel.frame.size.width, _locationLabel.frame.origin.y, parentView.frame.size.width - _locationLabel.frame.origin.x-_locationLabel.frame.size.width, _locationLabel.frame.size.height)];
    _locationValueLabel.backgroundColor = TRANSPARENT_COLOR;
    [_locationValueLabel setFont:FONT_SYSTEM_SIZE(14)];
    [_locationValueLabel setTextColor:[UIColor colorWithHexString:@"0x333333"]];
    [parentView addSubview:_locationValueLabel];
    //-------------------------类型----------------------
    startY += height + distY;
    width = 200;
    
    _typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(startX, startY, width, height)];
    [_typeLabel setText:LocaleStringForKey(@"类型:", nil)];
    [_typeLabel setFont:FONT_SYSTEM_SIZE(14)];
    [_typeLabel setTextColor:[UIColor colorWithHexString:@"0x333333"]];
    [_typeLabel setTextAlignment:NSTextAlignmentLeft];
    [_typeLabel sizeToFit];
    
    [parentView addSubview:_typeLabel];
    //-----------------------------------------------
    _typeValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(_typeLabel.frame.origin.x+_typeLabel.frame.size.width, _typeLabel.frame.origin.y, parentView.frame.size.width - _typeLabel.frame.origin.x-_typeLabel.frame.size.width, _typeLabel.frame.size.height)];
    _typeValueLabel.backgroundColor = TRANSPARENT_COLOR;
    [_typeValueLabel setFont:FONT_SYSTEM_SIZE(14)];
    [_typeValueLabel setTextColor:[UIColor colorWithHexString:@"0x333333"]];
    [parentView addSubview:_typeValueLabel];
    //------------------------体量-----------------------
    startY += height + distY;
    width = 200;
    
    _volumeLabel = [[UILabel alloc] initWithFrame:CGRectMake(startX, startY, width, height)];
    [_volumeLabel setText:LocaleStringForKey(@"体量:", nil)];
    [_volumeLabel setTextAlignment:NSTextAlignmentLeft];
    [_volumeLabel setFont:FONT_SYSTEM_SIZE(14)];
    [_volumeLabel setTextColor:[UIColor colorWithHexString:@"0x333333"]];
    [_volumeLabel sizeToFit];
    
    [parentView addSubview:_volumeLabel];
    //-----------------------------------------------
    _volumeValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(_volumeLabel.frame.origin.x+_volumeLabel.frame.size.width, _volumeLabel.frame.origin.y, parentView.frame.size.width - _volumeLabel.frame.origin.x-_volumeLabel.frame.size.width, _volumeLabel.frame.size.height)];
    _volumeValueLabel.backgroundColor = TRANSPARENT_COLOR;
    [_volumeValueLabel setFont:FONT_SYSTEM_SIZE(14)];
    [_volumeValueLabel setTextColor:[UIColor colorWithHexString:@"0x333333"]];
    [parentView addSubview:_volumeValueLabel];
    //-------------------------------售价----------------
    startY += height + distY;
    width = 200;
    
    _salePriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(startX, startY, width, height)];
    [_salePriceLabel setText:LocaleStringForKey(@"售价:", nil)];
    [_salePriceLabel setTextAlignment:NSTextAlignmentLeft];
    [_salePriceLabel setFont:FONT_SYSTEM_SIZE(14)];
    [_salePriceLabel setTextColor:[UIColor colorWithHexString:@"0x333333"]];
    [_salePriceLabel sizeToFit];
    
    [parentView addSubview:_salePriceLabel];
    //-----------------------------------------------
    _salePriceValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(_salePriceLabel.frame.origin.x+_salePriceLabel.frame.size.width, _salePriceLabel.frame.origin.y, parentView.frame.size.width - _salePriceLabel.frame.origin.x-_salePriceLabel.frame.size.width, _salePriceLabel.frame.size.height)];
    _salePriceValueLabel.backgroundColor = TRANSPARENT_COLOR;
    [_salePriceValueLabel setFont:FONT_SYSTEM_SIZE(14)];
    [_salePriceValueLabel setTextColor:[UIColor colorWithHexString:@"0x333333"]];
    [parentView addSubview:_salePriceValueLabel];
    //-------------------------------开盘时间----------------
    startY += height + distY;
    width = 200;
    
    _saleTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(startX, startY, width, height)];
    [_saleTimeLabel setText:LocaleStringForKey(@"开盘时间:", nil)];
    [_saleTimeLabel setTextAlignment:NSTextAlignmentLeft];
    [_saleTimeLabel setTextColor:[UIColor colorWithHexString:@"0x333333"]];
    [_saleTimeLabel setFont:FONT_SYSTEM_SIZE(14)];
    [_saleTimeLabel sizeToFit];
    
    [parentView addSubview:_saleTimeLabel];
    //-----------------------------------------------
    _saleTimeValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(_saleTimeLabel.frame.origin.x+_saleTimeLabel.frame.size.width, _saleTimeLabel.frame.origin.y, parentView.frame.size.width - _saleTimeLabel.frame.origin.x-_saleTimeLabel.frame.size.width, _saleTimeLabel.frame.size.height)];
    _saleTimeValueLabel.backgroundColor = TRANSPARENT_COLOR;
    [_saleTimeValueLabel setTextColor:[UIColor colorWithHexString:@"0x333333"]];
    [_saleTimeValueLabel setFont:FONT_SYSTEM_SIZE(14)];
    [parentView addSubview:_saleTimeValueLabel];
    //-----------------------------------------------
    
    height = 20;
    width = 20;
    startX = self.frame.size.width - 40;
    startY = (BUSINESS_ITEM_VIEW_CELL_HEIGHT - height ) / 2.0f;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(startX, startY, width, height)];
    imageView.image = IMAGE_WITH_IMAGE_NAME(@"circle_marketing_cell_expand.png");
    
    [parentView addSubview:imageView];
    [imageView release];
}

- (void)updateItemInfo:(BusinessItemModel *)itemModel withContext:(NSManagedObjectContext*)context withDataArray:(NSDictionary *)dataDict
{
    /*
     self.businessId = [NSNumber numberWithInteger:[[dic objectForKey:@"param1"] integerValue]];
     self.itemName = [dic objectForKey:@"param3"];
     self.location = [dic objectForKey:@"param11"];
     self.type = [dic objectForKey:@"param12"];
     self.volume =[dic objectForKey:@"param13"];
     self.salePrice = [dic objectForKey:@"param14"];
     self.saleTime = [dic objectForKey:@"param15"];
     self.imageURL = [dic objectForKey:@"param16"];
     self.area = [dic objectForKey:@"param11"];
     */
//    [_itemNameLabel setText:itemModel.itemName];
//    [_locationValueLabel setText:itemModel.location];
//    [_volumeValueLabel setText:itemModel.volume];
//    [_salePriceValueLabel setText:itemModel.salePrice];
//    [_saleTimeValueLabel setText:itemModel.saleTime];
//    [_typeValueLabel setText:itemModel.type];
//    self.projectID = itemModel.businessId.intValue;
    
    [_itemNameLabel setText:[dataDict objectForKey:@"param3"]];
    [_locationValueLabel setText:[dataDict objectForKey:@"param11"]];
    [_volumeValueLabel setText:[dataDict objectForKey:@"param13"]];
    [_salePriceValueLabel setText:[dataDict objectForKey:@"param14"]];
    [_saleTimeValueLabel setText:[dataDict objectForKey:@"param15"]];
    [_typeValueLabel setText:[dataDict objectForKey:@"param12"]];
    self.projectID = [[dataDict objectForKey:@"param1"] integerValue];
    
    //    _detailDict = dataDict;
    //
    //    NSString *headerImageURL =[dataDict objectForKey:@"param16"];
    
    
    
    self.localImageURL = [[[CommonMethod getLocalImageFolder] stringByAppendingString:@"/"] stringByAppendingString:[CommonMethod convertURLToLocal:itemModel.imageURL withId:[NSString stringWithFormat:@"%d",self.projectID]]];
    
    DLog(@"%@",itemModel.imageURL);
    
    [self drawAvatar:itemModel.imageURL];
    
    //    _downloadFile = [CommonMethod getLocalDownloadFileName:headerImageURL withId:[dataDict objectForKey:@"param1"]];
    ////    _asiNetwork = [[ASINetworkDownloadFile alloc] init];
    ////    _asiNetwork.delegate = self;
    ////    [_asiNetwork downloadFile:itemModel.imageURL withLocalFile:_downloadFile];
    //
    //    [CommonMethod loadImageWithURL:headerImageURL delegateForView:self localName:_downloadFile finished:^{
    //        [self updateImage];
    //    }];
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
//        _itemImageView.image = nil;
        
#if APP_TYPE == APP_TYPE_BASE
        [_itemImageView setImage:IMAGE_WITH_IMAGE_NAME(@"business_main_default_image.png")];
#endif
    }
}


- (void)fetchImageFromLocal:(NSString *)imageUrl
{
    [_imageDisplayerDelegate registerImageUrl:imageUrl];

    UIImage *image = [WXWCommonUtils cutCenterPartImage:[UIImage imageWithContentsOfFile:imageUrl] size:_itemImageView.frame.size];
    
    image = [WXWCommonUtils cutCenterPartImage:image size:_itemImageView.frame.size];
    _itemImageView.image = image;
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
//        _itemImageView.image = nil;
        
        [_itemImageView setImage:IMAGE_WITH_IMAGE_NAME(@"business_main_default_image.png")];
    }
}

- (void)imageFetchDone:(UIImage *)image url:(NSString *)url {
    if ([self currentUrlMatchCell:url]) {
        
        CATransition *imageFadein = [CATransition animation];
        imageFadein.duration = FADE_IN_DURATION;
        imageFadein.type = kCATransitionFade;
        [_itemImageView.layer addAnimation:imageFadein forKey:nil];
        //        self.headImageView.image = image;
        //        _itemImageView.image = [WXWCommonUtils cutCenterPartImage:image size:self.headImageView.frame.size];
        _itemImageView.image = image;
        
        
        [_imageDisplayerDelegate saveDisplayedImage:image];
    }
}

- (void)imageFetchFromeCacheDone:(UIImage *)image url:(NSString *)url {
    //    self.headImageView.image = [WXWCommonUtils cutCenterPartImage:image size:self.headImageView.frame.size];
    
    _itemImageView.image = image;// [WXWCommonUtils cutCenterPartImage:image size:self.imageView.frame.size];
}

- (void)imageFetchFailed:(NSError *)error url:(NSString *)url {
    
}
#pragma mark -- WXWImageDisplayerDelegate
- (void)saveDisplayedImage:(UIImage *)image
{
    [CommonMethod writeImage:image toFileAtPath:self.localImageURL];
}
- (void)registerImageUrl:(NSString *)url
{
    
}

@end
