//
//  SupplyDemandItemCell.m
//  Project
//
//  Created by XXX on 13-6-4.
//
//

#import "SupplyDemandItemCell.h"
#import "WXWConstants.h"
#import "TextPool.h"
#import "WXWCommonUtils.h"
#import "CommonUtils.h"
#import "WXWLabel.h"
#import "Post.h"

#define FLAG_SIDE_LEN   42.0f

#define TAG_LIST_HEIGHT 40.0f

@interface SupplyDemandItemCell()
@property (nonatomic, copy) NSString *imageUrl;
@end

@implementation SupplyDemandItemCell

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
imageClickableDelegate:(id<ECClickableElementDelegate>)imageClickableDelegate
                MOC:(NSManagedObjectContext *)MOC{
  
  self = [super initWithStyle:style
              reuseIdentifier:reuseIdentifier
       imageDisplayerDelegate:imageDisplayerDelegate
                          MOC:nil];
  
  if (self) {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryNone;
    self.backgroundColor = CELL_COLOR;
    self.contentView.backgroundColor = CELL_COLOR;
    
    _MOC = MOC;
    
    _imageClickableDelegate = imageClickableDelegate;
    
    _flagIcon = [[[UIImageView alloc] initWithFrame:CGRectMake(MARGIN * 2, MARGIN * 2, FLAG_SIDE_LEN, FLAG_SIDE_LEN)] autorelease];
    [self.contentView addSubview:_flagIcon];
    
    CGFloat x = _flagIcon.frame.origin.x + _flagIcon.frame.size.width + MARGIN * 2;
    _contentTextView = [[[JSCoreTextView alloc] initWithFrame:CGRectMake(x, MARGIN * 2, (self.frame.size.width - x - MARGIN * 2), 0)] autorelease];
    _contentTextView.backgroundColor = TRANSPARENT_COLOR;
    _contentTextView.fontName = SYS_FONT_NAME;
    _contentTextView.fontSize = 15.0f;
    _contentTextView.delegate = coreTextViewDelegate;
    _contentTextView.highlightColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    [self.contentView addSubview:_contentTextView];
    
    _tagListView = [[[TagListView alloc] initWithFrame:CGRectZero
                                     selectionDelegate:tagSelectionDelegate
                                                   MOC:_MOC] autorelease];
    [self.contentView addSubview:_tagListView];
    
    _dateLabel = [[self initLabel:CGRectZero
                       textColor:BASE_INFO_COLOR
                     shadowColor:TEXT_SHADOW_COLOR] autorelease];
    _dateLabel.font = FONT(12);
    [self.contentView addSubview:_dateLabel];
    
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
      _flagIcon.image = [UIImage imageNamed:@"supply.png"];
      break;
      
    case DEMAND_POST_TY:
      _flagIcon.image = [UIImage imageNamed:@"demand.png"];
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

- (void)arrangeTags:(NSString *)tagIds {
  
  CGFloat y = _contentTextView.frame.origin.y + _contentTextView.frame.size.height + MARGIN * 2;
    
  _tagListView.frame = CGRectMake(_flagIcon.frame.origin.x + _flagIcon.frame.size.width,
                                  y,
                                  self.frame.size.width - (_flagIcon.frame.origin.x + _flagIcon.frame.size.width),
                                  TAG_LIST_HEIGHT);
  
  [_tagListView drawTagIds:tagIds];
}

- (void)arrangeImageIfNeeded:(Post *)item {
  if (item.imageAttached.boolValue) {
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
  if (item.imageAttached.boolValue) {
    y = _imageButton.frame.origin.y + _imageButton.frame.size.height + MARGIN * 2;
  } else {
    y = _tagListView.frame.origin.y + _tagListView.frame.size.height + MARGIN * 2;
  }
  
  _dateLabel.text = item.elapsedTime;
  CGSize size = [_dateLabel.text sizeWithFont:_dateLabel.font];
  _dateLabel.frame = CGRectMake(_contentTextView.frame.origin.x,
                                y, size.width, size.height);
  
  _createdAtLabel.text = STR_FORMAT(@"%@ %@", LocaleStringForKey(NSFromTitle, nil), item.createdAt);
  size = [_createdAtLabel.text sizeWithFont:_createdAtLabel.font];
  _createdAtLabel.frame = CGRectMake(self.frame.size.width - MARGIN * 2 - size.width,
                                     y, size.width, size.height);
}

- (void)drawCellWithItem:(Post *)item {

  // draw flag
  [self arrangeFlag:item.postType.intValue];
  
  // draw text content
  [self arrangeTextView:item.content];
  
  // draw tag list
  [self arrangeTags:item.tagIds];
  
  // draw image if needed
  [self arrangeImageIfNeeded:item];
  
  // draw base info
  [self arrangeBaseInfo:item];
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
