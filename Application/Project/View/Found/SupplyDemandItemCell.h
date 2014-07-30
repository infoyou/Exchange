//
//  SupplyDemandItemCell.h
//  Project
//
//  Created by XXX on 13-6-4.
//
//

#import "ECImageConsumerCell.h"
#import "JSCoreTextView.h"
#import "TagListView.h"
#import "ECClickableElementDelegate.h"

@class TagListView;
@class Post;
@class WXWLabel;

@interface SupplyDemandItemCell : ECImageConsumerCell {
  @private
  
  UIImageView *_flagIcon;
  
  JSCoreTextView *_contentTextView;
  
  CGFloat _textHeight;
  
  TagListView *_tagListView;
  
  WXWLabel *_dateLabel;
  WXWLabel *_createdAtLabel;

  // image
  UIButton *_imageButton;
  id<ECClickableElementDelegate> _imageClickableDelegate;
}

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
coreTextViewDelegate:(id<JSCoreTextViewDelegate>)coreTextViewDelegate
tagSelectionDelegate:(id<TagSelectionDelegate>)tagSelectionDelegate
imageDisplayerDelegate:(id<WXWImageDisplayerDelegate>)imageDisplayerDelegate
imageClickableDelegate:(id<ECClickableElementDelegate>)imageClickableDelegate
                  MOC:(NSManagedObjectContext *)MOC;

- (void)drawCellWithItem:(Post *)item;

@end
