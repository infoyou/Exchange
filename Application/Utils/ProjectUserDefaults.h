//
//  ProjectUserDefaults.h
//  Project
//
//  Created by XXX on 13-10-23.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectUserDefaults : NSObject

- (NSString *)passwordRemembered;
- (NSString *)usernameRemembered;
- (NSString *)customerNameRemembered;

- (void)rememberUsername:(NSString *)username
			  andPassword:(NSString *)password;
//o2o
- (void)rememberCustomerName:(NSString *)customerName
                    userName:(NSString *)userName
                    password:(NSString *)password;

@end
