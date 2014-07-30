//
//  BizComposerViewController.h
//  Project
//
//  Created by XXX on 13-12-25.
//
//

#import "WXWRootViewController.h"
#import "ECEditorDelegate.h"
#import "ECPhotoPickerDelegate.h"
#import "ECPhotoPickerOverlayDelegate.h"
#import "ECItemUploaderDelegate.h"
#import "SupplyDemandTextEditorView.h"

@class BizPostHeaderTagView;
@class PhotoFetcherView;
@class TagSelectionView;
@class WXWLabel;

@interface BizComposerViewController : WXWRootViewController <UIActionSheetDelegate, ECPhotoPickerDelegate, UIImagePickerControllerDelegate, ECEditorDelegate, ECPhotoPickerOverlayDelegate, SupplyDemandTextEditorProtocal> {
  
  @private
  
  BizPostHeaderTagView *_textComposer;
  
  SupplyDemandTextEditorView *_textEditorView;
  
  PhotoFetcherView *_photoFetcherView;
  
  UIButton *_selectPhotoButton;
  
  //TagSelectionView *_tagSelectionView;
  
  BOOL _needMoveDownUI;
  BOOL _needMoveDown20px;
  
  BOOL _tagLoaded;
  BOOL _tagLoading;
  BOOL _tryToOpenTagList;
  
  // take photo
  ActionSheetOwnerType _actionSheetOwnerType;
  UIImagePickerControllerSourceType _photoSourceType;

}

- (id)initWithMOC:(NSManagedObjectContext *)MOC
   uploadDelegate:(id<ECItemUploaderDelegate>)uploadDelegate;


@end
