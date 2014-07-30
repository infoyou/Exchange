//
//  DataProvider.h
//  Product
//
//  Created by XXX on 13-10-15.
//  Copyright (c) 2013年 _CompanyName_. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXWConnectorDelegate.h"

@interface DataProvider : NSObject <WXWConnectorDelegate> {
  
}

@property (nonatomic, retain) NSManagedObjectContext *MOC;

@property (nonatomic, copy) NSString *sessionId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *hostUrl;
@property (nonatomic, copy) NSString *personId;
@property (nonatomic, copy) NSString *deviceConnectionIdentifier;


+ (DataProvider *)instance;

#pragma mark - prepare
- (void)signIn;

@end
