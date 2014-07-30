//
//  BaseAppDelegate.h
//  Product
//
//  Created by XXX on 13-10-15.
//  Copyright (c) 2013年 _CompanyName_. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "GlobalConstants.h"

@class HomepageContainerViewController;
@class WXWNavigationController;

@interface BaseAppDelegate : UIResponder <UIApplicationDelegate> {
  
  @private
  
  BOOL _startup;
  
  WXWNavigationController *_premiereNav;
}

@property (nonatomic, retain) HomepageContainerViewController *homepageContainer;

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain) id<WXApiDelegate> wxApiDelegate;

- (void)saveContext;
- (void)goHomePage;
- (void)logout;
- (NSURL *)applicationDocumentsDirectory;
-(void)closeSplash;
- (void) initNetworkListener;
@end
