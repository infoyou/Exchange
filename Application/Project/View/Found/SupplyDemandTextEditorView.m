//
//  SupplyDemandTextEditorView.m
//  Project
//
//  Created by XXX on 13-12-25.
//
//

#import "SupplyDemandTextEditorView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIUtils.h"
#import "ECTextView.h"
#import "ECGradientButton.h"
#import "CommonUtils.h"
#import "Tag.h"
#import "WXWLabel.h"

#define TOOL_SPACE_HEIGHT     45.0f

#define SELECTED_TAG_HEIGHT   30.0f

#define TOOL_LINE_COLOR       COLOR(236,236,236)

#define BUTTON_WIDHT          100.0f

#define TAG_BTN_WIDTH         70.0f
#define TAG_BTN_HEIGHT        28.0f

#define HIDE_KEYBOARD_BTN_WIDTH   45.0f
#define HIDE_KEYBOARD_BTN_HEIGHT  24.0f


@interface SupplyDemandTextEditorView ()
@property (nonatomic, assign, readwrite) SupplyDemandItemType itemType;
@property (nonatomic, copy, readwrite) NSString *content;
@property (nonatomic, retain) UIActivityIndicatorView *spin;
@end

@implementation SupplyDemandTextEditorView

#pragma mark - user actions
- (void)changeItemType:(id)sender {
  
  UIButton *btn = (UIButton *)sender;
  
  self.itemType = btn.tag;
  switch (self.itemType) {
    case SUPPLY_ITEM_TY:
      [_supplyItemButton setImage:[UIImage imageNamed:@"radioButton.png"]
                         forState:UIControlStateNormal];
      [_demandItemButton setImage:[UIImage imageNamed:@"unselected.png"]
                         forState:UIControlStateNormal];
      break;
      
    case DEMAND_ITEM_TY:
      [_supplyItemButton setImage:[UIImage imageNamed:@"unselected.png"]
                         forState:UIControlStateNormal];
      [_demandItemButton setImage:[UIImage imageNamed:@"radioButton.png"]
                         forState:UIControlStateNormal];
      break;
      
    default:
      break;
  }
}

- (void)openTags:(id)sender {
  if (_editorDelegate) {
    
    [self hideShowKeyboard:nil];
    
    [_editorDelegate openTags:sender];
  }
}

- (void)editPhoto:(id)sender {
  if (_editorDelegate) {
    [_editorDelegate editPhoto:sender];
  }
}

#pragma mark - arrange views
- (void)arrangeOutline {
  self.layer.masksToBounds = YES;
  self.layer.borderWidth = 0.5f;
  self.layer.borderColor = COLOR(189, 199, 195).CGColor;
  self.layer.cornerRadius = 6.0f;
  
  self.backgroundColor = [UIColor whiteColor];
}

- (void)arrangeTopButtons {
  
  _supplyItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
  _supplyItemButton.tag = SUPPLY_ITEM_TY;
  _supplyItemButton.frame = CGRectMake(0, 0, BUTTON_WIDHT, TOOL_SPACE_HEIGHT);
  _supplyItemButton.backgroundColor = TRANSPARENT_COLOR;
  [_supplyItemButton setTitle:LocaleStringForKey(NSSupplyLongTitle, nil)
                     forState:UIControlStateNormal];
  [_supplyItemButton setTitleColor:DARK_TEXT_COLOR forState:UIControlStateNormal];
  _supplyItemButton.titleLabel.font = BOLD_FONT(14);
  [_supplyItemButton setImage:[UIImage imageNamed:@"unselected.png"]
                     forState:UIControlStateNormal];
  if (_editorDelegate) {
    [_supplyItemButton addTarget:self
                          action:@selector(changeItemType:)
                forControlEvents:UIControlEventTouchUpInside];
  }
  _supplyItemButton.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
  _supplyItemButton.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
  [self addSubview:_supplyItemButton];
  
  _demandItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
  _demandItemButton.tag = DEMAND_ITEM_TY;
  _demandItemButton.frame = CGRectMake(_supplyItemButton.frame.origin.x + _supplyItemButton.frame.size.width, 0, BUTTON_WIDHT, TOOL_SPACE_HEIGHT);
  _demandItemButton.backgroundColor = TRANSPARENT_COLOR;
  [_demandItemButton setTitle:LocaleStringForKey(NSDemandLongTitle, nil)
                     forState:UIControlStateNormal];
  [_demandItemButton setTitleColor:DARK_TEXT_COLOR forState:UIControlStateNormal];
  _demandItemButton.titleLabel.font = BOLD_FONT(14);
  [_demandItemButton setImage:[UIImage imageNamed:@"unselected.png"]
                     forState:UIControlStateNormal];
  if (_editorDelegate) {
    [_demandItemButton addTarget:self
                          action:@selector(changeItemType:)
                forControlEvents:UIControlEventTouchUpInside];
  }
  _demandItemButton.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
  _demandItemButton.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
  [self addSubview:_demandItemButton];
  
  _tagButton = [UIButton buttonWithType:UIButtonTypeCustom];
  _tagButton.frame = CGRectMake(self.bounds.size.width - MARGIN * 2 - TAG_BTN_WIDTH, (TOOL_SPACE_HEIGHT - TAG_BTN_HEIGHT)/2.0f, TAG_BTN_WIDTH, TAG_BTN_HEIGHT);
  [_tagButton setTitle:LocaleStringForKey(NSAddTagTitle, nil) forState:UIControlStateNormal];
  _tagButton.titleLabel.font = BOLD_FONT(12);
  _tagButton.layer.cornerRadius = 4.0f;
  _tagButton.layer.masksToBounds = YES;
  _tagButton.backgroundColor = COLOR(77, 82, 86);
  if (_editorDelegate) {
    [_tagButton addTarget:self
                   action:@selector(openTags:)
         forControlEvents:UIControlEventTouchUpInside];
  }
  [self addSubview:_tagButton];
}

- (void)initTextView {
  _textView = [[[ECTextView alloc] initWithFrame:CGRectMake(0, TOOL_SPACE_HEIGHT + SELECTED_TAG_HEIGHT, self.bounds.size.width, (self.bounds.size.height - TOOL_SPACE_HEIGHT - SELECTED_TAG_HEIGHT - 30))] autorelease];
  _textView.delegate = self;
  _textView.editable = YES;
  _textView.backgroundColor = TRANSPARENT_COLOR;
  _textView.font = FONT(17);
  _textView.placeholder = LocaleStringForKey(NSSupplyDemandContentTitle, nil);
  
  [self addSubview:_textView];
  
  _textView.contentSize = CGSizeMake(_textView.frame.size.width, _textView.frame.size.height - HIDE_KEYBOARD_BTN_HEIGHT);
}

- (void)hideShowKeyboard:(id)sender {
  
  [_textView resignFirstResponder];
}

 - (void)arrangeLayoutForKeyboardChange:(CGFloat)noKeyboardAreaHeight {
 [UIView animateWithDuration:0.1f
 animations:^{
 
 CGFloat workAreaHeight = noKeyboardAreaHeight - self.frame.origin.y - MARGIN + TOOL_SPACE_HEIGHT;
 
 [UIUtils adjustFrameForView:_textView newHeight:workAreaHeight - TOOL_SPACE_HEIGHT * 2 - HIDE_KEYBOARD_BTN_HEIGHT];
 
 }];
 }

- (void)initHideKeyboardButton {
  _hideKeyboardButton = [[[ECGradientButton alloc] initWithFrame:CGRectMake(self.frame.size.width - MARGIN - HIDE_KEYBOARD_BTN_WIDTH, self.frame.size.height, HIDE_KEYBOARD_BTN_WIDTH, HIDE_KEYBOARD_BTN_HEIGHT)
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
  
  [self addSubview:_hideKeyboardButton];
  
  _hideKeyboardButton.transform = CGAffineTransformMakeRotation(M_PI);
  
  _hideKeyboardButton.enabled = NO;
}

- (void)initTakePhotoButton {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  button.backgroundColor = [UIColor whiteColor];
  button.frame = CGRectMake(0, self.bounds.size.height - TOOL_SPACE_HEIGHT + 1, self.bounds.size.width, TOOL_SPACE_HEIGHT - 1);
  [button addTarget:self action:@selector(editPhoto:) forControlEvents:UIControlEventTouchUpInside];
  [button setImage:IMAGE_WITH_NAME(@"selectPhoto.png") forState:UIControlStateNormal];
  [self addSubview:button];
}

- (void)startSpin {
  if (nil == self.spin) {
    self.spin = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
    self.spin.frame = CGRectMake(0, 0, 20, 20);
    self.spin.center = CGPointMake(TAG_BTN_WIDTH/2.0f, TAG_BTN_HEIGHT/2.0f);
    [_tagButton addSubview:self.spin];
  }
  
  self.spin.hidden = NO;
  [self.spin startAnimating];
  
  [_tagButton setTitle:NULL_PARAM_VALUE forState:UIControlStateNormal];
}

- (void)stopSpin {
  
  if (self.spin.isAnimating) {
    [self.spin stopAnimating];
    self.spin.hidden = YES;
  }
  
  [_tagButton setTitle:LocaleStringForKey(NSAddTagTitle, nil) forState:UIControlStateNormal];
}

- (void)hideKeyboard {
  if (_textView.isFirstResponder) {
    [_textView resignFirstResponder];
  }
}

#pragma mark - arrange selected tags
- (void)arrangeSelectedTags:(NSArray *)tags {
  
  if (tags.count == 0) {
    return;
  }
  
  if (nil == _selectedTagBoard) {
    _selectedTagBoard = [[[UIView alloc] initWithFrame:CGRectMake(0, TOOL_SPACE_HEIGHT + 1, self.frame.size.width, SELECTED_TAG_HEIGHT)] autorelease];
    _selectedTagBoard.backgroundColor = TRANSPARENT_COLOR;
    [self addSubview:_selectedTagBoard];
    
    UIImageView *tagIcon = [[[UIImageView alloc] initWithImage:IMAGE_WITH_NAME(@"tag.png")] autorelease];
    tagIcon.frame = CGRectMake(MARGIN * 3, (SELECTED_TAG_HEIGHT - tagIcon.frame.size.height)/2.0f,
                               tagIcon.frame.size.width, tagIcon.frame.size.height);
    [_selectedTagBoard addSubview:tagIcon];
    
    _tagsLabel = [[[WXWLabel alloc] initWithFrame:CGRectMake(tagIcon.frame.origin.x + tagIcon.frame.size.width + MARGIN * 2, 0, 0, 0)
                                        textColor:DARK_TEXT_COLOR
                                      shadowColor:TRANSPARENT_COLOR
                                             font:BOLD_FONT(11)] autorelease];
    _tagsLabel.numberOfLines = 1;
    [_selectedTagBoard addSubview:_tagsLabel];
  }
  
  NSMutableString *tagStr = [NSMutableString string];
  NSInteger i = 0;
  for (Tag *tag in tags) {
    if (i == 0) {
      [tagStr appendString:tag.tagName];
    } else {
      [tagStr appendFormat:@" | %@", tag.tagName];
    }
    i++;
  }
  
  _tagsLabel.text = tagStr;
  
  CGSize size = [tagStr sizeWithFont:_tagsLabel.font
                   constrainedToSize:CGSizeMake(self.frame.size.width - MARGIN * 6 - MARGIN * 2, 20)];
  _tagsLabel.frame = CGRectMake(_tagsLabel.frame.origin.x,
                                (SELECTED_TAG_HEIGHT - size.height)/2.0f, size.width, size.height);
}

#pragma mark - life cycle methods

- (void)resetTags {
  NSArray *tags = [WXWCoreDataUtils fetchObjectsFromMOC:_MOC
                                             entityName:@"Tag"
                                              predicate:nil];
  for (Tag *tag in tags) {
    tag.selected = @(NO);
    tag.changed = @(NO);
  }

  SAVE_MOC(_MOC);
}

- (id)initWithFrame:(CGRect)frame
                MOC:(NSManagedObjectContext *)MOC
     editorDelegate:(id<SupplyDemandTextEditorProtocal>)editorDelegate
{
  self = [super initWithFrame:frame];
  if (self) {
    
    _editorDelegate = editorDelegate;
    
    _originalHeight = frame.size.height;
    
    _MOC = MOC;
    
    self.itemType = INIT_VALUE_TYPE;
    
    [self resetTags];
    
    [self arrangeOutline];
    
    [self arrangeTopButtons];
    
    [self initTextView];
    
    [self initHideKeyboardButton];
    
    self.clearsContextBeforeDrawing = NO;
  }
  return self;
}

- (void)dealloc {
  
  self.content = nil;
  
  self.spin = nil;
  
  [super dealloc];
}

- (void)drawRect:(CGRect)rect {
  
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  
  [UIUtils draw1PxStroke:ctx
              startPoint:CGPointMake(0, TOOL_SPACE_HEIGHT)
                endPoint:CGPointMake(self.bounds.size.width, TOOL_SPACE_HEIGHT)
                   color:TOOL_LINE_COLOR.CGColor
            shadowOffset:CGSizeZero
             shadowColor:TRANSPARENT_COLOR];
  
}

#pragma mark - UITextViewDelegate methods

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
  
  [UIView animateWithDuration:0.2f
                   animations:^{
                       
                     if (![CommonUtils screenHeightIs4Inch]) {
                       self.frame = CGRectMake(self.frame.origin.x,
                                               -80,
                                               self.frame.size.width,
                                               self.frame.size.height);
                     }
                   }];
  
    _hideKeyboardButton.frame = CGRectMake(_hideKeyboardButton.frame.origin.x,
                                           self.frame.size.height - HIDE_KEYBOARD_BTN_HEIGHT - MARGIN,
                                           HIDE_KEYBOARD_BTN_WIDTH, HIDE_KEYBOARD_BTN_HEIGHT);
    
    _hideKeyboardButton.enabled = YES;
  return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
  self.content = textView.text;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
  
  [UIView animateWithDuration:0.1f
                   animations:^{
                     
                     if (![CommonUtils screenHeightIs4Inch]) {
                       self.frame = CGRectMake(self.frame.origin.x,
                                               MARGIN * 3,
                                               self.frame.size.width, self.frame.size.height);
                     }
                   }];
    
    [UIUtils adjustFrameForView:_hideKeyboardButton newY:self.frame.size.height];
    
    _hideKeyboardButton.enabled = NO;

}

@end
