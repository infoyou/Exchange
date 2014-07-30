//
//  BookListCache.h
//  Project
//
//  Created by XXX on 13-11-22.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXWConnectorDelegate.h"
#import "BookList.h"

@interface BookListCache : NSObject <WXWConnectorDelegate>

- (void)upinsertBookListInfo:(NSArray *)array timestamp:(double)timestamp;
- (double)getLatestBookListTime;

- (BookList *)booklistWithBookId:(int)bookId;
@end
