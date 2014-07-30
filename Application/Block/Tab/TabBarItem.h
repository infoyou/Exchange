//
//  TabBarItem.h
//  Project
//
//  Created by XXX on 14-1-10.
//
//

#import <UIKit/UIKit.h>

@class WXWLabel;
@class WXWNumberBadge;

@interface TabBarItem : UIView {
  @private
  WXWLabel *_titleLabel;
  
  UIImageView *_imageView;
  
  WXWNumberBadge *_numberBadge;
  
  id _delegate;
  SEL _selectionAction;
}

- (id)initWithFrame:(CGRect)frame
           delegate:(id)delegate
    selectionAction:(SEL)selectionAction
                tag:(NSInteger)tag;

- (void)setTitleColorForHighlight:(BOOL)highlight;

- (void)setImage:(UIImage *)image;

- (void)setTitle:(NSString *)title image:(UIImage *)image;

#pragma mark - set number badge
- (void)setNumberBadgeWithCount:(NSInteger)count;

@end
