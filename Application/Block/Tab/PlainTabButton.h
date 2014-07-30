//
//  PlainTabButton.h
//  Project
//
//  Created by XXX on 13-2-18.
//
//

#import <UIKit/UIKit.h>

@class WXWLabel;

@interface PlainTabButton : UIView {
  @private
  
  BOOL _selected;
  
  BOOL _needLeftBorder;
  
  WXWLabel *_titleLabel;
  
  NSInteger _buttonIndex;
  
  id _parent;
  SEL _selectinAction;
}

- (id)initWithFrame:(CGRect)frame
     needLeftBorder:(BOOL)needLeftBorder
              title:(NSString *)title
             parent:(id)parent
    selectionAction:(SEL)selectionAction
        buttonIndex:(NSInteger)buttonIndex;

- (void)select;

- (void)deselect;

@end
