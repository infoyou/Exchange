//
//  TextComposerView.h
//  Project
//
//  Created by XXX on 11-11-17.
//  Copyright (c) 2011年 _CompanyName_. All rights reserved.
//

#import "WXWGradientView.h"
#import <CoreData/CoreData.h>
#import "GlobalConstants.h"
#import "ECEditorDelegate.h"

@class ECGradientButton;
@class WXWLabel;
@class ECTextView;
@class Place;

@interface TextComposerView : WXWGradientView <UITextViewDelegate, UIGestureRecognizerDelegate> {
    
    UIView *_smsView;
    NSString *_content;
    
    UIImageView *_checkboxImage;
    BOOL _isCheck;
    
@private
    NSManagedObjectContext *_MOC;
    
    ECGradientButton *_tagButton;
    UIButton *_cancelPlaceButton;
    ECGradientButton *_placeButton;
    UIActivityIndicatorView *_placeSpinView;
    ECGradientButton *_hideKeyboardButton;
    WXWLabel *_infoLabel;
    ECTextView *_textView;
    WXWLabel *_placeLabel;
    UIView *_backgroundView;
    
    WebItemType _contentType;
    
    BOOL _placeCancelled;
    
    BOOL _keyboardShowing;
    
    BOOL _flipTriggeredByButton;
    
    id _target;
    SEL _selectTagsAction;
    SEL _selectPlaceAction;
    
    id<ECEditorDelegate> _delegate;
    
    Place *_selectedPlace;
    
    BOOL _locationDone;
}

@property (nonatomic, copy) NSString *content;
@property (nonatomic, retain) Place *selectedPlace;

- (id)initWithFrame:(CGRect)frame
           topColor:(UIColor *)topColor 
        bottomColor:(UIColor *)bottomColor 
             target:(id)target 
   selectTagsAction:(SEL)selectTagsAction
  selectPlaceAction:(SEL)selectPlaceAction
                MOC:(NSManagedObjectContext *)MOC
        contentType:(NSInteger)contentType
   showSwitchButton:(BOOL)showSwitchButton;

- (id)initWithFrame:(CGRect)frame
           topColor:(UIColor *)topColor 
        bottomColor:(UIColor *)bottomColor 
             target:(id)target
                MOC:(NSManagedObjectContext *)MOC
        contentType:(NSInteger)contentType
   showSwitchButton:(BOOL)showSwitchButton;

#pragma mark - adjust layout
- (void)arrangeLayoutForKeyboardChange:(CGFloat)noKeyboardAreaHeight;
- (void)showPlaceButton:(BOOL)success;

#pragma mark - ui elements status
- (NSInteger)charCount;

#pragma mark - show tags and place info
- (void)displaySelectedTagsAndPlace;
- (void)setCityInfo:(NSString *)cityInfo;

@end
