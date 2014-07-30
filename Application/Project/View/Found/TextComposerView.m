//
//  TextComposerView.m
//  Project
//
//  Created by XXX on 11-11-17.
//  Copyright (c) 2011年 _CompanyName_. All rights reserved.
//

#import "TextComposerView.h"
#import <QuartzCore/QuartzCore.h>
#import "ECGradientButton.h"
#import "WXWLabel.h"
#import "ECTextView.h"
#import "UIUtils.h"
#import "WXWCoreDataUtils.h"
#import "ComposerTag.h"
#import "AppManager.h"
#import "CommonUtils.h"
#import "Place.h"
#import "WXWCommonUtils.h"

#define BUTTON_WIDTH    145.0f
#define BUTTON_HEIGHT   30.0f

#define CANCEL_BUTTON_WIDTH   24.0f
#define CANCEL_BUTTON_HEIGHT  24.0f

#define HIDE_KEYBOARD_BTN_WIDTH   45.0f
#define HIDE_KEYBOARD_BTN_HEIGHT  24.0f

#define IMG_EDGE        UIEdgeInsetsMake(-29, 100, -27.0, 0.0)
#define TITLE_EDGE      UIEdgeInsetsMake(-29, -60, -27.0, 0.0)

@interface TextComposerView()
@property (nonatomic, copy) NSString *tagPlaceInfo;

@end

@implementation TextComposerView

@synthesize content = _content;
@synthesize tagPlaceInfo = _tagPlaceInfo;
@synthesize selectedPlace = _selectedPlace;

#pragma mark - user actions
- (void)chooseTags:(id)sender {
    [_delegate chooseTags];
}

- (void)deselectPlace {
    self.selectedPlace.selected = @NO;
    [WXWCoreDataUtils saveMOCChange:_MOC];
    self.selectedPlace = nil;
}

- (void)cancelPlace:(id)sender {
//    _placeCancelled = !_placeCancelled;
//    
//    [self deselectPlace];
//    
//    _placeLabel.text = [AppManager instance].cityName;
//    
//    CGSize size = [_placeLabel.text sizeWithFont:_placeLabel.font
//                               constrainedToSize:CGSizeMake(_hideKeyboardButton.frame.origin.x - MARGIN * 2, CGFLOAT_MAX) 
//                                   lineBreakMode:NSLineBreakByWordWrapping];
//    
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.2f];
//    _cancelPlaceButton.hidden = YES;
//    _cancelPlaceButton.enabled = NO;
//    
//    _placeLabel.frame = CGRectMake(MARGIN * 2, _placeLabel.frame.origin.y, size.width, _placeLabel.frame.size.height);
//    
//    [UIView commitAnimations];
}

- (void)choosePlaces:(id)sender {
    if (_locationDone) {
        [_delegate choosePlace];
    } else {
        [UIUtils showNotificationOnTopWithMsg:LocaleStringForKey(NSLoadNearbyFailedMsg, nil)
                                      msgType:ERROR_TY
                           belowNavigationBar:YES];
    }
    
}

- (void)hideShowKeyboard:(id)sender {
    
    _flipTriggeredByButton = YES;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2f];
    
    if (_keyboardShowing) {
        _keyboardShowing = !_keyboardShowing;
        [_textView resignFirstResponder];
        _hideKeyboardButton.transform = CGAffineTransformMakeRotation(0);
    } else {
        _keyboardShowing = !_keyboardShowing;
        [_textView becomeFirstResponder];    
        _hideKeyboardButton.transform = CGAffineTransformMakeRotation(M_PI);
    }
    
    [UIView commitAnimations];
}

#pragma mark - ui elements status
- (NSInteger)charCount {
    return [_textView.text length];
}

#pragma mark - adjust layout
- (void)arrangeLayoutForKeyboardChange:(CGFloat)noKeyboardAreaHeight {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1f];
    
    if (noKeyboardAreaHeight - KEYBOARD_GAP < self.frame.size.height) {
        // Chinese input method displayed, height of text view should be cut
        _backgroundView.frame = CGRectMake(_backgroundView.frame.origin.x, _backgroundView.frame.origin.y, _backgroundView.frame.size.width, noKeyboardAreaHeight - MARGIN - _backgroundView.frame.origin.y);
    } else {
        // height of text view should be enlarged
        _backgroundView.frame = CGRectMake(_backgroundView.frame.origin.x, _backgroundView.frame.origin.y, _backgroundView.frame.size.width, noKeyboardAreaHeight - KEYBOARD_GAP - MARGIN - _backgroundView.frame.origin.y);
    }
    
    _textView.frame = CGRectMake(0, 0, _backgroundView.frame.size.width, _backgroundView.frame.size.height - HIDE_KEYBOARD_BTN_HEIGHT - MARGIN);
    
    _hideKeyboardButton.frame = CGRectMake(_backgroundView.frame.size.width - MARGIN - HIDE_KEYBOARD_BTN_WIDTH, _backgroundView.frame.size.height - MARGIN - HIDE_KEYBOARD_BTN_HEIGHT, HIDE_KEYBOARD_BTN_WIDTH, HIDE_KEYBOARD_BTN_HEIGHT);
    
    _placeLabel.frame = CGRectMake(_placeLabel.frame.origin.x, _backgroundView.frame.size.height - HIDE_KEYBOARD_BTN_HEIGHT, _placeLabel.frame.size.width, _placeLabel.frame.size.height);
    _smsView.frame = CGRectMake(MARGIN, _hideKeyboardButton.frame.origin.y, 200, HIDE_KEYBOARD_BTN_HEIGHT);
    _cancelPlaceButton.frame = CGRectMake(_cancelPlaceButton.frame.origin.x, _backgroundView.frame.size.height - HIDE_KEYBOARD_BTN_HEIGHT - 2.0f, _cancelPlaceButton.frame.size.width, _cancelPlaceButton.frame.size.height);
    
    [UIView commitAnimations];
}

- (void)showPlaceButton:(BOOL)success {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2f];
    
    //_placeButton.enabled = enable;
    _locationDone = success;
    
    [_placeSpinView stopAnimating];
    _placeSpinView.hidden = YES;
    
    [_placeButton setImage:[UIImage imageNamed:@"location.png"] 
                  forState:UIControlStateNormal];
    _placeButton.titleEdgeInsets = TITLE_EDGE;
    _placeButton.imageEdgeInsets = IMG_EDGE;
    
    [UIView commitAnimations];
}

#pragma mark - show tags and place info

- (void)adjustPlaceInfoCancelButtonLayout {
    
    _cancelPlaceButton.hidden = NO;
    _cancelPlaceButton.enabled = YES;
    
    CGSize size = [_placeLabel.text sizeWithFont:_placeLabel.font 
                               constrainedToSize:CGSizeMake(_hideKeyboardButton.frame.origin.x - _cancelPlaceButton.frame.origin.x - _cancelPlaceButton.frame.size.width - MARGIN, CGFLOAT_MAX) 
                                   lineBreakMode:NSLineBreakByTruncatingTail];
    _placeLabel.frame = CGRectMake(_cancelPlaceButton.frame.origin.x + _cancelPlaceButton.frame.size.width + MARGIN, _placeLabel.frame.origin.y, size.width, _placeLabel.frame.size.height);
}

- (void)displaySelectedTagsAndPlace {
    
    // display selected tags info
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(selected == 1)"];
    NSArray *selectedTags = [WXWCoreDataUtils fetchObjectsFromMOC:_MOC 
                                                    entityName:@"ComposerTag"
                                                     predicate:predicate];
    self.tagPlaceInfo = nil;
    if ([selectedTags count] > 0) {
        self.tagPlaceInfo = [NSString stringWithFormat:@"%@", LocaleStringForKey(NSTagHeader, nil)];
        NSInteger index = 0;
        for (ComposerTag *tag in selectedTags) {
            if (index > 0) {
                self.tagPlaceInfo = [NSString stringWithFormat:@"%@, %@", self.tagPlaceInfo, tag.tagName];
            } else {
                self.tagPlaceInfo = [NSString stringWithFormat:@"%@ %@", self.tagPlaceInfo, tag.tagName];
            }
            index++;
        }
    }
    
    _infoLabel.text = self.tagPlaceInfo;
    
    // display selected place info
    NSArray *places = [WXWCoreDataUtils fetchObjectsFromMOC:_MOC entityName:@"Place" predicate:SELECTED_PREDICATE];
    if (places && [places count] > 0) {
        self.selectedPlace = (Place *)[places lastObject];
        _placeLabel.text = _selectedPlace.placeName;
        [self adjustPlaceInfoCancelButtonLayout];
    }
}

- (void)setCityInfo:(NSString *)cityInfo {
    _placeLabel.text = cityInfo;
    
    CGSize size = [_placeLabel.text sizeWithFont:_placeLabel.font 
                               constrainedToSize:CGSizeMake(_hideKeyboardButton.frame.origin.x - _cancelPlaceButton.frame.origin.x - _cancelPlaceButton.frame.size.width - MARGIN, CGFLOAT_MAX) 
                                   lineBreakMode:NSLineBreakByWordWrapping];
    _placeLabel.frame = CGRectMake(_placeLabel.frame.origin.x, _placeLabel.frame.origin.y, size.width, _placeLabel.frame.size.height);
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
    [_delegate textChanged:self.content];
}

#pragma mark - lifecycle methods

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

- (id)initWithFrame:(CGRect)frame
           topColor:(UIColor *)topColor 
        bottomColor:(UIColor *)bottomColor 
             target:(id)target 
   selectTagsAction:(SEL)selectTagsAction
  selectPlaceAction:(SEL)selectPlaceAction
                MOC:(NSManagedObjectContext *)MOC 
        contentType:(NSInteger)contentType 
   showSwitchButton:(BOOL)showSwitchButton {
    
    self = [super initWithFrame:frame topColor:topColor bottomColor:bottomColor];
    
    if (self) {
        
        _contentType = contentType;
        
        _MOC = MOC;
        
        [self addShadow];
        
        _delegate = (id<ECEditorDelegate>)target;
        
        CGRect textViewFrame;
        if (_contentType != SEND_COMMENT_TY ) {
            _target = target;
            _selectTagsAction = selectTagsAction;
            _selectPlaceAction = selectPlaceAction;
            
            // reset tag selection status
            [WXWCoreDataUtils resetPlaces:_MOC];
            
            _tagButton = [[ECGradientButton alloc] initWithFrame:CGRectMake(MARGIN * 2, MARGIN, BUTTON_WIDTH, BUTTON_HEIGHT) 
                                                          target:self 
                                                          action:@selector(chooseTags:) 
                                                       colorType:RED_BTN_COLOR_TY 
                                                           title:LocaleStringForKey(NSTagTitle, nil)
                                                           image:nil//[UIImage imageNamed:@"addTag.png"] 
                                                      titleColor:[UIColor whiteColor] 
                                                titleShadowColor:[UIColor grayColor] 
                                                       titleFont:BOLD_FONT(16) 
                                                     roundedType:HAS_ROUNDED 
                                                 imageEdgeInsert:IMG_EDGE 
                                                 titleEdgeInsert:TITLE_EDGE];
            [self addSubview:_tagButton];
            
            _placeButton = [[ECGradientButton alloc] initWithFrame:CGRectMake(frame.size.width - MARGIN * 2 - BUTTON_WIDTH, MARGIN, BUTTON_WIDTH, BUTTON_HEIGHT) 
                                                            target:self 
                                                            action:@selector(choosePlaces:) 
                                                         colorType:BLACK_BTN_COLOR_TY 
                                                             title:LocaleStringForKey(NSPlaceTitle, nil)
                                                             image:nil
                                                        titleColor:BLACK_BTN_TITLE_COLOR
                                                  titleShadowColor:BLACK_BTN_TITLE_SHADOW_COLOR
                                                         titleFont:BOLD_FONT(16) 
                                                       roundedType:HAS_ROUNDED 
                                                   imageEdgeInsert:IMG_EDGE
                                                   titleEdgeInsert:TITLE_EDGE];
            _placeButton.titleEdgeInsets = UIEdgeInsetsMake(-29.0f, -37.0f, -27.0, 0.0);
            [self addSubview:_placeButton];
            
            _placeSpinView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            _placeSpinView.frame = CGRectMake(_placeButton.frame.origin.x + BUTTON_WIDTH - BUTTON_HEIGHT - MARGIN * 2,
                                         _placeButton.frame.origin.y, BUTTON_HEIGHT, BUTTON_HEIGHT);
            _placeSpinView.backgroundColor = TRANSPARENT_COLOR;
            [_placeSpinView startAnimating];
            [self addSubview:_placeSpinView];
            
            CGFloat y = _tagButton.frame.origin.y + BUTTON_HEIGHT;
            
            _infoLabel = [[WXWLabel alloc] initWithFrame:CGRectMake(MARGIN * 2, y, frame.size.width - MARGIN * 4, BUTTON_HEIGHT - 10) 
                                              textColor:COLOR(129, 129, 132) 
                                            shadowColor:[UIColor whiteColor]];
            _infoLabel.textAlignment = UITextAlignmentCenter;
            _infoLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            _infoLabel.font = FONT(12);
            [self addSubview:_infoLabel];
            
            y = _infoLabel.frame.origin.y + _infoLabel.frame.size.height;
            textViewFrame = CGRectMake(MARGIN * 2, y, frame.size.width - MARGIN * 2 - MARGIN * 2, frame.size.height - MARGIN - y);
            
        } else {
            textViewFrame = CGRectMake(MARGIN * 2, MARGIN * 2, frame.size.width - MARGIN * 2 - MARGIN * 2, frame.size.height - MARGIN * 2 - MARGIN * 2);
        }
        
        _backgroundView = [[UIView alloc] initWithFrame:textViewFrame];
        _backgroundView.backgroundColor = [UIColor whiteColor];
        _backgroundView.layer.cornerRadius = 8.0f;
        _backgroundView.layer.borderColor = COLOR(215, 215, 215).CGColor;
        _backgroundView.layer.borderWidth = 2.0f;
        [self addSubview:_backgroundView];
        
        _textView = [[ECTextView alloc] initWithFrame:CGRectMake(0, 0, textViewFrame.size.width, textViewFrame.size.height - HIDE_KEYBOARD_BTN_HEIGHT - MARGIN)];
        _textView.delegate = self;
        _textView.editable = YES;
        _textView.backgroundColor = TRANSPARENT_COLOR;
        _textView.contentSize = CGSizeMake(_textView.frame.size.width, _textView.frame.size.height - HIDE_KEYBOARD_BTN_HEIGHT);
        _textView.font = FONT(17);
        if (!showSwitchButton) {
            // if hide the switch button, then the input area should focused
            [_textView becomeFirstResponder];
        }
        [_backgroundView addSubview:_textView];
        
        _hideKeyboardButton = [[ECGradientButton alloc] initWithFrame:CGRectMake(textViewFrame.size.width - MARGIN - HIDE_KEYBOARD_BTN_WIDTH, textViewFrame.size.height - MARGIN - HIDE_KEYBOARD_BTN_HEIGHT, HIDE_KEYBOARD_BTN_WIDTH, HIDE_KEYBOARD_BTN_HEIGHT) 
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
                                                      titleEdgeInsert:ZERO_EDGE];
        
        UIImageView *keyboard = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"keyboard.png"]] autorelease];
        keyboard.frame = CGRectMake(5, 5, 22, 14);
        [_hideKeyboardButton addSubview:keyboard];
        
        UIImageView *arrow = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"upArrow.png"]] autorelease];
        arrow.frame = CGRectMake(31, 5, 10, 14);
        [_hideKeyboardButton addSubview:arrow];
        
        if (showSwitchButton) {
            // dirty way to hide the button !!!
            [_backgroundView addSubview:_hideKeyboardButton];
        }
        
      if (_contentType != SEND_COMMENT_TY) {
            _cancelPlaceButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _cancelPlaceButton.frame = CGRectMake(MARGIN, textViewFrame.size.height - CANCEL_BUTTON_HEIGHT - 2, CANCEL_BUTTON_WIDTH, CANCEL_BUTTON_HEIGHT);
            _cancelPlaceButton.backgroundColor = TRANSPARENT_COLOR;
            [_cancelPlaceButton setImage:[UIImage imageNamed:@"cancel.png"] 
                                forState:UIControlStateNormal];      
            [_cancelPlaceButton addTarget:self action:@selector(cancelPlace:) 
                         forControlEvents:UIControlEventTouchUpInside];
            _cancelPlaceButton.hidden = YES;
            _cancelPlaceButton.enabled = NO;
            [_backgroundView addSubview:_cancelPlaceButton];
            
            CGFloat maxWidth = _hideKeyboardButton.frame.origin.x - CANCEL_BUTTON_WIDTH - MARGIN;
            
            _placeLabel = [[WXWLabel alloc] initWithFrame:CGRectZero
                                               textColor:[UIColor grayColor] 
                                             shadowColor:TRANSPARENT_COLOR];
            _placeLabel.font = ITALIC_FONT(13);
            _placeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            _placeLabel.text = @"City";//[AppManager instance].cityName;
            CGSize size = [_placeLabel.text sizeWithFont:_placeLabel.font
                                       constrainedToSize:CGSizeMake(maxWidth, CGFLOAT_MAX)
                                           lineBreakMode:NSLineBreakByWordWrapping];
            _placeLabel.frame = CGRectMake(MARGIN * 2, textViewFrame.size.height - HIDE_KEYBOARD_BTN_HEIGHT, size.width, HIDE_KEYBOARD_BTN_HEIGHT);
            [_backgroundView addSubview:_placeLabel];
        }    
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
           topColor:(UIColor *)topColor 
        bottomColor:(UIColor *)bottomColor 
             target:(id)target 
                MOC:(NSManagedObjectContext *)MOC 
        contentType:(NSInteger)contentType
   showSwitchButton:(BOOL)showSwitchButton {
    
    self = [super initWithFrame:frame topColor:topColor bottomColor:bottomColor];
    
    if (self) {
        
        _contentType = contentType;
        
        _MOC = MOC;
        
        [self addShadow];
        
        _delegate = (id<ECEditorDelegate>)target;
        
        CGRect textViewFrame;
        textViewFrame = CGRectMake(MARGIN * 2, MARGIN * 2, frame.size.width - MARGIN * 2 - MARGIN * 2, frame.size.height - MARGIN * 2 - MARGIN * 2);
        
        _backgroundView = [[UIView alloc] initWithFrame:textViewFrame];
        _backgroundView.backgroundColor = [UIColor whiteColor];
        _backgroundView.layer.cornerRadius = 8.0f;
        _backgroundView.layer.borderColor = COLOR(215, 215, 215).CGColor;
        _backgroundView.layer.borderWidth = 2.0f;
        [self addSubview:_backgroundView];
        
        _textView = [[ECTextView alloc] initWithFrame:CGRectMake(0, 0, textViewFrame.size.width, textViewFrame.size.height - HIDE_KEYBOARD_BTN_HEIGHT - MARGIN)];
        _textView.delegate = self;
        _textView.editable = YES;
        _textView.backgroundColor = TRANSPARENT_COLOR;
        _textView.contentSize = CGSizeMake(_textView.frame.size.width, _textView.frame.size.height - HIDE_KEYBOARD_BTN_HEIGHT);
        _textView.font = FONT(17);
        if (!showSwitchButton) {
            // if hide the switch button, then the input area should focused
            [_textView becomeFirstResponder];
        }
        [_backgroundView addSubview:_textView];
        
        _hideKeyboardButton = [[ECGradientButton alloc] initWithFrame:CGRectMake(textViewFrame.size.width - MARGIN - HIDE_KEYBOARD_BTN_WIDTH, textViewFrame.size.height - MARGIN - HIDE_KEYBOARD_BTN_HEIGHT, HIDE_KEYBOARD_BTN_WIDTH, HIDE_KEYBOARD_BTN_HEIGHT) 
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
                                                      titleEdgeInsert:ZERO_EDGE];
        
        UIImageView *keyboard = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"keyboard.png"]] autorelease];
        keyboard.frame = CGRectMake(5, 5, 22, 14);
        [_hideKeyboardButton addSubview:keyboard];
        
        UIImageView *arrow = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"upArrow.png"]] autorelease];
        arrow.frame = CGRectMake(31, 5, 10, 14);
        [_hideKeyboardButton addSubview:arrow];
        
        if (showSwitchButton) {
            // dirty way to hide the button !!!
            [_backgroundView addSubview:_hideKeyboardButton];
        }
        
        if (_contentType != SEND_COMMENT_TY ) {
            _cancelPlaceButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _cancelPlaceButton.frame = CGRectMake(MARGIN, textViewFrame.size.height - CANCEL_BUTTON_HEIGHT - 2, CANCEL_BUTTON_WIDTH, CANCEL_BUTTON_HEIGHT);
            _cancelPlaceButton.backgroundColor = TRANSPARENT_COLOR;
            [_cancelPlaceButton setImage:[UIImage imageNamed:@"cancel.png"] 
                                forState:UIControlStateNormal];      
            [_cancelPlaceButton addTarget:self action:@selector(cancelPlace:) 
                         forControlEvents:UIControlEventTouchUpInside];
            _cancelPlaceButton.hidden = YES;
            _cancelPlaceButton.enabled = NO;
            [_backgroundView addSubview:_cancelPlaceButton];
            
            // Place
            CGFloat maxWidth = _hideKeyboardButton.frame.origin.x - CANCEL_BUTTON_WIDTH - MARGIN;
            
            _placeLabel = [[WXWLabel alloc] initWithFrame:CGRectZero
                                               textColor:[UIColor grayColor] 
                                             shadowColor:TRANSPARENT_COLOR];
            _placeLabel.font = ITALIC_FONT(13);
            _placeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            _placeLabel.text = @"同时短信同时短信发送";
            CGSize size = [_placeLabel.text sizeWithFont:_placeLabel.font
                                       constrainedToSize:CGSizeMake(maxWidth, CGFLOAT_MAX)
                                           lineBreakMode:NSLineBreakByWordWrapping];
            _placeLabel.frame = CGRectMake(MARGIN * 2, textViewFrame.size.height - HIDE_KEYBOARD_BTN_HEIGHT, size.width, HIDE_KEYBOARD_BTN_HEIGHT);
          
            // SMS
            _smsView = [[UIView alloc] init];
            _smsView.frame = CGRectMake(MARGIN, _hideKeyboardButton.frame.origin.y, size.width, HIDE_KEYBOARD_BTN_HEIGHT);
            _checkboxImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
            _checkboxImage.image = [UIImage imageNamed:@"btn_check.png"];
            _checkboxImage.backgroundColor = TRANSPARENT_COLOR;
            _checkboxImage.userInteractionEnabled = YES;
            UIGestureRecognizer *checkImgTap = [[UITapGestureRecognizer alloc] 
                                                initWithTarget:self action:@selector(doCheckBox:)];
            checkImgTap.delegate = self;
            [_checkboxImage addGestureRecognizer:checkImgTap];
            [_smsView addSubview:_checkboxImage];
            
            UILabel *smsLabel = [[[UILabel alloc] initWithFrame:CGRectMake(30, 0, 200, 25)] autorelease];
            smsLabel.text = LocaleStringForKey(NSSMSTitle, nil);
            smsLabel.font = FONT(13);
            smsLabel.backgroundColor = TRANSPARENT_COLOR;
            smsLabel.userInteractionEnabled = YES;
            UIGestureRecognizer *checkLabelTap = [[UITapGestureRecognizer alloc] 
                                                  initWithTarget:self action:@selector(doCheckBox:)];
            checkLabelTap.delegate = self;
            [smsLabel addGestureRecognizer:checkLabelTap];
            [_smsView addSubview:smsLabel];
            
            [_backgroundView addSubview:_smsView];
        }    
    }
    return self;
}

-(void)doCheckBox:(UIGestureRecognizer *)recognizer
{
    if(!_isCheck)
    {
        _checkboxImage.image = [UIImage imageNamed:@"btn_checked.png"];
        _isCheck = YES;
    } else {
        _checkboxImage.image = [UIImage imageNamed:@"btn_check.png"];
        _isCheck = NO;
    }
    
    [_delegate chooseSMS:_isCheck];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIUtils draw1PxStroke:context startPoint:CGPointMake(0, self.frame.size.height) 
                  endPoint:CGPointMake(self.frame.size.width, self.frame.size.width) 
                     color:[UIColor darkGrayColor].CGColor 
              shadowOffset:CGSizeZero shadowColor:nil];
}

- (void)dealloc {
    
    RELEASE_OBJ(_tagButton);
    RELEASE_OBJ(_placeButton);
    RELEASE_OBJ(_hideKeyboardButton);
    RELEASE_OBJ(_placeSpinView);
    _textView.delegate = nil;
    RELEASE_OBJ(_textView);
    RELEASE_OBJ(_infoLabel);
    RELEASE_OBJ(_placeLabel);
    RELEASE_OBJ(_backgroundView);
    RELEASE_OBJ(_smsView);
    
    self.content = nil;
    self.tagPlaceInfo = nil;
    self.selectedPlace = nil;
    
    [super dealloc];
}

@end
