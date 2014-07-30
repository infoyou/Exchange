//
//  ComposerViewController.m
//  Project
//
//  Created by XXX on 11-11-17.
//  Copyright (c) 2011年 _CompanyName_. All rights reserved.
//

#import "ComposerViewController.h"
#import "TextComposerView.h"
#import "TextPool.h"
#import "CommonUtils.h"
#import "PhotoFetcherView.h"
#import "AppManager.h"
#import "UIUtils.h"
#import "XMLParser.h"
#import "WXWCoreDataUtils.h"
#import "ComposerTag.h"
#import "ECPhotoPickerOverlayViewController.h"
#import "ItemPropertiesListViewController.h"
#import "Place.h"
#import "WXWDebugLogOutput.h"

#define TEXT_COMPOSER_35INCH_HEIGHT		(200-KEYBOARD_GAP)
#define TEXT_COMPOSER_40INCH_HEIGHT		TEXT_COMPOSER_35INCH_HEIGHT + 88.0f

#define PLACE_SEARCH_RADIUS         0.5f

@interface ComposerViewController()
@property (nonatomic, copy) NSString *originalItemId;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, retain) UIImage *selectedPhoto;
@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, retain) ECPhotoPickerOverlayViewController *pickerOverlayVC;
@property (nonatomic, retain) id<ECItemUploaderDelegate> delegate;
@property (nonatomic, assign) NSString *isSelectedSms;
@property (nonatomic, copy) NSString *brandId;
@end

@implementation ComposerViewController

@synthesize originalItemId = _originalItemId;
@synthesize content = _content;
@synthesize isSelectedSms = _isSelectedSms;
@synthesize selectedPhoto = _selectedPhoto;
@synthesize groupId = _groupId;
@synthesize pickerOverlayVC = _pickerOverlayVC;
@synthesize delegate = _delegate;
@synthesize brandId = _brandId;

#pragma mark - user actions

- (void)sendComment {
  /*
  self.connFacade = [[[ECAsyncConnectorFacade alloc] initWithDelegate:self
                                               interactionContentType:SEND_COMMENT_TY] autorelease];
  
  [(ECAsyncConnectorFacade *)self.connFacade sendComment:self.content originalItemId:self.originalItemId photo:self.selectedPhoto];
   */
}

- (void)sendServiceItemComment {
  if (self.content.length == 0 || nil == self.content) {
    self.content = @" ";
  }
  
    /*
  self.connFacade = [[[ECAsyncConnectorFacade alloc] initWithDelegate:self
                                               interactionContentType:SEND_SERVICE_ITEM_COMMENT_TY] autorelease];
  [(ECAsyncConnectorFacade *)self.connFacade sendServiceItemComment:self.content
                                   itemId:self.originalItemId
                                  brandId:self.brandId];
     */
}

- (NSArray *)fetchSelectedTags {
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(selected == 1)"];
  
  NSArray *selectedTags = [WXWCoreDataUtils fetchObjectsFromMOC:_MOC
                                                  entityName:@"ComposerTag"
                                                   predicate:predicate];
  return selectedTags;
}

- (void)doSend:(NSArray *)selectedTags {
    /*
  self.connFacade = [[[ECAsyncConnectorFacade alloc] initWithDelegate:self
                                               interactionContentType:SEND_POST_TY] autorelease];
  
  NSString *selectedTagIds = NULL_PARAM_VALUE;
  NSInteger index = 0;
  for (ComposerTag *tag in selectedTags) {
    if (index > 0) {
      selectedTagIds = [NSString stringWithFormat:@"%@,%@", selectedTagIds, tag.tagId];
    } else {
      selectedTagIds = [NSString stringWithFormat:@"%@", tag.tagId];
    }
    index++;
  }
  
  if (self.content.length == 0 || nil == self.content) {
    self.content = @" ";
  }
  
  switch (_contentType) {
    case SEND_POST_TY:
      [(ECAsyncConnectorFacade *)self.connFacade sendPost:self.content
                          photo:self.selectedPhoto
                         hasSms:self.isSelectedSms];
      break;
      
    case SEND_EVENT_DISCUSS_TY:
      [(ECAsyncConnectorFacade *)self.connFacade sendEventDiscuss:self.content
                                  photo:self.selectedPhoto
                                 hasSMS:self.isSelectedSms
                                eventId:self.groupId];
      break;
      
    case SEND_SHARE_TY:
    {
      PostType type = 0;
      NSString *groupId = NULL_PARAM_VALUE;
      if (self.groupId.longLongValue == ALL_CATEGORY_GROUP_ID) {
        type = SHARE_POST_TY;
      } else {
        type = DISCUSS_POST_TY;
        groupId = self.groupId;
      }
      [(ECAsyncConnectorFacade *)self.connFacade sendPost:self.content
                         tagIds:selectedTagIds
                      placeName:_textComposer.selectedPlace.placeName
                          photo:self.selectedPhoto
                       postType:type
                        groupId:groupId];
      break;
    }
      
    default:
      break;
  }
     */
}

- (void)sendPost {
  
  if (self.content.length == 0 || nil == self.content) {
    [UIUtils showNotificationOnTopWithMsg:LocaleStringForKey(NSChatEmptyWarningMsg, nil)
                                  msgType:WARNING_TY
                       belowNavigationBar:YES];
  } else {
    NSArray *selectedTags = [self fetchSelectedTags];
    [self doSend:selectedTags];
  }
  
}

- (BOOL)needTagMandatory {
  if ([WXWCoreDataUtils objectInMOC:_MOC
                      entityName:@"ComposerTag"
                       predicate:nil]) {
    return YES;
  } else {
    return NO;
  }
}

- (void)sendShare {
  
  NSArray *selectedTags = nil;
  
  if ([self needTagMandatory]) {
    selectedTags = [self fetchSelectedTags];
    
    if (nil == selectedTags || [selectedTags count] == 0) {
      // user must select one tag at least
      
      [self chooseTags];
      
      [UIUtils showNotificationOnTopWithMsg:LocaleStringForKey(NSSelectTagNotifyMsg, nil)
                                    msgType:WARNING_TY
                         belowNavigationBar:YES];
      return;
    }
  }
  
  if (self.content.length == 0 || nil == self.content) {
    [UIUtils showNotificationOnTopWithMsg:LocaleStringForKey(NSChatEmptyWarningMsg, nil)
                                  msgType:WARNING_TY
                       belowNavigationBar:YES];
    return;
  }
  
  [self doSend:selectedTags];
  
  /*
   NSArray *selectedTags = [self fetchSelectedTags];
   
   if (nil == selectedTags || [selectedTags count] == 0) {
   // user must select one tag at least
   
   [self chooseTags];
   
   [UIUtils showNotificationOnTopWithMsg:LocaleStringForKey(NSSelectTagNotifyMsg, nil)
   msgType:WARNING_TY
   belowNavigationBar:YES];
   } else if (self.content.length == 0 || nil == self.content) {
   [UIUtils showNotificationOnTopWithMsg:LocaleStringForKey(NSChatEmptyWarningMsg, nil)
   msgType:WARNING_TY
   belowNavigationBar:YES];
   } else {
   [self doSend:selectedTags];
   }
   */
}

- (void)sendEventDiscuss {
  [self doSend:nil];
}

- (void)send:(id)sender {
  
  switch (_contentType) {
    case SEND_COMMENT_TY:
      [self sendComment];
      break;
      
    case SEND_POST_TY:
      [self sendPost];
      break;
          
    default:
      break;
  }
  
}

- (void)doClose {
  [self cancelConnection];
  [self cancelLocation];
  
  switch (_photoTakerType) {
    case SERVICE_ITEM_AVATAR_TY:
    case HANDY_PHOTO_TAKER_TY:
      
      if (_needBeClosedParent && _closeAction) {
        // composer view controller initialized by photo picker, so close the photo picker directly
        [_needBeClosedParent performSelector:_closeAction];
      }
      
      break;
      
    case POST_COMPOSER_TY:
      // normal close method
      [self.navigationController dismissModalViewControllerAnimated:YES];
      break;
    default:
      break;
  }
}

- (void)close:(id)sender {
  
  _actionSheetOwnerType = CLOSE_BTN;
  
  if ([_textComposer charCount] > 0 || self.selectedPhoto) {
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:LocaleStringForKey(NSCloseNotificationTitle, nil)
                                                    delegate:self
                                           cancelButtonTitle:nil
                                      destructiveButtonTitle:nil
                                           otherButtonTitles:nil];
		[as addButtonWithTitle:LocaleStringForKey(NSCloseTitle, nil)];
		[as addButtonWithTitle:LocaleStringForKey(NSCancelTitle, nil)];
    as.destructiveButtonIndex = 0;
		as.cancelButtonIndex = [as numberOfButtons] - 1;
		[as showInView:self.navigationController.view];
		RELEASE_OBJ(as)
    
  } else {
    
    [self doClose];
  }
}

#pragma mark - photo add/remove

- (void)showImagePicker:(BOOL)hasCamera {
  _photoSourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  if (hasCamera) {
    _photoSourceType = UIImagePickerControllerSourceTypeCamera;
  }
  
  self.pickerOverlayVC = [[[ECPhotoPickerOverlayViewController alloc] initWithSourceType:_photoSourceType
                                                                                delegate:self
                                                                        uploaderDelegate:self.delegate
                                                                               takerType:POST_COMPOSER_TY
                                                                                     MOC:_MOC] autorelease];
  
  [self.pickerOverlayVC arrangeViews];
  
  [self presentModalViewController:self.pickerOverlayVC.imagePicker animated:YES];
  
  /*
   ECPhotoPickerController *picker = [[[ECPhotoPickerController alloc] initWithSourceType:_photoSourceType] autorelease];
   picker.title = LocaleStringForKey(NSPhotoEffectHandleTitle, nil);
   picker.delegate = self;
   [self.navigationController pushViewController:picker animated:YES];
   [picker.navigationController presentModalViewController:picker.imagePicker animated:YES];
   */
}

- (void)showImagePicker {
  
  _photoSourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  if (HAS_CAMERA) {
    _photoSourceType = UIImagePickerControllerSourceTypeCamera;
  }
  
  self.pickerOverlayVC = [[[ECPhotoPickerOverlayViewController alloc] initWithSourceType:_photoSourceType
                                                                                delegate:self
                                                                        uploaderDelegate:self.delegate
                                                                               takerType:POST_COMPOSER_TY
                                                                                     MOC:_MOC] autorelease];
  
  [self.pickerOverlayVC arrangeViews];
  
  [self presentModalViewController:self.pickerOverlayVC.imagePicker animated:YES];
}

- (void)addOrRemovePhoto {
  
  if (nil == self.selectedPhoto) {
    [self showImagePicker];
  } else {
    
    _actionSheetOwnerType = PHOTO_BTN;
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:nil
                                                    delegate:self
                                           cancelButtonTitle:nil
                                      destructiveButtonTitle:nil
                                           otherButtonTitles:nil];
    
    if (self.selectedPhoto) {
      [as addButtonWithTitle:LocaleStringForKey(NSClearCurrentSelection, nil)];
      as.destructiveButtonIndex = [as numberOfButtons] - 1;
    }
    
    if (HAS_CAMERA) {
      [as addButtonWithTitle:LocaleStringForKey(NSTakePhotoTitle, nil)];
    } else {
      [as addButtonWithTitle:LocaleStringForKey(NSChooseExistingPhotoTitle, nil)];
    }
    
    [as addButtonWithTitle:LocaleStringForKey(NSCancelTitle, nil)];
    as.cancelButtonIndex = [as numberOfButtons] - 1;
    [as showInView:self.navigationController.view];
    
    RELEASE_OBJ(as);
  }
}

- (void)changeSendButtonStatus {
  if ((self.content && [self.content length] > 0) || self.selectedPhoto) {
    self.navigationItem.rightBarButtonItem.enabled = YES;
  } else {
    self.navigationItem.rightBarButtonItem.enabled = NO;
  }
}

- (void)applyPhotoSelectedStatus:(UIImage *)image {
	self.selectedPhoto = image;
  [_photoFetcherView applySelectedPhoto:[CommonUtils cutPartImage:image
                                                            width:ADD_PHOTO_BUTTON_SIDE_LENGTH
                                                           height:ADD_PHOTO_BUTTON_SIDE_LENGTH]];
  [self changeSendButtonStatus];
}

- (void)saveImageIfNecessary:(UIImage *)image
                  sourceType:(UIImagePickerControllerSourceType)sourceType {
  if (sourceType == UIImagePickerControllerSourceTypeCamera) {
    
		UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
	}
}

- (void)handleFinishPickImage:(UIImage *)image
                   sourceType:(UIImagePickerControllerSourceType)sourceType {
  UIImage *handledImage = [CommonUtils scaleAndRotateImage:image sourceType:sourceType];
	
  [self saveImageIfNecessary:handledImage sourceType:sourceType];
	
	[self applyPhotoSelectedStatus:handledImage];
}

#pragma mark - PhotoPickerDelegate method

- (void)selectPhoto:(UIImage *)selectedImage {
  if (_photoSourceType == UIImagePickerControllerSourceTypeCamera) {
    UIImageWriteToSavedPhotosAlbum(selectedImage, nil, nil, nil);
  }
  
  [self applyPhotoSelectedStatus:selectedImage];
}

#pragma mark - ECPhotoPickerOverlayDelegate methods
- (void)didTakePhoto:(UIImage *)photo {
  [self selectPhoto:photo];
}

// as a delegate we are told to finished with the camera
- (void)didFinishWithCamera {
  
  self.pickerOverlayVC = nil;
}

- (void)adjustUIAfterUserBrowseAlbumInImagePicker {
  
  // user browse the album in image picker, so UI layout be set as full screen, then we should recovery
  // the layout corresponding
  
  [UIApplication sharedApplication].statusBarHidden = NO;
  
  self.navigationController.navigationBar.frame = CGRectOffset(self.navigationController.navigationBar.frame, 0.0f, 20.0f);
  self.view.frame = CGRectOffset(self.view.frame, 0.0f, 20.0f);
  
  _needMoveDown20px = YES;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo {
	
  [self handleFinishPickImage:image
                   sourceType:picker.sourceType];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	
	[self.navigationController dismissModalViewControllerAnimated:YES];
}


#pragma mark - action sheet delegate method
- (void)actionSheet:(UIActionSheet *)as  clickedButtonAtIndex:(NSInteger)buttonIndex {
  
  switch (_actionSheetOwnerType) {
    case CLOSE_BTN:
      if (as.cancelButtonIndex == buttonIndex) {
        return;
      } else {
        [self doClose];
      }
      break;
      
    case PHOTO_BTN:
    {
      if (as.cancelButtonIndex == buttonIndex) {
				return;
			} else if (as.destructiveButtonIndex == buttonIndex) {
				self.selectedPhoto = nil;
        [_photoFetcherView applySelectedPhoto:nil];
        [self changeSendButtonStatus];
				return;
			} else {
        [self showImagePicker];
      }
      
			/*
       if ([actionTitle isEqualToString:LocaleStringForKey(NSTakePhotoTitle, nil)]) {
       [self showImagePicker:YES];
       } else {
       [self showImagePicker:NO];
       }
       */
      break;
    }
    default:
      break;
  }
  
}

#pragma mark - keyboard notification handlers

- (CGSize)fetchKeyboardSize:(NSNotification *)notification {
  return [[notification userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
}

- (CGFloat)calcNoKeyboardAreaHeight:(NSNotification *)notification {
  CGSize size = [self fetchKeyboardSize:notification];
  
  CGFloat areaHeight = self.view.frame.size.height - size.height;
  
  if (_needMoveDownUI) {
    areaHeight -= (SYS_STATUS_BAR_HEIGHT + NAVIGATION_BAR_HEIGHT);
  } else {
    if (_photoTakerType == HANDY_PHOTO_TAKER_TY ||
        /*_photoTakerType == SERVICE_ITEM_AVATAR_TY ||*/
        _needMoveDown20px) {
      areaHeight -= SYS_STATUS_BAR_HEIGHT;
    }
  }
  return areaHeight;
}

- (void)keyboardHeightChanged:(NSNotification*)notification {
  
  [_textComposer arrangeLayoutForKeyboardChange:[self calcNoKeyboardAreaHeight:notification]];
}

- (void)keyboardWasShown:(NSNotification *)notification {
  /*
   CGSize size = [self fetchKeyboardSize:notification];
   
   CGFloat areaHeight = self.view.frame.size.height - size.height;
   
   if (_needMoveDownUI) {
   areaHeight -= (SYS_STATUS_BAR_HEIGHT + NAVIGATION_BAR_HEIGHT);
   } else {
   if (_photoTakerType == HANDY_PHOTO_TAKER_TY || _needMoveDown20px) {
   areaHeight -= SYS_STATUS_BAR_HEIGHT;
   }
   }
   */
  
  [_textComposer arrangeLayoutForKeyboardChange:[self calcNoKeyboardAreaHeight:notification]];
}

#pragma mark - ECEditorDelegate methods
- (void)textChanged:(NSString *)text {
  
  self.content = text;
  [self changeSendButtonStatus];
}

- (void)chooseTags {
  ItemPropertiesListViewController *itemPropertiesListVC = [[[ItemPropertiesListViewController alloc] initWithMOC:_MOC
                                                                                                           holder:nil
                                                                                                 backToHomeAction:nil
                                                                                                     propertyType:TAG_TY
                                                                                                       moveDownUI:_needMoveDownUI
                                                                                                          tagType:SHARE_TY] autorelease];
  itemPropertiesListVC.title = LocaleStringForKey(NSTagTitle, nil);
  [self.navigationController pushViewController:itemPropertiesListVC animated:YES];
}

- (void)choosePlace {
//  PlaceListViewController *placeListVC = [[[PlaceListViewController alloc] initWithMOC:_MOC
//                                                                                holder:nil
//                                                                      backToHomeAction:nil
//                                                                            needGoHome:NO] autorelease];
//  
//  placeListVC.title = LocaleStringForKey(NSNearbyPlaceListTitle, nil);
//  [self.navigationController pushViewController:placeListVC animated:YES];
}

#pragma mark - ECConnectorDelegate methods
- (void)connectStarted:(NSString *)url contentType:(NSInteger)contentType {
  
  switch (contentType) {
      
    case SEND_COMMENT_TY:
    case SEND_POST_TY:
   {
      [UIUtils showAsyncLoadingView:LocaleStringForKey(NSSendingTitle, nil)
                    toBeBlockedView:NO];
      
      [self doClose];
      break;
    }
      
    default:
      break;
  }
  
  [super connectStarted:url contentType:contentType];
}

- (void)connectCancelled:(NSString *)url contentType:(NSInteger)contentType {
  
  [super connectCancelled:url contentType:contentType];
}

- (NSString *)successMsg {
  return LocaleStringForKey(NSSendFeedDoneMsg, nil);
}

- (NSString *)errorMsg {
  if ([AppManager instance].feedGroupId.longLongValue == self.groupId.longLongValue) {
    // send feed
    return LocaleStringForKey(NSSendFeedFailedMsg, nil);
  } 
  return nil;
}

- (void)connectDone:(NSData *)result url:(NSString *)url contentType:(NSInteger)contentType {
  
  switch (contentType) {
    case SEND_COMMENT_TY:
    case SEND_SERVICE_ITEM_COMMENT_TY:
    {
      if ([XMLParser parserResponseXml:result
                                  type:SEND_COMMENT_TY
                                   MOC:nil
                     connectorDelegate:self
                                   url:url]) {
        
        if (self.delegate) {
          [self.delegate afterUploadFinishAction:contentType];
        }
        
        [UIUtils showNotificationOnTopWithMsg:LocaleStringForKey(NSSendCommentDoneMsg, nil)
                                      msgType:SUCCESS_TY
                           belowNavigationBar:YES];
        
      } else {
        [UIUtils showNotificationOnTopWithMsg:(self.errorMsgDic)[url]
                               alternativeMsg:LocaleStringForKey(NSSendCommentFailedMsg, nil)
                                      msgType:ERROR_TY
                           belowNavigationBar:YES];
      }
      break;
    }
      
    case SEND_POST_TY:
    {
      if ([XMLParser parserResponseXml:result
                                  type:contentType
                                   MOC:nil
                     connectorDelegate:self
                                   url:url]) {
        
        if (self.delegate) {
          [self.delegate afterUploadFinishAction:contentType];
        }
        
        [UIUtils showNotificationOnTopWithMsg:[self successMsg]
                                      msgType:SUCCESS_TY
                           belowNavigationBar:YES];
      } else {
        [UIUtils showNotificationOnTopWithMsg:(self.errorMsgDic)[url]
                               alternativeMsg:[self errorMsg]
                                      msgType:ERROR_TY
                           belowNavigationBar:YES];
      }
      break;
      
    }
      
    default:
      break;
  }
  
  [UIUtils closeAsyncLoadingView];
  
  [super connectDone:result url:url contentType:contentType];
}

- (void)connectFailed:(NSError *)error url:(NSString *)url contentType:(NSInteger)contentType {
  
  NSString *msg = nil;
  
  switch (contentType) {
//    case LOAD_NEARBY_PLACE_LIST_TY:
//    {
//      _placesLoaded = NO;
//      _loadingPlaces = NO;
//      
//      [_textComposer showPlaceButton:NO];
//      break;
//    }
      
    case SEND_COMMENT_TY:
    {
      msg = LocaleStringForKey(NSSendCommentFailedMsg, nil);
      break;
    }
      
    case SEND_POST_TY:
//    case SEND_EVENT_DISCUSS_TY:
    {
      msg = [self errorMsg];
      break;
    }
    default:
      break;
  }
  
  if ([self connectionMessageIsEmpty:error]) {
    self.connectionErrorMsg = msg;
  }
  
  [UIUtils closeAsyncLoadingView];
  
  [super connectFailed:error url:url contentType:contentType];
}

#pragma mark - WXWLocationFetcherDelegate methods

- (void)locationManagerDidReceiveLocation:(WXWLocationManager *)manager location:(CLLocation *)location {
  [super locationManagerDidReceiveLocation:manager location:location];
  
//  [_textComposer setCityInfo:[AppManager instance].cityName];
      [_textComposer setCityInfo:@"cityName"];
}

#pragma mark - select tags and place
- (void)displaySelectedTagsAndPlace {
  [_textComposer displaySelectedTagsAndPlace];
}

#pragma mark - prepare for share

- (void)clearOldPlacesData {
  // delete 'Place' and 'ComposerTag' instance from MOC firstly
  DELETE_OBJS_FROM_MOC(_MOC, @"ComposerTag", nil);
  DELETE_OBJS_FROM_MOC(_MOC, @"Place", nil);
}

- (void)loadPlaces
{
//  _currentType = LOAD_NEARBY_PLACE_LIST_TY;
//  
//  NSString *param = [NSString stringWithFormat:@"<latitude>%f</latitude><longitude>%f</longitude>",
//                     [AppManager instance].latitude,
//                     [AppManager instance].longitude];
//  
//  NSString *url = [CommonUtils geneUrl:param itemType:_currentType];
//  WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url contentType:_currentType];
//  [connFacade fetchGets:url];
}

- (void)prepareDataForShare {
  [self clearOldPlacesData];
  [self loadPlaces];
  [self initTags];
}

#pragma mark - lifecycle methods

- (void)registerKeyboardNotifications {
  if (CURRENT_OS_VERSION >= IOS5) {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardHeightChanged:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
  }
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWasShown:)
                                               name:UIKeyboardDidShowNotification
                                             object:nil];
}

- (void)initTags {
  
  if ([WXWCoreDataUtils objectInMOC:_MOC entityName:@"Tag" predicate:nil]) {
    [WXWCoreDataUtils createComposerTagsForGroupId:self.groupId
                                            MOC:_MOC];
  }
}

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         delegate:(id<ECItemUploaderDelegate>)delegate {
  self = [super initWithMOC:MOC
                     holder:nil backToHomeAction:nil needGoHome:NO];
  if (self) {
    [self registerKeyboardNotifications];
    self.delegate = delegate;
    
    _photoTakerType = POST_COMPOSER_TY;
    
    _imagePickerSourceType = UIImagePickerControllerSourceTypeCamera;
  }
  return self;
}

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         delegate:(id<ECItemUploaderDelegate>)delegate
   originalItemId:(NSString *)originalItemId {
  
  self = [self initWithMOC:MOC delegate:delegate];
  if (self) {
    self.originalItemId = originalItemId;
    _contentType = SEND_COMMENT_TY;
  }
  return self;
}

- (id)initNoPhotoFetcherWithMOC:(NSManagedObjectContext *)MOC
                       delegate:(id<ECItemUploaderDelegate>)delegate
                 originalItemId:(NSString *)originalItemId {
  self = [self initWithMOC:MOC delegate:delegate originalItemId:originalItemId];
  if (self) {
    _hidePhotoFetcher = YES;
  }
  return self;
}

- (id)initServiceItemCommentComposerWithMOC:(NSManagedObjectContext *)MOC
                                   delegate:(id<ECItemUploaderDelegate>)delegate
                             originalItemId:(NSString *)originalItemId
                                    brandId:(NSString *)brandId {
  self = [self initWithMOC:MOC delegate:delegate originalItemId:originalItemId];
  if (self) {
    _hidePhotoFetcher = YES;
    
    self.brandId = brandId;
    
    _contentType = SEND_SERVICE_ITEM_COMMENT_TY;
  }
  return self;
}


- (id)initWithMOC:(NSManagedObjectContext *)MOC
         delegate:(id<ECItemUploaderDelegate>)delegate
          groupId:(NSString *)groupId {
  
  self.groupId = groupId;
  self.isSelectedSms = @"0";
  self = [self initWithMOC:MOC delegate:delegate];
  if (self) {
    _contentType = SEND_POST_TY;
    _photoTakerType = POST_COMPOSER_TY;
  }
  return self;
}

- (id)initForShareWithMOC:(NSManagedObjectContext *)MOC
                 delegate:(id<ECItemUploaderDelegate>)delegate
                  groupId:(NSString *)groupId {
//  self.groupId = groupId;
//  
//  self = [self initWithMOC:MOC delegate:delegate];
//  if (self) {
//    _contentType = SEND_SHARE_TY;
//    _photoTakerType = POST_COMPOSER_TY;
//    
//    [self prepareDataForShare];
//    
//    if (![IPHONE_SIMULATOR isEqualToString:[CommonUtils deviceModel]]) {
//      [AppManager instance].latitude = 0.0;
//      [AppManager instance].longitude = 0.0;
//      
//      [self getCurrentLocationInfoIfNecessary];
//    } else {
//      [AppManager instance].latitude = [SIMULATION_LATITUDE doubleValue];
//      [AppManager instance].longitude = [SIMULATION_LONGITUDE doubleValue];
//    }
//    
//  }
//  return self;
    return nil;
}

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         delegate:(id<ECItemUploaderDelegate>)delegate
          groupId:(NSString *)groupId
    selectedImage:(UIImage *)selectedImage
needBeClosedParent:(id)needBeClosedParent
      closeAction:(SEL)closeAction
   photoTakerType:(PhotoTakerType)photoTakerType
   needMoveDownUI:(BOOL)needMoveDownUI
imagePickerSourceType:(UIImagePickerControllerSourceType)imagePickerSourceType {
  
  self = [self initWithMOC:MOC delegate:delegate groupId:groupId];
  if (self) {
    
    if (selectedImage) {
      self.selectedPhoto = selectedImage;
    }
    _needBeClosedParent = needBeClosedParent;
    _closeAction = closeAction;
    
    _photoTakerType = photoTakerType;
    
    _needMoveDownUI = needMoveDownUI;
    
    _imagePickerSourceType = imagePickerSourceType;
  }
  return self;
}

- (id)initWithMOCForServiceItem:(NSString *)itemId
                            MOC:(NSManagedObjectContext *)MOC
                       delegate:(id<ECItemUploaderDelegate>)delegate
                  selectedImage:(UIImage *)selectedImage
             needBeClosedParent:(id)needBeClosedParent
                    closeAction:(SEL)closeAction
                 needMoveDownUI:(BOOL)needMoveDownUI
          imagePickerSourceType:(UIImagePickerControllerSourceType)imagePickerSourceType {
  
  self = [self initWithMOC:MOC
                  delegate:delegate
                   groupId:nil
             selectedImage:selectedImage
        needBeClosedParent:needBeClosedParent
               closeAction:closeAction
            photoTakerType:SERVICE_ITEM_AVATAR_TY
            needMoveDownUI:needMoveDownUI
     imagePickerSourceType:imagePickerSourceType];
  
  if (self) {
    self.originalItemId = itemId;
  }
  return self;
}

- (void)initNavigationBar {
  if (_photoTakerType != HANDY_PHOTO_TAKER_TY /*&& _photoTakerType != SERVICE_ITEM_AVATAR_TY*/) {
    
    [self addLeftBarButtonWithTitle:LocaleStringForKey(NSCloseTitle, nil)
                             target:self
                             action:@selector(close:)];
  }
  
  [self addRightBarButtonWithTitle:LocaleStringForKey(NSSendTitle, nil)
                            target:self
                            action:@selector(send:)];
  self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)initTextComposer {
  
  CGFloat y = 0.0f;
  if (_needMoveDownUI) {
    y += NAVIGATION_BAR_HEIGHT;
  }
  
  CGFloat textComposerHeight = 0;
  if ([WXWCommonUtils screenHeightIs4Inch]) {
    textComposerHeight = TEXT_COMPOSER_40INCH_HEIGHT;
  } else {
    textComposerHeight = TEXT_COMPOSER_35INCH_HEIGHT;
  }
  
  BOOL showSwitchButton = !_hidePhotoFetcher;
//  if (_contentType == SEND_EVENT_DISCUSS_TY) {
//    _textComposer = [[TextComposerView alloc] initWithFrame:CGRectMake(0, y, self.view.frame.size.width, textComposerHeight)
//                                                   topColor:COLOR(249, 249, 249)
//                                                bottomColor:COLOR(200, 200, 200)
//                                                     target:self
//                                                        MOC:_MOC
//                                                contentType:_contentType
//                                           showSwitchButton:showSwitchButton];
//  } else
    {
    _textComposer = [[TextComposerView alloc] initWithFrame:CGRectMake(0, y, self.view.frame.size.width, textComposerHeight)
                                                   topColor:COLOR(249, 249, 249)
                                                bottomColor:COLOR(200, 200, 200)
                                                     target:self
                                           selectTagsAction:nil
                                          selectPlaceAction:nil
                                                        MOC:_MOC
                                                contentType:_contentType
                                           showSwitchButton:showSwitchButton];
  }
  [self.view addSubview:_textComposer];
}

- (void)initPhotoFetcherView {
  BOOL userInteractionEnabled = YES;
  if (_photoTakerType == HANDY_PHOTO_TAKER_TY/* || _photoTakerType == SERVICE_ITEM_AVATAR_TY*/) {
    userInteractionEnabled = NO;
  }
  
  CGFloat textComposerHeight = 0;
  if ([WXWCommonUtils screenHeightIs4Inch]) {
    textComposerHeight = TEXT_COMPOSER_40INCH_HEIGHT;
  } else {
    textComposerHeight = TEXT_COMPOSER_35INCH_HEIGHT;
  }
  
  CGFloat y = textComposerHeight;
  if (_needMoveDownUI) {
    y += NAVIGATION_BAR_HEIGHT;
  }
  _photoFetcherView = [[PhotoFetcherView alloc] initWithFrame:CGRectMake(0,
                                                                         y,
                                                                         self.view.frame.size.width,
                                                                         self.view.frame.size.height - textComposerHeight)
                                                       target:self
                                        photoManagementAction:@selector(addOrRemovePhoto)
                                       userInteractionEnabled:userInteractionEnabled];
  [self.view addSubview:_photoFetcherView];
  
  [self.view bringSubviewToFront:_textComposer];
}

- (void)initSelfViewProperties {
  self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self initSelfViewProperties];
  
  [self initNavigationBar];
  
  [self initTextComposer];
  
  if (!_hidePhotoFetcher) {
    [self initPhotoFetcherView];
  }
  
  //    if (_contentType != SEND_COMMENT_TY && _contentType != ADD_PHOTO_FOR_SERVICE_ITEM_TY) {
  //        [self getCurrentLocationInfoIfNecessary];
  //    }
  
  if (self.selectedPhoto) {
    // caller pass a selected image, user takes photo directly from home page
    [self handleFinishPickImage:self.selectedPhoto
                     sourceType:_imagePickerSourceType];
  }
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [self displaySelectedTagsAndPlace];
}

- (void)deregisterKeyboardNotifications {
  if (CURRENT_OS_VERSION >= IOS5 ) {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillChangeFrameNotification
                                                  object:nil];
  }
  
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:UIKeyboardDidShowNotification
                                                object:nil];
}

- (void)dealloc {
  
  [self deregisterKeyboardNotifications];
  
  RELEASE_OBJ(_textComposer);
  RELEASE_OBJ(_photoFetcherView);
  
  self.isSelectedSms = nil;
  self.content = nil;
  self.selectedPhoto = nil;
  self.pickerOverlayVC = nil;
  self.delegate = nil;
  self.brandId = nil;
  
  DELETE_OBJS_FROM_MOC(_MOC, @"ComposerTag", nil);
  
  [super dealloc];
}

- (void)chooseSMS:(BOOL)isSelectedSms
{
  if (isSelectedSms) {
    self.isSelectedSms = @"1";
  }else {
    self.isSelectedSms = @"0";
  }
}

#pragma mark - location result
- (void)locationResult:(LocationResultType)type {
  
  [UIUtils closeActivityView];
  
  switch (type) {
    case LOCATE_SUCCESS_TY:
    {
      
    }
      break;
      
    case LOCATE_FAILED_TY:
    {
      [UIUtils showNotificationOnTopWithMsg:@"定位失败"
                                    msgType:ERROR_TY
                         belowNavigationBar:YES];
    }
      break;
      
    default:
      break;
  }
  
}

@end
