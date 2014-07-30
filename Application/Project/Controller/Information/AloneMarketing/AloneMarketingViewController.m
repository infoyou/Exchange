//
//  AloneMarketingViewController.m
//  Project
//
//  Created by user on 13-10-8.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "AloneMarketingViewController.h"
#import "SummaryViewController.h"
#import "GuideViewController.h"
#import "CaseViewController.h"
#import "ExecuteViewController.h"
#import "QuestionViewController.h"
#import "GHCustomTabBar.h"
#import "UIView+SharedObject.h"
#import "HardwareInfo.h"
#import "GlobalConstants.h"
#import "GlobalInfo.h"
#import "UIColor+expanded.h"
#import "ProjectAPI.h"
#import "AppManager.h"
#import "JSONKit.h"
#import "JSONParser.h"
#import "TextPool.h"
#import "GlobalConstants.h"
#import "CommonUtils.h"
#import "RootCategory.h"
#import "SubCategory.h"
#import "BaseCategory.h"
#import "ChildSubCategory.h"
#import "SectionViewController.h"
#import "GoHighDBManager.h"
#import "OffLineDBCacheManager.h"
#import "WXWConstants.h"

@interface AloneMarketingViewController ()<GHCustomTabBarDelegate> {
    GHCustomTabBar *_tabBar;
    CGSize _tabItemSize;
    NSMutableArray *_tabBarItems;
    
    SummaryViewController *summaryController;
    GuideViewController *guideController;
    CaseViewController *caseController;
    QuestionViewController *questionController;
    ExecuteViewController *executeController;
}

//@property (nonatomic, retain) NSMutableArray *tabTitles;
@property (nonatomic, retain) NSMutableArray *categorys;

@end

@implementation AloneMarketingViewController

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
    
    self.view.backgroundColor = DEFAULT_VIEW_COLOR;
    
#if APP_TYPE == APP_TYPE_BASE
    self.navigationItem.title  = @"不打扰营销";
#elif APP_TYPE == APP_TYPE_CIO || APP_TYPE == APP_TYPE_IALUMNIUSA || APP_TYPE == APP_TYPE_INEARBY
    self.navigationItem.title  = @"信息化案例";
#elif APP_TYPE == APP_TYPE_O2O
    self.navigationItem.title  = @"不打扰营销";
#endif
    
    
    _categorys = [[NSMutableArray alloc] init];
//    _tabTitles = [[NSMutableArray alloc] init];
    
    [self loadCategory];
    
   self.categorys =  [[OffLineDBCacheManager handleAloneMarketingDB:_MOC] retain];
    
    if (self.categorys.count) {
        
//    for (int i = 0; i < self.categorys.count; ++i) {
//        
//        ChildSubCategory *ch = [self.categorys objectAtIndex:i];
//        [self.tabTitles addObject:ch.param3];
//    }
        
//        for (int i = 0; i < self.categorys.count; ++i) {
//            
//            ChildSubCategory *ch = [self.categorys objectAtIndex:i];
//            [self.tabTitles addObject:ch.param3];
//        }
        
        
        CGSize size = [[HardwareInfo getInstance] getScreenSize];
        _tabItemSize = CGSizeMake(size.width/self.categorys.count, ALONE_MARKETING_TAB_HEIGHT);
        
        [self initTabInfo];
        }
    
    //    [self initTabInfo];
    //    [self initTabBar];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (RootCategory *)rootCategrayOfString:(NSString *)string {
    //    DLog(@"self.category: %@",self.categorys);
    for (RootCategory *rc in self.categorys) {
        if ([rc.param3 isEqualToString:string]) {
            return rc;
        }
    }
    return nil;
}

- (void)initTabInfo {
    
    _tabBarItems = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.categorys.count; ++i) {
        
        ChildSubCategory *ch = [self.categorys objectAtIndex:i];
        
        if (ch.list1.count) {
            
            ChildSubCategory *cch = [ch.list1 objectAtIndex:0];
            if (cch.list1.count) {
                SectionViewController *vc = [[[SectionViewController alloc] initWithRootCategory:ch] autorelease];
                
                NSDictionary *dict =
                [NSDictionary dictionaryWithObjectsAndKeys:@"", KEY_IMAGE_NORMAL, @"", KEY_IMAGE_SELECTED, ch.param3, KEY_NAME,vc, KEY_VIEW_CONTROLLER,  nil];
                
                
                [_tabBarItems addObject:dict];
            }else{
                CaseViewController *vc = [[[CaseViewController alloc] initWithRootCategory:ch cellType:CellType_OnlyTitle] autorelease];
                
                NSDictionary *dict =
                [NSDictionary dictionaryWithObjectsAndKeys:@"", KEY_IMAGE_NORMAL, @"", KEY_IMAGE_SELECTED, ch.param3, KEY_NAME,vc, KEY_VIEW_CONTROLLER,  nil];
                
                
                [_tabBarItems addObject:dict];
            }
        }else{
            
            SummaryViewController *vc = [[[SummaryViewController alloc] initWithRootCategory:ch showBottom:YES] autorelease];
            
            NSDictionary *dict =
            [NSDictionary dictionaryWithObjectsAndKeys:@"", KEY_IMAGE_NORMAL, @"", KEY_IMAGE_SELECTED, ch.param3, KEY_NAME,vc, KEY_VIEW_CONTROLLER,  nil];
            
            
            [_tabBarItems addObject:dict];
        }
    }
    
    [self initTabBar];
}

- (void)initTabBar {
    CGSize buttonSize = CGSizeMake(_tabItemSize.width, _tabItemSize.height);
    
    // Create a custom tab bar passing in the number of items, the size of each item and setting ourself as the delegate
    _tabBar = [[GHCustomTabBar alloc] initWithItemCount:_tabBarItems.count itemSize:_tabItemSize buttonSize:buttonSize tag:0 delegate:self];
    
    // Place the tab bar at the bottom of our view
    _tabBar.frame = CGRectMake(0,self.view.frame.size.height - ALONE_MARKETING_TAB_HEIGHT,[GlobalInfo getDeviceSize].width, _tabItemSize.height);
    [self.view addSubview:_tabBar];
    
    // Select the first tab
    [_tabBar selectItemAtIndex:0];
}

#pragma mark -- customtab bar delegate

- (NSString *)nameFor:(GHCustomTabBar*)tabBar atIndex:(NSUInteger)itemIndex
{
    NSDictionary* data = [_tabBarItems objectAtIndex:itemIndex];
    // Return the image for this tab bar item
    return [data objectForKey:KEY_NAME];
}

- (UIImage *)imageFor:(GHCustomTabBar*)tabBar atIndex:(NSUInteger)itemIndex
{
    return nil;
}


- (UIImage *)imageForSelected:(GHCustomTabBar*)tabBar atIndex:(NSUInteger)itemIndex
{
    
    
    // Get the right data
    NSDictionary *data = [_tabBarItems objectAtIndex:itemIndex];
    // Return the image for this tab bar item
    return [UIImage imageNamed:[data objectForKey:KEY_IMAGE_SELECTED]];
}

- (CGSize)imageSize:(GHCustomTabBar *)tabBar atIndex:(NSUInteger)itemIndex
{
    
    return CGSizeZero;
}

- (UIImage *)backgroundImage:(CGRect)rect
{
    UIImage *image =  [UIImage imageNamed:@"aloneMarketing_tabBar_bg"];
    UIGraphicsBeginImageContext(rect.size);
    
    [image  drawInRect:rect];
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return theImage;
}

// This is the blue background shown for selected tab bar items
- (UIImage *)selectedItemBackgroundImage
{
    return [GlobalInfo createImageWithColor:RANDOM_COLOR withRect:CGRectMake(0, 0, _tabItemSize.width, _tabItemSize.height)];
    //    return [UIImage imageNamed:@"courseManager_btn_rect_selected.png"];
}

// This is the glow image shown at the bottom of a tab bar to indicate there are new items
- (UIImage *)glowImage
{
    //    return nil;
    UIImage *tabBarGlow = [GlobalInfo createImageWithColor:[UIColor colorWithHexString:@"0xffffff"] withRect:CGRectMake(0, 0, _tabItemSize.width, _tabItemSize.height)];
    
    // Create a new image using the TabBarGlow image but offset 4 pixels down
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(tabBarGlow.size.width, tabBarGlow.size.height-4), NO, 0.0);
    
    // Draw the image
    [tabBarGlow drawAtPoint:CGPointZero];
    
    // Generate a new image
    UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}

// This is the embossed-like image shown around a selected tab bar item
- (UIImage *)selectedItemImage:(int)index
{
    // Use the TabBarGradient image to figure out the tab bar's height (22x2=44)
    
    
    CGSize tabBarItemSize = CGSizeMake(_tabItemSize.width, _tabItemSize.height);
    UIGraphicsBeginImageContextWithOptions(tabBarItemSize, NO, 0.0);
    
    //    srandom(rand());
    [[[UIImage imageNamed:@"information_aloneMarketing_content_bg.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] drawInRect:CGRectMake(0, 0, tabBarItemSize.width , tabBarItemSize.height)];
    
    // Generate a new image
    UIImage *selectedItemImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    
    return selectedItemImage;
}

- (UIImage *)tabBarArrowImage
{
    return nil;
}


#define SELECTED_VIEW_CONTROLLER_TAG 98456345

- (void)touchDownAtItemAtIndex:(NSUInteger)itemIndex
{
    // Remove the current view controller's view
    UIView* currentView = [self.view viewWithTag:SELECTED_VIEW_CONTROLLER_TAG];
    [currentView removeFromSuperview];
    
    // Get the right view controller
    NSDictionary* data = [_tabBarItems objectAtIndex:itemIndex];
    UIViewController* viewController = [data objectForKey:KEY_VIEW_CONTROLLER];
    
    // Use the TabBarGradient image to figure out the tab bar's height (22x2=44)
    CGSize size = [GlobalInfo getDeviceSize];
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height - ALONE_MARKETING_TAB_HEIGHT);
    // Set the view controller's frame to account for the tab bar
    viewController.view.frame = rect;
    
    // Se the tag so we can find it later
    viewController.view.tag = SELECTED_VIEW_CONTROLLER_TAG;
    
    // Add the new view controller's view
    [self.view insertSubview:viewController.view belowSubview:_tabBar];
    
    // In 1 second glow the selected tab
    [NSTimer scheduledTimerWithTimeInterval:0.0001 target:self selector:@selector(addGlowTimerFireMethod:) userInfo:[NSNumber numberWithInteger:itemIndex] repeats:NO];
}


- (CGSize) buttonSize
{
    return _tabItemSize;
}

- (int)infoCount:(int)index
{
    switch (index) {
        case 0:
            return 0;
            
        case 1:
            return 0;
            
        case 2:
            return 0;
            
        case 3:
            return 0;
            
        case 4:
            return 0;
            
        default:
            return 0;
    }
}

- (void)addGlowTimerFireMethod:(NSTimer*)theTimer
{
    // Remove the glow from all tab bar items
    for (NSUInteger i = 0 ; i < _tabBarItems.count ; i++)
    {
        [_tabBar removeGlowAtIndex:i];
    }
    
    // Then add it to this tab bar item
    [_tabBar glowItemAtIndex:[[theTimer userInfo] integerValue]];
}

- (void)loadCategory {
    
    NSMutableDictionary *specialDict = [[[NSMutableDictionary alloc] init] autorelease];
    [specialDict setValue:VALUE_API_PREFIX forKey:KEY_API_PREFIX];
    [specialDict setValue:VALUE_API_CONTENT forKey:KEY_API_CONTENT];
    
    [specialDict setObject:NUMBER(1) forKey:KEY_API_PARAM_PAGE_NO];
    [specialDict setObject:NUMBER(2) forKey:KEY_API_PARAM_CATEGORY_TYPE];
    
    [specialDict setObject:[CommonMethod convertLongTimeToString:[[GoHighDBManager instance] getLatestAloneMarketingTime] / 1000 ]  forKey:KEY_API_PARAM_START_TIME];
//    [specialDict setObject:@"" forKey:KEY_API_PARAM_START_TIME];  
    [specialDict setObject:@"" forKey:KEY_API_PARAM_END_TIME];
    [specialDict setObject:@"" forKey:KEY_API_PARAM_KEYWORD];
    
    NSDictionary *commonDict = [AppManager instance].common;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (commonDict) {
        [dict setObject:commonDict forKey:@"common"];
    }
    if (specialDict) {
        [dict setObject:specialDict forKey:@"special"];
    }
    
    NSString *url = [ProjectAPI getRequestURL:API_SERVICE_INFORMATION withApiName:API_NAME_GET_INFORMATION_CATEGORY withCommon:commonDict withSpecial:specialDict];
    
    _currentType = LOAD_CATEGORY_TY;
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                              contentType:_currentType];
    //    [connFacade post:url data:[specialDict JSONData]];
    [connFacade fetchGets:url];
}

#pragma mark - ECConnectorDelegate methods
- (void)connectStarted:(NSString *)url
           contentType:(NSInteger)contentType {
    [self showAsyncLoadingView:LocaleStringForKey(NSLoadingTitle, nil) blockCurrentView:YES];
    
    [super connectStarted:url contentType:contentType];
}


-(void)recursionParse:(NSDictionary *)dict
{
    
}

- (void)connectDone:(NSData *)result url:(NSString *)url contentType:(NSInteger)contentType {
    
    switch (contentType) {
            
        case LOAD_CATEGORY_TY:
        {
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            
            if (ret == SUCCESS_CODE) {
                DLog(@"parserSuccess");
                
                NSDictionary *resultDic = [result objectFromJSONData];
                NSDictionary *contentDic = OBJ_FROM_DIC(resultDic, @"content");
                NSString *timestamp = OBJ_FROM_DIC(resultDic, @"timestamp");
                
                
                //                NSString* aStr;
                //                aStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
                
                __block void (^blocks)(NSDictionary*,NSMutableArray *, NSString *);
                blocks = ^(NSDictionary *dict, NSMutableArray *afterArray, NSString *parentid){
                    NSArray *array =[dict objectForKey:@"list1"];
                    
                    DLog(@"%@:%@", [dict objectForKey:@"param3"], [dict objectForKey:@"param8"]);
                    
                    ChildSubCategory *cc = [[[ChildSubCategory alloc] init] autorelease];
                    cc.list1 = [[[NSMutableArray alloc] init] autorelease];
                    cc.parentId = parentid;
                    [cc parserData:dict];
                    
                    [afterArray addObject:cc];
                    if([array count]){
                        for (int i = 0; i < [array count]; ++i) {
                            blocks([array objectAtIndex:i], cc.list1, cc.param1);
                        }
                    }
                };
                
                NSMutableArray *arr = [[[NSMutableArray alloc] init] autorelease];
                blocks(contentDic,arr, @"-1");
                
                [[GoHighDBManager instance] upinsertAloneMarketing:arr timestamp:[timestamp doubleValue]];
                
#if 0
                __block void (^blocksPrint)(NSMutableArray *);
                
                blocksPrint = ^(NSMutableArray *printArray){
                    for (int i = 0; i < [printArray count]; ++i) {
                        
                        ChildSubCategory *cc = (ChildSubCategory *)[printArray objectAtIndex:i];
                        DLog(@"%@:%d:%@",cc.param3, cc.list1.count, cc.param8);
                        
                        blocksPrint(cc.list1);
                    }
                };
                
                blocksPrint(arr);
#endif
                
                ChildSubCategory *ch = [arr objectAtIndex:0];
                NSMutableArray *array = ch.list1;
                int count = 0;
                if (array.count) {
                    for (int i = 0; i < array.count; ++i) {
                        BOOL isExist = FALSE;;
                        ChildSubCategory *ch = [array objectAtIndex:i];
                        
                        for (int j = 0; j < self.categorys.count; ++j) {
                            ChildSubCategory *chh = [self.categorys objectAtIndex:j];
                            
                            if ([ch.param1 isEqualToString:chh.param1] ) {
                                isExist = TRUE;
                                self.categorys[j] = ch;
                            }
                        }
                        
                        if (!isExist) {
                            [self.categorys addObject:ch];
                            count++;
//                            [self.tabTitles addObject:ch.param3];
                        }
                    }
                
                //---------------------------------排序-------------------
                //排序
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"param5" ascending:YES];
                NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
                [self.categorys sortUsingDescriptors:sortDescriptors];
                [sortDescriptor release];
                [sortDescriptors release];
                
                
                
                    if (_tabBarItems.count) {
                        
                        CGSize size = [[HardwareInfo getInstance] getScreenSize];
                        _tabItemSize = CGSizeMake(size.width/(count +_tabBarItems.count) , ALONE_MARKETING_TAB_HEIGHT);
                        
                        [self initTabInfo];
                    }else{
                        
                        CGSize size = [[HardwareInfo getInstance] getScreenSize];
                        _tabItemSize = CGSizeMake(size.width/self.categorys.count, ALONE_MARKETING_TAB_HEIGHT);
                        
                        [self initTabInfo];
                    }
                    
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

- (void)dealloc {
    [_categorys release];
    
    [super dealloc];
}

@end
