//
//  ECPhotoPickerOverlayViewController.m
//  Project
//
//  Created by XXX on 12-1-11.
//  Copyright (c) 2012年 _MyCompanyName_. All rights reserved.
//

#import "ECPhotoPickerOverlayViewController.h"
#import "ECPhotoPickerOverlayDelegate.h"
#import "ECPhotoEffectSamplesView.h"
#import "ComposerViewController.h"
#import "UIDevice+Hardware.h"
#import "UIImage-Extensions.h"
#import "CommonUtils.h"
#import "AppManager.h"
#import "WXWCommonUtils.h"
#import "GlobalConstants.h"
#import "TextPool.h"

enum {
	DIFF_ORI,
	LANDSCAPE_ORI,
	PORTRAIT_ORI,
};

#define SELF_VIEW_TAG   10000
#define CAMERA_TRANSFORM 1.05f

#define BTN_WIDTH  70.0f
#define BTN_HEIGHT 40.0f

#define DEVICE_IS_LANDSCAPE	[CommonUtils currentOrientationIsLandscape]
#define IMAGE_IS_LANDSCAPE	[self imageOrientationIsLandscape]

#define DISPLAY_BOARD_35INCH_HEIGHT  436.0f
#define DISPLAY_BOARD_40INCH_HEIGHT  524.0f
//#define DISPLAY_BOARD_HEIGHT

#define LANDSCAPE_W_H_RATIO	1.5
//#define PORTRAIT_W_H_RATIO	320.0f/DISPLAY_BOARD_HEIGHT

#define VERTICAL_Y    -20.0f

#define ICON_SIDE_LENGTH  32.0f

@interface ECPhotoPickerOverlayViewController()
@property (nonatomic, retain) UIImage *originalImage;
@property (nonatomic, retain) UIImage *selectedImage;
@property (nonatomic, retain) UIImage *targetImage;
@property (nonatomic, retain) UIView *displayBoard;
@property (nonatomic, retain) ECPhotoEffectSamplesView *palette;
@property (nonatomic, assign) id<ECItemUploaderDelegate> uploaderDelegate;
@property (nonatomic, assign) id<ECPhotoPickerOverlayDelegate> delegate;
@property (nonatomic, copy) NSString *itemId;
@end

@implementation ECPhotoPickerOverlayViewController

@synthesize imagePicker = _imagePicker;
@synthesize originalImage = _originalImage;
@synthesize selectedImage = _selectedImage;
@synthesize targetImage = _targetImage;
@synthesize displayBoard = _displayBoard;
@synthesize palette = _palette;
@synthesize delegate = _delegate;
@synthesize uploaderDelegate = _uploaderDelegate;
@synthesize itemId = _itemId;
@synthesize needSaveToAlbum = _needSaveToAlbum;

#pragma mark - camera controller buttons

- (void)creaetFlashControllerButton:(UIButton **)button
                              frame:(CGRect)frame
                             action:(SEL)action
                              title:(NSString *)title {
  
  *button = [UIButton buttonWithType:UIButtonTypeCustom];
  (*button).frame = frame;
  (*button).backgroundColor = [UIColor colorWithWhite:0.5f alpha:0.6f];
  [(*button) addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
  [(*button) setTitle:title forState:UIControlStateNormal];
  (*button).titleLabel.font = BOLD_FONT(14);
  [_flashButtonBoard addSubview:(*button)];
}

- (NSString *)currentFlashModeName {
  switch (self.imagePicker.cameraFlashMode) {
    case UIImagePickerControllerCameraFlashModeOff:
      return LocaleStringForKey(NSOffTitle, nil);
      
    case UIImagePickerControllerCameraFlashModeOn:
      return LocaleStringForKey(NSOnTitle, nil);
      
    case UIImagePickerControllerCameraFlashModeAuto:
      return LocaleStringForKey(NSAutoTitle, nil);
      
    default:
      return nil;
  }
}

- (void)createFlashButton {
  _flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
  _flashButton.frame = CGRectMake(0, 0, BTN_WIDTH, BTN_HEIGHT);
  _flashButton.backgroundColor = TRANSPARENT_COLOR;
  [_flashButton addTarget:self
                   action:@selector(expandFlashBoard:)
         forControlEvents:UIControlEventTouchUpInside];
  [_flashButton setImage:[UIImage imageNamed:@"lightning.png"] forState:UIControlStateNormal];
  [_flashButton setTitle:[self currentFlashModeName] forState:UIControlStateNormal];
  _flashButton.titleLabel.font = BOLD_FONT(14);
  
  [_flashButtonBoard addSubview:_flashButton];
}

- (void)collapseFlashBoard {
  
  [_autoFlashButton removeFromSuperview];
  _autoFlashButton = nil;
  
  [_offFlashButton removeFromSuperview];
  _offFlashButton = nil;
  
  [_onFlashButton removeFromSuperview];
  _onFlashButton = nil;
  
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:0.2f];
  
  [self createFlashButton];
  _flashButtonBoard.frame = CGRectMake(MARGIN * 2, MARGIN * 5, BTN_WIDTH, BTN_HEIGHT);
  
  [UIView commitAnimations];
}

- (void)turnFlashOff:(id)sender {
  self.imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
  [self collapseFlashBoard];
}

- (void)turnFlashOn:(id)sender {
  self.imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOn;
  [self collapseFlashBoard];
}

- (void)turnFlashAuto:(id)sender {
  self.imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
  [self collapseFlashBoard];
}

- (void)expandFlashBoard:(id)sender {
  
  if (_flashButton) {
    [_flashButton removeFromSuperview];
    _flashButton = nil;
  }
  
  [self creaetFlashControllerButton:&_autoFlashButton
                              frame:CGRectMake(0, 0, BTN_WIDTH - 1, BTN_HEIGHT)
                             action:@selector(turnFlashAuto:)
                              title:LocaleStringForKey(NSAutoTitle, nil)];
  [_autoFlashButton setImage:[UIImage imageNamed:@"lightning.png"] forState:UIControlStateNormal];
  
  [self creaetFlashControllerButton:&_onFlashButton
                              frame:CGRectMake(_autoFlashButton.frame.size.width + 1, 0, 60.0f - 1, BTN_HEIGHT)
                             action:@selector(turnFlashOn:)
                              title:LocaleStringForKey(NSOnTitle, nil)];
  [self creaetFlashControllerButton:&_offFlashButton
                              frame:CGRectMake(_onFlashButton.frame.size.width + _onFlashButton.frame.origin.x + 1, 0, 60.0f, BTN_HEIGHT)
                             action:@selector(turnFlashOff:)
                              title:LocaleStringForKey(NSOffTitle, nil)];
  
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:0.2f];
  
  _flashButtonBoard.frame = CGRectMake(MARGIN * 2, 0, 190.0f, BTN_HEIGHT);
  
  [UIView commitAnimations];
}

- (void)initFlashButtonBoard:(BOOL)animated {
  
  if (nil == _flashButtonBoard) {
    
    _flashButtonBoard = [[UIView alloc] initWithFrame:CGRectMake(MARGIN * 2, MARGIN * 5, BTN_WIDTH, BTN_HEIGHT)];
    _flashButtonBoard.layer.cornerRadius = 20.0f;
    _flashButtonBoard.layer.masksToBounds = YES;
    _flashButtonBoard.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
    [self.view addSubview:_flashButtonBoard];
    
    if (nil == _flashButton) {
      [self createFlashButton];
    }
  }
  
  if (animated) {
    _flashButtonBoard.alpha = 0.0f;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2f];
    _flashButtonBoard.alpha = 1.0;
    [UIView commitAnimations];
  }
}

- (void)removeFlashButtonBoard {
  
  _flashButton = nil;
  
  [_flashButtonBoard removeFromSuperview];
  RELEASE_OBJ(_flashButtonBoard);
}

- (void)hideFlashButtonBoard {
  if (_flashButtonBoard) {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeFlashButtonBoard)];
    _flashButtonBoard.alpha = 0.0f;
    [UIView commitAnimations];
  }
}

- (void)switchFrontRear:(id)sender {
  if (self.imagePicker.cameraDevice == UIImagePickerControllerCameraDeviceRear) {
    self.imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
  } else {
    self.imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
  }
  
  if ([UIImagePickerController isFlashAvailableForCameraDevice:self.imagePicker.cameraDevice]) {
    
    [self initFlashButtonBoard:YES];
  } else {
    [self hideFlashButtonBoard];
  }
}

#pragma mark - user actions

- (void)setFetchPhotoButtons {
  UIButton *albumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  albumBtn.frame = CGRectMake(0, 0, ICON_SIDE_LENGTH, ICON_SIDE_LENGTH);
  albumBtn.backgroundColor = TRANSPARENT_COLOR;
  [albumBtn addTarget:self
               action:@selector(browseAlbum:)
     forControlEvents:UIControlEventTouchUpInside];
  [albumBtn setImage:[UIImage imageNamed:@"album.png"]
            forState:UIControlStateNormal];
  albumBtn.showsTouchWhenHighlighted = YES;
  UIBarButtonItem *albumBarBtn = [[[UIBarButtonItem alloc] initWithCustomView:albumBtn] autorelease];
  
  UIBarButtonItem *spaceBtn = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                             target:nil
                                                                             action:nil] autorelease];
  
  UIButton *takePhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  takePhotoBtn.frame = CGRectMake(0, 0, ICON_SIDE_LENGTH * 3, ICON_SIDE_LENGTH );
  takePhotoBtn.backgroundColor = COLOR(206, 206, 206);
  takePhotoBtn.layer.cornerRadius = ICON_SIDE_LENGTH/2.0f;
  takePhotoBtn.layer.masksToBounds = YES;
  [takePhotoBtn addTarget:self
                   action:@selector(takePhoto:)
         forControlEvents:UIControlEventTouchUpInside];
  [takePhotoBtn setImage:[UIImage imageNamed:@"takePhoto.png"] forState:UIControlStateNormal];
  takePhotoBtn.showsTouchWhenHighlighted = YES;
  UIBarButtonItem *takePhotoBarBtn = [[[UIBarButtonItem alloc] initWithCustomView:takePhotoBtn] autorelease];
  
  UIBarButtonItem *spaceBtn1 = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                              target:nil
                                                                              action:nil] autorelease];
  
  UIButton *discardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  discardBtn.frame = CGRectMake(0, 0, ICON_SIDE_LENGTH, ICON_SIDE_LENGTH);
  discardBtn.backgroundColor = TRANSPARENT_COLOR;
  [discardBtn addTarget:self action:@selector(discard:) forControlEvents:UIControlEventTouchUpInside];
  [discardBtn setImage:[UIImage imageNamed:@"exitPhoto.png"] forState:UIControlStateNormal];
  discardBtn.showsTouchWhenHighlighted = YES;
  UIBarButtonItem *discardBarBtn = [[[UIBarButtonItem alloc] initWithCustomView:discardBtn] autorelease];
  
  [_toolbar setItems:@[albumBarBtn, spaceBtn, takePhotoBarBtn, spaceBtn1, discardBarBtn]
            animated:YES];
  
}

- (void)setImageEffectHandleButtons {
  
  UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  cancelBtn.frame = CGRectMake(0, 0, ICON_SIDE_LENGTH, ICON_SIDE_LENGTH);
  cancelBtn.backgroundColor = TRANSPARENT_COLOR;
  [cancelBtn addTarget:self action:@selector(deselectPhoto:)
      forControlEvents:UIControlEventTouchUpInside];
  [cancelBtn setImage:[UIImage imageNamed:@"disagree.png"] forState:UIControlStateNormal];
  cancelBtn.showsTouchWhenHighlighted = YES;
  UIBarButtonItem *cancelBarBtn = [[[UIBarButtonItem alloc] initWithCustomView:cancelBtn] autorelease];
  
  UIBarButtonItem *spaceBtn = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
  
  UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  confirmBtn.frame = CGRectMake(0, 0, ICON_SIDE_LENGTH, ICON_SIDE_LENGTH);
  confirmBtn.backgroundColor = TRANSPARENT_COLOR;
  [confirmBtn addTarget:self
                 action:@selector(selectPhoto:)
       forControlEvents:UIControlEventTouchUpInside];
  [confirmBtn setImage:[UIImage imageNamed:@"agree.png"] forState:UIControlStateNormal];
  confirmBtn.showsTouchWhenHighlighted = YES;
  UIBarButtonItem *confirmBarBtn = [[[UIBarButtonItem alloc] initWithCustomView:confirmBtn] autorelease];
  
  UIBarButtonItem *spaceBtn1 = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
  
  //    UIBarButtonItem *rotateBtn = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(doRotate:)] autorelease];
  
  UIButton *rotate = [UIButton buttonWithType:UIButtonTypeCustom];
  rotate.frame = CGRectMake(0, 0, ICON_SIDE_LENGTH, ICON_SIDE_LENGTH);
  rotate.backgroundColor = TRANSPARENT_COLOR;
  [rotate addTarget:self action:@selector(doRotate:) forControlEvents:UIControlEventTouchUpInside];
  [rotate setImage:[UIImage imageNamed:@"rotate.png"] forState:UIControlStateNormal];
  rotate.showsTouchWhenHighlighted = YES;
  UIBarButtonItem *rotateBtn = [[[UIBarButtonItem alloc] initWithCustomView:rotate] autorelease];
  
  UIBarButtonItem *spaceBtn2 = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
  
  UIButton *discardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  discardBtn.frame = CGRectMake(0, 0, ICON_SIDE_LENGTH, ICON_SIDE_LENGTH);
  discardBtn.backgroundColor = TRANSPARENT_COLOR;
  [discardBtn addTarget:self action:@selector(discard:) forControlEvents:UIControlEventTouchUpInside];
  [discardBtn setImage:[UIImage imageNamed:@"exitPhoto.png"] forState:UIControlStateNormal];
  discardBtn.showsTouchWhenHighlighted = YES;
  UIBarButtonItem *discardBarBtn = [[[UIBarButtonItem alloc] initWithCustomView:discardBtn] autorelease];
  
  [_toolbar setItems:@[cancelBarBtn, spaceBtn, confirmBarBtn, spaceBtn1, rotateBtn, spaceBtn2, discardBarBtn]
            animated:YES];
}

- (void)browseAlbum:(id)sender {
  
  self.needSaveToAlbum = NO;
  self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

  // strange, why use clicks the album in photo picker, all views will be move up 20, so reset the position,
  // when user close the photo picker after he/she browse album in photo picker
  if (CURRENT_OS_VERSION >= IOS5) {
    _needMoveDownComposerSubViews = YES;
  } else {
    if ([CommonUtils currentOSVersion] < IOS7) {
      [UIApplication sharedApplication].statusBarHidden = NO;
      [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
    }
  }
}

- (void)takePhoto:(id)sender {
  
  self.needSaveToAlbum = YES;
  
  [self.imagePicker takePicture];
}

- (void)doClose {
  
  if ([CommonUtils currentOSVersion] < IOS7) {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
  }
  
  [self.imagePicker dismissModalViewControllerAnimated:YES];
  
  if (self.delegate) {
    
    if (_needMoveDownComposerSubViews) {
      [self.delegate adjustUIAfterUserBrowseAlbumInImagePicker];
    }
    
    [self.delegate didFinishWithCamera];
  }
  
}

- (void)discard:(id)sender {
  
  if (self.originalImage) {
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:LocaleStringForKey(NSPhotoDiscardMsg, nil)
                                                    delegate:self
                                           cancelButtonTitle:nil
                                      destructiveButtonTitle:nil
                                           otherButtonTitles:nil];
		[as addButtonWithTitle:LocaleStringForKey(NSDiscardTitle, nil)];
		[as addButtonWithTitle:LocaleStringForKey(NSCancelTitle, nil)];
    as.destructiveButtonIndex = 0;
		as.cancelButtonIndex = [as numberOfButtons] - 1;
		[as showInView:self.view];
		RELEASE_OBJ(as)
    
  } else {
    [self doClose];
  }
}

- (void)moveCameraOverlayViewToPicker {
  
  // current device is camera, but user browse the album
  
  [self.view removeFromSuperview]; // removed from both self.imagePicker.view and self.imagePicker.cameraOverlayView
  _userSelectPhotoFromAlbum = NO;
  
  if (_sourceType == UIImagePickerControllerSourceTypeCamera) {
    // add it back to self.imagePicker.cameraOverlayView
    [self.imagePicker.cameraOverlayView addSubview:self.view];
  }
}

- (void)doRotate:(id)sender {
  
  CGSize targetSize;
  
  switch (rotateStep%4) {
    case 0:
    {
      targetSize = CGSizeMake(rotateWidth, rotateWidth*imgHeight/imgWidth);
      
      UIImage *showImg = [self.targetImage imageRotatedByDegrees:90.0];
      _displayedImageView.image = [showImg imageByScalingProportionallyToSize:targetSize];
      
      UIImage *editImg = [self.targetImage imageByScalingProportionallyToSize:targetSize];
      self.selectedImage = [editImg imageRotatedByDegrees:90.0];
      
      break;
    }
      
    case 1:
    {
      self.selectedImage = [self.targetImage imageRotatedByDegrees:180.0];
      _displayedImageView.image = self.selectedImage;
      break;
    }
      
    case 2:
    {
      targetSize = CGSizeMake(rotateWidth, rotateWidth*imgHeight/imgWidth);
      
      UIImage *showImg = [self.targetImage imageRotatedByDegrees:270.0];
      _displayedImageView.image = [showImg imageByScalingProportionallyToSize:targetSize];
      
      UIImage *editImg = [self.targetImage imageByScalingProportionallyToSize:targetSize];
      self.selectedImage = [editImg imageRotatedByDegrees:270.0];
      
      break;
    }
      
    case 3:
    {
      self.selectedImage = self.targetImage;
      _displayedImageView.image = self.targetImage;
      break;
    }
      
    default:
      break;
  }
  
  
  rotateStep ++;
}

- (void)selectPhoto:(id)sender {
  
  if ([CommonUtils currentOSVersion] < IOS7) {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
  }
  
  switch (_takerType) {
    case HANDY_PHOTO_TAKER_TY:
    case SERVICE_ITEM_PHOTO_TY:
    case SERVICE_ITEM_AVATAR_TY:
    {
      
      UIImagePickerControllerSourceType imagePickerSourceType = UIImagePickerControllerSourceTypeCamera;
      if (_userSelectPhotoFromAlbum) {
        [self moveCameraOverlayViewToPicker];
        
        _needMoveDownComposerSubViews = YES;
        
        // although current image picker source type is camera, user selects a photo from album, then
        // the source type of composer view controller should be set as album
        imagePickerSourceType = UIImagePickerControllerSourceTypePhotoLibrary;
      }
      
      if ([CommonUtils currentOSVersion] < IOS7) {
        [UIApplication sharedApplication].statusBarHidden = NO;
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
      }
      
      ComposerViewController *composerVC = nil;
      if (_takerType == HANDY_PHOTO_TAKER_TY) {
        composerVC = [[[ComposerViewController alloc] initWithMOC:_MOC
                                                         delegate:self.uploaderDelegate
                                                          groupId:LLINT_TO_STRING([AppManager instance].feedGroupId.longLongValue)
                                                    selectedImage:self.selectedImage
                                               needBeClosedParent:self
                                                      closeAction:@selector(doClose)
                                                   photoTakerType:HANDY_PHOTO_TAKER_TY
                                                   needMoveDownUI:_needMoveDownComposerSubViews
                                            imagePickerSourceType:imagePickerSourceType] autorelease];
      } else {
        composerVC = [[[ComposerViewController alloc] initWithMOCForServiceItem:self.itemId
                                                                            MOC:_MOC
                                                                       delegate:self.uploaderDelegate
                                                                  selectedImage:self.selectedImage
                                                             needBeClosedParent:self
                                                                    closeAction:@selector(doClose)
                                                                 needMoveDownUI:_needMoveDownComposerSubViews
                                                          imagePickerSourceType:imagePickerSourceType] autorelease];
        
      }
      
      
      self.imagePicker.navigationBar.tintColor = NAVIGATION_BAR_COLOR;
      self.imagePicker.navigationBar.barStyle = UIBarStyleDefault;
      self.imagePicker.navigationItem.hidesBackButton = NO;
      self.imagePicker.navigationBarHidden = NO;
      
      composerVC.title = LocaleStringForKey(NSSharePhotoTitle, nil);
      
      [self.imagePicker pushViewController:composerVC animated:YES];
      
      _needMoveDownComposerSubViews = NO;
      
      break;
    }
      
    case POST_COMPOSER_TY:
      //case SERVICE_ITEM_AVATAR_TY:
    case USER_AVATAR_TY:
    {
      if (self.delegate) {
        [self.delegate didTakePhoto:self.selectedImage];
      }
      
      [self doClose];
      break;
    }
    default:
      break;
  }
}

- (void)clearPalette {
  self.palette = nil;
}

- (void)deselectPhoto:(id)sender {
  
  if (self.displayBoard) {
    [self.displayBoard removeFromSuperview];
    self.displayBoard = nil;
  }
  
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:0.2f];
  self.palette.frame = CGRectMake(0, [self photoDisplayHeight] - 20.0f, self.view.bounds.size.width, 0);
  self.palette.alpha = 0.0f;
  
  if (_sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
    [self.view removeFromSuperview];
  }
  
  if (_userSelectPhotoFromAlbum) {
    [self moveCameraOverlayViewToPicker];
  }
  
  [UIView commitAnimations];
  
  [self setFetchPhotoButtons];
  
  self.palette = nil;
  
  self.originalImage = nil;
}

#pragma mark - UIActionSheetDelegate methods
- (void)actionSheet:(UIActionSheet *)as clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (as.cancelButtonIndex == buttonIndex) {
    return;
  } else {
    [self doClose];
  }
}

#pragma mark - lifecycle methods

- (void)initImagePickerToolbar {
  
  _toolbar = [[[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - TOOLBAR_HEIGHT, self.view.bounds.size.width, TOOLBAR_HEIGHT)] autorelease];
  _toolbar.barStyle = UIBarStyleBlack;
  
  [self.view addSubview:_toolbar];
  
  [self setFetchPhotoButtons];
}

- (void)addRearFrontSwitchButton {
  UIButton *switchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  switchBtn.frame = CGRectMake(self.view.bounds.size.width - BTN_WIDTH - MARGIN * 2, MARGIN * 5, BTN_WIDTH, BTN_HEIGHT);
  switchBtn.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
  [switchBtn addTarget:self
                action:@selector(switchFrontRear:)
      forControlEvents:UIControlEventTouchUpInside];
  [switchBtn setImage:[UIImage imageNamed:@"switchFrontRear.png"] forState:UIControlStateNormal];
  
  switchBtn.layer.cornerRadius = 20.0f;
  switchBtn.layer.masksToBounds = YES;
  
  [self.view addSubview:switchBtn];
}

- (void)initPhotoPicker {
  
  self.imagePicker = [[[UIImagePickerController alloc] init] autorelease];
  self.imagePicker.delegate = self;
  self.imagePicker.sourceType = _sourceType;
  
  [self initImagePickerToolbar];
  
  switch (_sourceType) {
    case UIImagePickerControllerSourceTypeCamera:
    {
      self.imagePicker.showsCameraControls = NO;
      
      CGAffineTransform cameraTransform = CGAffineTransformMakeScale(1.0f, CAMERA_TRANSFORM);
      self.imagePicker.cameraViewTransform = cameraTransform;
      
      if (0 == self.imagePicker.cameraOverlayView.subviews.count) {
        [self.imagePicker.cameraOverlayView addSubview:self.view];
      }
      break;
    }
      
    case UIImagePickerControllerSourceTypePhotoLibrary:
    {
      break;
    }
    default:
      break;
  }
}

- (id)initWithSourceType:(UIImagePickerControllerSourceType)sourceType
                delegate:(id<ECPhotoPickerOverlayDelegate>)delegate
        uploaderDelegate:(id<ECItemUploaderDelegate>)uploaderDelegate
               takerType:(PhotoTakerType)takerType
                     MOC:(NSManagedObjectContext *)MOC {
    
    self = [super initWithMOC:MOC];
  
  if (self) {
    _sourceType = sourceType;
    self.delegate = delegate;
    self.uploaderDelegate = uploaderDelegate;
    _takerType = takerType;
  }
  return self;
}

- (id)initForServiceUploadPhoto:(NSString *)itemId
                     SourceType:(UIImagePickerControllerSourceType)sourceType
                       delegate:(id<ECPhotoPickerOverlayDelegate>)delegate
               uploaderDelegate:(id<ECItemUploaderDelegate>)uploaderDelegate
                      takerType:(PhotoTakerType)takerType
                            MOC:(NSManagedObjectContext *)MOC {
  
  self = [self initWithSourceType:sourceType
                         delegate:delegate
                 uploaderDelegate:uploaderDelegate
                        takerType:takerType
                              MOC:MOC];
  if (self) {
    self.itemId = itemId;
  }
  return self;
}

- (void)arrangeViews {
    
  // 拒绝父类 颜色
  self.view.backgroundColor = TRANSPARENT_COLOR;
  
  self.view.tag = SELF_VIEW_TAG;
  
  BOOL hasFrontCamera = NO;
  BOOL hasFlash = NO;
  
  if ([IPHONE_4_NAMESTRING isEqualToString:[CommonUtils deviceModel]] ||
      [IPHONE_4S_NAMESTRING isEqualToString:[CommonUtils deviceModel]] ||
      [IPHONE_5_NAMESTRING isEqualToString:[CommonUtils deviceModel]] ||
      [IPHONE_5S_NAMESTRING isEqualToString:[CommonUtils deviceModel]] ||
      [IPHONE_5C_NAMESTRING isEqualToString:[CommonUtils deviceModel]]) {
    
    hasFrontCamera = YES;
    hasFlash = YES;
    
  } else if ([IPOD_4G_NAMESTRING isEqualToString:[CommonUtils deviceModel]]) {
    hasFrontCamera = YES;
  }
  
  if (hasFrontCamera) {
    [self addRearFrontSwitchButton];
  }
  
  if (hasFlash) {
    [self initFlashButtonBoard:NO];
  }
  
  [self initPhotoPicker];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
  return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidUnload {
  [super viewDidUnload];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)dealloc {
  
  self.imagePicker = nil;
  self.originalImage = nil;
  self.selectedImage = nil;
  self.targetImage = nil;
  self.displayBoard = nil;
  self.palette = nil;
  self.uploaderDelegate = nil;
  self.delegate = nil;
  self.itemId = nil;
  
  RELEASE_OBJ(_flashButtonBoard);
  
  [super dealloc];
}

#pragma mark - handle photo display board height
- (CGFloat)photoDisplayHeight {
  
  if ([WXWCommonUtils screenHeightIs4Inch]) {
    if (CURRENT_OS_VERSION >= IOS7) {
      return DISPLAY_BOARD_40INCH_HEIGHT + SYS_STATUS_BAR_HEIGHT;
    } else {
      return DISPLAY_BOARD_40INCH_HEIGHT;
    }
  } else {
    if (CURRENT_OS_VERSION >= IOS7) {
      return DISPLAY_BOARD_35INCH_HEIGHT + SYS_STATUS_BAR_HEIGHT;
    } else {
      return DISPLAY_BOARD_35INCH_HEIGHT;
    }
  }
}

#pragma mark - handle photo taken

- (BOOL)imageIsBigWithSameOrientation:(NSInteger)orientation width:(float)width height:(float)height {
  
  switch (orientation) {
    case LANDSCAPE_ORI:
      return (width > self.view.bounds.size.width || height > [self photoDisplayHeight]);
      
    case PORTRAIT_ORI:
      return (width > self.view.bounds.size.width || height > [self photoDisplayHeight]);
      
    default:
      return NO;
  }
}

- (BOOL)imageOrientationIsLandscape {
  return self.originalImage.size.width > self.originalImage.size.height;
}

- (NSInteger)currentSameOrientation {
  
  if (DEVICE_IS_LANDSCAPE && IMAGE_IS_LANDSCAPE) {
    return LANDSCAPE_ORI;
  }
  
  if (!DEVICE_IS_LANDSCAPE && !IMAGE_IS_LANDSCAPE) {
    return PORTRAIT_ORI;
  }
  
  return DIFF_ORI;
}

- (BOOL)imageIsBigWithDifferentOrientation:(float)width height:(float)height {
  if (DEVICE_IS_LANDSCAPE) {
    // means image is portrait
    if (height > [self photoDisplayHeight]) {
      return YES;
    } else {
      return NO;
    }
  } else {
    // means image is landscape
    if (width > self.view.bounds.size.width) {
      return YES;
    } else {
      return NO;
    }
  }
}

- (void)arrangeDiplayBoard {
  
  CGFloat width = 0.0f;
  CGFloat height = 0.0f;
  CGFloat x = 0.0f;
  CGFloat y = VERTICAL_Y;
  
  CGFloat imageHeight = [self photoDisplayHeight];
  
  NSInteger currentSameOrientation = [self currentSameOrientation];
  
  BOOL isBigImage = NO;
  if (currentSameOrientation == DIFF_ORI) {
    isBigImage = [self imageIsBigWithDifferentOrientation:self.originalImage.size.width height:self.originalImage.size.height];
  } else {
    isBigImage = [self imageIsBigWithSameOrientation:currentSameOrientation width:self.originalImage.size.width height:self.originalImage.size.height];
  }
  
  if (self.originalImage.size.width == self.originalImage.size.height) {

    // if image is square
    
    if (isBigImage) {
      width = SCREEN_WIDTH;
      height = SCREEN_WIDTH;
    
    } else {
    
      height = self.originalImage.size.height;
      width = self.originalImage.size.width;

    }
    
    x = (self.view.bounds.size.width - width)/2;
    y = (imageHeight - height)/2;
    
  } else {
    
    switch (currentSameOrientation) {
      case LANDSCAPE_ORI:
      {
        // both device and image are landscape orientation
        if (isBigImage) {
          if (self.originalImage.size.width/self.originalImage.size.height > LANDSCAPE_W_H_RATIO) {
            // means the width is the base, height should be calculated according to the ratio
            width = self.view.bounds.size.width;
            height = (self.originalImage.size.height/self.originalImage.size.width)*width;
            x = 0;
            y = (imageHeight - height) / 2;
          } else if (self.originalImage.size.width/self.originalImage.size.height < LANDSCAPE_W_H_RATIO) {
            // means the height is the base, width should be calculated according to the ratio
            height = imageHeight;
            width = (self.originalImage.size.width/self.originalImage.size.height)*height;
            y = 0;
            x = (self.view.bounds.size.width - width)/2;
          } else {
            // image width/height is same as current device width/height, then the displayed width and height
            // could be the same as the width and height of device
            x = 0;
            y = 0;
            width = self.view.bounds.size.width;
            height = imageHeight;
          }
          
        } else {
          // image size is smaller than the screen size, so the actual displayed x and y could be
          // calculated according to the actual width and height of image and screen size
          height = self.originalImage.size.height;
          width = self.originalImage.size.width;
          x = (self.view.bounds.size.width - width)/2;
          y = (imageHeight - height)/2;
        }
        
        break;
      }
        
      case PORTRAIT_ORI:
      {
        // both device and image are portrait
        if (isBigImage) {
          
          CGFloat portraitWidthHeightRation = 0.0f;
          if ([WXWCommonUtils screenHeightIs4Inch]) {
            portraitWidthHeightRation = 320.0f/DISPLAY_BOARD_40INCH_HEIGHT;
          } else {
            portraitWidthHeightRation = 320.0f/DISPLAY_BOARD_35INCH_HEIGHT;
          }
          
          if (self.originalImage.size.width/self.originalImage.size.height > portraitWidthHeightRation) {
            height = imageHeight;
            width = (imageHeight * self.originalImage.size.width)/self.originalImage.size.height;
            x = 0;
            y = 0;
          } else if (self.originalImage.size.width/self.originalImage.size.height < portraitWidthHeightRation) {
            height = imageHeight;
            width = (self.originalImage.size.width/self.originalImage.size.height)*height;
            y = 0;
            x = (self.view.bounds.size.width - width)/2;
          } else {
            x = 0;
            y = 0;
            width = self.view.bounds.size.width;
            height = imageHeight;
          }
          
        } else {
          height = self.originalImage.size.height;
          width = self.originalImage.size.width;
          x = (self.view.bounds.size.width - width)/2;
          y = (imageHeight - height)/2;
        }
        
        break;
      }
        
      case DIFF_ORI:
      {
        if (isBigImage) {
          if (DEVICE_IS_LANDSCAPE) {
            // image is portrait
            height = imageHeight;
            width = (self.originalImage.size.width/self.originalImage.size.height)*height;
            x = (self.view.bounds.size.width - width)/2;
            y = 0;
          } else {
            // image is landscape
            width = self.view.bounds.size.width;
            height = (self.originalImage.size.height/self.originalImage.size.width)*width;
            x = 0;
            y = (imageHeight - height)/2;
          }
          
        } else {
          height = self.originalImage.size.height;
          width = self.originalImage.size.width;
          if (DEVICE_IS_LANDSCAPE) {
            x = (self.view.bounds.size.width - width)/2;
            y = (imageHeight - height)/2;
          } else {
            x = (self.view.bounds.size.width - width)/2;
            y = (imageHeight - height)/2;
          }
        }
        break;
      }
        
      default:
        break;
    }
  }
    
  self.displayBoard = [[[UIView alloc] init] autorelease];
  self.displayBoard.frame = CGRectMake(0, VERTICAL_Y, self.view.bounds.size.width, imageHeight);
  self.displayBoard.backgroundColor = [UIColor blackColor];
  
  _displayedImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)] autorelease];
  _displayedImageView.image = self.originalImage;
  
  [self.displayBoard addSubview:_displayedImageView];
  [self.view addSubview:self.displayBoard];
}

- (void)applyEffectedImage:(UIImage *)effectedImage {
  
  rotateStep = 0;
  
  self.selectedImage = effectedImage;
  self.targetImage = effectedImage;
  _displayedImageView.image = effectedImage;
}

- (void)arrangePalette {
  
  self.palette = [[[ECPhotoEffectSamplesView alloc] initWithFrame:CGRectMake(0, /*DISPLAY_BOARD_HEIGHT - 20.0f*/_toolbar.frame.origin.y, self.view.bounds.size.width, 0)
                                                    originalImage:self.originalImage
                                                           target:self
                                                           action:@selector(applyEffectedImage:)] autorelease];
  
  self.palette.alpha = 0.0f;
  [self.view addSubview:self.palette];
  
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:0.2f];
  self.palette.alpha = 1.0f;
  self.palette.frame = CGRectMake(0, /*DISPLAY_BOARD_HEIGHT - EFFECT_PHOTO_SAMPLE_VIEW_HEIGHT - 20.0f*/_toolbar.frame.origin.y - EFFECT_PHOTO_SAMPLE_VIEW_HEIGHT, self.view.bounds.size.width, EFFECT_PHOTO_SAMPLE_VIEW_HEIGHT);
  
  [UIView commitAnimations];
}

- (void)handleTakenPhoto:(UIImage *)image {
  
  self.originalImage = [CommonUtils scaleAndRotateImage:image
                                             sourceType:_sourceType];
  
  self.selectedImage = self.originalImage;
  self.targetImage = self.originalImage;
  
  imgWidth = self.originalImage.size.width;
  imgHeight = self.originalImage.size.height;
  
  CGImageRef imgRef = self.targetImage.CGImage;
  imgWidth = CGImageGetWidth(imgRef);
  imgHeight = CGImageGetHeight(imgRef);
  
  rotateWidth = [[UIScreen mainScreen] bounds].size.width;
  rotateStep = 0;
  
  [self arrangeDiplayBoard];
  
  [self arrangePalette];
}

#pragma mark - UIImagePickerControllerDelegate methods

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
  
  [self setImageEffectHandleButtons];
  
  UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
  
  [self handleTakenPhoto:image];
  
  switch (_sourceType) {
    case UIImagePickerControllerSourceTypePhotoLibrary:
    {
      _userSelectPhotoFromAlbum = YES;
      [self.imagePicker.view addSubview:self.view];
      break;
    }
    case UIImagePickerControllerSourceTypeCamera:
    {
      if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        [self.imagePicker.view addSubview:self.view];
        self.imagePicker.sourceType = _sourceType;
        
        _userSelectPhotoFromAlbum = YES;
      }
      break;
    }
    default:
      break;
  }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
  
  if (_sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
    [self.imagePicker dismissModalViewControllerAnimated:YES];
    
  } else {
    
    // user opens album from camera controllers, then user cancel the album pick action,
    // the image picker source type should be recoveried as UIImagePickerControllerSourceTypeCamera
    self.imagePicker.sourceType = _sourceType;
  }
  
  _userSelectPhotoFromAlbum = NO;
}

/*
 - (UIImage *)rotateImage:(UIImage *)aImage
 {
 CGImageRef imgRef = aImage.CGImage;
 
 CGFloat width = CGImageGetWidth(imgRef);
 CGFloat height = CGImageGetHeight(imgRef);
 
 CGAffineTransform transform = CGAffineTransformIdentity;
 CGRect bounds = CGRectMake(0, 0, width, height);
 
 CGFloat scaleRatio = 1;
 CGFloat boundHeight;
 
 UIImageOrientation orient = aImage.imageOrientation;
 
 switch(orient)
 {
 
 case UIImageOrientationUp: //EXIF = 1
 transform = CGAffineTransformIdentity;
 break;
 
 case UIImageOrientationUpMirrored: //EXIF = 2
 transform = CGAffineTransformMakeTranslation(width, 0.0);
 transform = CGAffineTransformScale(transform, -1.0, 1.0);
 break;
 
 case UIImageOrientationDown: //EXIF = 3
 transform = CGAffineTransformMakeTranslation(width, height);
 transform = CGAffineTransformRotate(transform, M_PI);
 break;
 
 case UIImageOrientationDownMirrored: //EXIF = 4
 transform = CGAffineTransformMakeTranslation(0.0, height);
 transform = CGAffineTransformScale(transform, 1.0, -1.0);
 break;
 
 case UIImageOrientationLeftMirrored: //EXIF = 5
 boundHeight = bounds.size.height;
 bounds.size.height = bounds.size.width;
 bounds.size.width = boundHeight;
 transform = CGAffineTransformMakeTranslation(height, width);
 transform = CGAffineTransformScale(transform, -1.0, 1.0);
 transform = CGAffineTransformRotate(transform, 3.0 * M_PI /2.0);
 break;
 
 case UIImageOrientationLeft: //EXIF = 6
 boundHeight = bounds.size.height;
 bounds.size.height = bounds.size.width;
 bounds.size.width = boundHeight;
 transform = CGAffineTransformMakeTranslation(0.0, width);
 transform = CGAffineTransformRotate(transform, 3.0 * M_PI /2.0);
 break;
 
 case UIImageOrientationRightMirrored: //EXIF = 7
 boundHeight = bounds.size.height;
 bounds.size.height = bounds.size.width;
 bounds.size.width = boundHeight;
 transform = CGAffineTransformMakeScale(-1.0, 1.0);
 transform = CGAffineTransformRotate(transform, M_PI / 2.0);
 break;
 
 case UIImageOrientationRight: //EXIF = 8
 boundHeight = bounds.size.height;
 bounds.size.height = bounds.size.width;
 bounds.size.width = boundHeight;
 transform = CGAffineTransformMakeTranslation(height, 0.0);
 transform = CGAffineTransformRotate(transform, M_PI / 2.0);
 break;
 
 default:
 break;
 
 }
 
 UIGraphicsBeginImageContext(bounds.size);
 
 CGContextRef context = UIGraphicsGetCurrentContext();
 
 if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
 
 CGContextScaleCTM(context, -scaleRatio, scaleRatio);
 
 CGContextTranslateCTM(context, -height, 0);
 
 } else {
 
 CGContextScaleCTM(context, scaleRatio, -scaleRatio);
 
 CGContextTranslateCTM(context, 0, -height);
 }
 
 CGContextConcatCTM(context, transform);
 
 CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
 
 UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
 UIGraphicsEndImageContext();
 
 return imageCopy;
 
 }
 */

@end
