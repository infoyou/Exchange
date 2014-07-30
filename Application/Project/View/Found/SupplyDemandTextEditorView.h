//
//  SupplyDemandTextEditorView.h
//  Project
//
//  Created by XXX on 13-12-25.
//
//

#import <UIKit/UIKit.h>
#import "GlobalConstants.h"
#import "TextPool.h"
#import "WXWCommonUtils.h"
#import "WXWCoreDataUtils.h"

@class ECTextView;
@class ECGradientButton;
@class WXWLabel;

@protocol SupplyDemandTextEditorProtocal <NSObject>

- (void)openTags:(id)sender;

- (void)editPhoto:(id)sender;

@end

@interface SupplyDemandTextEditorView : UIView <UITextViewDelegate> {
  
  @private
  
  NSManagedObjectContext *_MOC;
  
  id<SupplyDemandTextEditorProtocal> _editorDelegate;
  
  UIButton *_supplyItemButton;
  UIButton *_demandItemButton;
  UIButton *_tagButton;
  
  ECGradientButton *_hideKeyboardButton;
  
  ECTextView *_textView;
  
  UIView *_selectedTagBoard;
  WXWLabel *_tagsLabel;
  
  CGFloat _originalHeight;
}

@property (nonatomic, assign, readonly) SupplyDemandItemType itemType;
@property (nonatomic, copy, readonly) NSString *content;
- (id)initWithFrame:(CGRect)frame
                MOC:(NSManagedObjectContext *)MOC
     editorDelegate:(id<SupplyDemandTextEditorProtocal>)editorDelegate;

//- (void)arrangeLayoutForKeyboardChange:(CGFloat)noKeyboardAreaHeight;

- (void)startSpin;
- (void)stopSpin;

- (void)hideKeyboard;

#pragma mark - arrange selected tags
- (void)arrangeSelectedTags:(NSArray *)tags;
@end
