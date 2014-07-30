//
//  BaseUITableViewCell.m
//  Project
//
//  Created by XXX on 12-4-12.
//  Copyright (c) 2012年 _MyCompanyName_. All rights reserved.
//

#import "BaseUITableViewCell.h"
#import "WXWUIUtils.h"
#import "WXWImageManager.h"

@interface BaseUITableViewCell()
@property (nonatomic, retain) NSMutableArray *imageUrls;
@end

@implementation BaseUITableViewCell
@synthesize imageUrls = _imageUrls;
@synthesize errorMsgDic = _errorMsgDic;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    
  }
  return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
imageDisplayerDelegate:(id<WXWImageDisplayerDelegate>)imageDisplayerDelegate
                MOC:(NSManagedObjectContext *)MOC
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    _imageDisplayerDelegate = imageDisplayerDelegate;
    _MOC = MOC;
  }
  return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
imageDisplayerDelegate:(id<WXWImageDisplayerDelegate>)imageDisplayerDelegate
connectionTriggerHolderDelegate:(id<WXWConnectionTriggerHolderDelegate>)connectionTriggerHolderDelegate
                MOC:(NSManagedObjectContext *)MOC {
  
  self = [self initWithStyle:style
             reuseIdentifier:reuseIdentifier
      imageDisplayerDelegate:imageDisplayerDelegate
                         MOC:MOC];
  if (self) {
    _connectionTriggerHolderDelegate = connectionTriggerHolderDelegate;
    self.errorMsgDic = [NSMutableDictionary dictionary];
  }
  return self;
}

- (void)dealloc {
  if (self.imageUrls) {
    for (NSString *url in self.imageUrls) {
      [[WXWImageManager instance] clearCallerFromCache:url];
    }
    
    self.imageUrls = nil;
  }
  
  self.errorMsgDic = nil;
  
  self.connectionErrorMsg = nil;
  
  [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
  [super setSelected:selected animated:animated];
  // Configure the view for the selected state
}

- (void)setCellStyle:(CGFloat)cellHeight
{
  // Back ground
  UIView* bgView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
  bgView.backgroundColor = CELL_COLOR;//COLOR(229, 229, 231);
  self.backgroundView = bgView;
  
  // topSeparator
  UIView *topSeparator = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, LIST_WIDTH, 0.8f)] autorelease];
  topSeparator.backgroundColor = CELL_TOP_COLOR; // COLOR(172, 172, 172);
  [self.contentView addSubview:topSeparator];
  
  // bottomSeparator
  UIView *bottomSeparator = [[[UIView alloc] initWithFrame:CGRectMake(0, cellHeight - 0.8f, LIST_WIDTH, 0.8f)] autorelease];
  bottomSeparator.backgroundColor = CELL_BOTTOM_COLOR; // COLOR(175, 175, 175);
  [self.contentView addSubview:bottomSeparator];
  
  // Selected Style
  self.selectedBackgroundView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, LIST_WIDTH, cellHeight)] autorelease];
  self.selectedBackgroundView.backgroundColor = CELL_SELECTED_COLOR;
  self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  
  // Select Content Color Change
  self.contentView.layer.shadowColor = [UIColor grayColor].CGColor;
  self.contentView.layer.shadowOffset = CGSizeMake(0, 1.0f);
  self.contentView.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height)].CGPath;
}

- (void)requestConnection:(NSString *)url
               connFacade:(WXWAsyncConnectorFacade *)connFacade
         connectionAction:(SEL)connectionAction {
  if (_connectionTriggerHolderDelegate) {
    [_connectionTriggerHolderDelegate registerRequestUrl:url connFacade:connFacade];
  }
  
  [connFacade performSelector:connectionAction withObject:url];
}

#pragma mark - check connection error message
- (BOOL)connectionMessageIsEmpty:(NSError *)error {
  if (self.connectionErrorMsg && self.connectionErrorMsg.length > 0) {
    return NO;
  } else {
    
    if (error) {
      self.connectionErrorMsg = error.localizedDescription;
      return NO;
    }
    
    return YES;
  }
}

#pragma mark - ECConnectorDelegate methods

- (void)connectStarted:(NSString *)url contentType:(NSInteger)contentType {
  self.connectionErrorMsg = nil;
}

- (void)connectDone:(NSData *)result url:(NSString *)url contentType:(NSInteger)contentType {
  
  if (url && url.length > 0) {
    [self.errorMsgDic removeObjectForKey:url];
  }
}

- (void)traceParserXMLErrorMessage:(NSString *)message url:(NSString *)url {
  if (url && url.length > 0) {
    (self.errorMsgDic)[url] = message;
  }
}

- (void)connectCancelled:(NSString *)url contentType:(NSInteger)contentType {
  
}

- (void)connectFailed:(NSError *)error url:(NSString *)url contentType:(NSInteger)contentType {
  if (self.connectionErrorMsg && self.connectionErrorMsg.length > 0) {
    [WXWUIUtils showNotificationOnTopWithMsg:self.connectionErrorMsg
                                     msgType:ERROR_TY
                          belowNavigationBar:YES];
  }
}

- (void)parserConnectionError:(NSError *)error {
  if (nil == error) {
    return;
  }
  
  switch (error.code) {
    case kCFURLErrorTimedOut:
      self.connectionErrorMsg = LocaleStringForKey(NSTimeoutMsg, nil);
      break;
      
    case kCFURLErrorNotConnectedToInternet:
      self.connectionErrorMsg = LocaleStringForKey(NSNetworkUnstableMsg, nil);
      break;
      
    default:
      break;
  }
}

#pragma mark - WXWImageFetcherDelegate
- (void)imageFetchStarted:(NSString *)url {}
- (void)imageFetchDone:(UIImage *)image url:(NSString *)url {}
- (void)imageFetchFromeCacheDone:(UIImage *)image url:(NSString *)url {}
- (void)imageFetchFailed:(NSError *)error url:(NSString *)url {}

- (void)fetchImage:(NSMutableArray *)imageUrls forceNew:(BOOL)forceNew {
  
  self.imageUrls = imageUrls;
  
  for (NSString *url in imageUrls) {
    // register image url, when the displayer (view controller) be pop up from view controller stack, if
    // image still being loaded, the process could be cancelled
    [_imageDisplayerDelegate registerImageUrl:url];
    [[WXWImageManager instance] fetchImage:url caller:self forceNew:forceNew];
  }
}

- (CATransition *)imageTransition {
  CATransition *imageFadein = [CATransition animation];
  imageFadein.duration = FADE_IN_DURATION;
  imageFadein.type = kCATransitionFade;
  return imageFadein;
}

- (BOOL)currentUrlMatchCell:(NSString *)url {
  // if the image of current url need be displayed in current cell, then return YES; otherwise return NO;
  if (url && url.length > 0 && self.imageUrls) {
    return [self.imageUrls containsObject:url];
  } else {
    return NO;
  }
  
}

- (void)removeLabelShadowForHighlight:(UILabel **)label {
  (*label).shadowOffset = CGSizeMake(0, 0);
  (*label).shadowColor = TRANSPARENT_COLOR;
}

- (void)addLabelShadowForHighlight:(UILabel **)label {
  (*label).shadowOffset = CGSizeMake(0, 1.0f);
  (*label).shadowColor = [UIColor whiteColor];
}

- (void)hideLabelShadow {
  
}

- (void)showLabelShadow {
  
}

@end
