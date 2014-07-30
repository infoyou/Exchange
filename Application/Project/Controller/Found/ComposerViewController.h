//
//  ComposerViewController.h
//  Project
//
//  Created by XXX on 11-11-17.
//  Copyright (c) 2011年 _CompanyName_. All rights reserved.
//

#import "WXWRootViewController.h"
#import "GlobalConstants.h"
#import "ECPhotoPickerDelegate.h"
#import "ECEditorDelegate.h"
#import "ECItemUploaderDelegate.h"
#import "ECPhotoPickerOverlayDelegate.h"

@class TextComposerView;
@class PhotoFetcherView;
@class ECPhotoPickerOverlayViewController;

@interface ComposerViewController : WXWRootViewController <UIActionSheetDelegate, ECPhotoPickerDelegate, UIImagePickerControllerDelegate, ECEditorDelegate, ECPhotoPickerOverlayDelegate> {
  
@private
  TextComposerView *_textComposer;
  
  PhotoFetcherView *_photoFetcherView;
  
  ActionSheetOwnerType _actionSheetOwnerType;
  UIImagePickerControllerSourceType _photoSourceType;
  UIImage *_selectedPhoto;
  
  NSString *_originalItemId;
  
  NSString *_brandId;
  
  NSString *_groupId;
  
  WebItemType _contentType;
  
  NSString *_content;
  NSString *_isSelectedSms;
  
  id<ECItemUploaderDelegate> _delegate;
  
  id _needBeClosedParent;
  SEL _closeAction;
  
  PhotoTakerType _photoTakerType;
  
  BOOL _needMoveDownUI;
  
  BOOL _needMoveDown20px;
  
  BOOL _hidePhotoFetcher;
  
  UIImagePickerControllerSourceType _imagePickerSourceType;
  
  ECPhotoPickerOverlayViewController *_pickerOverlayVC;
  
  BOOL _loadingPlaces;
  BOOL _placesLoaded;
}

- (id)initWithMOC:(NSManagedObjectContext *)MOC 
         delegate:(id<ECItemUploaderDelegate>)delegate;

- (id)initWithMOC:(NSManagedObjectContext *)MOC 
         delegate:(id<ECItemUploaderDelegate>)delegate
   originalItemId:(NSString *)originalItemId;

- (id)initNoPhotoFetcherWithMOC:(NSManagedObjectContext *)MOC
                       delegate:(id<ECItemUploaderDelegate>)delegate
                 originalItemId:(NSString *)originalItemId;

- (id)initServiceItemCommentComposerWithMOC:(NSManagedObjectContext *)MOC
                                   delegate:(id<ECItemUploaderDelegate>)delegate
                             originalItemId:(NSString *)originalItemId
                                    brandId:(NSString *)brandId;

- (id)initServiceProviderCommentComposerWithMOC:(NSManagedObjectContext *)MOC
                                       delegate:(id<ECItemUploaderDelegate>)delegate
                                 originalItemId:(NSString *)originalItemId;

- (id)initWithMOC:(NSManagedObjectContext *)MOC 
         delegate:(id<ECItemUploaderDelegate>)delegate
          groupId:(NSString *)groupId;

- (id)initForEventDiscussWithMOC:(NSManagedObjectContext *)MOC
                        delegate:(id<ECItemUploaderDelegate>)delegate
                         eventId:(NSString *)eventId;

- (id)initForShareWithMOC:(NSManagedObjectContext *)MOC 
                 delegate:(id<ECItemUploaderDelegate>)delegate
                  groupId:(NSString *)groupId;

- (id)initWithMOC:(NSManagedObjectContext *)MOC 
         delegate:(id<ECItemUploaderDelegate>)delegate
          groupId:(NSString *)groupId
    selectedImage:(UIImage *)selectedImage 
needBeClosedParent:(id)needBeClosedParent
      closeAction:(SEL)closeAction
   photoTakerType:(PhotoTakerType)photoTakerType 
   needMoveDownUI:(BOOL)needMoveDownUI 
imagePickerSourceType:(UIImagePickerControllerSourceType)imagePickerSourceType;

- (id)initWithMOCForServiceItem:(NSString *)itemId
                            MOC:(NSManagedObjectContext *)MOC 
                       delegate:(id<ECItemUploaderDelegate>)delegate          
                  selectedImage:(UIImage *)selectedImage 
             needBeClosedParent:(id)needBeClosedParent
                    closeAction:(SEL)closeAction
                 needMoveDownUI:(BOOL)needMoveDownUI 
          imagePickerSourceType:(UIImagePickerControllerSourceType)imagePickerSourceType;

@end
