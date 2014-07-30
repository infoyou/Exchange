
/*!
 @header TabBarView.h
 @abstract TabBar
 @author Adam
 @version 1.00 2014/03/18 Creation
 */

#import <UIKit/UIKit.h>

@protocol TabDelegate <NSObject>

- (void)selectFirstTabBar;
- (void)selectSecondTabBar;
- (void)selectThirdTabBar;
- (void)selectFourthTabBar;
- (void)selectFifthTabBar;

@end

@interface TabBarView : UIView {
    
  @private
  UIView *_selectedIndicator;
  
  id<TabDelegate> _delegate;
}

- (id)initWithFrame:(CGRect)frame delegate:(id<TabDelegate>)delegate;

- (void)refreshBadges;

- (void)refreshItems;

- (void)switchTabHighlightStatus:(NSInteger)tag;

@end
