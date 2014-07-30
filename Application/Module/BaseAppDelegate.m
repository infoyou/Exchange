//
//  BaseAppDelegate.m
//  Product
//
//  Created by XXX on 13-10-15.
//  Copyright (c) 2013年 _CompanyName_. All rights reserved.
//

#import "BaseAppDelegate.h"
#import "HomepageContainerViewController.h"
#import "WXWNavigationController.h"
#import <CrashReporter/CrashReporter.h>
#import "WXWDebugLogOutput.h"
#import "UIDevice+Hardware.h"
#import "WXWDBConnection.h"
#import "SplashViewController.h"
#import "DataProvider.h"
#import "WXWImageManager.h"
#import "LoginViewController.h"
#import "CommonUtils.h"
#import "FileUtils.h"
#import "AppManager.h"
#import "ProjectAPI.h"
#import "iChatInstance.h"
#import "GlobalConstants.h"
#import "WXApi.h"
#import "MobClick.h"
#import "LogUploader.h"
#import "GoHighDBManager.h"
#import "PushNotifyServer.h"

#import "Reachability.h"

NSString *const UIApplicationDidReceivedRomateNotificationNotification = @"UIApplicationDidReceivedRomateNotificationNotification";

@interface BaseAppDelegate () <SplashViewControllerDelegate,
UserLoginViewControllerDelegate,WXApiDelegate>
@property (nonatomic, retain) WXWNavigationController *homepageContainerNav;
@property (nonatomic, retain) SplashViewController *splashVC;
@property (nonatomic, assign) LoginViewController *userLoginVC;
@property (nonatomic, retain) WXWNavigationController *splashNav;

@property (nonatomic, retain) WXWNavigationController *loginNav;
@property (nonatomic, assign) BOOL isEndsplahsed;
@end

@implementation BaseAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

@synthesize loginNav = _loginNav;
@synthesize userLoginVC= _userLoginVC;
@synthesize wxApiDelegate;

#pragma mark - properties

- (SplashViewController *)splashVC {
    if (nil == _splashVC) {
        _splashVC = [[[SplashViewController alloc] init] autorelease];
        _splashVC.delegate = self;
//        [self.window addSubview:_splashVC.view];
//        [self.window bringSubviewToFront:_splashVC.view];
    }
    return _splashVC;
}

- (WXWNavigationController *)splashNav {
    if (nil == _splashNav) {
        _splashNav = [[WXWNavigationController alloc] initWithRootViewController:self.splashVC];
    }
    return _splashNav;
}

- (HomepageContainerViewController *)homepageContainer {
    if (nil == _homepageContainer) {
        _homepageContainer = [[HomepageContainerViewController alloc] initHomepageWithMOC:self.managedObjectContext];
    }
    return _homepageContainer;
}

- (WXWNavigationController *)homepageContainerNav {
    if (nil == _homepageContainerNav) {
        _homepageContainerNav = [[WXWNavigationController alloc] initWithRootViewController:self.homepageContainer];
    }
    return _homepageContainerNav;
}

#pragma mark - prepare app

//- (void)prepareCrashReporter {
//    
//    // Enable the Crash Reporter
//    NSError *error;
//	if (![[PLCrashReporter sharedReporter] enableCrashReporterAndReturnError: &error]) {
//		debugLog(@"Warning: Could not enable crash reporter: %@", error);
//    }
//}

- (void)applyCurrentLanguage {
    [WXWSystemInfoManager instance].currentLanguageCode = [WXWCommonUtils fetchIntegerValueFromLocal:SYSTEM_LANGUAGE_LOCAL_KEY];
    
    if ([WXWSystemInfoManager instance].currentLanguageCode == NO_TY) {
        [WXWCommonUtils getLocalLanguage];
    }else {
        [WXWCommonUtils getDBLanguage];
    }
}

- (void)prepareDB {
    [WXWDBConnection prepareBizDB];
}

- (void)prepareApp {
    [self prepareCrashReporter];
    
    [self loadNessesaryResource];
    
    _startup = YES;
    
    if (![IPHONE_SIMULATOR isEqualToString:[WXWCommonUtils deviceModel]]) {
        [self registerNotify];
    }
    
    [AppManager instance].deviceToken = @"";
    
    [self applyCurrentLanguage];
    
    [DataProvider instance].MOC = self.managedObjectContext;
    
    // register call back method for MOC save notification
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:sel_registerName("handleSaveNotification:")
                                                 name:NSManagedObjectContextDidSaveNotification
                                               object:self.managedObjectContext];
    
    [self prepareDB];
    
    // register app to WeChat
    [WXApi registerApp:WX_API_KEY];
    
    // get Device System
    [WXWCommonUtils parserDeviceSystemInfo];
}

- (void)arrangeSolidColorNavigationBar {
    if([UINavigationBar respondsToSelector:@selector(appearance)]){
        
        if ([CommonMethod is7System]) {
            UIImage *image = [UIImage imageNamed:@"gohigh_nav_top_background_blue"];
            [[UINavigationBar appearance] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            self.window.tintColor = [UIColor colorWithHexString:STYLE_NAVIGATIONBAR_COLOR];
        }else {
            UIImage *image = [UIImage imageNamed:@"nav_top_background_blue"];
            [[UINavigationBar appearance] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
        }
        
    }
    
//    if (CURRENT_OS_VERSION >= IOS7)
    {
        NSDictionary *textTitleOptions = @{UITextAttributeTextColor : [UIColor colorWithHexString:@"0x333333"],
                                           UITextAttributeTextShadowColor : TRANSPARENT_COLOR, UITextAttributeFont:FONT_SYSTEM_SIZE(18)};
        [UINavigationBar appearance].titleTextAttributes = textTitleOptions;
    }
}

#pragma mark - view navigation
- (void)switchViews:(WXWNavigationController *)toBeDisplayedNav {
    
    CATransition *viewFadein = [CATransition animation];
    viewFadein.duration = 0.3f;
    viewFadein.type = kCATransitionFade;
    
    [self.window.layer addAnimation:viewFadein forKey:nil];
    
    if (_premiereNav) {
        _premiereNav.view.hidden = YES;
        [_premiereNav.view removeFromSuperview];
    }
    
    toBeDisplayedNav.view.hidden = NO;
    
//    [self.window addSubview:toBeDisplayedNav.view];
    [self.window setRootViewController:toBeDisplayedNav];
//    [self.window bringSubviewToFront:toBeDisplayedNav.view];
//    [_userLoginVC.view setHidden:YES];
    
    _premiereNav = toBeDisplayedNav;
}

- (void)clearHomepageViewController {
    
    [self.homepageContainer cancelConnectionAndImageLoading];
    self.homepageContainer = nil;
    self.homepageContainerNav = nil;
}

- (void)clearSplashViewIfNeeded {
//    if (self.splashNav) {
//        [self.splashNav.view removeFromSuperview];
//        self.splashNav = nil;
//        self.splashVC = nil;
//    }
    
    if (_splashVC) {
        _splashVC = nil;
    }
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO
                                            withAnimation:UIStatusBarAnimationFade];
    
}

- (void)goHomePage {
    
    [self clearSplashViewIfNeeded];
    
    [self switchViews:self.homepageContainerNav];
}

- (void)logout
{
    if (_userLoginVC) {
        
        [self clearLogin];
        
        [[iChatInstance instance] dologout];
        
        _userLoginVC = [[LoginViewController alloc] initLoginVC:self.homepageContainer.MOC
                                                           parentVC:self.homepageContainer];
        
        _userLoginVC.delegate = self;
        _userLoginVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);

        [self.window setRootViewController:_userLoginVC];
        
        [AppManager instance].isFromLogout = YES;
        
        NSArray *array = [NSArray arrayWithObjects:@"ChatGroupDataModal", nil];
        [[GoHighDBManager instance] deleteEntity:array MOC:_managedObjectContext];
    }
}

#pragma mark - push notification
- (void)registerNotify
{
//    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                                           UIRemoteNotificationTypeSound |
                                                                           UIRemoteNotificationTypeAlert)];
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSLog(@"My token is: %@", deviceToken);
    
    if (deviceToken && deviceToken.length > 0) {
        
        [AppManager instance].deviceToken = [NSString stringWithFormat:@"%@", deviceToken];
        [AppManager instance].deviceToken = [[AppManager instance].deviceToken stringByReplacingOccurrencesOfString:@"<" withString:@""];
        [AppManager instance].deviceToken = [[AppManager instance].deviceToken stringByReplacingOccurrencesOfString:@">" withString:@""];
        [AppManager instance].deviceToken = [[AppManager instance].deviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    } else {
        [AppManager instance].deviceToken = @"";
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:GET_DEVICE_TOKEN
                                                        object:nil
                                                      userInfo:nil];
}

-(void)endSplash
{
    if (!self.isEndsplahsed) {
       
        if (![IPHONE_SIMULATOR isEqualToString:[WXWCommonUtils deviceModel]]) {
            
            [self endSplash:nil];
        }

        self.isEndsplahsed = TRUE;
    }
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidReceivedRomateNotificationNotification
                                                        object:nil
                                                      userInfo:userInfo];
}

- (void)generateConnectionIdentifier {
    NSString *seed = [NSString stringWithFormat:@"%@_%@_%@", [NSDate date], [WXWCommonUtils deviceModel], @"210437"];
    [DataProvider instance].deviceConnectionIdentifier = [WXWCommonUtils hashStringAsMD5:seed];
}

#pragma mark - system call back methods
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // prepare meta data and cache
    [self prepareApp];
    
    // prepare UI homepage
    [self arrangeSolidColorNavigationBar];
    
    [self generateConnectionIdentifier];
    
    [self initNetworkListener];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    [self.window makeKeyAndVisible];
    
    float scale = [[UIScreen mainScreen] scale];
    NSLog(@"scale = %f", scale);
    self.window.rootViewController = self.splashVC;
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    [WXApi registerApp:WEIXIN_APP_ID];
    
    [MobClick startWithAppkey:UMENG_ANALYS_APP_KEY reportPolicy:SEND_INTERVAL channelId:nil];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    [MobClick setLogEnabled:YES];
    
    [self performSelector:@selector(endSplash) withObject:nil afterDelay:5.f];
    
    return YES;
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    
    // clear UIWebView cache
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    // clear image cache
    [[WXWImageManager instance] clearImageCacheForHandleMemoryWarning];
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    application.applicationIconBadgeNumber = 0;
    
    PushNotifyServer *pushNotifyServer = [[[PushNotifyServer alloc] init] autorelease];
    [NSThread detachNewThreadSelector:@selector(triggerNotify)
                             toTarget:pushNotifyServer
                           withObject:nil];
    
    LogUploader *log = [[[LogUploader alloc] init] autorelease];
    [NSThread detachNewThreadSelector:@selector(triggerUpload)
                             toTarget:log
                           withObject:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
    
    [[WXWImageManager instance].imageCache clearAllCachedAndLocalImages];
    
    [WXWDBConnection closeDB];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSManagedObjectContextDidSaveNotification
                                                  object:self.managedObjectContext];
    
}

#pragma mark - rewrite
-(BOOL)application:(UIApplication*)application handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
   return [WXApi handleOpenURL:url delegate:self];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

- (void)handleSaveNotification:(NSNotification *)aNotification {
    [self.managedObjectContext performSelectorOnMainThread:@selector(mergeChangesFromContextDidSaveNotification:)
                                                withObject:aNotification
                                             waitUntilDone:YES];
}

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ProjectCoreData" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ProductFramework.sqlite"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtURL:storeURL error:nil];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)makeWorkingDir
{
	[FileUtils mkdir:[CommonMethod getLocalDownloadFolder]];
	[FileUtils  mkdir:[CommonMethod getLocalImageFolder]];
}

- (void)loadNessesaryResource
{
    [self makeWorkingDir];
    [[AppManager instance] prepareData];
    [[ProjectAPI getInstance] setCommon:[AppManager instance].common];
    
    [[AppManager instance] getAllUserProfiles];
}

- (BOOL)isNeedShowRegisterView
{
    return TRUE;
}

- (void)clearSplash
{
    [_splashVC.view removeFromSuperview];
    _splashVC = nil;
}

- (void)clearLogin
{
    [_userLoginVC.view removeFromSuperview];
    _userLoginVC = nil;
}

- (void)endSplash:(SplashViewController *)vc
{   
    if ([self isNeedShowRegisterView]) {
        
        if (!_userLoginVC) {
            _userLoginVC = [[LoginViewController alloc] initLoginVC:self.homepageContainer.MOC
                                                                parentVC:self.homepageContainer];
            _userLoginVC.view.hidden = YES;
            _userLoginVC.delegate = self;
            if ([AppManager instance].isAutoLogout) {
                [_userLoginVC autoLogin];
            } else {
                [_userLoginVC bringToFront];
            }
        }
    } else {
        [self loginSuccessful:_userLoginVC];
    }
}

-(void)closeSplash
{
    [self logout];
}

- (void) initNetworkListener {
    Reachability * reach = [Reachability reachabilityForInternetConnection];
    
    reach.reachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [AppManager instance].connectionStatus = NetworkConnectionStatusOn;
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_NETWORK_STATUS
                                                                object:nil
                                                              userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:1], @"status", nil]];
        });
    };
    
    reach.unreachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [AppManager instance].connectionStatus = NetworkConnectionStatusOff;
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_NETWORK_STATUS
                                                                object:nil
                                                              userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0], @"status", nil]];
        });
    };
    
    [reach startNotifier];
    
    [AppManager instance].connectionStatus = [reach isReachable] ? NetworkConnectionStatusOn : NetworkConnectionStatusOff;
}

- (BOOL)loginSuccessful:(LoginViewController *)vc
{
    [self goHomePage];
    
    [[iChatInstance instance] dologin:[AppManager instance].userId];
    
    return  YES;
}
//
// Called to handle a pending crash report.
//
- (void) handleCrashReport {
    PLCrashReporter *crashReporter = [PLCrashReporter sharedReporter];
    NSData *crashData;
    NSError *error;
    
    // Try loading the crash report
    crashData = [crashReporter loadPendingCrashReportDataAndReturnError: &error];
    if (crashData == nil) {
        NSLog(@"Could not load crash report: %@", error);
        goto finish;
    }
    
    // We could send the report from here, but we'll just print out
    // some debugging info instead
    PLCrashReport *report = [[[PLCrashReport alloc] initWithData: crashData error: &error] autorelease];
    if (report == nil) {
        NSLog(@"Could not parse crash report");
        goto finish;
    }
    
    NSLog(@"Crashed on %@", report.systemInfo.timestamp);
    NSLog(@"Crashed with signal %@ (code %@, address=0x%" PRIx64 ")", report.signalInfo.name,
          report.signalInfo.code, report.signalInfo.address);
    
    NSString *crashFile =  [crashReporter crashReportPath];
    
    // Purge the report
finish:
    //    [crashReporter purgePendingCrashReport];
    return;
}

- (void)prepareCrashReporter {
    
    // Enable the Crash Reporter
    PLCrashReporter *crashReporter = [PLCrashReporter sharedReporter];
    NSError *error;
    
    /* Check if we previously crashed */
    if ([crashReporter hasPendingCrashReport])
        [self handleCrashReport];
    
    /* Enable the Crash Reporter */
    if (![crashReporter enableCrashReporterAndReturnError: &error])
        NSLog(@"Warning: Could not enable crash reporter: %@", error);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    NSLog(@"application will resign active");
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    NSLog(@"application will enter background");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    NSLog(@"application will enter foreground");
}

@end
