//
//  CommunicationGroupHeaderViewController.m
//  Project
//
//  Created by XXX on 13-12-5.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "CommunicationGroupHeaderViewController.h"
#import "GlobalConstants.h"
#import "CommonMethod.h"
#import "ImageObject.h"
#import "JSONParser.h"
#import "TextPool.h"
#import "AppManager.h"
#import "ProjectAPI.h"
#import "JSONKit.h"

@interface CommunicationGroupHeaderViewController ()<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation CommunicationGroupHeaderViewController {
    
    ChatGroupDataModal *_dataModal;
    
    UIImageView *_imageView;
    NSString *_downloadFile;
    UIImage * _selectedPhoto;
}

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(WXWRootViewController *)pVC
    withDataModal:(ChatGroupDataModal *)dataModal
{
    
    self = [super initWithMOC:MOC];
    if (self) {
        _dataModal = dataModal;
    }
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"群组图标";
    [self initControl];
    
    
    if (_dataModal.isAdmin )
    [self initNavButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initControl
{
    int imageWidth = _screenSize.width / 2.0f;
    int imageHeight = imageWidth;
    
    int startX = (_screenSize.width - imageWidth) / 2.0f;
    int startY = 40;
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(startX, startY, imageWidth, imageHeight)];
    _imageView.image = IMAGE_WITH_NAME(@"chat_group_cell_default.png");
    _imageView.userInteractionEnabled = YES;
//    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    _imageView.layer.masksToBounds = NO;
    //    //设置阴影的高度
    _imageView.layer.shadowOffset = CGSizeMake(0, 1);
    //设置透明度
    _imageView.layer.shadowOpacity = 0.7;
    _imageView.layer.shadowPath = [UIBezierPath bezierPathWithRect:_imageView.bounds].CGPath;
    
    if (_dataModal.isAdmin )
        [CommonMethod viewAddGuestureRecognizer:_imageView withTarget:self withSEL:@selector(viewTapped:)];
    
    [self downloadFile:_dataModal];
    
    [self.view addSubview:_imageView];
}

-(void)downloadFile:(ChatGroupDataModal *)dataModal
{
    _downloadFile = [CommonMethod getLocalDownloadFileName:dataModal.groupImage withId:[dataModal.groupId stringValue]];
    
    if (_downloadFile)
        [CommonMethod loadImageWithURL:dataModal.groupImage delegateFor:self localName:_downloadFile finished:^{
            [self updateImage];
        }];
}

- (void)updateImage
{
    _imageView.image = [UIImage imageWithContentsOfFile:_downloadFile];
}

#pragma mark -- ASIHttp delegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    [self updateImage];
}

- (void)initNavButton
{
    self.navigationItem.rightBarButtonItem = BAR_BUTTON(@"保存", UIBarButtonItemStyleDone, self, @selector(rightNavButtonClicked:));

    if ([WXWCommonUtils currentOSVersion] >= IOS7) {
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    }
}


- (void)loadUpdateChatGroup:(LoadTriggerType)triggerType forNew:(BOOL)forNew
{
    NSMutableDictionary *specialDict = [[[NSMutableDictionary alloc] init] autorelease];
    
    
    [specialDict setObject:[_dataModal  groupId] forKey:KEY_API_PARAM_GROUP_ID];
    [specialDict setObject:[_dataModal groupName] forKey:KEY_API_PARAM_GROUP_NAME];
    [specialDict setObject:[_dataModal groupImage] forKey:KEY_API_PARAM_GROUP_IMAGE];
    [specialDict setObject:[_dataModal groupDescription] forKey:KEY_API_PARAM_GROUP_DESCRIPTION];
    [specialDict setObject:[_dataModal groupPhone] forKey:KEY_API_PARAM_GROUP_PHONE];
    [specialDict setObject:[_dataModal groupEmail] forKey:KEY_API_PARAM_GROUP_EMAIL];
    [specialDict setObject:[_dataModal groupWebsite] forKey:KEY_API_PARAM_GROUP_WEBSITE];
    [specialDict setObject:[_dataModal invitationPublicLevel] forKey:KEY_API_PARAM_GROUP_INVITATION_PUBLIC_LEVEL];
    
    //------------------------------
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionary];
    
    [requestDict setObject:[AppManager instance].common forKey:@"common"];
    [requestDict setObject:specialDict forKey:@"special"];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",VALUE_API_PREFIX,API_SERVICE_CHAT_GROUP,API_NAME_UPDATE_CHAT_GROUP];
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                              contentType:SUBMIT_UPDATE_CHAT_GROUP_TY];
    
    [connFacade post:url data:[requestDict JSONData]];
}

-(void)rightNavButtonClicked:(id)sender
{
    if (_selectedPhoto)
    [self uploadAvatar:_selectedPhoto];
}

- (void)viewTapped:(UISwipeGestureRecognizer *)recognizer
{
    [self showActionSheet];
}

#pragma mark -- delegate

- (void)showActionSheet {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择照片"
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"照片库", @"拍照", nil];
    [actionSheet showFromRect:self.view.bounds inView:self.view animated:YES];
    [actionSheet release];
}



- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    DLog(@"Action Sheet Button Index: %d",buttonIndex);
    
    if (buttonIndex == 0) {
        //Show Photo Library
        @try {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
                UIImagePickerController *imgPickerVC = [[UIImagePickerController alloc] init];
                [imgPickerVC setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                [imgPickerVC.navigationBar setBarStyle:UIBarStyleBlack];
                [imgPickerVC setDelegate:self];
                [imgPickerVC setAllowsEditing:YES];
                //显示Image Picker
                [self presentModalViewController:imgPickerVC animated:YES];
            }else {
                DLog(@"Album is not available.");
            }
        }
        @catch (NSException *exception) {
            //Error
            DLog(@"Album is not available.");
        }
    }
    if (buttonIndex == 1) {
        //Take Photo with Camera
        @try {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController *cameraVC = [[UIImagePickerController alloc] init];
                [cameraVC setSourceType:UIImagePickerControllerSourceTypeCamera];
                [cameraVC.navigationBar setBarStyle:UIBarStyleBlack];
                [cameraVC setDelegate:self];
                [cameraVC setAllowsEditing:YES];
                //显示Camera VC
                [self presentModalViewController:cameraVC animated:YES];
                
            }else {
                DLog(@"Camera is not available.");
            }
        }
        @catch (NSException *exception) {
            DLog(@"Camera is not available.");
        }
    }
}

#pragma mark - imagepicker delegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    DLog(@"Image Picker Controller canceled.");
    //Cancel以后将ImagePicker删除
    [self dismissModalViewControllerAnimated:YES];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    DLog(@"Image Picker Controller did finish picking media.");
    //TODO:选择照片或者照相完成以后的处理
    
    if ([info objectForKey:@"UIImagePickerControllerEditedImage"]) {
        _selectedPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
//
        _imageView.image = _selectedPhoto;
    }
    
    [self dismissModalViewControllerAnimated:YES];
}


- (void)uploadAvatar:(UIImage *)image {
    
    _currentType = UPLOAD_IMAGE_TY;
    
    self.connFacade = [[[WXWAsyncConnectorFacade alloc] initWithDelegate:self
                        
                                                  interactionContentType:_currentType] autorelease];
    
    NSDictionary *paramDic = @{@"appId":@"EMBA_UNION", @"moduleId":@"USER_MOD_ID",};
    
    [((WXWAsyncConnectorFacade *)self.connFacade) uploadImage:image
                                                          url:@"http://112.124.68.147:5000/UploadImage.aspx"
                                                          dic:paramDic];
    
}


#pragma mark ---

#pragma mark - ECConnectorDelegate methods
- (void)connectStarted:(NSString *)url
           contentType:(NSInteger)contentType {
    [self showAsyncLoadingView:LocaleStringForKey(NSLoadingTitle, nil) blockCurrentView:YES];
    
    [super connectStarted:url contentType:contentType];
}

- (void)connectDone:(NSData *)result url:(NSString *)url contentType:(NSInteger)contentType {
    
    switch (contentType) {
            
        case UPLOAD_IMAGE_TY: {
            ImageObject *imageObj = [JSONParser handleImageUploadResponseData:result
                                                            connectorDelegate:self
                                                                          url:url];
            _dataModal.groupImage = imageObj.middleUrl;
//            _dataModal.groupImage = imageObj.originalUrl;
            
//            [WXWUIUtils showNotificationOnTopWithMsg:@"保存成功！"
//                                             msgType:SUCCESS_TY
//                                  belowNavigationBar:YES];
            
            
            [self loadUpdateChatGroup:TRIGGERED_BY_AUTOLOAD forNew:YES];
            
            break;
        }
            
        case SUBMIT_UPDATE_CHAT_GROUP_TY:
        {
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            if (ret == SUCCESS_CODE) {
                [WXWUIUtils showNotificationOnTopWithMsg:LocaleStringForKey(@"更新成功", nil)
                                                 msgType:INFO_TY
                                      belowNavigationBar:YES];
                
                [self back:nil];
            }
        }
            break;
            
        default:
            break;
    }
    
    [super connectDone:result
                   url:url
           contentType:contentType];
}

- (void)connectCancelled:(NSString *)url
             contentType:(NSInteger)contentType {
    
    [super connectCancelled:url contentType:contentType];
}

- (void)connectFailed:(NSError *)error
                  url:(NSString *)url
          contentType:(NSInteger)contentType {
    
    if ([self connectionMessageIsEmpty:error]) {
        self.connectionErrorMsg = LocaleStringForKey(NSActionFaildMsg, nil);
    }
    
    [super connectFailed:error url:url contentType:contentType];
}

@end
