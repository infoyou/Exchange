//
//  EventListViewController.m
//  ProductFramework
//
//  Created by XXX on 12-5-30.
//  Copyright (c) 2011年 _CompanyName_. All rights reserved.
//

#import "EventListViewController.h"
#import "DataProvider.h"
#import "XMLParser.h"
#import "EventListCell.h"
#import "TextPool.h"
#import "GlobalConstants.h"
#import "Event.h"

#define EVENT_LIST_CELL_HEIGHT          96.f

@interface EventListViewController ()

@end

@implementation EventListViewController

#pragma mark - load data
- (void)loadListData:(LoadTriggerType)triggerType forNew:(BOOL)forNew {
  [super loadListData:triggerType forNew:forNew];
  
  _currentType = EVENTLIST_TY;
  
  NSInteger index = 0;
  if (!forNew) {
    index = ++_currentStartIndex;
  }
  
  NSString *url = [NSString stringWithFormat:@"http://alumniapp.ceibs.edu:8080/ceibs_test/phone_controller?action=event_list_v2&ReqContent=<?xml version=\"1.0\" encoding=\"UTF-8\"?><content><locale>zh</locale><plat>iPhone</plat><channel>1</channel><system>7.0</system><version>1.5.2</version><device_token></device_token><user_id>zying.e09sh5</user_id><user_name>章英</user_name><person_id>238869</person_id><user_type>1</user_type><session_id>%@</session_id><class_id>EMBA09SH5</class_id><class_name>EMBA09SH5</class_name><connect_id>%@</connect_id><keywords></keywords><screen_type>4</screen_type><city_id>0</city_id><sort_type>1</sort_type><page_size>20</page_size><page>%d</page><longitude>0.000000</longitude><latitude>0.000000</latitude></content>", [DataProvider instance].sessionId, [DataProvider instance].deviceConnectionIdentifier, index];
  
  WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                            contentType:_currentType];
  [connFacade fetchGets:url];

}

- (void)configureMOCFetchConditions {
  self.entityName = @"Event";
  self.descriptors = [NSMutableArray array];
  self.predicate = nil;
  
  NSSortDescriptor *dateDesc = [[[NSSortDescriptor alloc] initWithKey:@"showOrder" ascending:YES] autorelease];
  [self.descriptors addObject:dateDesc];

}

#pragma mark - life cycle methods
- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(WXWRootViewController *)pVC {
  self = [super initWithMOC:MOC
      needRefreshHeaderView:YES
      needRefreshFooterView:YES];
  if (self) {
    _noNeedBackButton = YES;
    
    self.parentVC = pVC;
  }
  return self;
}

- (void)dealloc {
  
  [super dealloc];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
	
    self.view.backgroundColor = DEFAULT_VIEW_COLOR;
  
  _tableView.backgroundColor = DEFAULT_VIEW_COLOR;

  if ([WXWCommonUtils currentOSVersion] < IOS7) {
    self.view.frame = CGRectOffset(self.view.frame, 0, -20);
  }

}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  if (!_autoLoaded) {
    [self loadListData:TRIGGERED_BY_AUTOLOAD forNew:YES];
  }
  
  [self updateLastSelectedCell];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - ECConnectorDelegate methods
- (void)connectStarted:(NSString *)url
           contentType:(NSInteger)contentType {
  [self showAsyncLoadingView:LocaleStringForKey(NSLoadingTitle, nil) blockCurrentView:YES];
  
  [super connectStarted:url contentType:contentType];
}

- (void)connectDone:(NSData *)result url:(NSString *)url contentType:(NSInteger)contentType {
  
  switch (contentType) {
      
    case EVENTLIST_TY:
    {
      
      if ([XMLParser parserResponseXml:result
                                  type:contentType
                                   MOC:_MOC
                     connectorDelegate:self
                                   url:url]) {
        
        [self refreshTable];
        
        if (!_autoLoaded) {
          _autoLoaded = YES;
        }
        _tableView.alpha = 1.0f;
        
      } else {
        [WXWUIUtils showNotificationOnTopWithMsg:LocaleStringForKey(NSActionFaildMsg, nil)
                                         msgType:INFO_TY
                              belowNavigationBar:YES];
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

#pragma mark - UITableViewDelegate, UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
  
  return self.fetchedRC.fetchedObjects.count + 1;
}

- (EventListCell *)drawEventCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
  
  // Event Cell
  NSString *kEventCellIdentifier = @"EventCell";
  EventListCell *cell = (EventListCell *)[tableView dequeueReusableCellWithIdentifier:kEventCellIdentifier];
  if (nil == cell) {
    cell = [[[EventListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kEventCellIdentifier] autorelease];
 
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
  }
  
  Event *event = (Event *)[self.fetchedRC objectAtIndexPath:indexPath];
  [cell drawEvent:event];
  
  return cell;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  if (indexPath.row == self.fetchedRC.fetchedObjects.count) {
    return [self drawFooterCell];
  } else {
    
    return [self drawEventCell:tableView indexPath:indexPath];
  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  if (indexPath.row == _fetchedRC.fetchedObjects.count) {
    return;
  }
  
  [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return EVENT_LIST_CELL_HEIGHT;
}


@end
