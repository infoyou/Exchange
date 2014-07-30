//
//  SupplyDemandPostCell.h
//  Project
//
//  Created by XXX on 13-7-3.
//
//

#import "ECImageConsumerCell.h"
#import "JSCoreTextView.h"
#import "TagListView.h"
#import "ECClickableElementDelegate.h"

@class TagListView;
@class Post;
@class WXWLabel;

@interface SupplyDemandPostCell : ECImageConsumerCell {
@private
    
    UIImageView *_flagIcon;
    
    JSCoreTextView *_contentTextView;
    
    CGFloat _textHeight;
    
    TagListView *_tagListView;
    
    WXWLabel *_dateLabel;
    WXWLabel *_createdAtLabel;
    
    UIImageView *_commentIV;
    WXWLabel *_commentLabel;
    UIImageView *_favoriteIV;
    WXWLabel *_favoriteLabel;
    UIImageView *_shareIV;
    WXWLabel *_shareLabel;
    UIImageView *_commentLineIV;
    
    // image
    UIButton *_imageButton;
    id<ECClickableElementDelegate> _imageClickableDelegate;
}

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
coreTextViewDelegate:(id<JSCoreTextViewDelegate>)coreTextViewDelegate
tagSelectionDelegate:(id<TagSelectionDelegate>)tagSelectionDelegate
imageDisplayerDelegate:(id<WXWImageDisplayerDelegate>)imageDisplayerDelegate
imageClickableDelegate:(id<ECClickableElementDelegate>)imageClickableDelegate;

- (void)drawCellWithPost:(Post *)post;

@end
