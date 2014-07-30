//
//  UserSearchViewController.m
//  Project
//
//  Created by user on 13-9-24.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "CommunicationUserSearchViewController.h"
#import "CommunicationSearchResultViewController.h"
#import "JSONKit.h"
#import "AppManager.h"
#import "CommonHeader.h"
#import "UserDataManager.h"
#import "MBProgressHUD.h"
#import "ProjectAPI.h"
#import "TextPool.h"
#import "JSONParser.h"


@interface CommunicationUserSearchViewController ()<UIWebViewDelegate> {
    NSMutableDictionary *reqContentDic;
}

@property (nonatomic, retain) UIWebView *webview;

@end


@implementation CommunicationUserSearchViewController

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(WXWRootViewController *)pVC {
    self = [super initWithMOC:MOC];
    if (self) {
        
    }
    return self;
}

- (void) showProgressWithLabel:(NSString *) label
						  task:(int (^)(MBProgressHUD *)) task
					completion:(void (^)(int)) completion
{
	assert(task);
	MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	hud.labelText = label;
    hud.labelFont = [UIFont systemFontOfSize:14];
	[hud setMargin:10];
    hud.opacity = .8f;
	dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
		int result = task(hud);
		dispatch_async(dispatch_get_main_queue(), ^{
			[MBProgressHUD hideHUDForView:self.view animated:YES];
			if(completion)
				completion(result);
		});
	});
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [_webview release];
    [reqContentDic release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    
    self.navigationItem.title = @"好友搜索";
    self.view.backgroundColor = DEFAULT_VIEW_COLOR;
    
    
    [self initData];
    [self showWebView];
}


- (void)startSearch:(NSDictionary  *)dict
{
    _currentType = GET_USER_SEARCH_TY;
    
    NSMutableDictionary *specialDict = [NSMutableDictionary dictionaryWithDictionary:[dict objectForKey:@"special"]];
    [specialDict setObject:VALUE_API_PREFIX forKey:KEY_API_PREFIX];
    [specialDict setObject:VALUE_API_CONTENT forKey:KEY_API_CONTENT];
    
    
    
    NSDictionary *commonDict = [AppManager instance].common;
    
    
    NSString *url = [ProjectAPI getRequestURL:API_SERVICE_USER withApiName:API_NAME_USER_PROFILE withCommon:commonDict withSpecial:specialDict];
    
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                              contentType:_currentType];
    [connFacade fetchGets:url];
    
}


- (void)initData {
    
    reqContentDic = [[NSMutableDictionary alloc] init];
    
    [reqContentDic setObject:[AppManager instance].common forKey:KEY_API_COMMON];
    [reqContentDic setObject:[[AppManager instance] specialWithInvokeType:INVOKETYPE_SEARCHUSER] forKey:KEY_API_SPECIAL];
}

- (void)showWebView {
    _webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, ITEM_BASE_TOP_VIEW_HEIGHT, self.view.frame.size.width, self.view.frame.size.height - ITEM_BASE_TOP_VIEW_HEIGHT - NAVIGATION_BAR_HEIGHT)];
    _webview.delegate = self;
    _webview.backgroundColor = [UIColor clearColor];
    _webview.scalesPageToFit = YES;
    self.webview.contentMode = UIViewContentModeScaleToFill;
//    self.webview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _webview.scrollView.showsVerticalScrollIndicator = NO;
    self.webview.contentMode = UIViewContentModeScaleToFill;
//    self.webview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_webview];
    
    [self loadURL:[ProjectAPI loadUserSearchHTML5ViewWithParam:reqContentDic] webView:_webview];
    
}

-(void)showEmptyBackground
{
    int width = self.view.frame.size.width * 1 / 2.0;
    int startY =   _screenSize.height > 480 ?(self.view.frame.size.height - width) / 2  - 80: (self.view.frame.size.height - width) / 2 - width / 4.0f;
    
//    UIImage *image = ImageWithName(@"gohigh_empty_background.png");
//    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    CGRect drawRect = CGRectMake((self.view.frame.size.width - width) / 2.0f, startY, width,width);
    
//    image = [CommonMethod drawImageToRect:image withImageRect:drawRect withMaskImage:[CommonMethod createImageWithColor:[UIColor whiteColor]] withMaskImageRect:rect withRegionRect:rect];
    
//    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    UIImageView *imageView = [[[UIImageView alloc] initWithFrame:drawRect] autorelease];
    imageView.image = IMAGE_WITH_IMAGE_NAME(@"gohigh_empty_background.png");
    
    [self.view addSubview:imageView];
    
       UILabel * noContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, startY + width / 2 + 20, self.view.frame.size.width, 30)];
        noContentLabel.font = FONT_SYSTEM_SIZE(15);
        noContentLabel.textAlignment = UITextAlignmentCenter;
        noContentLabel.textColor= [UIColor colorWithHexString:@"0x676767"];
        noContentLabel.text = @"未能连接到服务器";
        [noContentLabel setHidden:NO];
        [self.view addSubview:noContentLabel];
    
    [noContentLabel release];
    
}

- (void)loadURL:(NSString *)url webView:(UIWebView *)wview {
    NSURL *requestUrl = [[NSURL alloc] initWithString:url];
    NSURLRequest *request =  [[NSURLRequest alloc] initWithURL:requestUrl];
    [wview loadRequest:request];
    
    [requestUrl release];
    [request release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - show search result method

- (void)showSearchResult {
    CommunicationSearchResultViewController *searchResultController = [[[CommunicationSearchResultViewController alloc] init] autorelease];
    //    [CommonMethod popViewController:self];
    [CommonMethod pushViewController:searchResultController withAnimated:YES];
}

#pragma mark - search action

- (void)doSearchWithDescribe:(NSString *)des withParam:(NSMutableDictionary *)dic{
    
    [self showProgressWithLabel:des task:^int(MBProgressHUD *hud){
        
        return [self searchWithParam:dic];
        
    } completion:^(int result) {
        if (result) {
            [self showSearchResult];
            DLog(@"userprofiles: %@",[UserDataManager defaultManager].userProfiles);
        }
    }];
}

- (BOOL)searchWithParam:(NSMutableDictionary *)dict {
    
#if 0
    NSMutableDictionary *specialDict = [NSMutableDictionary dictionaryWithDictionary:[dict objectForKey:@"special"]];
    
    [specialDict setValue:VALUE_API_PREFIX forKey:KEY_API_PREFIX];
    [specialDict setValue:VALUE_API_CONTENT forKey:KEY_API_CONTENT];
    
    NSArray *userInfoArr = [APIInfo getUserServiceForUserList:API_NAME_USER_PROFILE withSpecial:specialDict];
    //    NSArray *userInfoArr = [APIInfo getUserListWithParam:dict];
    
    if (userInfoArr) {
        [UserDataManager defaultManager].userProfiles  = [CommonMethod userProfileWithArray:userInfoArr];
        DLog(@"userinfo:%@ %d",userInfoArr, userInfoArr.count);
        
        return YES;
    }else {
        return NO;
    }
#else 
    return NO;
#endif
}

#pragma mark - webview delegate

//当网页视图被指示载入内容而得到通知。应当返回YES，这样会进行加载。
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    //    NSLog(@"webview shouldStartLoadWithRequest:%@",request);
    
    NSString *url = [[request URL] absoluteString];
    
    if ([url hasPrefix:@"http://goapp/?data="]) {
        
        //        NSString *jsonStr = [[url componentsSeparatedByString:@"="] lastObject];
        
        NSString *jsonStr = [CommonMethod decodeURLWithURL:[CommonMethod JSONStringFromURL:url]];
        
        NSDictionary *dic = [CommonMethod dictionaryFromJSONString:jsonStr];
        
        //        NSMutableDictionary *responseDic = [dic objectForKey:@"ReqContent"];
        
//        [self doSearchWithDescribe:@"搜索中..." withParam:[CommonMethod encapsulationReqContentWithParam:dic]];
        
        [self startSearch:[CommonMethod encapsulationReqContentWithParam:dic]];
        
        //        [dic release];
        return NO;
    }
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [_webview setHidden:YES];
    [self showEmptyBackground];
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
            
        case GET_USER_SEARCH_TY:
        {
            
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            
            if (ret == SUCCESS_CODE) {
                NSDictionary *resultDic = [result objectFromJSONData];
                NSDictionary *contentDict = [resultDic objectForKey:@"content"];
                
                if (contentDict) {
                    NSArray *userList = [contentDict objectForKey:@"userList"];
                    
                    [UserDataManager defaultManager].userProfiles  =[NSMutableArray arrayWithArray: [CommonMethod userProfilesFromUserList:userList]];
                    
                    [self showSearchResult];
                }

            }
            
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
