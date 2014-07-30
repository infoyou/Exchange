//
//  MyInfoViewController.m
//  Project
//
//  Created by user on 13-10-16.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "MyInfoViewController.h"
#import "CommonHeader.h"
#import "AppManager.h"
#import "GlobalConstants.h"
#import "UIColor+expanded.h"
#import "ProjectAPI.h"
#import "HomepageContainerViewController.h"
#import "WXWAsyncConnectorFacade.h"
#import "JSONParser.h"
#import "TextPool.h"
#import "ImageObject.h"
#import "GoHighDBManager.h"
#import "JSONKit.h"
#import "GlobalConstants.h"
#import "CommonUtils.h"
#import "ChangePWDViewController.h"

@interface MyInfoViewController () <UIWebViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate,
UINavigationControllerDelegate> {
    UIWebView *wView;
    NSMutableDictionary *reqContentDic;
    BOOL reload;
}

@property (nonatomic, retain) UIImage *selectedPhoto;
@property (nonatomic, retain) ImageObject *imageObj;

@end

@implementation MyInfoViewController {
    HomepageContainerViewController *_parentVC;
    int _viewHeight;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(WXWRootViewController *)pVC
       viewHeight:(int)viewHeight{
    
    if (self = [super initWithMOC:MOC]) {
        _parentVC = (HomepageContainerViewController *) pVC;
        _viewHeight= viewHeight;
    }
    
    return self;
}

- (void)dealloc {
    
    [reqContentDic release];
    [super dealloc];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xe5ddd1"];
    self.navigationItem.title = @"个人名片";
    
    [self initData];
    [self showWebView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData {
    
    reqContentDic = [[NSMutableDictionary alloc] init];
    
    [reqContentDic setObject:[AppManager instance].common forKey:KEY_API_COMMON];
    [reqContentDic setObject:[[AppManager instance] specialWithInvokeType:INVOKETYPE_EDITUSERINFO specifieduserID:[[AppManager instance].userId integerValue]] forKey:KEY_API_SPECIAL];
}

- (void)showWebView {
    
    wView = [[UIWebView alloc] initWithFrame:CGRectMake(0, ITEM_BASE_TOP_VIEW_HEIGHT, self.view.frame.size.width, self.view.frame.size.height - ITEM_BASE_TOP_VIEW_HEIGHT - ALONE_MARKETING_TAB_HEIGHT)];
    wView.delegate = self;
    wView.backgroundColor = [UIColor clearColor];
    wView.scalesPageToFit = YES;
    wView.scrollView.showsVerticalScrollIndicator = NO;
    wView.contentMode = UIViewContentModeScaleToFill;
    //    wView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:wView];
    
    [self loadURL:[ProjectAPI loadUserInfoCanEditHTML5VuewWithParam:reqContentDic] webView:wView];
}

- (void)loadURL:(NSString *)url webView:(UIWebView *)wview {
    
    NSURL *requestUrl = [[NSURL alloc] initWithString:url];
    NSURLRequest *request =  [[NSURLRequest alloc] initWithURL:requestUrl];
    [wview loadRequest:request];
    
    [requestUrl release];
    [request release];
}

- (void)showActionSheet {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择照片"
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"照片库", @"拍照", nil];
    [actionSheet showFromRect:self.view.bounds inView:self.view animated:YES];
    [actionSheet release];
}

- (void)loadDataUserProfile
{
    NSMutableDictionary *specialDict = [[NSMutableDictionary alloc]init];
    [specialDict setObject:NUMBER(INVOKETYPE_LOOKUSERINFO) forKey:KEY_API_INVOKETYPE];
    
    [specialDict setObject:VALUE_API_PREFIX forKey:KEY_API_PREFIX];
    [specialDict setObject:VALUE_API_CONTENT forKey:KEY_API_CONTENT];
    [specialDict setObject:[AppManager instance].userId forKey:API_NAME_USER_SPECIFIELD_USER_ID];
    
    [specialDict setObject:[CommonMethod convertLongTimeToString:0] forKey:KEY_API_PARAM_START_TIME];
    
    [specialDict setObject:@"" forKey:KEY_API_PARAM_END_TIME];
    
    NSString *url = [ProjectAPI getRequestURL:API_SERVICE_USER withApiName:API_NAME_USER_PROFILE withCommon:[AppManager instance].common withSpecial:specialDict];
    [specialDict release];
    
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                              contentType:GET_USER_PROFILES];
    
    [connFacade fetchGets:url];
}


#pragma mark - actionsheet delegate

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
        self.selectedPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        [self uploadAvatar];
        
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)uploadAvatar {
    
    _currentType = UPLOAD_IMAGE_TY;
    
    self.connFacade = [[[WXWAsyncConnectorFacade alloc] initWithDelegate:self
                        
                                                  interactionContentType:_currentType] autorelease];
    
    NSDictionary *paramDic = @{@"appId":@"EMBA_UNION", @"moduleId":@"USER_MOD_ID",};
    
    [((WXWAsyncConnectorFacade *)self.connFacade) uploadImage:self.selectedPhoto
                                                          url:@"http://112.124.68.147:5000/UploadImage.aspx"
                                                          dic:paramDic];
    
}

- (void)goChangePWD {
    ChangePWDViewController *vc = [[[ChangePWDViewController alloc] initWithMOC:_MOC] autorelease];
    [CommonMethod pushViewController:vc withAnimated:YES];
}

#pragma mark - webview delegate

//当网页视图被指示载入内容而得到通知。应当返回YES，这样会进行加载。
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *url = [[request URL] absoluteString];
    
    //修改头像
    if ([url hasPrefix:@"http://edithead/?data="]) {
        
        [self showActionSheet];
        
        return NO;
    }
    
    //修改密码
    if ([url hasPrefix:@"http://editpwd/?data="]) {
        [self goChangePWD];
        return NO;
    }
    
    //提交修改
    if ([url hasPrefix:@"http://goapp/?data="]) {
        
        NSString *jsonStr = [CommonMethod decodeURLWithURL:[CommonMethod JSONStringFromURL:url]];
        
        NSDictionary *dic = [CommonMethod dictionaryFromJSONString:jsonStr];
        
        NSDictionary *paramDic = [CommonMethod encapsulationReqContentWithParam:dic withInvokeType:INVOKETYPE_SAVEUSERINFO];
        
        NSString *urlString = [NSString stringWithFormat:@"%@/%@?ReqContent=%@",VALUE_API_PREFIX,KEY_GETUSERLIST_URL,[paramDic JSONString]];
        
        NSString *url = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        // save to server
        _currentType = SAVE_INFO_TO_SERVER;
        
        WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                                  contentType:_currentType];
        [connFacade fetchGets:url];
        
        return NO;
    }
    
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self closeAsyncLoadingView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self closeAsyncLoadingView];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self showAsyncLoadingView:LocaleStringForKey(NSLoadingTitle, nil) blockCurrentView:YES];
}

#pragma mark - ECConnectorDelegate methods
- (void)connectStarted:(NSString *)url
           contentType:(NSInteger)contentType {
    [self showAsyncLoadingView:LocaleStringForKey(NSLoadingTitle, nil) blockCurrentView:YES];
    
    [super connectStarted:url contentType:contentType];
}

- (void)connectDone:(NSData *)result url:(NSString *)url contentType:(NSInteger)contentType {
    
    switch (contentType) {
            
        case SAVE_INFO_TO_SERVER:
        {
            
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            
            if (ret == SUCCESS_CODE) {
                [WXWUIUtils showNotificationOnTopWithMsg:@"保存成功！"
                                                 msgType:SUCCESS_TY
                                      belowNavigationBar:YES];
                
                [self loadDataUserProfile];
            }else {
                [WXWUIUtils showNotificationOnTopWithMsg:@"保存失败！"
                                                 msgType:INFO_TY
                                      belowNavigationBar:YES];
            }

            break;
        }
            
        case UPLOAD_IMAGE_TY:
        {
            self.imageObj = [JSONParser handleImageUploadResponseData:result
                                                    connectorDelegate:self
                                                                  url:url];
            reload = YES;
            //            [self loadURL:[ProjectAPI loadUserInfoCanEditHTML5VuewWithParam:reqContentDic] webView:wView];
            
            NSString *js = [NSString stringWithFormat:@"SearchJS.CallbackBack(\'%@\')",self.imageObj.thumbnailUrl];
            
            [wView stringByEvaluatingJavaScriptFromString:js];
            
            DLog(@"%@",self.imageObj.thumbnailUrl);// self.imageObj.originalUrl
            
            break;
        }
            
        case GET_USER_PROFILES:
        {
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            
            if (ret == SUCCESS_CODE) {
                NSDictionary *resultDic = [result objectFromJSONData];
                
                NSDictionary *contentDic = OBJ_FROM_DIC(resultDic, @"content");
                NSString *timestamp = OBJ_FROM_DIC(resultDic, @"timestamp");
                
                NSDictionary *contentDict = [resultDic objectForKey:@"content"];
                if (contentDict) {
                    NSArray *userListArr = [contentDict objectForKey:@"userList"];
                    
                    if (![userListArr isEqual:[NSNull null]] && userListArr.count) {
                        for (int i = 0; i < userListArr.count; i++) {
                            //        UserProfile *up = [[UserProfile alloc] init];
                            
                            NSDictionary *deltaDic = [userListArr objectAtIndex:i];
                            //        up.userID = [[deltaDic objectForKey:@"userID"] integerValue];
                            DLog(@"%d", [[deltaDic objectForKey:@"userID"] integerValue]);
                            
                            UserProfile *userProfile =[CommonMethod formatUserProfileWithParam:deltaDic];
                            [[AppManager instance].userDM.userProfiles addObject:userProfile];
                            
                            //保存用户到DB
                            [[GoHighDBManager instance] upinsertUserIntoDB:[CommonMethod userBaseInfoWithDictUserProfile:userProfile] timestamp:[timestamp doubleValue]];
                            [[GoHighDBManager instance] upinsertUserProfile:userProfile];
                            
                            NSMutableArray * arr = [[GoHighDBManager instance] getUserPropertiesByUserId:userProfile.userID] ;
                            DLog(@"%d",arr.count);
                        }
                    }
                }
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_USER_NOTIFY
                                                                object:nil
                                                              userInfo:nil];
        break;
    }
            
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
