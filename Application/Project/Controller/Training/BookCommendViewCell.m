//
//  BookCommendViewCell.m
//  Project
//
//  Created by Yfeng__ on 13-11-1.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "BookCommendViewCell.h"
#import "WXWLabel.h"
#import "WXWCommonUtils.h"
#import "ContentView.h"
#import "CommonHeader.h"

#define HEAD_IMAGE_WIDTH  76.f
#define HEAD_IMAGE_HEIGHT 105.f

CellMargin BCCM = {13.f, 15.f, 17.f, 15.f};

@interface BookCommendViewCell()

@property (nonatomic, retain) UIImageView *headImageView;
@property (nonatomic, retain) WXWLabel *titleLabel;
@property (nonatomic, retain) WXWLabel *categoryLabel;
@property (nonatomic, retain) WXWLabel *reasonLabel;
@property (nonatomic, retain) WXWLabel *lineLabel;
@property (nonatomic, retain) ContentView *bgView;

@end

@implementation BookCommendViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = TRANSPARENT_COLOR;
        [self initViews];
    }
    return self;
}

- (void)drawAvatar:(NSString *)imageUrl {
    if (imageUrl && imageUrl.length > 0 ) {
        NSMutableArray *urls = [NSMutableArray array];
        [urls addObject:imageUrl];
        [self fetchImage:urls forceNew:NO];
    } else {
        self.headImageView.image = nil;
    }
}

- (void)resetViews {
    self.titleLabel.text = NULL_PARAM_VALUE;
    self.categoryLabel.text = NULL_PARAM_VALUE;
    self.reasonLabel.text = NULL_PARAM_VALUE;
}

- (void)dealloc {
    [_bgView release];
    [_headImageView release];
    self.titleLabel = nil;
    self.categoryLabel = nil;
    self.reasonLabel = nil;
    self.lineLabel = nil;
    [super dealloc];
}

- (void)initViews {
    
    _bgView = [[ContentView alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width - 20, self.frame.size.height - 12)];
    [self.contentView addSubview:self.bgView];
    
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(BCCM.left, BCCM.top, HEAD_IMAGE_WIDTH, HEAD_IMAGE_HEIGHT)];
    [self.bgView addSubview:self.headImageView];
    
    _titleLabel = [self initLabel:CGRectZero
                        textColor:[UIColor colorWithHexString:@"0x333333"]
                      shadowColor:TRANSPARENT_COLOR];
    self.titleLabel.font = FONT_SYSTEM_SIZE(15);
    self.titleLabel.numberOfLines = 0;
    [self.bgView addSubview:self.titleLabel];
    
    // line label
    _lineLabel = [self initLabel:CGRectZero
                       textColor:TRANSPARENT_COLOR
                     shadowColor:TRANSPARENT_COLOR];
    _lineLabel.backgroundColor = [UIColor colorWithWhite:.7 alpha:1];
    [self.bgView addSubview:self.lineLabel];
    
    _categoryLabel = [self initLabel:CGRectZero
                           textColor:[UIColor colorWithHexString:@"0x333333"]
                         shadowColor:TRANSPARENT_COLOR];
    self.categoryLabel.font = FONT_SYSTEM_SIZE(11);
    self.categoryLabel.numberOfLines = 0;
    [self.bgView addSubview:self.categoryLabel];
    
    _reasonLabel = [self initLabel:CGRectZero
                         textColor:[UIColor colorWithHexString:@"333333"]
                       shadowColor:TRANSPARENT_COLOR];
    self.reasonLabel.font = FONT_SYSTEM_SIZE(12);
    self.reasonLabel.numberOfLines = 0;
    [self.bgView addSubview:self.reasonLabel];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.bgView.frame = CGRectMake(10, 10, self.frame.size.width - 20, self.frame.size.height - 12);
    
}

- (void)drawBookCommendCell:(BookList *)bookList {
    [self resetViews];
    [self drawAvatar:bookList.bookImage];
    
    CGFloat disX = 12.f;
    CGFloat disY = 11.f;
    CGFloat disYY = 8.f;
    
    //titleLabel
    self.titleLabel.text = bookList.bookTitle;
    
    CGSize titleSize = [WXWCommonUtils sizeForText:self.titleLabel.text
                                              font:self.titleLabel.font
                                 constrainedToSize:CGSizeMake(LABEL_WIDTH, MAXFLOAT)
                                     lineBreakMode:NSLineBreakByCharWrapping
                                           options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                        attributes:@{NSFontAttributeName : self.titleLabel.font}];
    self.titleLabel.frame = CGRectMake(self.headImageView.frame.origin.x + self.headImageView.frame.size.width + disX, BCCM.top - 2, LABEL_WIDTH, titleSize.height);
    
    self.lineLabel.frame = CGRectMake(self.titleLabel.frame.origin.x, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + disY, LABEL_WIDTH, 1);
    
    //categoryLabel
    self.categoryLabel.text = [NSString stringWithFormat:@"类别：%@",bookList.bookCategory];
    CGSize categorySize = [WXWCommonUtils sizeForText:self.categoryLabel.text
                                                 font:self.categoryLabel.font
                                    constrainedToSize:CGSizeMake(LABEL_WIDTH, MAXFLOAT)
                                        lineBreakMode:NSLineBreakByCharWrapping
                                              options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                           attributes:@{NSFontAttributeName : self.categoryLabel.font}];
    self.categoryLabel.frame = CGRectMake(self.titleLabel.frame.origin.x, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + disY + disYY, LABEL_WIDTH, categorySize.height);
    [self resetTextColor:self.categoryLabel range:[self.categoryLabel.text rangeOfString:bookList.bookCategory]];
    
    //reasonLabel
    self.reasonLabel.text = [NSString stringWithFormat:@"推荐理由：%@",bookList.commendReason];
    CGSize reasonSize = [WXWCommonUtils sizeForText:self.reasonLabel.text
                                                 font:self.reasonLabel.font
                                    constrainedToSize:CGSizeMake(LABEL_WIDTH, MAXFLOAT)
                                        lineBreakMode:NSLineBreakByCharWrapping
                                              options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                           attributes:@{NSFontAttributeName : self.reasonLabel.font}];
    self.reasonLabel.frame = CGRectMake(self.titleLabel.frame.origin.x, self.categoryLabel.frame.origin.y + self.categoryLabel.frame.size.height + disYY, LABEL_WIDTH, reasonSize.height);
    [self resetTextColor:self.reasonLabel range:[self.reasonLabel.text rangeOfString:bookList.commendReason]];
}

- (void)resetTextColor:(WXWLabel *)label range:(NSRange)range {
    if (CURRENT_OS_VERSION >= IOS6) {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:label.text];
        
        [str addAttribute:NSForegroundColorAttributeName
                    value:[UIColor colorWithHexString:@"0x666666"]
                    range:range];
        
        label.attributedText = str;
        [str release];
    }
}

#pragma mark - WXWImageFetcherDelegate methods
- (void)imageFetchStarted:(NSString *)url {
    if ([self currentUrlMatchCell:url]) {
        self.headImageView.image = nil;
    }
}

- (void)imageFetchDone:(UIImage *)image url:(NSString *)url {
    if ([self currentUrlMatchCell:url]) {
        
        CATransition *imageFadein = [CATransition animation];
        imageFadein.duration = FADE_IN_DURATION;
        imageFadein.type = kCATransitionFade;
        [self.headImageView.layer addAnimation:imageFadein forKey:nil];
        self.headImageView.image = image;
//        self.headImageView.image = [WXWCommonUtils cutCenterPartImage:image size:self.headImageView.frame.size];
    }
}

- (void)imageFetchFromeCacheDone:(UIImage *)image url:(NSString *)url {
//    self.headImageView.image = [WXWCommonUtils cutCenterPartImage:image size:self.headImageView.frame.size];
    self.headImageView.image = image;
}

- (void)imageFetchFailed:(NSError *)error url:(NSString *)url {
    
}



@end
