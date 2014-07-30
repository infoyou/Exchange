//
//  BizPostHeaderTagView.m
//  Project
//
//  Created by XXX on 13-5-29.
//
//

#import "BizPostHeaderTagView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageButton.h"
#import "ECTextView.h"
#import "ECTextField.h"
#import "ECGradientButton.h"
#import "WXWCommonUtils.h"

#define CHECK_BTN_WIDTH   145.0f
#define CHECK_BTN_HEIGHT  30.0f

#define BUTTON_IMAGE_EDGE UIEdgeInsetsMake(0, -20, 0, 0)

#define TAG_FIELD_HEIGHT  40.0f

#define HIDE_KEYBOARD_BTN_WIDTH   45.0f
#define HIDE_KEYBOARD_BTN_HEIGHT  24.0f

@interface BizPostHeaderTagView()
@property (nonatomic, copy) NSString *content;
@end

@implementation BizPostHeaderTagView

#pragma mark - user actions
- (void)selectSupply:(id)sender {
  [_supplyButton setImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
  [_demandButton setImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
  
  _type = SUPPLY_POST_TY;
}

- (void)selectDemand:(id)sender {
  [_demandButton setImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
  [_supplyButton setImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
  
  _type = DEMAND_POST_TY;
}

#pragma mark - ui elements status
- (NSInteger)charCount {
  return [_textView.text length];
}

- (NSString *)tags {
  return _tagsField.text;
}

- (PostType)contentType {
  return _type;
}

#pragma mark - arrange views

- (void)hideShowKeyboard:(id)sender {
  
  _flipTriggeredByButton = YES;
  
  /*
  [UIView animateWithDuration:0.2f
                   animations:^{
                     if (_keyboardShowing) {
                       _keyboardShowing = !_keyboardShowing;
                       [_textView resignFirstResponder];
                       _hideKeyboardButton.transform = CGAffineTransformMakeRotation(0);
                     } else {
                       _keyboardShowing = !_keyboardShowing;
                       [_textView becomeFirstResponder];
                       _hideKeyboardButton.transform = CGAffineTransformMakeRotation(M_PI);
                     }
                   }]; 
   */
  
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:0.2f];
  
  if (_keyboardShowing) {
    _keyboardShowing = !_keyboardShowing;
    [_textView resignFirstResponder];
//    _hideKeyboardButton.transform = CGAffineTransformMakeRotation(0);
  } else {
    _keyboardShowing = !_keyboardShowing;
    [_textView becomeFirstResponder];
//    _hideKeyboardButton.transform = CGAffineTransformMakeRotation(M_PI);
  }
  
  [UIView commitAnimations];

}

- (void)arrangeLayoutForKeyboardChange:(CGFloat)noKeyboardAreaHeight {
  
  [UIView animateWithDuration:0.1f
                   animations:^{
                     if (noKeyboardAreaHeight - KEYBOARD_GAP < self.frame.size.height) {
                       // Chinese input method displayed, height of text view should be cut
                       _backgroundView.frame = CGRectMake(_backgroundView.frame.origin.x, _backgroundView.frame.origin.y, _backgroundView.frame.size.width, noKeyboardAreaHeight - MARGIN - _backgroundView.frame.origin.y);
                     } else {
                       // height of text view should be enlarged
                       _backgroundView.frame = CGRectMake(_backgroundView.frame.origin.x, _backgroundView.frame.origin.y, _backgroundView.frame.size.width, noKeyboardAreaHeight - KEYBOARD_GAP - MARGIN - _backgroundView.frame.origin.y);
                     }
                     
                     _textView.frame = CGRectMake(0, 0, _backgroundView.frame.size.width, _backgroundView.frame.size.height - HIDE_KEYBOARD_BTN_HEIGHT - MARGIN);
                     
                     _hideKeyboardButton.frame = CGRectMake(_backgroundView.frame.size.width - MARGIN - HIDE_KEYBOARD_BTN_WIDTH, _backgroundView.frame.size.height - MARGIN - HIDE_KEYBOARD_BTN_HEIGHT, HIDE_KEYBOARD_BTN_WIDTH, HIDE_KEYBOARD_BTN_HEIGHT);

                   }];  
}

- (void)addCategoryButtons {
  
  _supplyButton = [[[UIImageButton alloc] initImageButtonWithFrame:CGRectMake(MARGIN * 2, MARGIN * 2, CHECK_BTN_WIDTH, CHECK_BTN_HEIGHT)
                                                                target:self
                                                                action:@selector(selectSupply:)
                                                                 title:LocaleStringForKey(NSSupplyLongTitle, nil)
                                                                 image:[UIImage imageNamed:@"unselected.png"]
                                                           backImgName:nil
                                                        selBackImgName:nil
                                                             titleFont:BOLD_FONT(14)
                                                            titleColor:DARK_TEXT_COLOR
                                                      titleShadowColor:TEXT_SHADOW_COLOR
                                                           roundedType:HAS_ROUNDED
                                                       imageEdgeInsert:BUTTON_IMAGE_EDGE
                                                       titleEdgeInsert:ZERO_EDGE] autorelease];
  
  [self addSubview:_supplyButton];

  _demandButton = [[[UIImageButton alloc] initImageButtonWithFrame:CGRectMake(self.frame.size.width - CHECK_BTN_WIDTH - MARGIN * 2, MARGIN * 2, CHECK_BTN_WIDTH, CHECK_BTN_HEIGHT)
                                                            target:self
                                                            action:@selector(selectDemand:)
                                                             title:LocaleStringForKey(NSDemandLongTitle, nil)
                                                             image:[UIImage imageNamed:@"unselected.png"]
                                                       backImgName:nil
                                                    selBackImgName:nil
                                                         titleFont:BOLD_FONT(14)
                                                        titleColor:DARK_TEXT_COLOR
                                                  titleShadowColor:TEXT_SHADOW_COLOR
                                                       roundedType:HAS_ROUNDED
                                                   imageEdgeInsert:BUTTON_IMAGE_EDGE
                                                   titleEdgeInsert:ZERO_EDGE] autorelease];
  [self addSubview:_demandButton];
  
}

- (void)arrangeTagsField {
  
  _tagsField = [[[ECTextField alloc] initWithFrame:CGRectMake(MARGIN * 2, _demandButton.frame.origin.y + _demandButton.frame.size.height + MARGIN * 2, self.frame.size.width - MARGIN * 4, 40.0f)] autorelease];
  
  _tagsField.font = BOLD_FONT(13);
  _tagsField.backgroundColor = [UIColor whiteColor];
  _tagsField.placeholder = LocaleStringForKey(NSSupplyDemandTagPlaceholderTitle, nil);
  _tagsField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
  _tagsField.layer.borderColor = COLOR(215, 215, 215).CGColor;
  _tagsField.layer.borderWidth = 1.0f;
  _tagsField.clearButtonMode = UITextFieldViewModeWhileEditing;
  
  [self addSubview:_tagsField];
  
}

- (void)arrangeTextView {
  
  CGFloat y = _tagsField.frame.origin.y + _tagsField.frame.size.height + MARGIN * 2;
  
  _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(MARGIN * 2, y, self.frame.size.width - MARGIN * 4, self.frame.size.height - y - MARGIN)];
  _backgroundView.backgroundColor = [UIColor whiteColor];
  _backgroundView.layer.cornerRadius = 8.0f;
  _backgroundView.layer.borderColor = COLOR(215, 215, 215).CGColor;
  _backgroundView.layer.borderWidth = 2.0f;
  [self addSubview:_backgroundView];

  
  _textView = [[ECTextView alloc] initWithFrame:CGRectMake(0, 0, _backgroundView.frame.size.width, _backgroundView.frame.size.height - HIDE_KEYBOARD_BTN_HEIGHT - MARGIN)];
  _textView.delegate = self;
  _textView.editable = YES;
  _textView.backgroundColor = TRANSPARENT_COLOR;
  _textView.contentSize = CGSizeMake(_textView.frame.size.width, _textView.frame.size.height - HIDE_KEYBOARD_BTN_HEIGHT);
  _textView.font = FONT(17);
  _textView.placeholder = LocaleStringForKey(NSSupplyDemandContentTitle, nil);
  
  [_backgroundView addSubview:_textView];
  
  _hideKeyboardButton = [[[ECGradientButton alloc] initWithFrame:CGRectMake(_backgroundView.frame.size.width - MARGIN - HIDE_KEYBOARD_BTN_WIDTH, _backgroundView.frame.size.height - MARGIN - HIDE_KEYBOARD_BTN_HEIGHT, HIDE_KEYBOARD_BTN_WIDTH, HIDE_KEYBOARD_BTN_HEIGHT)
                                                         target:self
                                                         action:@selector(hideShowKeyboard:)
                                                      colorType:WHITE_BTN_COLOR_TY
                                                          title:nil
                                                          image:nil
                                                     titleColor:nil
                                               titleShadowColor:nil
                                                      titleFont:nil
                                                    roundedType:HAS_ROUNDED
                                                imageEdgeInsert:ZERO_EDGE
                                                titleEdgeInsert:ZERO_EDGE] autorelease];
  
  UIImageView *keyboard = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"keyboard.png"]] autorelease];
  keyboard.frame = CGRectMake(5, 5, 22, 14);
  [_hideKeyboardButton addSubview:keyboard];
  
  UIImageView *arrow = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"upArrow.png"]] autorelease];
  arrow.frame = CGRectMake(31, 5, 10, 14);
  [_hideKeyboardButton addSubview:arrow];
  
  [_backgroundView addSubview:_hideKeyboardButton];

}

- (void)addShadow {
  CGRect bounds = self.bounds;
  
  UIBezierPath *shadowPath = [UIBezierPath bezierPath];
  
  [shadowPath moveToPoint:CGPointMake(-2, bounds.size.height)];
  [shadowPath addLineToPoint:CGPointMake(bounds.size.width + 2, bounds.size.height)];
  [shadowPath addLineToPoint:CGPointMake(bounds.size.width + 2, bounds.size.height + 3)];
  [shadowPath addLineToPoint:CGPointMake(-2, bounds.size.height + 3)];
  [shadowPath addLineToPoint:CGPointMake(-2, bounds.size.height)];
  
  self.layer.shadowColor = [UIColor darkGrayColor].CGColor;
  self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
  self.layer.shadowOpacity = 0.8f;
  self.layer.masksToBounds = NO;
  self.layer.shadowPath = shadowPath.CGPath;
}

#pragma mark - UITextViewDelegate methods

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
  
  if (!_keyboardShowing) {
    [self hideShowKeyboard:nil];
  }
  
  _flipTriggeredByButton = NO;
  
  return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
  self.content = textView.text;
  [_editorDelegate textChanged:self.content];
}


#pragma mark - lifecycle methods
- (id)initWithFrame:(CGRect)frame
           topColor:(UIColor *)topColor
        bottomColor:(UIColor *)bottomColor
     editorDelegate:(id<ECEditorDelegate>)editorDelegate
{
  
  self = [super initWithFrame:frame topColor:topColor bottomColor:bottomColor];
  if (self) {
    
    _editorDelegate = editorDelegate;
    
    _type = INIT_VALUE_TYPE;
    
    [self addShadow];
    
    [self addCategoryButtons];
    
    [self arrangeTagsField];
    
    [self arrangeTextView];
  }
  return self;
}

- (void)dealloc {
  
  self.content = nil;
  
  [super dealloc];
}


@end
