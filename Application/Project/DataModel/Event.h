//
//  Event.h
//
//  Created by Adam on 14-3-19.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Event : NSManagedObject

@property (nonatomic, retain) NSString * actionStr;
@property (nonatomic, retain) NSNumber * actionType;
@property (nonatomic, retain) NSNumber * actualPaid;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSNumber * backed;
@property (nonatomic, retain) NSNumber * backerCount;
@property (nonatomic, retain) NSNumber * checkinCount;
@property (nonatomic, retain) NSString * checkinMsg;
@property (nonatomic, retain) NSNumber * checkinNumber;
@property (nonatomic, retain) NSNumber * checkinResultType;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSNumber * commentCount;
@property (nonatomic, retain) NSString * contact;
@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSNumber * dateCategory;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSNumber * eventId;
@property (nonatomic, retain) NSNumber * fake;
@property (nonatomic, retain) NSNumber * fee;
@property (nonatomic, retain) NSNumber * hasAward;
@property (nonatomic, retain) NSNumber * hasSignedUp;
@property (nonatomic, retain) NSString * hostId;
@property (nonatomic, retain) NSString * hostImg;
@property (nonatomic, retain) NSString * hostName;
@property (nonatomic, retain) NSString * hostSubTypeValue;
@property (nonatomic, retain) NSString * hostType;
@property (nonatomic, retain) NSString * hostTypeValue;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSNumber * intervalDayCount;
@property (nonatomic, retain) NSNumber * languageType;
@property (nonatomic, retain) NSString * latestPostContent;
@property (nonatomic, retain) NSString * latestPostElapsedTime;
@property (nonatomic, retain) NSString * latestPoster;
@property (nonatomic, retain) NSNumber * latestPostTimestamp;
@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) NSString * membershipScope;
@property (nonatomic, retain) NSString * monthDayInfo;
@property (nonatomic, retain) NSString * monthWeekInfo;
@property (nonatomic, retain) NSNumber * needSignUp;
@property (nonatomic, retain) NSString * orderId;
@property (nonatomic, retain) NSString * orderTitle;
@property (nonatomic, retain) NSString * payOrderId;
@property (nonatomic, retain) NSNumber * postCount;
@property (nonatomic, retain) NSNumber * requirementType;
@property (nonatomic, retain) NSNumber * screenType;
@property (nonatomic, retain) NSNumber * showOrder;
@property (nonatomic, retain) NSNumber * signupCount;
@property (nonatomic, retain) NSString * signupMsg;
@property (nonatomic, retain) NSString * skuMsg;
@property (nonatomic, retain) NSString * sponsorMsg;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSNumber * surveyEditable;
@property (nonatomic, retain) NSString * tableInfo;
@property (nonatomic, retain) NSString * tel;
@property (nonatomic, retain) NSString * time;
@property (nonatomic, retain) NSString * timeStr;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * winnerCount;
@property (nonatomic, retain) NSString * winnerMsg;

@end
