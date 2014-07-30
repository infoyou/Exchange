//
//  PopupView.h
//  Project
//
//  Created by XXX on 13-5-31.
//
//

#import <UIKit/UIKit.h>

@interface PopupView : UIView <UITableViewDataSource, UITableViewDelegate> {
  @private
  
  id _target;
  SEL _selectionAction;
  
  BOOL _displayAbove;
  BOOL _displayLeft;
  
  CGFloat _height;
  
  CGFloat _arrowVertexY;
  CGFloat _arrowVertexX;
  
  CGFloat _midX;
  CGFloat _midY;
  
  CGPoint _topLeftPoint;
  CGPoint _bottomLeftPoint;

  CGPoint _topRightPoint;
  CGPoint _bottomRightPoint;
  
  CGPoint _arrowBottomLeftPoint;
  CGPoint _arrowBottomRightPoint;
  
  UITableView *_tableView;
  
  NSInteger _selectedIndex;
}

- (id)initWithDelegate:(id)delegate selectionAction:(SEL)selectionAction;

- (void)presentFromFrame:(CGRect)frame
               optionDic:(NSDictionary *)optionDic
    currentSelectedIndex:(NSInteger)currentSelectedIndex;

@end
