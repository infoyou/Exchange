//
//  NSString+Extend.m
//
//  Created by Adam on 14-3-19.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import "NSString+Extend.h"

@implementation NSString (Extend)


+ (NSString *)parserStringEncode:(NSString*)str
{
    NSMutableString * output = [NSMutableString string];
    const unsigned char * source = (const unsigned char *)[str UTF8String];
    int sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

+ (NSString *)parserStringDecode:(NSString*)str
{
    return [[str stringByReplacingOccurrencesOfString:@"+" withString:@" "] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+ (NSString *)parserURLEncode:(NSString*)baseUrl data:(NSDictionary*)dictionary
{
    NSString *url = baseUrl;
    if(url.length > 0)
    {
        url = [url stringByAppendingString:@"?"];
    }
    
    BOOL isFirst = YES;
    for(NSString *key in dictionary.allKeys)
    {
        if(isFirst)
        {
            isFirst = NO;
        }
        else
        {
            url = [url stringByAppendingString:@"&"];
        }
        url = [url stringByAppendingFormat:@"%@=%@", [self parserStringEncode:key], [self parserStringEncode:[dictionary objectForKey:key]]];
    }
    return url;
}

+ (NSArray *)parserURLDecode:(NSString *)url
{
    NSRange range = [url rangeOfString:@"?"];
    if(range.location == NSNotFound)
    {
        return @[url, [NSNull null]];
    }
    
    NSString *baseUrl = [url substringToIndex:range.location - 1];
    NSString *dataUrl = [url substringFromIndex:range.location + 1];
    
    NSArray *parameters = [dataUrl componentsSeparatedByString:@"&"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:parameters.count];
    for(NSString *pa in parameters)
    {
        NSArray *pair = [pa componentsSeparatedByString:@"="];
        NSString *key = [self parserStringDecode:[pair objectAtIndex:0]];
        NSString *val = [self parserStringDecode:[pair objectAtIndex:1]];
        
        [dic setValue:val forKey:key];
    }
    return @[baseUrl, dic];
}

@end
