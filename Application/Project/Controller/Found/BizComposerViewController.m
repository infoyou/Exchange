//
//  BizComposerViewController.m
//  Project
//
//  Created by XXX on 13-12-25.
//
//

#import "BizComposerViewController.h"
#import "BizPostHeaderTagView.h"
#import "WXWCommonUtils.h"
#import "ECPhotoPickerOverlayViewController.h"
#import "ECItemUploaderDelegate.h"
#import "PhotoFetcherView.h"
#import "AppManager.h"
#import "WXWAsyncConnectorFacade.h"
#import "XMLParser.h"
#import "UIUtils.h"
#import "CommonUtils.h"
#import "TagSelectionView.h"
#import "Tag.h"
#import "WXWLabel.h"
#import "TextPool.h"
#import "Post.h"
#import "ImageObject.h"
#import "JSONParser.h"

#define TEXT_COMPOSER_35INCH_HEIGHT		(200-KEYBOARD_GAP)
#define TEXT_COMPOSER_40INCH_HEIGHT		TEXT_COMPOSER_35INCH_HEIGHT + 88.0f

#define TEXT_EDITOR_HEIGHT            239.0f

@interface BizComposerViewController ()
@property (nonatomic, retain) Post *post;
@property (nonatomic, retain) ECPhotoPickerOverlayViewController *pickerOverlayVC;
@property (nonatomic, retain) id<ECItemUploaderDelegate> uploaderDelegate;
@property (nonatomic, retain) UIImage *selectedPhoto;
@property (nonatomic, copy) NSMutableString *selectedTagIds;
@property (nonatomic, retain) ImageObject *imageObj;
@end

@implementation BizComposerViewController

#pragma mark - user actions
- (void)doClose {
    [self cancelConnection];
    [self cancelLocation];
    
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)close:(id)sender {
    
    _actionSheetOwnerType = CLOSE_BTN;
    
    if (_textEditorView.content.length > 0 || self.selectedPhoto) {
        
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

- (void)parserSelectedTags {
    
    NSArray *tags = [WXWCoreDataUtils fetchObjectsFromMOC:_MOC
                                               entityName:@"Tag"
                                                predicate:nil];
    
    NSMutableString *ids = [NSMutableString string];
    NSInteger i = 0;
    
    for (Tag *tag in tags) {
        if (tag.selected.boolValue) {
            
            if (i == 0) {
//                NSMutableString *tagId = [NSMutableString stringWithFormat:@"%@", tag.tagId];
                NSMutableString *tagId = [NSMutableString stringWithFormat:@"%@", tag.tagName];
                [ids appendString:tagId];
            } else {
//                NSMutableString *tagId = [NSMutableString stringWithFormat:@",%@", tag.tagId];
                NSMutableString *tagId = [NSMutableString stringWithFormat:@",%@", tag.tagName];
                [ids appendString:tagId];
            }
            i++;
        }
    }
    
    self.selectedTagIds = ids;
}

- (void)confirmSelectedTags {
    
    NSArray *selectedTags = [WXWCoreDataUtils fetchObjectsFromMOC:_MOC
                                                       entityName:@"Tag"
                                                        predicate:SELECTED_PREDICATE];
    
    if (selectedTags.count > 0) {
        [_textEditorView arrangeSelectedTags:selectedTags];
    }
}

- (void)send:(id)sender {
    
    if (_textEditorView.itemType == 0) {
        ShowAlert(nil, nil, LocaleStringForKey(NSSelectSupplyDemandTypeMsg, nil), LocaleStringForKey(NSIKnowTitle, nil));
        return;
    }
    
    if (_textEditorView.content.length == 0) {
        
        ShowAlert(nil, nil, LocaleStringForKey(NSSupplyDemandContentEmptyMsg, nil), LocaleStringForKey(NSIKnowTitle, nil));
        return;
    }
    
    [self parserSelectedTags];
    
    if (self.selectedTagIds.length == 0) {
        ShowAlert(nil, nil, LocaleStringForKey(NSSupplyDemandTagsEmptyMsg, nil), LocaleStringForKey(NSIKnowTitle, nil));
        return;
    }
    
    if (self.selectedPhoto == nil) {
        [self sendPost];
    } else {
        [self uploadPhoto];
    }
    
}

#pragma mark - upload

- (void)uploadPhoto {
    _currentType = UPLOAD_IMAGE_TY;
    
    NSString *url = IMAGE_UPLOAD_URL;
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                              contentType:_currentType];
    
    NSDictionary *paramDic = @{
                               @"appId":APP_ID,
                               @"moduleId":POST_MOD_ID
                               };
    [connFacade uploadImage:self.selectedPhoto
                                                         url:url
                                                         dic:paramDic];
}

- (void)sendPost
{
    _currentType = SEND_SUPPLY_DEMAND_TY;
    
    NSString *url = [NSString stringWithFormat:@"%@%@", @"http://180.153.154.21:9007/" /*[AppManager instance].hostUrl */, GROUP_SUBUMIT_POST_URL];
    
    NSString *postId = @"";
    if (self.post != nil) {
        postId = self.post.postId;
    }
    
    NSDictionary *paramDic = nil;
    paramDic = @{@"groupId":  [AppManager instance].supplyDemandGroupId,
                 @"message":  _textEditorView.content,
                 @"imageUrl": self.imageObj.originalUrl==nil ? @"" : self.imageObj.originalUrl,
                 @"thumbnailImageUrl": self.imageObj.thumbnailUrl==nil ? @"" : self.imageObj.thumbnailUrl,
                 @"middleImageUrl":self.imageObj.middleUrl==nil ? @"" : self.imageObj.middleUrl,
                 @"thumbnailWidth": [NSString stringWithFormat:@"%f", self.imageObj.thumbnailWidth],
                 @"thumbnailHeight": [NSString stringWithFormat:@"%f", self.imageObj.thumbnailHeight],
                 @"middleImageWidth":[NSString stringWithFormat:@"%f", self.imageObj.middleSizeWidth],
                 @"middleImageHeight": [NSString stringWithFormat:@"%f", self.imageObj.middleSizeHeight],
                 @"originalImageWidth": [NSString stringWithFormat:@"%f", self.imageObj.originalSizeWidth],
                 @"originalImageHeight": [NSString stringWithFormat:@"%f", self.imageObj.originalSizeHeight],
                 @"longitude": @"",
                 @"latitude": @"",
                 @"postType": @(_textEditorView.itemType),
                 @"itemId": @"",
                 @"tages": self.selectedTagIds,
                 @"postId": postId,
                 };
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                              contentType:_currentType];
    [connFacade postCommonInfoDic:paramDic url:url];
}


#pragma mark - load data
- (void)loadTags {
    
    _currentType = SUPPLY_DEMAND_TAG_TY;
    
    NSString *url = @"http://alumniapp.ceibs.edu:8080/ceibs_test/phone_controller?action=post_tag_list_v2&ReqContent=<?xml version=\"1.0\" encoding=\"UTF-8\"?><content><locale>zh</locale><plat>iPhone</plat><channel>2</channel><system>7.0</system><version>1.6.1</version><device_token></device_token><user_id>qronghao.e08sh2</user_id><user_name>邱荣浩</user_name><person_id>210437</person_id><user_type>1</user_type><session_id>2013122513413551849</session_id><class_id>EMBA08SH2</class_id><class_name>EMBA08SH2</class_name><connect_id>25e9ac57111f0f06160613f8801a03a1</connect_id></content>";
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url contentType:SUPPLY_DEMAND_TAG_TY];
    [connFacade asyncGet:url showAlertMsg:YES];
    
}

#pragma mark - lifecycle methods
 - (void)registerKeyboardNotifications {
 
 [[NSNotificationCenter defaultCenter] addObserver:self
 selector:@selector(keyboardWasShown:)
 name:UIKeyboardDidShowNotification
 object:nil];
 }
 
 - (void)deregisterKeyboardNotifications {
 [[NSNotificationCenter defaultCenter] removeObserver:self
 name:UIKeyboardDidShowNotification
 object:nil];
 }

- (id)initWithMOC:(NSManagedObjectContext *)MOC
   uploadDelegate:(id<ECItemUploaderDelegate>)uploadDelegate
             post:(Post *)post {
    
    self = [super initWithMOC:MOC];
    
    if (self) {
        self.post = post;
        self.uploaderDelegate = uploadDelegate;
        [self registerKeyboardNotifications];
    }
    return self;
}

- (id)initWithMOC:(NSManagedObjectContext *)MOC
   uploadDelegate:(id<ECItemUploaderDelegate>)uploadDelegate {
    
    self = [super initWithMOC:MOC];
    
    if (self) {
        self.uploaderDelegate = uploadDelegate;
        [self registerKeyboardNotifications];
    }
    return self;
}

- (void)dealloc {
    
    [self deregisterKeyboardNotifications];
    
    self.pickerOverlayVC = nil;
    
    self.selectedPhoto = nil;
    
    self.uploaderDelegate = nil;
    
    self.selectedTagIds = nil;
    
    [super dealloc];
}

- (void)initTextEditor {
    _textEditorView = [[[SupplyDemandTextEditorView alloc] initWithFrame:CGRectMake(MARGIN * 3, MARGIN * 3, self.view.frame.size.width - MARGIN * 6, TEXT_EDITOR_HEIGHT)
                                                                     MOC:_MOC
                                                          editorDelegate:self] autorelease];
    [self.view addSubview:_textEditorView];
}

- (void)initPhotoView {
    
    CGFloat textEditorBottomY = _textEditorView.frame.origin.y + _textEditorView.frame.size.height;
    
    CGFloat photoHeight = self.view.frame.size.height - NAVIGATION_BAR_HEIGHT - textEditorBottomY - MARGIN * 6;
    if (CURRENT_OS_VERSION >= IOS7) {
        photoHeight -= MARGIN * 3;
    }
    
    _selectPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectPhotoButton.frame = CGRectMake(MARGIN * 3, textEditorBottomY + MARGIN * 3, self.view.frame.size.width - MARGIN * 6, photoHeight);
    [_selectPhotoButton addTarget:self
                           action:@selector(editPhoto:)
                 forControlEvents:UIControlEventTouchUpInside];
    _selectPhotoButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    _selectPhotoButton.titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    _selectPhotoButton.backgroundColor = COLOR(152, 152, 152);
    [_selectPhotoButton setTitleColor:COLOR(68, 68, 68) forState:UIControlStateNormal];
    _selectPhotoButton.titleLabel.font = BOLD_FONT(18);
    
    [_selectPhotoButton setImage:IMAGE_WITH_NAME(@"selectPhoto.png") forState:UIControlStateNormal];
    [_selectPhotoButton setTitle:LocaleStringForKey(NSAddPhotoTitle, nil) forState:UIControlStateNormal];
    
    _selectPhotoButton.imageEdgeInsets = UIEdgeInsetsMake(-20, 80, 0, 0);
    _selectPhotoButton.titleEdgeInsets = UIEdgeInsetsMake(65, -60, 0, 0);
    
    [self.view addSubview:_selectPhotoButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addLeftBarButtonWithTitle:LocaleStringForKey(NSCloseTitle, nil)
                             target:self
                             action:@selector(close:)];
    
    [self addRightBarButtonWithTitle:LocaleStringForKey(NSPublishTitle, nil)
                              target:self
                              action:@selector(send:)];
    
    [self initTextEditor];
    
    [self initPhotoView];
}

- (void)viewWillAppear:(BOOL)animated {
 [super viewWillAppear:animated];
 
     if (!_tagLoaded) {
     [self loadTags];
     }
 }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - photo add/remove

- (void)showImagePicker:(BOOL)hasCamera {
    _photoSourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if (hasCamera) {
        _photoSourceType = UIImagePickerControllerSourceTypeCamera;
    }
    
    self.pickerOverlayVC = [[[ECPhotoPickerOverlayViewController alloc] initWithSourceType:_photoSourceType
                                                                                  delegate:self
                                                                          uploaderDelegate:self.uploaderDelegate
                                                                                 takerType:POST_COMPOSER_TY
                                                                                       MOC:_MOC] autorelease];
    
    [self.pickerOverlayVC arrangeViews];
    
    [self presentModalViewController:self.pickerOverlayVC.imagePicker animated:YES];
}

- (void)showImagePicker {
    
    _photoSourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if (HAS_CAMERA) {
        _photoSourceType = UIImagePickerControllerSourceTypeCamera;
    }
    
    self.pickerOverlayVC = [[[ECPhotoPickerOverlayViewController alloc] initWithSourceType:_photoSourceType
                                                                                  delegate:self
                                                                          uploaderDelegate:self.uploaderDelegate
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
    if ([_textEditorView.content length] > 0 || self.selectedPhoto) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

- (void)applyPhotoSelectedStatus:(UIImage *)image {
	self.selectedPhoto = image;
    
    [self applySelectedPhoto:image];
}

- (void)saveImageIfNecessary:(UIImage *)image
                  sourceType:(UIImagePickerControllerSourceType)sourceType {
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        
		UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
	}
}

- (void)handleFinishPickImage:(UIImage *)image
                   sourceType:(UIImagePickerControllerSourceType)sourceType {
    UIImage *handledImage = [WXWCommonUtils scaleAndRotateImage:image sourceType:sourceType];
	
    [self saveImageIfNecessary:handledImage sourceType:sourceType];
	
	[self applyPhotoSelectedStatus:handledImage];
}

#pragma mark - SupplyDemandTextEditorProtocal methods
- (void)setItemType:(SupplyDemandItemType)itemType {
    
}

- (void)displayTagList {
    NSArray *tags = [WXWCoreDataUtils fetchObjectsFromMOC:_MOC
                                               entityName:@"Tag"
                                                predicate:nil];
    
    TagSelectionView *tagSelectionView = [[[TagSelectionView alloc] initWithFrame:CGRectMake(0, 0,
                                                                                             self.view.frame.size.width,
                                                                                             self.view.frame.size.height)
                                                                             tags:tags
                                                                              MOC:_MOC
                                                                      tagSelector:self
                                                                    confirmAction:@selector(confirmSelectedTags)] autorelease];
    [self.view addSubview:tagSelectionView];
}

- (void)openTags:(id)sender {
    
    if (_tagLoading) {
        [UIUtils showNotificationOnTopWithMsg:LocaleStringForKey(NSFetchingTagMsg, nil)
                                      msgType:INFO_TY
                           belowNavigationBar:YES];
        return;
    }
    
    [self displayTagList];
   
}

- (void)editPhoto:(id)sender {
    
    [_textEditorView hideKeyboard];
    
    [self addOrRemovePhoto];
}

#pragma mark - handle for edit photo
- (void)applySelectedPhoto:(UIImage *)image {
    
    if (image == nil) {
        
        [_selectPhotoButton setImage:IMAGE_WITH_NAME(@"selectPhoto.png") forState:UIControlStateNormal];
        [_selectPhotoButton setTitle:LocaleStringForKey(NSAddPhotoTitle, nil) forState:UIControlStateNormal];
        
        _selectPhotoButton.imageEdgeInsets = UIEdgeInsetsMake(-20, 80, 0, 0);
        
        _selectPhotoButton.backgroundColor = COLOR(152, 152, 152);
        
    } else {
        UIImage *resizedImage = [CommonUtils cutMiddlePartImage:image
                                                          width:_selectPhotoButton.frame.size.width
                                                         height:_selectPhotoButton.frame.size.height];
        [_selectPhotoButton setImage:resizedImage forState:UIControlStateNormal];
        [_selectPhotoButton setTitle:nil forState:UIControlStateNormal];
        
        _selectPhotoButton.imageEdgeInsets = ZERO_EDGE;
        
        _selectPhotoButton.backgroundColor = TRANSPARENT_COLOR;
    }
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
                [self applySelectedPhoto:nil];
				return;
			} else {
                [self showImagePicker];
            }
            
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
        if (_needMoveDown20px) {
            areaHeight -= SYS_STATUS_BAR_HEIGHT;
        }
    }
    return areaHeight;
}

 - (void)keyboardHeightChanged:(NSNotification*)notification {
// [_textEditorView arrangeLayoutForKeyboardChange:[self calcNoKeyboardAreaHeight:notification]];
 }
 
 - (void)keyboardWasShown:(NSNotification *)notification {
// [_textEditorView arrangeLayoutForKeyboardChange:[self calcNoKeyboardAreaHeight:notification]];
 }

#pragma mark - ECEditorDelegate methods
- (void)textChanged:(NSString *)text {
}

#pragma mark - ECConnectorDelegate methods
- (void)connectStarted:(NSString *)url contentType:(NSInteger)contentType {
    
    switch (contentType) {
        case SEND_SUPPLY_DEMAND_TY:
            [UIUtils showAsyncLoadingView:LocaleStringForKey(NSSendingTitle, nil)
                          toBeBlockedView:NO];
            
            [self doClose];
            break;
            
        case SUPPLY_DEMAND_TAG_TY:
            _tagLoading = YES;
            [super connectStarted:url contentType:contentType];
            break;
            
        default:
            break;
    }
}

- (void)connectCancelled:(NSString *)url contentType:(NSInteger)contentType {
    
    [super connectCancelled:url contentType:contentType];
}

- (void)connectDone:(NSData *)result url:(NSString *)url contentType:(NSInteger)contentType {
    
    switch (contentType) {
        case UPLOAD_IMAGE_TY:
        {
            self.imageObj = [JSONParser handleImageUploadResponseData:result
                                                    connectorDelegate:self
                                                                  url:url];
            
            if (self.imageObj.originalUrl.length > 0) {
                [self sendPost];
            } else {
                [WXWUIUtils showNotificationOnTopWithMsg:self.errorMsgDic[url]
                                                 msgType:ERROR_TY
                                      belowNavigationBar:YES];
            }
            break;
        }
            
        case SUPPLY_DEMAND_TAG_TY:
        {
            if ([XMLParser parserResponseXml:result
                                        type:contentType
                                         MOC:_MOC
                           connectorDelegate:self
                                         url:url]) {
                
                _tagLoaded = YES;
                _tagLoading = NO;
                
                if (_tryToOpenTagList) {
                    [self displayTagList];
                }
                [_textEditorView stopSpin];
            }
            break;
        }
            
        case SEND_SUPPLY_DEMAND_TY:
        {
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            
            if (ret == SUCCESS_CODE) {
                
                if (self.uploaderDelegate) {
                    [self.uploaderDelegate afterUploadFinishAction:contentType];
                }
                
                [UIUtils showNotificationOnTopWithMsg:LocaleStringForKey(NSSendFeedDoneMsg, nil)
                                              msgType:SUCCESS_TY
                                   belowNavigationBar:YES];
                [AppManager instance].supplyDemandType = @(_textEditorView.itemType);
                [AppManager instance].supplyDemandMsg = _textEditorView.content;
            } else {
                [UIUtils showNotificationOnTopWithMsg:(self.errorMsgDic)[url]
                                       alternativeMsg:LocaleStringForKey(NSActionFaildMsg, nil)
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
        case SEND_SUPPLY_DEMAND_TY:
            msg = LocaleStringForKey(NSSendFeedFailedMsg, nil);
            break;
            
        case SUPPLY_DEMAND_TAG_TY:
            _tagLoading = NO;
            break;
            
        default:
            break;
    }
    
    if ([self connectionMessageIsEmpty:error]) {
        self.connectionErrorMsg = msg;
    }
    
    [UIUtils closeAsyncLoadingView];
    [super connectFailed:error url:url contentType:contentType];
}


@end
