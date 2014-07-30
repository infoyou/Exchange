//
//  GroupMemberInfo.m
//  Project
//
//  Created by XXX on 13-9-27.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "GroupMemberInfo.h"

@implementation GroupMemberInfo

@synthesize userId;
@synthesize userName;
@synthesize imageUrl;
@synthesize schoolInfo;
@synthesize companyName;
@synthesize jobTitle;
@synthesize displayIndex;

-(NSString *)description {
    NSString *result = [NSString stringWithFormat:@"userId:%@ userName:%@ imageUrl:%@ schoolInfo:%@ companyName:%@ jobTitle:%@ displayIndex:%@", self.userId, self.userName, self.imageUrl, self.schoolInfo, self.companyName, self.jobTitle, self.displayIndex];
    
    return result;
}
@end
