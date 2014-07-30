//
//  SupplyDemandPostCell.m
//  Project
//
//  Created by XXX on 13-7-3.
//
//

#import "SupplyDemandPostCell.h"
#import "Post.h"
#import "CommonUtils.h"
#import "WXWLabel.h"
#import "WXWCommonUtils.h"

#define FLAG_SIDE_LEN   42.0f

#define TAG_LIST_HEIGHT 40.0f

@interface SupplyDemandPostCell()
@property (nonatomic, copy) NSString *imageUrl;
@end

@implementation SupplyDemandPostCell

#pragma mark - user action
- (void)openImage:(id)sender {
    if (_imageClickableDelegate) {
        [_imageClickableDelegate openImageUrl:self.imageUrl];
    }
}

#pragma mark - lifecycle methods
- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
coreTextViewDelegate:(id<JSCoreTextViewDelegate>)coreTextViewDelegate
tagSelectionDelegate:(id<TagSelectionDelegate>)tagSelectionDelegate
imageDisplayerDelegate:(id<WXWImageDisplayerDelegate>)imageDisplayerDelegate
imageClickableDelegate:(id<ECClickableElementDelegate>)imageClickableDelegate {
    
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier
         imageDisplayerDelegate:imageDisplayerDelegate
                            MOC:nil];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.backgroundColor = CELL_COLOR;
        self.contentView.backgroundColor = CELL_COLOR;
        
        _imageClickableDelegate = imageClickableDelegate;
        
        _flagIcon = [[[UIImageView alloc] initWithFrame:CGRectMake(MARGIN * 2, MARGIN * 2, FLAG_SIDE_LEN, FLAG_SIDE_LEN)] autorelease];
        [self.contentView addSubview:_flagIcon];
        
        CGFloat x = _flagIcon.frame.origin.x + _flagIcon.frame.size.width + MARGIN * 2;
        _contentTextView = [[[JSCoreTextView alloc] initWithFrame:CGRectMake(x, MARGIN * 2, (self.frame.size.width - x - MARGIN * 2), 0)] autorelease];
        _contentTextView.backgroundColor = TRANSPARENT_COLOR;
        _contentTextView.fontName = @"Arial";
        _contentTextView.fontSize = 15.0f;
        _contentTextView.delegate = coreTextViewDelegate;
        _contentTextView.highlightColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
        [self.contentView addSubview:_contentTextView];
        
        _tagListView = [[[TagListView alloc] initWithFrame:CGRectZero
                                         selectionDelegate:tagSelectionDelegate] autorelease];
        [self.contentView addSubview:_tagListView];
        
//        _dateLabel = [[self initLabel:CGRectZero
//                            textColor:BASE_INFO_COLOR
//                          shadowColor:TEXT_SHADOW_COLOR] autorelease];
//        _dateLabel.font = FONT(12);
//        [self.contentView addSubview:_dateLabel];
      
        // comment
        _commentIV = [[[UIImageView alloc] initWithFrame:CGRectZero] autorelease];
        [_commentIV setImage:[UIImage imageNamed:@"commentLabel.png"]];
        [self.contentView addSubview:_commentIV];
        
        _commentLabel = [[self initLabel:CGRectZero
                            textColor:BASE_INFO_COLOR
                          shadowColor:TEXT_SHADOW_COLOR] autorelease];
        _commentLabel.font = FONT(14);
        [self.contentView addSubview:_commentLabel];

        // favorite
        _favoriteIV = [[[UIImageView alloc] initWithFrame:CGRectZero] autorelease];
        [_favoriteIV setImage:[UIImage imageNamed:@"favoriteLabel.png"]];
        [self.contentView addSubview:_favoriteIV];
        
        _favoriteLabel = [[self initLabel:CGRectZero
                               textColor:BASE_INFO_COLOR
                             shadowColor:TEXT_SHADOW_COLOR] autorelease];
        _favoriteLabel.font = FONT(14);
        [self.contentView addSubview:_favoriteLabel];
        
        // share
        _shareIV = [[[UIImageView alloc] initWithFrame:CGRectZero] autorelease];
        [_shareIV setImage:[UIImage imageNamed:@"shareLabel.png"]];
        [self.contentView addSubview:_shareIV];
        
        _shareLabel = [[self initLabel:CGRectZero
                               textColor:BASE_INFO_COLOR
                             shadowColor:TEXT_SHADOW_COLOR] autorelease];
        _shareLabel.font = FONT(14);
        [self.contentView addSubview:_shareLabel];
        
        // comment Line
        _commentLineIV = [[[UIImageView alloc] initWithFrame:CGRectZero] autorelease];
        [_commentLineIV setImage:[UIImage imageNamed:@"commentLine.png"]];
        [self.contentView addSubview:_commentLineIV];
                
        // create
        _createdAtLabel = [[self initLabel:CGRectZero
                                 textColor:BASE_INFO_COLOR
                               shadowColor:TEXT_SHADOW_COLOR] autorelease];
        _createdAtLabel.font = FONT(12);
        [self.contentView addSubview:_createdAtLabel];
    }
    return self;
}

- (void)dealloc {
    
    self.imageUrl = nil;
    
    [super dealloc];
}

#pragma mark - arrange views

- (void)arrangeFlag:(PostType)type {
    switch (type) {
        case SUPPLY_POST_TY:
            _flagIcon.image = [UIImage imageNamed:@"supplyDemand_gong"];
            break;
            
        case DEMAND_POST_TY:
            _flagIcon.image = [UIImage imageNamed:@"supplyDemand_qiu"];
            break;
            
        default:
            break;
    }
}

- (void)arrangeTextView:(NSString *)content {
    
    _contentTextView.text = content;
    
    _textHeight = [JSCoreTextView measureFrameHeightForText:content
                                                   fontName:_contentTextView.fontName
                                                   fontSize:_contentTextView.fontSize
                                         constrainedToWidth:_contentTextView.frame.size.width
                                                 paddingTop:0
                                                paddingLeft:0];
    CGRect textFrame = _contentTextView.frame;
    textFrame.size.height = _textHeight;
    _contentTextView.frame = textFrame;
    
}

- (void)arrangeTags:(NSString *)tagNames {
    
    CGFloat y = _contentTextView.frame.origin.y + _contentTextView.frame.size.height + MARGIN * 2;
    
    _tagListView.frame = CGRectMake(_flagIcon.frame.origin.x + _flagIcon.frame.size.width,
                                    y,
                                    self.frame.size.width - (_flagIcon.frame.origin.x + _flagIcon.frame.size.width),
                                    TAG_LIST_HEIGHT);
    
    [_tagListView drawTagNames:tagNames];
}

- (void)arrangeImageIfNeeded:(Post *)item {
    if (item.hasImage.boolValue) {
        if (nil == _imageButton) {
            
            _imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _imageButton.backgroundColor = [UIColor whiteColor];
            [_imageButton addTarget:self
                             action:@selector(openImage:)
                   forControlEvents:UIControlEventTouchUpInside];
            
            CGFloat photoSideLength = self.frame.size.width - _contentTextView.frame.origin.x - MARGIN * 2;
            _imageButton.frame = CGRectMake(_contentTextView.frame.origin.x, 0, photoSideLength, photoSideLength);
            [self.contentView addSubview:_imageButton];
        }
        
        CGRect frame = _imageButton.frame;
        frame.origin.y = _tagListView.frame.origin.y + _tagListView.frame.size.height + MARGIN * 2;
        _imageButton.frame = frame;
        
        self.imageUrl = item.imageUrl;
        
        [self fetchImage:[NSMutableArray arrayWithObject:item.imageUrl]
                forceNew:NO];
    }
}

- (void)arrangeBaseInfo:(Post *)item {
    
    CGFloat y = 0;
    if (item.hasImage.boolValue) {
        y = _imageButton.frame.origin.y + _imageButton.frame.size.height + MARGIN * 2;
    } else {
        y = _tagListView.frame.origin.y + _tagListView.frame.size.height + MARGIN * 2;
    }
    
//    _dateLabel.text = item.createdTime;
//    CGSize size = [_dateLabel.text sizeWithFont:_dateLabel.font];
//    _dateLabel.frame = CGRectMake(_contentTextView.frame.origin.x,
//                                  y, size.width, size.height);
    
    int x = _contentTextView.frame.origin.x;
    // comment
    _commentIV.frame = CGRectMake(x, y-3, 20, 20);
    _commentLabel.text = [NSString stringWithFormat:@"%d", item.commentCount.intValue];
    CGSize commentSize = [_commentLabel.text sizeWithFont:_commentLabel.font];
    _commentLabel.frame = CGRectMake(x + 25, y, commentSize.width, commentSize.height);
    x+=35;
    x+= commentSize.width;
    
    // favorite
    _favoriteIV.frame = CGRectMake(x, y-3, 20, 20);
    _favoriteLabel.text = [NSString stringWithFormat:@"%d", item.attentionCount.intValue];
    CGSize favoriteSize = [_favoriteLabel.text sizeWithFont:_favoriteLabel.font];
    _favoriteLabel.frame = CGRectMake(x + 25, y, favoriteSize.width, favoriteSize.height);
    x+=35;
    x+= favoriteSize.width;
    
    // share
    _shareIV.frame = CGRectMake(x, y-3, 20, 20);
    _shareLabel.text = [NSString stringWithFormat:@"%d", item.shareCount.intValue];
    CGSize shareSize = [_shareLabel.text sizeWithFont:_shareLabel.font];
    _shareLabel.frame = CGRectMake(x + 25, y, shareSize.width, shareSize.height);
    
    // comment Line IV
    if (item.commentCount.intValue > 0) {
        _commentLineIV.hidden = NO;
        _commentLineIV.frame = CGRectMake(0, y+20, 320, 10);
    } else {
        _commentLineIV.hidden = YES;
    }
    
    // create
//    _createdAtLabel.text = STR_FORMAT(@"%@ %@ %@", LocaleStringForKey(NSFromTitle, nil), item.plat, item.version);
    _createdAtLabel.text = item.createdTime;
    CGSize size = [_createdAtLabel.text sizeWithFont:_createdAtLabel.font];
    _createdAtLabel.frame = CGRectMake(self.frame.size.width - MARGIN * 2 - size.width,
                                       y, size.width, size.height);
}

- (void)drawCellWithPost:(Post *)post {
    
    // draw flag icon
    [self arrangeFlag:post.postType.intValue];
    
    // draw text content
    [self arrangeTextView:post.content];
    
    // draw tag list
    [self arrangeTags:post.tagNames];
    
    // draw image if needed
    [self arrangeImageIfNeeded:post];
    
    // draw base info
    [self arrangeBaseInfo:post];
}

#pragma mark - WXWImageFetcherDelegate methods
- (void)imageFetchStarted:(NSString *)url {
    if ([self currentUrlMatchCell:url]) {
        [_imageButton setImage:nil forState:UIControlStateNormal];
    }
}

- (void)imageFetchDone:(UIImage *)image url:(NSString *)url {
    if ([self currentUrlMatchCell:url]) {
        
        [_imageDisplayerDelegate saveDisplayedImage:image];
        
        [_imageButton.layer addAnimation:[self imageTransition] forKey:nil];
        
        CGFloat photoSideLength = _imageButton.frame.size.width;
        [_imageButton setImage:[CommonUtils cutPartImage:image
                                                   width:photoSideLength
                                                  height:photoSideLength]
                      forState:UIControlStateNormal];
    }
}

- (void)imageFetchFromeCacheDone:(UIImage *)image url:(NSString *)url {
    CGFloat photoSideLength = _imageButton.frame.size.width;
    [_imageButton setImage:[CommonUtils cutPartImage:image
                                               width:photoSideLength
                                              height:photoSideLength]
                  forState:UIControlStateNormal];
}

@end
