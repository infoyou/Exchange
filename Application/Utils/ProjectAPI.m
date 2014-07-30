//
//  ProjectAPI.m
//  Project
//
//  Created by XXX on 13-10-22.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "ProjectAPI.h"
#import "JSONKit.h"
#import "CommonMethod.h"

@implementation ProjectAPI {
    NSDictionary *_common;
}

static ProjectAPI *instance = nil;

+ (ProjectAPI *)getInstance {
    
    @synchronized(self) {
        if(instance == nil)
            instance = [[super allocWithZone:NULL] init];
    }
    
    return instance;
}

- (void)setCommon:(NSDictionary *)common
{
    _common = [common retain];
}

- (NSDictionary *)getCommon
{
    return _common;
}

+ (NSString *)getRequestURL:(NSString *)apiServiceName withApiName:(NSString *)apiName withCommon:(NSDictionary *)commonDict withSpecial:(NSMutableDictionary *)specialDict
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (commonDict) {
        [dict setObject:commonDict forKey:@"common"];
    }
    if (specialDict) {
        [dict setObject:specialDict forKey:@"special"];
    }
    
    
    NSString *apiPrefix = [specialDict objectForKey:KEY_API_PREFIX];
    [specialDict removeObjectForKey:KEY_API_PREFIX];
    
    NSString *apiContent = [specialDict objectForKey:KEY_API_CONTENT];
    [specialDict removeObjectForKey:KEY_API_CONTENT];
    
    NSString *urlString = @"";
    if (dict.count > 1) {
        urlString = [NSString stringWithFormat:apiContent,apiPrefix,apiServiceName,apiName, [dict JSONString]];
    }else {
        urlString = [NSString stringWithFormat:apiContent,apiPrefix,apiServiceName,apiName];
    }
    DLog(@"requstURL:%@", urlString);
    
    return urlString;
}

+ (NSString *)loadUserSearchHTML5ViewWithParam:(NSDictionary *)dict {
    
    return [NSString stringWithFormat:@"%@/%@%@",VALUE_API_PREFIX, KEY_GETUSERSEARCH_HTML5_URL,[CommonMethod encodeURLWithURL:[dict JSONString]]];
}

+ (NSString *)loadUserInfoCanEditHTML5VuewWithParam:(NSDictionary *)dict {
    return [NSString stringWithFormat:@"%@/%@%@&appname=SAVE&specifiedUserID=5", VALUE_API_PREFIX,KEY_GETUSERSEARCH_HTML5_URL, [CommonMethod encodeURLWithURL:[dict JSONString]]];
}

@end
