//
//  ECPhotoPickerOverlayViewController.h
//  Project
//
//  Created by XXX on 12-1-11.
//  Copyright (c) 2012年 _MyCompanyName_. All rights reserved.
//

#import "WXWRootViewController.h"
#import "GlobalConstants.h"

@protocol ECPhotoPickerOverlayDelegate;
@protocol ECItemUploaderDelegate;
@class ECPhotoEffectSamplesView;

@interface ECPhotoPickerOverlayViewController : WXWRootViewController <UINavigationControllerDelegate,  UIImagePickerControllerDelegate, UIActionSheetDelegate> {
    
    UIImagePickerController *_imagePicker;
    
    CGFloat imgWidth;
    CGFloat imgHeight;
    int rotateStep;
    CGFloat rotateWidth;
    
@private
    
    id<ECPhotoPickerOverlayDelegate> _delegate;
    
    id<ECItemUploaderDelegate> _uploaderDelegate;
    
    UIImagePickerControllerSourceType _sourceType;
    
    UIToolbar *_toolbar;
    
    UIButton *_onFlashButton;
    UIButton *_offFlashButton;
    UIButton *_autoFlashButton;
    UIButton *_flashButton;
    UIView *_flashButtonBoard;
    
    UIImage *_originalImage;
    UIImage *_selectedImage;
    UIImage *_targetImage;
    
    UIView *_displayBoard;
    
    UIImageView *_displayedImageView;
    
    ECPhotoEffectSamplesView *_palette;
    
    PhotoTakerType _takerType;
    
    NSString *_itemId;
    
    BOOL _userSelectPhotoFromAlbum;
    BOOL _needMoveDownComposerSubViews;
    
    BOOL _needSaveToAlbum;
}

@property (nonatomic, retain) UIImagePickerController *imagePicker;
@property (nonatomic, assign) BOOL needSaveToAlbum;

- (id)initWithSourceType:(UIImagePickerControllerSourceType)sourceType
                delegate:(id<ECPhotoPickerOverlayDelegate>)delegate
        uploaderDelegate:(id<ECItemUploaderDelegate>)uploaderDelegate
               takerType:(PhotoTakerType)takerType
                     MOC:(NSManagedObjectContext *)MOC;

- (id)initForServiceUploadPhoto:(NSString *)itemId
                     SourceType:(UIImagePickerControllerSourceType)sourceType
                       delegate:(id<ECPhotoPickerOverlayDelegate>)delegate
               uploaderDelegate:(id<ECItemUploaderDelegate>)uploaderDelegate
                      takerType:(PhotoTakerType)takerType
                            MOC:(NSManagedObjectContext *)MOC;
- (void)arrangeViews;

@end
