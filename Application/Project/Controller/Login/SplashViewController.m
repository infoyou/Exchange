//
//  SplashViewController.m
//  Project
//
//  Created by XXX on 13-2-2.
//
//

#import "SplashViewController.h"
#import "WXWCommonUtils.h"
#import "UIViewController+SharedObject.h"
#import "ProjectAPI.h"
#import "AppManager.h"
#import "TextPool.h"
#import "JSONParser.h"
#import "JSONKit.h"
#import "CommonMethod.h"
#import "UIDevice+Hardware.h"
#import "CommonUtils.h"

@interface SplashViewController ()

@end

@implementation SplashViewController

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
    
    self.navigationController.navigationBarHidden = YES;
    
    UIImage *image = nil;
    NSString *model = [WXWCommonUtils deviceModel];
    
    if([CommonUtils screenHeightIs4Inch])
    {
        image = [UIImage imageNamed:@"Default-568h.png"];
    } else  {
        image = [UIImage imageNamed:@"Default.png"];
    }
    
    self.view.backgroundColor = [UIColor blackColor];
    
    CGRect imageFrame = CGRectZero;
    
    if ([CommonMethod is7System]) {
        imageFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }else {
        imageFrame = CGRectMake(0, -20.0f, self.view.frame.size.width, self.view.frame.size.height + 20);
    }
    
    UIImageView *startUpImageView = [[[UIImageView alloc] initWithFrame:imageFrame] autorelease];
    startUpImageView.backgroundColor = [UIColor blackColor];
    startUpImageView.image = image;
    
    [self.view addSubview:startUpImageView];
    
    startUpImageView.alpha = 0.0f;
    [UIView animateWithDuration:2 animations:^{
        
        startUpImageView.alpha = 1.0f;
    } completion:^(BOOL finished){ }];

    
    [self startSplash];
    
//    [self loadData];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    sleep(2);
    
    if ([IPHONE_SIMULATOR isEqualToString:[WXWCommonUtils deviceModel]]) {
        
    if (self.delegate && [self.delegate respondsToSelector:@selector(endSplash:)]) {
        [self.delegate endSplash:self];
    }
    }
}

- (void)loadData
{
    NSMutableDictionary *specialDict = [[NSMutableDictionary alloc]init];
    [specialDict setObject:NUMBER(INVOKETYPE_ALLUSERINFO) forKey:KEY_API_INVOKETYPE];
    
    [specialDict setObject:VALUE_API_PREFIX forKey:KEY_API_PREFIX];
    [specialDict setObject:VALUE_API_CONTENT forKey:KEY_API_CONTENT];
    
    NSString *url = [ProjectAPI getRequestURL:API_SERVICE_USER withApiName:API_NAME_USER_PROFILE withCommon:[AppManager instance].common withSpecial:specialDict];
    [specialDict release];
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                              contentType:GET_USER_PROFILES];
    [connFacade fetchGets:url];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startSplash
{
#if 0
    [self showProgressWithLabel:LocaleStringForKey(NSSplashLoadNessesaryResource, nil) task:^int(MBProgressHUD * hud) {
        sleep(2);
        return 1;
    } completion:^(int result) {
        if (result) {
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(endSplash:)]) {
                [self.delegate endSplash:self];
            }
        }
    }];
#elif 1

    
#endif
}



#pragma mark - ECConnectorDelegate methods
- (void)connectStarted:(NSString *)url
           contentType:(NSInteger)contentType {
    [self showAsyncLoadingView:LocaleStringForKey(NSLoadingTitle, nil) blockCurrentView:YES];
    
    [super connectStarted:url contentType:contentType];
}

- (void)connectDone:(NSData *)result url:(NSString *)url contentType:(NSInteger)contentType {
    
    switch (contentType) {
            
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
                
                NSDictionary *contentDict = [resultDic objectForKey:@"content"];
                if (contentDict) {
                    NSArray *userListArr = [contentDict objectForKey:@"userList"];
                    
                    
                    if (![userListArr isEqual:[NSNull null]] && userListArr.count) {
                        for (int i = 0; i < userListArr.count; i++) {
                            //        UserProfile *up = [[UserProfile alloc] init];
                            
                            NSDictionary *deltaDic = [userListArr objectAtIndex:i];
                            //        up.userID = [[deltaDic objectForKey:@"userID"] integerValue];
                            DLog(@"%d", [[deltaDic objectForKey:@"userID"] integerValue]);
                            [[AppManager instance].userDM.userProfiles addObject:[CommonMethod formatUserProfileWithParam:deltaDic]];
                        }
                    }
                    
                }
             }
            
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(endSplash:)]) {
                [self.delegate endSplash:self];
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
