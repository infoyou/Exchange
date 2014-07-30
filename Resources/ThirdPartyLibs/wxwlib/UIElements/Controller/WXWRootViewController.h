//
//  WXWRootViewController.h
//  Project
//
//  Created by XXX on 12-05-02.
//  Copyright (c) 2011年 _CompanyName_. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import <CoreData/CoreData.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CGColor.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/ABPersonViewController.h>
#import <AddressBookUI/ABUnknownPersonViewController.h>
#import <MapKit/MKReverseGeocoder.h>
#import <CoreLocation/CoreLocation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "MessageUI/MessageUI.h"
#import "WXWConnectionTriggerHolderDelegate.h"
#import "WXWLocationFetcherDelegate.h"
#import "WXWImageDisplayerDelegate.h"
#import "WXWConnectorDelegate.h"
#import "WXWConstants.h"
#import "WXWLocationManager.h"
#import "WXWTextPool.h"
#import "WXWCommonUtils.h"
#import "WXWSystemInfoManager.h"
#import "WXWUIUtils.h"
#import "ColofulNavigationBar.h"
#import "WXWSyncConnectorFacade.h"

@class WXWAsyncConnectorFacade;
@class WXWConnector;

@interface WXWRootViewController : UIViewController <WXWConnectorDelegate, WXWImageDisplayerDelegate, WXWLocationFetcherDelegate, WXWConnectionTriggerHolderDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIGestureRecognizerDelegate> {
    
    NSInteger _currentType;
    BOOL _needGoHome;
    int _alertType;
    int _sheetType;
    UITableView *_tableView;
    
    NSManagedObjectContext *_MOC;
    NSFetchedResultsController *_fetchedRC;
    NSPredicate *_predicate;
    NSString *_entityName;
    NSMutableArray *_descriptors;
    
    NSString *_sectionNameKeyPath;
    UIActivityIndicatorView *_activityView;
    UIView *_activityBackgroundView;
    UILabel *_loadingLabel;
    
    UIPickerView *_PickerView;
    NSMutableArray *_DropDownValArray;
    NSMutableArray *_PickData;
    UIView *_PopView;
    UIView *_PopBGView;
    
    int iFliterIndex;
    int pickSel0Index;
    int pickSel1Index;
    BOOL isPickSelChange;
    
    id _holder;
    SEL _backToHomeAction;
    
    WXWAsyncConnectorFacade *_connFacade;
    NSString *_connectionErrorMsg;
    
    NSMutableDictionary *_connDic;
    
    NSMutableDictionary *_errorMsgDic;
    
    NSMutableDictionary *_imageUrlDic;
    
    // sub class responsible for setting this message, then closeAsyncLoadingView will check its value
    // to determine whether show this message
    NSString *_connectionResultMessage;
    
    WXWLocationManager *_locationManager;
    
    UIView *disableViewOverlay;
    
    // navigation
    BOOL _noNeedBackButton;
    
    // swipe back to parent view controller
    BOOL _allowSwipeBackToParentVC;
    
    // session management
    BOOL _sessionExpired;
    
    
    CGSize _screenSize;
    
@private
    // async loading
    UIView *_asyncLoadingBackgroundView;
    UILabel *_asyncLoadingLabel;
    UIImageView *_operaFacebookImageView;
    BOOL _reverseFromRightToLeft;
    BOOL _stopAsyncLoading;
    BOOL _blockCurrentView;
    BOOL _userCancelledLocate;
    
    // tiny notification
    UIView *_tinyNotifyBackgroundView;
    UILabel *_tinyNotifyLabel;
    
    // animate view
    UIViewController *modalDisplayedVC;
    
    // session management
    NSInteger _sessionExpiredRequestType;
    BOOL _showAlert;
    
    NSTimer* _timerTitleLoading;
}

@property (nonatomic, retain) WXWRootViewController *parentVC;

@property (nonatomic, retain) NSManagedObjectContext *MOC;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) WXWAsyncConnectorFacade *connFacade;
@property (nonatomic, retain) NSString *connectionErrorMsg;
@property (nonatomic, retain) NSMutableDictionary *connDic;
@property (nonatomic, retain) NSMutableDictionary *errorMsgDic;
@property (nonatomic, retain) NSMutableDictionary *imageUrlDic;
@property (nonatomic, retain) NSFetchedResultsController *fetchedRC;
@property (nonatomic, copy) NSString *entityName;
@property (nonatomic, copy) NSString *sectionNameKeyPath;
@property (nonatomic, retain) NSMutableArray *descriptors;
@property (nonatomic, retain) NSPredicate *predicate;
@property (nonatomic, copy) NSString *connectionResultMessage;
@property (nonatomic, retain) UIView *disableViewOverlay;


// Picker View
@property (nonatomic,retain) IBOutlet UIPickerView *_PickerView;
@property (nonatomic,retain) NSMutableArray* DropDownValArray;
@property (nonatomic,retain) NSMutableArray *_PickData;
@property (nonatomic,retain) UIView *_PopView;
@property (nonatomic,retain) UIView *_PopBGView;

// animate view
@property (nonatomic, retain) UIViewController *modalDisplayedVC;

- (void)adjustNavigationBarImage:(UIImage *)image
         forNavigationController:(UINavigationController *)navigationController;

- (void)initTableView;
- (void)deselectCell;

- (id)initWithMOC:(NSManagedObjectContext *)MOC;

- (id)initWithMOCWithoutBackButton:(NSManagedObjectContext *)MOC;

#pragma mark - set bar item buttons
- (void)setRightButtonTitle:(NSString *)title;
- (void)setLeftButtonTitle:(NSString *)title;
- (void)addRightBarButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action;
- (void)addLeftBarButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action;

#pragma mark - back to homepage
- (void)backToHomepage:(id)sender;

- (void)back:(id)sender;
- (void)backToRootViewController:(id)sender;

#pragma mark - network consumer methods-- sync
- (WXWSyncConnectorFacade *)setupSyncConnectorForUrl:(NSString *)url
                                         contentType:(NSInteger)contentType;

#pragma mark - network consumer methods -- async
- (WXWAsyncConnectorFacade *)setupAsyncConnectorForUrl:(NSString *)url
                                           contentType:(NSInteger)contentType;

#pragma mark - check connection error message
- (BOOL)connectionMessageIsEmpty:(NSError *)error;

#pragma mark - cancel connection/location when navigation back to parent layer
- (void)cancelConnection;
- (void)cancelLocation;

#pragma mark - location fetch
- (void)forceGetLocation;
- (void)getCurrentLocationInfoIfNecessary;

#pragma mark - async loading animation
- (void)showAsyncLoadingView:(NSString *)message blockCurrentView:(BOOL)blockCurrentView;
- (void)changeAsyncLoadingMessage:(NSString *)message;
- (void)closeAsyncLoadingView;

#pragma mark - show tiny notification
- (void)showTinyNotification:(NSString *)message;

#pragma mark - cancel connection and image loading
- (void)cancelConnectionAndImageLoading;

#pragma mark - picker
- (void)pickerSelectRow:(NSInteger)row;
- (void)clearPickerSelIndex2Init:(int)size;
- (void)setPopView;
- (void)onPopCancle;
- (void)onPopSelectedOk;
- (int)pickerList0Index;

#pragma mark - core data
- (NSFetchedResultsController *)prepareFetchRC;

#pragma mark - DisableView option
- (void)initDisableView:(CGRect)frame;
- (void)showDisableView;
- (void)removeDisableView;

#pragma mark - manage modal view controller
- (void)presentModalQuickViewController:(WXWRootViewController *)vc;
- (void)presentModalQuickView:(UIView *)view;
- (void)dismissModalQuickView;

#pragma mark -- featch MOC
- (void)configureMOCFetchConditions;

#pragma mark -- MOC
- (void)fetchContentFromMOC;

#pragma mark -- navigation bar font
- (void)updateNavigationBarSizeFont:(NSString *)fontName size:(int)size;


#pragma mark -- Navigation Title & Loading Animation
- (void) setLoadingTitle:(NSString*)title withAnimation:(BOOL)animation;
- (void) startLoadingTitle;
- (void) stopLoadingTitle;
- (void) resetTitle:(NSString*)title;
@end
