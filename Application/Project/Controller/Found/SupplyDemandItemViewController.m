//
//  SupplyDemandItemViewController.m
//  Project
//
//  Created by XXX on 13-12-25.
//
//

#import "SupplyDemandItemViewController.h"
#import "Post.h"
#import "AuthorCell.h"
#import "CommunicationPersonalInfoViewController.h"
#import "SupplyDemandItemCell.h"
#import "TextPool.h"
#import "ECImageBrowseViewController.h"
#import "WXWNavigationController.h"
#import "SupplyDemandItemToolbar.h"
#import "CommonUtils.h"
#import "JSONParser.h"
#import "UIUtils.h"
#import "AppManager.h"
#import "Alumni.h"
#import "WXWCoreDataUtils.h"
#import "UIWebViewController.h"
#import "Tag.h"
//#import "DMChatViewController.h"
#import "BaseAppDelegate.h"
#import "Comment.h"

enum {
  AUTHOR_CELL,
  CONTENT_CELL,
};

#define CELL_COUNT    2

#define AUTHOR_CELL_HEIGHT      71.0f

#define FLAG_SIDE_LEN   42.0f

#define TAG_LIST_HEIGHT 40.0f

@interface SupplyDemandItemViewController (){
    NSInteger _attentionOffset;
    BOOL isNew;
    BOOL _loadingComments;
}

@property (nonatomic, retain) Post *item;
@property (nonatomic, retain) UIImage *postImage;
@end

@implementation SupplyDemandItemViewController

#pragma mark - user actions
- (void)favoriteItem:(id)sender {
  
  if (_target && _triggerRefreshAction) {
    [_target performSelector:_triggerRefreshAction];
  }

   if (!self.item.isAttention.boolValue) {
       _currentType = POST_FAVORITE_ACTION_TY;
       _attentionOffset = 1;
   } else {
       _currentType = POST_UNFAVORITE_ACTION_TY;
       _attentionOffset = -1;
   }
   
    NSDictionary *paramDict = @{  @"postId":self.item.postId,
                                  @"attentionStatus":[NSString stringWithFormat:@"%d", ![self.item.isAttention intValue] ],
                                  };
   NSString *url = [CommonUtils  geneJSONUrl:paramDict itemType:_currentType];
   
   WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                             contentType:_currentType];
   [connFacade postCommonInfoDic:paramDict url:url];
}

- (void)openChatListForAlumni:(Alumni *)alumni {
  /*
  DMChatViewController *chatVC = [[[DMChatViewController alloc] initWithMOC:_MOC
                                                                     alumni:alumni] autorelease];
  [self.navigationController pushViewController:chatVC animated:YES];
*/
}

- (void)sendDM:(id)sender {
  
//  if ([[AppManager instance].personId isEqualToString:self.item.authorId]) {
//    return;
//  }
//  
//  _currentType = ALUMNI_QUERY_DETAIL_TY;
//  
//  NSString *url = [NSString stringWithFormat:@"%@%@&personId=%@&username=%@&sessionId=%@&userType=%d&active_personId=%@", [AppManager instance].hostUrl, ALUMNI_DETAIL_URL, self.item.authorId, [AppManager instance].userId, [AppManager instance].sessionId, ALUMNI_USER_TY, [AppManager instance].personId];
//
//  WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
//                                                            contentType:_currentType];
//  [connFacade fetchGets:url];
}

- (void)shareItem:(id)sender {
//  if ([WXApi isWXAppInstalled]) {
//    ((BaseAppDelegate*)APP_DELEGATE).wxApiDelegate = self;
//    
//    NSString *url = [NSString stringWithFormat:CONFIGURABLE_DOWNLOAD_URL,
//                     [AppManager instance].hostUrl,
//                     [WXWSystemInfoManager instance].currentLanguageDesc,
//                     [AppManager instance].releaseChannelType];
//    [CommonUtils sharePostByWeChat:self.item
//                             scene:WXSceneSession
//                               url:url
//                             image:self.postImage];
//  } else {
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
//                                                    message:LocaleStringForKey(NSNoWeChatMsg, nil)
//                                                   delegate:self
//                                          cancelButtonTitle:LocaleStringForKey(NSDonotInstallTitle, nil)
//                                          otherButtonTitles:LocaleStringForKey(NSInstallTitle, nil), nil];
//    [alert show];
//    [alert release];
//  }
}

- (void)deleteItem:(id)sender {
  UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:LocaleStringForKey(NSDeleteFeedWarningMsg, nil)
                                                  delegate:self
                                         cancelButtonTitle:nil
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:nil];
  [as addButtonWithTitle:LocaleStringForKey(NSDeleteActionTitle, nil)];
  as.destructiveButtonIndex = [as numberOfButtons] - 1;
  [as addButtonWithTitle:LocaleStringForKey(NSCancelTitle, nil)];
  as.cancelButtonIndex = [as numberOfButtons] - 1;
  [as showInView:self.view];
  RELEASE_OBJ(as);
}

#pragma mark - lifecycle methods

- (id)initMOC:(NSManagedObjectContext *)MOC
         item:(Post *)item
       target:(id)target
triggerRrefreshAction:(SEL)triggerRrefreshAction
{
  self = [super initWithMOC:MOC];
  
  if (self) {
    self.item = item;
    
    _noNeedDisplayEmptyMsg = YES;
    
    _target = target;
    _triggerRefreshAction = triggerRrefreshAction;
  }
  return self;
}

- (void)dealloc {
  
  self.item = nil;
  self.postImage = nil;
  
  [super dealloc];
}

- (void)addToolbar {
  
  BOOL itemSentByMe = [AppManager instance].userId.intValue == self.item.authorId.intValue ? YES : NO;
  
  CGFloat y = self.view.frame.size.height - TOOLBAR_HEIGHT - NAVIGATION_BAR_HEIGHT;
  if (CURRENT_OS_VERSION >= IOS7) {
    y -= SYS_STATUS_BAR_HEIGHT;
  }
  
    _toolbar = [[[SupplyDemandItemToolbar alloc] initWithFrame:CGRectMake(0, y, self.view.frame.size.width, TOOLBAR_HEIGHT)
                                                          item:self.item
                                                  selfSentItem:itemSentByMe
                                                        target:self
                                                     favAction:@selector(favoriteItem:)
                                                      dmAction:@selector(sendDM:)
                                                   shareAction:@selector(shareItem:)
                                                  deleteAction:@selector(deleteItem:)] autorelease];
    [self.view addSubview:_toolbar];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self addToolbar];
  
  _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  
  CGRect frame = _tableView.frame;
  frame.size = CGSizeMake(frame.size.width, frame.size.height - TOOLBAR_HEIGHT);
  _tableView.frame = frame;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  if (!_autoLoaded) {
    [_tableView reloadData];
    
    _autoLoaded = YES;
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
  
  return CELL_COUNT;
}


- (UITableViewCell *)drawAuthorCell {
  static NSString *kCellIdentifier = @"authorCell";
  
  AuthorCell *cell = (AuthorCell *)[_tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
  if (nil == cell) {
    cell = [[[AuthorCell alloc] initWithStyle:UITableViewCellStyleDefault
                              reuseIdentifier:kCellIdentifier] autorelease];
  }
  
  [cell drawCellWithImageUrl:self.item.authorPicUrl
                  authorName:self.item.authorName];
  
  return cell;
}

- (UITableViewCell *)drawContentCell {

  static NSString *kCellIdentifier = @"contentCell";
  SupplyDemandItemCell *cell = (SupplyDemandItemCell *)[_tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
  if (nil == cell) {
    cell = [[[SupplyDemandItemCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:kCellIdentifier
                                   coreTextViewDelegate:self
                                   tagSelectionDelegate:self
                                 imageDisplayerDelegate:self
                                 imageClickableDelegate:self
                                                    MOC:_MOC] autorelease];
  }
  
  [cell drawCellWithItem:self.item];
  
  return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  switch (indexPath.row) {
    case AUTHOR_CELL:
      return [self drawAuthorCell];
      
    case CONTENT_CELL:
      return [self drawContentCell];
      
    default:
      return nil;
  }
}

- (void)selectAuthorCell {
//  AlumniProfileViewController *profileVC = [[[AlumniProfileViewController alloc] initWithMOC:_MOC
//                                                                                    personId:self.item.authorId
//                                                                                    userType:ALUMNI_USER_TY] autorelease];
//  profileVC.title = LocaleStringForKey(NSAlumniDetailTitle, nil);
//  [self.navigationController pushViewController:profileVC animated:YES];
    
    CommunicationPersonalInfoViewController *vc = [[CommunicationPersonalInfoViewController alloc] initWithMOC:nil parentVC:nil userId:self.item.authorId  withDelegate:self isFromChatVC:FALSE];
    [CommonMethod pushViewController:vc withAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  
  [super tableView:tableView didSelectRowAtIndexPath:indexPath];
  
  switch (indexPath.row) {
    case AUTHOR_CELL:
      [self selectAuthorCell];
      break;
      
    default:
      break;
  }
}

- (CGFloat)contentHeight {
  
  CGFloat textLimitedWidth = self.view.frame.size.width - (MARGIN * 2 + FLAG_SIDE_LEN + MARGIN * 2 + MARGIN * 2);
  
  CGFloat height = MARGIN * 2;
  height += [JSCoreTextView measureFrameHeightForText:self.item.content
                                             fontName:SYS_FONT_NAME
                                             fontSize:15.0f
                                   constrainedToWidth:textLimitedWidth
                                           paddingTop:0
                                          paddingLeft:0];
  
  height += MARGIN * 2;
  
  height += TAG_LIST_HEIGHT;
  
  height += MARGIN * 2;
  
  if (self.item.imageAttached) {
    height += textLimitedWidth;
    
    height += MARGIN * 2;
  }
  
  height += 20.0f;
  
  height += MARGIN * 2;
  
  return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  switch (indexPath.row) {
    case AUTHOR_CELL:      
      return AUTHOR_CELL_HEIGHT;
      
    case CONTENT_CELL:
      return [self contentHeight];
      
    default:
      return 0;
  }
}

#pragma mark - TagSelectionDelegate methods
- (void)selectTagWithName:(Tag *)tag {
//  TagSearchResultViewController *tagSearchResultVC = [[[TagSearchResultViewController alloc] initWithMOC:_MOC tagId:tag.tagId] autorelease];
//  tagSearchResultVC.title = STR_FORMAT(LocaleStringForKey(NSSearchTagTitle, nil), tag.tagName);
//  [self.navigationController pushViewController:tagSearchResultVC animated:YES];
}

#pragma mark - ECClickableElementDelegate methods
- (void)openImageUrl:(NSString *)imageUrl {
  if (imageUrl && [imageUrl length] > 0) {
    ECImageBrowseViewController *imgBrowseVC = [[[ECImageBrowseViewController alloc] initWithImageUrl:imageUrl] autorelease];
    WXWNavigationController *imgBrowseNav = [[[WXWNavigationController alloc] initWithRootViewController:imgBrowseVC] autorelease];
    imgBrowseVC.title = LocaleStringForKey(NSBigPicTitle, nil);
    [self.navigationController presentModalViewController:imgBrowseNav animated:YES];    
  }

}

#pragma mark - ECConnectorDelegate methoes
- (void)connectStarted:(NSString *)url contentType:(NSInteger)contentType {
  
  if (contentType != POST_FAVORITE_ACTION_TY &&
      contentType != POST_UNFAVORITE_ACTION_TY) {
    
    [self showAsyncLoadingView:LocaleStringForKey(NSLoadingTitle, nil)
              blockCurrentView:YES];

  }
  
  [super connectStarted:url contentType:contentType];
}

- (void)connectDone:(NSData *)result url:(NSString *)url contentType:(NSInteger)contentType {
  
  switch (contentType) {
      
    case POST_FAVORITE_ACTION_TY:
    case POST_UNFAVORITE_ACTION_TY:
    {
        ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                          type:contentType
                                                                           MOC:_MOC
                                                             connectorDelegate:self
                                                                           url:url
                                                                       paramID:0];
        
        if(SUCCESS_CODE == ret) {
            
            self.item.isAttention = @(!self.item.isAttention.boolValue);
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(postId == %@)", self.item.postId];
            Post *post = (Post *)[WXWCoreDataUtils fetchObjectFromMOC:_MOC
                                                           entityName:@"Post"
                                                            predicate:predicate];
            
            post.isAttention = self.item.isAttention;
            post.attentionCount = @(self.item.attentionCount.intValue + _attentionOffset);
            SAVE_MOC(_MOC);
            
            [_toolbar updateFavButtonWithStatus:self.item.isAttention.boolValue];
            [_tableView reloadData];
        } else {
            [UIUtils showNotificationOnTopWithMsg:LocaleStringForKey(NSActionFaildMsg, nil)
                                          msgType:ERROR_TY
                               belowNavigationBar:YES];
        }
      
      break;
    }
      
      case SUPPLYDEMAND_SHARE_POST_TY:
      {
          ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                            type:contentType
                                                                             MOC:_MOC
                                                               connectorDelegate:self
                                                                             url:url
                                                                         paramID:0];
          
          if(SUCCESS_CODE == ret) {
              
              NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(postId == %@)", self.item.postId];
              Post *post = (Post *)[WXWCoreDataUtils fetchObjectFromMOC:_MOC
                                                             entityName:@"Post"
                                                              predicate:predicate];
              
              post.shareCount = @(self.item.attentionCount.intValue + 1);
              SAVE_MOC(_MOC);
              
              [_toolbar updateFavButtonWithStatus:self.item.isAttention.boolValue];
              [_tableView reloadData];
          } else {
              [UIUtils showNotificationOnTopWithMsg:LocaleStringForKey(NSActionFaildMsg, nil)
                                            msgType:ERROR_TY
                                 belowNavigationBar:YES];
          }
          
          break;
      }

      case COMMENT_LIST_TY:
      {
          ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                            type:contentType
                                                                             MOC:_MOC
                                                               connectorDelegate:self
                                                                             url:url
                                                                         paramID:0];
          
          
          if(_fetchedRC.fetchedObjects.count==0||isNew==YES)
              [CommonUtils doDelete:_MOC entityName:@"Comment"];
         if(SUCCESS_CODE == ret) {
              
              //[self refreshTable];
              [self loadAndDisplayComment];
              
              // update latest comment count
              if(self.item.commentCount.intValue < [_fetchedRC.fetchedObjects count])
              {
                  self.item.commentCount = [NSNumber numberWithInt:[_fetchedRC.fetchedObjects count]];
                  [WXWCoreDataUtils saveMOCChange:_MOC];
              }
          } else {
              [UIUtils showNotificationOnTopWithMsg:(self.errorMsgDic)[url]
                                     alternativeMsg:LocaleStringForKey(NSLoadCommentFailedMsg, nil)
                                            msgType:ERROR_TY
                                 belowNavigationBar:YES];
          }
          
          _loadingComments = NO;
          
          _autoLoaded = YES;
          
          break;
      }

      case ALUMNI_QUERY_DETAIL_TY:
      {
          ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                            type:contentType
                                                                             MOC:_MOC
                                                               connectorDelegate:self
                                                                             url:url
                                                                         paramID:0];
          
          if(SUCCESS_CODE == ret) {
              NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(userId == %@)", self.item.authorId];
              Alumni *alumni = (Alumni *)[WXWCoreDataUtils fetchObjectFromMOC:_MOC
                                                                   entityName:@"Alumni"
                                                                    predicate:predicate];
              [self openChatListForAlumni:alumni];
          }
          break;
      }

      case DELETE_POST_TY:
      {
          
          [UIUtils closeActivityView];
          
          ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                            type:contentType
                                                                             MOC:_MOC
                                                               connectorDelegate:self
                                                                             url:url
                                                                         paramID:0];
          
          if(SUCCESS_CODE == ret) {
              NSString *name = @"Post";
              
              NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(postId == %@)", self.item.postId];
              DELETE_OBJS_FROM_MOC(_MOC, name, predicate);
              
              [[NSNotificationCenter defaultCenter] postNotificationName:POST_DELETED_NOTIFY
                                                                  object:nil
                                                                userInfo:nil];
              
              [self.navigationController popViewControllerAnimated:YES];
              
              [UIUtils showNotificationOnTopWithMsg:LocaleStringForKey(NSDeleteFeedDoneMsg, nil)
                                            msgType:SUCCESS_TY
                                 belowNavigationBar:YES];
          } else {
              [UIUtils showNotificationOnTopWithMsg:(self.errorMsgDic)[url]
                                     alternativeMsg:LocaleStringForKey(NSDeleteFeedFailedMsg, nil)
                                            msgType:ERROR_TY
                                 belowNavigationBar:YES];
          }
          
          break;
      }
          
      case SEND_COMMENT_TY:
      {
          int ret = [JSONParser parserResponseJsonData:result
                                                  type:contentType
                                                   MOC:_MOC
                                     connectorDelegate:self
                                                   url:url
                                               paramID:0];
          if (ret == SUCCESS_CODE) {
              
              [self loadComments:TRIGGERED_BY_AUTOLOAD forNewComment:YES];
              
              NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(postId == %@)", self.item.postId];
              Post *post = (Post *)[WXWCoreDataUtils fetchObjectFromMOC:_MOC
                                                             entityName:@"Post"
                                                              predicate:predicate];
              
              post.commentCount = @(self.item.commentCount.intValue + 1);
              SAVE_MOC(_MOC);
              
              [UIUtils showNotificationOnTopWithMsg:LocaleStringForKey(NSSendCommentDoneMsg, nil)
                                            msgType:SUCCESS_TY
                                 belowNavigationBar:YES];
              
          } else {
              [UIUtils showNotificationOnTopWithMsg:(self.errorMsgDic)[url]
                                     alternativeMsg:LocaleStringForKey(NSSendCommentFailedMsg, nil)
                                            msgType:ERROR_TY
                                 belowNavigationBar:YES];
          }
          
          [UIUtils closeAsyncLoadingView];
          break;
      }
          
      case DELETE_POST_COMMENTS_TY:
      {
          
          int ret =[JSONParser parserResponseJsonData:result
                                                 type:contentType
                                                  MOC:_MOC
                                    connectorDelegate:self
                                                  url:url
                                              paramID:0];
          
          if (ret == SUCCESS_CODE) {
              
              [self loadComments:TRIGGERED_BY_AUTOLOAD forNewComment:YES];
              
              NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(postId == %@)", self.item.postId];
              Post *post = (Post *)[WXWCoreDataUtils fetchObjectFromMOC:_MOC
                                                             entityName:@"Post"
                                                              predicate:predicate];
              
              post.commentCount = @(self.item.commentCount.intValue - 1);
              SAVE_MOC(_MOC);
              
              [UIUtils showNotificationOnTopWithMsg:LocaleStringForKey(NSDeleteCommentDoneMsg, nil)
                                            msgType:SUCCESS_TY
                                 belowNavigationBar:YES];
              
          } else {
              [UIUtils showNotificationOnTopWithMsg:(self.errorMsgDic)[url]
                                     alternativeMsg:LocaleStringForKey(NSDeleteCommentFailedMsg, nil)
                                            msgType:ERROR_TY
                                 belowNavigationBar:YES];
          }
          
          [UIUtils closeAsyncLoadingView];
          break;
      }
      
      case CLUB_POST_LIST_TY:
      {
          NSInteger ret = [JSONParser parserResponseJsonData:result
                                                        type:contentType
                                                         MOC:_MOC
                                           connectorDelegate:self
                                                         url:url
                                                     paramID:0];
          
          if (ret == SUCCESS_CODE) {
              
              [self refreshTable];
              
          } else {
              [UIUtils showNotificationOnTopWithMsg:(self.errorMsgDic)[url]
                                     alternativeMsg:LocaleStringForKey(NSLoadSupplyDemandFailedMsg, nil)
                                            msgType:ERROR_TY
                                 belowNavigationBar:YES];
          }
          
          [self resetUIElementsForConnectDoneOrFailed];
          
          if (_userFirstUseThisList) {
              _userFirstUseThisList = NO;
          }
          
          break;
      }

    default:
      break;
  }
  
  [super connectDone:result url:url contentType:contentType];
}

- (void)connectCancelled:(NSString *)url contentType:(NSInteger)contentType {
  [super connectCancelled:url contentType:contentType];
}

- (void)connectFailed:(NSError *)error url:(NSString *)url contentType:(NSInteger)contentType {
  
  switch (contentType) {
      
    case LOAD_SUPPLY_DEMAND_ITEM_TY:
    {
      
      if ([self connectionMessageIsEmpty:error]) {
        self.connectionErrorMsg = LocaleStringForKey(NSLoadFeedFailedMsg, nil);
      }
      
    }
      break;
      
    default:
      break;
  }
  
  [super connectFailed:error url:url contentType:contentType];
}


#pragma mark - WXApiDelegate methods
-(void) onResp:(BaseResp*)resp
{
  if([resp isKindOfClass:[SendMessageToWXResp class]]) {
    switch (resp.errCode) {
      case WECHAT_OK_CODE:
        [UIUtils showNotificationOnTopWithMsg:LocaleStringForKey(NSAppShareByWeChatDoneMsg, nil)
                                      msgType:SUCCESS_TY
                           belowNavigationBar:YES];
        break;
        
      case WECHAT_BACK_CODE:
        break;
        
      default:
        [UIUtils showNotificationOnTopWithMsg:LocaleStringForKey(NSAppShareByWeChatFailedMsg, nil)
                                      msgType:ERROR_TY
                           belowNavigationBar:YES];
        break;
    }
  }
  
  ((BaseAppDelegate*)APP_DELEGATE).wxApiDelegate = nil;
}

#pragma mark - WXWImageDisplayerDelegate methods
- (void)saveDisplayedImage:(UIImage *)image {
  self.postImage = image;
}

#pragma mark - UIActionSheetDelegate methods

- (void)actionSheet:(UIActionSheet *)as clickedButtonAtIndex:(NSInteger)buttonIndex {

  if (as.cancelButtonIndex == buttonIndex) {
    return;
  } else if (as.destructiveButtonIndex == buttonIndex) {
    
    _currentType = DELETE_POST_TY;
    
      NSDictionary *paramDict = @{ @"postId":self.item.postId };
      NSString *url =@"http://180.153.154.21:9007/PostService/deletePost";
      
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                              contentType:_currentType];
      
      [connFacade postCommonInfoDic:paramDict url:url];
  }
}

#pragma mark - JSCoreTextViewDelegate methods
- (void)textView:(JSCoreTextView *)textView linkTapped:(AHMarkedHyperlink *)link {
  
  UIWebViewController *webVC = [[UIWebViewController alloc] initWithNeedAdjustForiOS7:YES];
  UINavigationController *webViewNav = [[UINavigationController alloc] initWithRootViewController:webVC];
  webViewNav.navigationBar.tintColor = TITLESTYLE_COLOR;
  webVC.strUrl = link.URL.absoluteString;
  webVC.strTitle = NULL_PARAM_VALUE;
  
  [self.parentViewController presentModalViewController:webViewNav
                                               animated:YES];
  RELEASE_OBJ(webVC);
  RELEASE_OBJ(webViewNav);

}

- (void)loadComments:(LoadTriggerType)triggerType forNewComment:(BOOL)forNewComment {
    
    isNew = forNewComment;
    NSString* displayIndexLast = nil;
    NSString* timeStamp = nil;
    
    if(_fetchedRC.fetchedObjects.count>0 && forNewComment==NO)
    {
        //Post *post = [_fetchedRC objectAtIndexPath:[NSIndexPath indexPathForRow: inSection:0]];
        Comment *comment = [_fetchedRC objectAtIndexPath:[NSIndexPath indexPathForRow:_fetchedRC.fetchedObjects.count-1 inSection:0]];
        
        //Comment *comment = (_fetchedRC.fetchedObjects)[indexPath.row];
        displayIndexLast = [NSString stringWithFormat:@"%d",comment.displayIndex.intValue];
        timeStamp = comment.timestamp;
    } else {
        displayIndexLast = @"";
        timeStamp = @"0";
    }
    
    NSLog(@"self.post.postId=%@",self.item.postId);
    NSDictionary *paramDict = nil;
    switch (triggerType) {
        case TRIGGERED_BY_AUTOLOAD:
        {
            paramDict = @{  @"postId":self.item.postId,
                            @"timestamp":timeStamp,
                            @"pageSize":@"30",
                            @"displayIndexLast":displayIndexLast};
        }
            break;
            
        case TRIGGERED_BY_SCROLL:
        {
            
            paramDict = @{  @"postId":self.item.postId,
                            @"timestamp":timeStamp,
                            @"pageSize":@"30",
                            @"displayIndexLast":displayIndexLast};
        }
            break;
        default:
            break;
    }
    
    _currentType = COMMENT_LIST_TY;
    NSString *url = [CommonUtils geneJSONUrl:paramDict itemType:_currentType];
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                              contentType:_currentType];
    [connFacade asyncGet:url
            showAlertMsg:YES];
}

@end
