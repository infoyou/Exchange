//
//  Alumni.h
//  Project
//
//  Created by XXX on 13-12-16.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Alumni : NSManagedObject

@property (nonatomic, retain) NSNumber * allKnownAlumniCount;
@property (nonatomic, retain) NSNumber * alumniType;
@property (nonatomic, retain) NSString * approvedByName;
@property (nonatomic, retain) NSString * approvedTime;
@property (nonatomic, retain) NSString * bio;
@property (nonatomic, retain) NSNumber * bizCardAuthStatus;
@property (nonatomic, retain) NSString * bizCardImageUrl;
@property (nonatomic, retain) NSNumber * bySearch;
@property (nonatomic, retain) NSNumber * checkinTime;
@property (nonatomic, retain) NSString * classGroupName;
@property (nonatomic, retain) NSString * classmate;
@property (nonatomic, retain) NSString * classTeacher;
@property (nonatomic, retain) NSString * companyAddress;
@property (nonatomic, retain) NSString * companyAddressC;
@property (nonatomic, retain) NSString * companyAddressE;
@property (nonatomic, retain) NSString * companyCity;
@property (nonatomic, retain) NSString * companyCountryC;
@property (nonatomic, retain) NSString * companyCountryE;
@property (nonatomic, retain) NSString * companyFax;
@property (nonatomic, retain) NSString * companyName;
@property (nonatomic, retain) NSString * companyPhone;
@property (nonatomic, retain) NSString * companyProvince;
@property (nonatomic, retain) NSNumber * containerType;
@property (nonatomic, retain) NSString * courseId;
@property (nonatomic, retain) NSString * courseName;
@property (nonatomic, retain) NSString * createTime;
@property (nonatomic, retain) NSString * currentCity;
@property (nonatomic, retain) NSNumber * degreeCertAuthStatus;
@property (nonatomic, retain) NSString * degreeCertImageUrl;
@property (nonatomic, retain) NSString * distance;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * emailScope;
@property (nonatomic, retain) NSNumber * endorsementCount;
@property (nonatomic, retain) NSString * endorsementNameInfo;
@property (nonatomic, retain) NSString * feePaid;
@property (nonatomic, retain) NSString * feeToPay;
@property (nonatomic, retain) NSString * firstNamePinyinChar;
@property (nonatomic, retain) NSNumber * groupId;
@property (nonatomic, retain) NSString * hasApplied;
@property (nonatomic, retain) NSString * hobby;
@property (nonatomic, retain) NSString * hometown;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSString * industryId;
@property (nonatomic, retain) NSString * industryName;
@property (nonatomic, retain) NSString * isAdmin;
@property (nonatomic, retain) NSString * isApprove;
@property (nonatomic, retain) NSNumber * isCheckIn;
@property (nonatomic, retain) NSNumber * isEndorsement;
@property (nonatomic, retain) NSNumber * isFriend;
@property (nonatomic, retain) NSNumber * isLastMessageFromSelf;
@property (nonatomic, retain) NSString * isMember;
@property (nonatomic, retain) NSString * jobTitle;
@property (nonatomic, retain) NSNumber * joinedGroupCount;
@property (nonatomic, retain) NSString * lastLoginTime;
@property (nonatomic, retain) NSString * lastMsg;
@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * linkedIn;
@property (nonatomic, retain) NSNumber * linkedInScope;
@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) NSString * memberLevel;
@property (nonatomic, retain) NSString * middleUrl;
@property (nonatomic, retain) NSString * mobile;
@property (nonatomic, retain) NSNumber * mobileScope;
@property (nonatomic, retain) NSNumber * notReadMsgCount;
@property (nonatomic, retain) NSNumber * orderId;
@property (nonatomic, retain) NSString * plat;
@property (nonatomic, retain) NSString * refuseInfo;
@property (nonatomic, retain) NSNumber * relationshipType;
@property (nonatomic, retain) NSString * schoolId;
@property (nonatomic, retain) NSString * schoolInfo;
@property (nonatomic, retain) NSString * shakePlace;
@property (nonatomic, retain) NSString * shakeThing;
@property (nonatomic, retain) NSString * sinaWeibo;
@property (nonatomic, retain) NSString * startYearId;
@property (nonatomic, retain) NSString * startYearName;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * supplyDemandMsg;
@property (nonatomic, retain) NSString * supplyDemandNumber;
@property (nonatomic, retain) NSString * tableInfo;
@property (nonatomic, retain) NSString * thumbnailUrl;
@property (nonatomic, retain) NSString * time;
@property (nonatomic, retain) NSString * travelCities;
@property (nonatomic, retain) NSString * userClassName;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * userType;
@property (nonatomic, retain) NSString * version;
@property (nonatomic, retain) NSNumber * weChatScope;
@property (nonatomic, retain) NSNumber * weiboScope;
@property (nonatomic, retain) NSString * weiXin;
@property (nonatomic, retain) NSNumber * withMeConnectionCount;

@end
