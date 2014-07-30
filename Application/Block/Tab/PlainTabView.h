//
//  PlainTabView.h
//  Project
//
//  Created by XXX on 13-2-18.
//
//

#import <UIKit/UIKit.h>

@protocol TapSwitchDelegate <NSObject>

@optional
- (void)selectTapByIndex:(NSInteger)index;

@end

@interface PlainTabView : UIView {

@private
  id<TapSwitchDelegate> _tapSwitchDelegate;
}

- (id)initWithFrame:(CGRect)frame
       buttonTitles:(NSArray *)buttonTitles
  tapSwitchDelegate:(id<TapSwitchDelegate>)tapSwitchDelegate;

#pragma mark - user action
- (void)selectButtonWithIndex:(NSInteger)index;
- (void)selectButtonWithIndexWithoutTriggerEvent:(NSInteger)index;

@end
