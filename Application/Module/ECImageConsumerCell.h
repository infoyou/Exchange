//
//  ECImageConsumerCell.h
//  Project
//
//  Created by XXX on 11-11-10.
//  Copyright (c) 2011年 _CompanyName_. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <QuartzCore/QuartzCore.h>
#import "WXWImageFetcherDelegate.h"
#import "WXWImageDisplayerDelegate.h"
#import "BaseTextBoardCell.h"

@interface ECImageConsumerCell : BaseTextBoardCell <WXWImageFetcherDelegate> {
  
  id<WXWImageDisplayerDelegate> _imageDisplayerDelegate;
  
  NSManagedObjectContext *_MOC;
  
@private
  NSMutableArray *_imageUrls;
  
}

- (id)initWithStyle:(UITableViewCellStyle)style 
    reuseIdentifier:(NSString *)reuseIdentifier
imageDisplayerDelegate:(id<WXWImageDisplayerDelegate>)imageDisplayerDelegate
                MOC:(NSManagedObjectContext *)MOC;

- (CATransition *)imageTransition;

- (BOOL)currentUrlMatchCell:(NSString *)url;

- (void)fetchImage:(NSMutableArray *)imageUrls forceNew:(BOOL)forceNew;

/*
- (void)removeLabelShadowForHighlight:(UILabel **)label;

- (void)addLabelShadowForHighlight:(UILabel **)label;

- (void)hideLabelShadow;

- (void)showLabelShadow;
*/
@end
