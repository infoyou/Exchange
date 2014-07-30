//
//  BizPostHeaderView.h
//  Project
//
//  Created by XXX on 13-5-29.
//
//

#import <UIKit/UIKit.h>
#import "WXWGradientView.h"
#import "ECEditorDelegate.h"

@class UIImageButton;
@class ECTextView;
@class ECTextField;
@class ECGradientButton;

@interface BizPostHeaderView : WXWGradientView <UITextViewDelegate> {
@private
    
    id<ECEditorDelegate> _editorDelegate;
    
    UIImageButton *_supplyButton;
    UIImageButton *_demandButton;
    
    ECTextField *_tagsField;
    UIView *_backgroundView;
    ECTextView *_textView;
    
    PostType _type;
    
    ECGradientButton *_hideKeyboardButton;
    
    BOOL _keyboardShowing;
    
    BOOL _flipTriggeredByButton;
    
    CGFloat _animatedDistance;
}

- (id)initWithFrame:(CGRect)frame
           topColor:(UIColor *)topColor
        bottomColor:(UIColor *)bottomColor
     editorDelegate:(id<ECEditorDelegate>)editorDelegate;

- (void)arrangeLayoutForKeyboardChange:(CGFloat)noKeyboardAreaHeight;

- (NSInteger)charCount;

- (NSString *)tags;

- (PostType)contentType;

- (void)changeTextValue:(NSString *)value tag:(NSString *)tag type:(int)type;

@end
