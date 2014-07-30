//
//  NSString+Extend.h
//
//  Created by Adam on 14-3-19.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extend)

//http://stackoverflow.com/questions/3423545/objective-c-iphone-percent-encode-a-string/3426140#3426140
//对字符串进行URL编码
+ (NSString *)parserStringEncode:(NSString*)str;

//http://stackoverflow.com/questions/7920071/how-to-url-decode-in-ios-objective-c
//对字符串进行URL解码
+ (NSString *)parserStringDecode:(NSString*)str;

//URL编码
+ (NSString *)parserURLEncode:(NSString*)baseUrl data:(NSDictionary*)dictionary;

//URL解码
+ (NSArray *)parserURLDecode:(NSString *)url;

@end
