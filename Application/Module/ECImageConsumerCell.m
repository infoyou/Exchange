//
//  ECImageConsumerCell.m
//  Project
//
//  Created by XXX on 11-11-10.
//  Copyright (c) 2011年 _CompanyName_. All rights reserved.
//

#import "ECImageConsumerCell.h"
#import "WXWImageManager.h"
#import "GlobalConstants.h"
#import "WXWConstants.h"


@interface ECImageConsumerCell()
@property (nonatomic, retain) NSMutableArray *imageUrls;
@end

@implementation ECImageConsumerCell

@synthesize imageUrls = _imageUrls;

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

/*
- (void)removeLabelShadowForHighlight:(UILabel **)label {
  (*label).shadowOffset = CGSizeMake(0, 0);
  (*label).shadowColor = TRANSPARENT_COLOR;
}

- (void)addLabelShadowForHighlight:(UILabel **)label {
  (*label).shadowOffset = CGSizeMake(0, 1.0f);
  (*label).shadowColor = [UIColor whiteColor];
}

- (void)hideLabelShadow {
  // implemented by sub class
}

- (void)showLabelShadow {
  // implemented by sub class
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}
*/

- (void)dealloc {
  
  for (NSString *url in self.imageUrls) {
    [[WXWImageManager instance] clearCallerFromCache:url];
  }
  
  self.imageUrls = nil;
  
  [super dealloc];
}

- (void)fetchImage:(NSMutableArray *)imageUrls forceNew:(BOOL)forceNew {
  
  if (imageUrls.count == 0) {
    return;
  }
  
  self.imageUrls = imageUrls;
  
  for (NSString *url in imageUrls) {
      
      [_imageDisplayerDelegate registerImageUrl:url];
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
  return [self.imageUrls containsObject:url];
}

#pragma mark - WXWImageFetcherDelegate methods
- (void)imageFetchStarted:(NSString *)url {
  // implemented by sub class
}

- (void)imageFetchDone:(UIImage *)image url:(NSString *)url {
  // implemented by sub class
}

- (void)imageFetchFromeCacheDone:(UIImage *)image url:(NSString *)url {
  // implemented by sub class
}

- (void)imageFetchFailed:(NSError *)error url:(NSString *)url {
  // implemented by sub class  
}


@end
