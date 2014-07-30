//
//  ProjectAPI.h
//  Project
//
//  Created by XXX on 13-10-22.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalConstants.h"

#define KEY_API_DATA              @"data"
#define KEY_API_COMMON            @"common"
#define KEY_API_SPECIAL           @"special"
#define KEY_API_INVOKETYPE        @"invokeType"
#define KEY_API_SPECIFIEDUSERID   @"specifiedUserID"
#define KEY_API_PROPERTYVALUELIST @"propertyValueList"

#define KEY_GETUSERLIST_URL @"UserService/UserProfile"
#define KEY_GETUSERSEARCH_HTML5_URL @"/WebView/index.html?getDataApiName=UserProfile&submitDataApiName=UserProfile&ReqContent="

//#define KEY_UPLOAD_IMAGE_URL @"http://180.153.154.21:9001/UploadImage.aspx"
#define KEY_UPLOAD_IMAGE_URL @"http://112.124.68.147:5000/UploadImage.aspx"

#if APP_TYPE == APP_TYPE_BASE
#define VALUE_API_PREFIX   @"http://112.124.68.147:5002"

//CIO
#elif APP_TYPE == APP_TYPE_CIO
#define VALUE_API_PREFIX   @"http://112.124.68.147:5012"

//iAlumniUSA
#elif APP_TYPE == APP_TYPE_IALUMNIUSA
#define VALUE_API_PREFIX   @"http://112.124.68.147:5022"

//iNearby
#elif APP_TYPE == APP_TYPE_INEARBY
#define VALUE_API_PREFIX   @"http://112.124.68.147:5038"

//YIMA
#elif APP_TYPE == APP_TYPE_YIMA
#define VALUE_API_PREFIX   @"http://112.124.68.147:5052"

//FOSUN
#elif APP_TYPE == APP_TYPE_FOSUN
//#define VALUE_API_PREFIX   @"http://112.124.68.147:5058" // Publish
#define VALUE_API_PREFIX @"http://mo.fosun.com:5036" // Exchange Publish

//O2O
#elif APP_TYPE == APP_TYPE_O2O
#define VALUE_API_PREFIX   @"http://112.124.68.147:5008"

//default is jit- test
#else
#define VALUE_API_PREFIX   @"http://112.124.68.147:5008"
#endif //if APP_TYPE


#define KEY_API_PREFIX     @"keyApiURL"

#define VALUE_API_CONTENT  @"%@/%@/%@?ReqContent=%@"
#define KEY_API_CONTENT    @"keyApiPrefix"


#define KEY_API_NAME    @"apiName"
#define KEY_API_PARAM   @"apiParam"

//--------------------common service---------------
//用于获取登录前数据
#define API_SERVICE_COMMON @"CommonService"

#define API_NAME_GET_VERSION    @"version"

#define API_NAME_MESSAGE_GET @"messageGet"

//--------------------api name-------------------
#define API_SERVICE_CHAT_GROUP                @"chatgroupService"
//获取群组列表
#define API_NAME_GET_CHAT_GROUP               @"GetChatGroup"
//加入某群组
#define API_NAME_JOIN_CHAT_GROUP              @"JoinChatGroup"
//创建群组
#define API_NAME_CREATE_CHAT_GROUP      @"CreateChatGroup"
//退出群组
#define API_NAME_QUIT_CHAT_GROUP              @"QuitChatGroup"
//删除群组
#define API_NAME_DELETE_CHAT_GROUP              @"DeleteChatGroup"
//更新群组信息
#define API_NAME_UPDATE_CHAT_GROUP           @"UpdateChatGroup"
//获取群组成员列表
#define API_NAME_GET_CHAT_GROUP_USER          @"GetChatGroupUser"
//私信人员列表
#define API_NAME_GET_PRIVATE_LETTER_USER_LIST @"GetPrivateLetterUserList"
//提交私信
#define API_NAME_SUBMIT_PRIVATE_LETTER        @"SubmitPrivateLetter"

#define API_NAME_SET_USER_LOGIN_LICALL        @"SetUserLoginLicall"

#define API_SERVICE_USER        @"UserService"
#define API_NAME_USER_PROFILE   @"UserProfile"
#define API_NAME_USER_SIGN_IN   @"signIn"
#define API_NAME_USER_FEEDBACK  @"feedback"
#define API_NAME_USER_SPECIFIELD_USER_ID    @"specifiedUserID"
#define API_NAME_USER_PASSWORD  @"password"

//发现
#define API_NAME_NEARBY_USER   @"GetUserNearby"


#define API_SERVICE_INFORMATION               @"InformationService"
#define API_NAME_GET_INFORMATION_LIST         @"List"
#define API_NAME_GET_INFORMATION_SIDEIMAGE    @"SlideImage"
#define API_NAME_GET_INFORMATION_CATEGORY     @"Category"
#define API_NAME_UPDATE_INFORMATION_READER    @"Reader"  //更新读者数

//圈层营销
#define API_SERVICE_EVENT                   @"EventService"
//活动列表
#define API_NAME_GET_EVENT_LIST             @"GetEventList"
//活动投票列表
#define API_NAME_GET_EVENT_VOTE_LIST        @"GetEventVoteList"
//提交活动投票选项
#define API_NAME_SUBMIT_EVENT_VOTE_OPTION   @"SubmitEventVoteOption"
//活动报名人员列表
#define API_NAME_GET_EVENT_APPLY_USER_LIST  @"GetEventApplyUserList"
//活动评论列表
#define API_NAME_GET_EVENT_COMMENT_LIST     @"GetEventCommentList"
//提交活动评论
#define API_NAME_SUBMIT_EVENT_COMMENT       @"SubmitEventComment"
//提交活动报名信息
#define API_NAME_SUBMIT_EVENT_APPLY_INFO    @"SubmitEventApplyInfo"
//活动详细
#define API_NAME_GET_EVENT_DETAIL           @"GetEventDetail"

#define API_SERVICE_PROJECT   @""

//获取项目明细1
#define API_NAME_GET_DETAIL_PAGE1   @"GetDetailPage1"

//======================training============================
#define API_SERVICE_TRAINING                   @"TrainingService"

//培训列表
#define API_NAME_GET_TRAINING_LIST  @"CategoryCourse" //GET

//课程详情
#define API_NAME_GET_TRAINING_COURSE_DETAIL @"CourseChapter" //GET
//章节完成度
#define API_NAME_GET_TRAINING_CHAPTER_SCHEDULE  @"ChapterCompletion" //POST

//====================EVENT PARAM==================

#define KEY_API_PARAM_EVENT_ID           @"eventId"
#define KEY_API_PARAM_APPLY_LIST         @"applyList"
#define KEY_API_PARAM_APPLY_ID           @"applyId"
#define KEY_PAI_PARAM_APPLY_TITLE        @"applyTitle"
#define KEY_API_PARAM_APPLY_RESULT       @"applyResult"
#define KEY_API_PARAM_EVENTS_TYPE        @"eventsType"
#define KEY_API_PARAM_CONTENT            @"content"
#define KEY_API_PARAM_VOTE_ID            @"voteId"
#define KEY_API_PARAM_OPTION_ID          @"optionId"
#define KEY_API_PARAM_TIME_STAMP         @"timestamp"
#define KEY_API_PARAM_DISPLAY_INDEX_LAST @"displayIndexLast"

//====================api param====================

#define KEY_API_PARAM_PAGE_NO       @"pageNo"
#define KEY_API_PARAM_TYPE          @"type"
#define KEY_API_PARAM_USERID        @"userId"
#define KEY_API_PARAM_USERIDLIST    @"userIDList"
#define KEY_API_PARAM_GROUP_NAME    @"groupName"
#define KEY_API_PARAM_FEEDBACK      @"feedback"
#define KEY_API_PARAM_OLD_PWD       @"oldPassword"
#define KEY_API_PARAM_NEW_PWD       @"newPassword"

//--------------------Course-----------------------
#define KEY_API_PARAM_COURSE_ID    @"courseID"
#define KEY_API_PARAM_CHAPTER_ID   @"chapterID"
#define KEY_API_PARAM_COMPLETION   @"completion"

//--------------------GetChatGroup-----------------

#define KEY_API_PARAM_PAGE_NO       @"pageNo"
#define KEY_API_PARAM_GROUP_TPE     @"groupType"
#define KEY_API_PARAM_GROUP_ID      @"groupId"
#define KEY_API_PARAM_GROUP_NAME @"groupName"
#define KEY_API_PARAM_GROUP_IMAGE  @"groupImage"
#define KEY_API_PARAM_GROUP_DESCRIPTION @"groupDescription"
#define KEY_API_PARAM_GROUP_PHONE   @"groupPhone"
#define KEY_API_PARAM_GROUP_EMAIL   @"groupEmail"
#define KEY_API_PARAM_GROUP_INVITATION_PUBLIC_LEVEL @"invitationPublicLevel"
#define KEY_API_PARAM_GROUP_WEBSITE @"groupWebsite"


//--------------------GetInformationList-----------
#define KEY_API_PARAM_START_TIME       @"startTime"
#define KEY_API_PARAM_END_TIME         @"endTime"
#define KEY_API_PARAM_INFORTMATION_ID   @"informationID"
#define KEY_API_PARAM_INFORMATION_TYPE @"informationType"
#define KEY_API_PARAM_SPECIAL_CATEGORY_ID   @"specifiedCategoryID"
#define KEY_API_PARAM_SPECIFIED_ID     @"specifiedID"
#define KEY_API_PARAM_COMMENTTYPE      @"commentType"
#define KEY_API_PARAM_IMAGE_TYPE       @"ImageType"

#define KEY_API_PARAM_KEYWORD          @"keyword"
//#define KEY_API_PARAM_IMAGETYPE        @"imageType"
#define KEY_API_PARAM_CATEGORY_TYPE    @"categoryType"
#define KEY_API_PARAM_OBJECT_ID        @"objectID"
#define KEY_API_PARAM_LEVEL            @"level"

#define KEY_API_PARAM_PROJECT_ID    @"projectId"

//--------------------get order list----------------- o2o

#define O2O_SERVER_BASE_URL          @"http://www.o2omarketing.cn:9012/"
#define API_SERVICE_O2O              @"http://www.o2omarketing.cn:9004/Pad/data.aspx"
#define KEY_API_NAME_GET_ORDER_LIST  @"getOrderList"
#define KEY_API_NAME_GET_USER_MESSAGE_LIST @"GetUserMessageList"
#define KEY_API_SUBMIT_UER_MESSAGE   @"SetUserMessageData"
#define KEY_API_SET_IOS_DEVICE_TOKEN @"setIOSDeviceToken"

#define KEY_API_PARAM_CUSTOMER_ID    @"customerId"  //客户标识
#define KEY_API_PARAM_PAGE           @"page"        //页码
#define KEY_API_PARAM_PAGE_SIZE      @"pageSize"    //页面数量
#define KEY_API_PARAM_STATUS         @"status"      //状态 1未付款/2待处理/3已发货/0已取消 /可为空（获取所有）
#define KEY_API_PARAM_DISPLAY_INDEX_LAST @"displayIndexLast"
#define KEY_API_PARAM_UNIT_ID        @"unitId"
#define KEY_API_PARAM_USER_ID        @"userId"

//================== weixin share ===================

#define SHARE_WEIXIN_APPID   @"wxaf2414de75f47280"
#define SHARE_WEIXIN_APPKEY  @"266e26e26a06a36d3111913daeae69b3"


@interface ProjectAPI : NSObject
+ (ProjectAPI *)getInstance;

- (void)setCommon:(NSDictionary *)common;
- (NSDictionary *)getCommon;

+ (NSString *)getRequestURL:(NSString *)apiServiceName withApiName:(NSString *)apiName withCommon:(NSDictionary *)commonDict withSpecial:(NSMutableDictionary *)specialDict;


+ (NSString *)loadUserSearchHTML5ViewWithParam:(NSDictionary *)dict;
+ (NSString *)loadUserInfoCanEditHTML5VuewWithParam:(NSDictionary *)dict;

@end
