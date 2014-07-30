//
//  Comment.h
//  Project
//
//  Created by XXX on 13-12-26.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Comment : NSManagedObject

@property (nonatomic, retain) NSString * authorId;
@property (nonatomic, retain) NSString * authorImageUrl;
@property (nonatomic, retain) NSString * authorName;
@property (nonatomic, retain) NSString * authorPicUrl;
@property (nonatomic, retain) NSString * authorSchoolInfo;
@property (nonatomic, retain) NSString * authorType;
@property (nonatomic, retain) NSString * commentId;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * createTime;
@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSNumber * displayIndex;
@property (nonatomic, retain) NSString * elapsedTime;
@property (nonatomic, retain) NSNumber * imageAttached;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSString * locationName;
@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSNumber * middleImageHeight;
@property (nonatomic, retain) NSString * middleImageUrl;
@property (nonatomic, retain) NSNumber * middleImageWidth;
@property (nonatomic, retain) NSNumber * originalImageHeight;
@property (nonatomic, retain) NSString * originalImageUrl;
@property (nonatomic, retain) NSNumber * originalImageWidth;
@property (nonatomic, retain) NSNumber * parentId;
@property (nonatomic, retain) NSNumber * thumbnailHeight;
@property (nonatomic, retain) NSString * thumbnailImageUrl;
@property (nonatomic, retain) NSString * thumbnailUrl;
@property (nonatomic, retain) NSNumber * thumbnailWidth;
@property (nonatomic, retain) NSString * timestamp;

@end
