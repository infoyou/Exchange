//
//  AuthorCell.m
//  Project
//
//  Created by XXX on 13-6-4.
//
//

#import "AuthorCell.h"
#import "WXWLabel.h"
#import "CommonUtils.h"
#import "WXWUIUtils.h"
#import "AuthorCellBackgroundView.h"
#import "WXWCommonUtils.h"

#define NAME_W                      144.0f

#define AUTHOR_CELL_HEIGHT      71.0f

@interface AuthorCell()
@property (nonatomic, copy) NSString *imageUrl;
@end

@implementation AuthorCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundView = [[[AuthorCellBackgroundView alloc] initWithFrame:CGRectMake(0, 1, self.frame.size.width, AUTHOR_CELL_HEIGHT)] autorelease];
        self.backgroundView.backgroundColor = COLOR(247, 247, 247);
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _authorPhotoImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(MARGIN * 2, MARGIN * 2, POST_DETAIL_PHOTO_WIDTH, POST_DETAIL_PHOTO_HEIGHT)] autorelease];
        _authorPhotoImageView.layer.cornerRadius = 6.0f;
        _authorPhotoImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_authorPhotoImageView];
        
        // set name label
        _authorLabel = [[[WXWLabel alloc] initWithFrame:CGRectMake(MARGIN * 2 + PHOTO_SIDE_LENGTH + MARGIN * 2,
                                                                   MARGIN * 2, 230, 15)
                                              textColor:DARK_TEXT_COLOR
                                            shadowColor:[UIColor whiteColor]] autorelease];
        _authorLabel.font = BOLD_FONT(14);
        _authorLabel.lineBreakMode = UILineBreakModeTailTruncation;
        [self.contentView addSubview:_authorLabel];
        
        // set school label
        _schoolLabel = [[[WXWLabel alloc] initWithFrame:CGRectZero
                                              textColor:DARK_TEXT_COLOR
                                            shadowColor:[UIColor whiteColor]] autorelease];
        _schoolLabel.font = BOLD_FONT(14);
        _schoolLabel.lineBreakMode = UILineBreakModeTailTruncation;
        [self.contentView addSubview:_schoolLabel];
        
        // set company label
        _companyLabel = [[[WXWLabel alloc] initWithFrame:CGRectMake(MARGIN * 2 + PHOTO_SIDE_LENGTH + MARGIN * 2,
                                                                    MARGIN * 2, 230, 15)
                                               textColor:DARK_TEXT_COLOR
                                             shadowColor:[UIColor whiteColor]] autorelease];
        _companyLabel.font = BOLD_FONT(14);
        _companyLabel.lineBreakMode = UILineBreakModeTailTruncation;
        [self.contentView addSubview:_companyLabel];
    }
    return self;
}

- (void)dealloc {
    
    self.imageUrl = nil;
    
    [super dealloc];
}

- (void)drawCellWithImageUrl:(NSString *)imageUrl authorName:(NSString *)authorName {
    
    self.imageUrl = imageUrl;
    
    if (imageUrl && imageUrl.length > 0 ) {
        NSMutableArray *urls = [NSMutableArray array];
        [urls addObject:imageUrl];
        [self fetchImage:urls forceNew:NO];
    } else {
        _authorPhotoImageView.image = nil;
    }
    
	CGSize nameSize = [authorName sizeWithFont:_authorLabel.font
                             constrainedToSize:CGSizeMake(NAME_W, 20)
                                 lineBreakMode:NSLineBreakByTruncatingTail];
    
    _authorLabel.frame = CGRectMake(_authorPhotoImageView.frame.origin.x + _authorPhotoImageView.frame.size.width + MARGIN * 2, _authorPhotoImageView.frame.origin.y, nameSize.width, nameSize.height);
	_authorLabel.text = authorName;
    
}

#pragma mark - WXWImageFetcherDelegate methods
- (void)imageFetchStarted:(NSString *)url {
    if ([self currentUrlMatchCell:url]) {
        _authorPhotoImageView.image = nil;
    }
}

- (void)imageFetchDone:(UIImage *)image url:(NSString *)url {
    if ([self currentUrlMatchCell:url]) {
        
        CATransition *imageFadein = [CATransition animation];
        imageFadein.duration = FADE_IN_DURATION;
        imageFadein.type = kCATransitionFade;
        [_authorPhotoImageView.layer addAnimation:imageFadein forKey:nil];
        
        _authorPhotoImageView.image = [CommonUtils cutPartImage:image
                                                          width:POST_DETAIL_PHOTO_WIDTH
                                                         height:POST_DETAIL_PHOTO_HEIGHT];
    }
}

- (void)imageFetchFromeCacheDone:(UIImage *)image url:(NSString *)url {
    _authorPhotoImageView.image = [CommonUtils cutPartImage:image
                                                      width:POST_DETAIL_PHOTO_WIDTH
                                                     height:POST_DETAIL_PHOTO_HEIGHT];
}

- (void)imageFetchFailed:(NSError *)error url:(NSString *)url {
    
}

@end
