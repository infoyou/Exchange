//
//  LogUploader.h
//  Project
//
//  Created by XXX on 13-12-3.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogUploader : NSObject{
    
@private
    NSMutableArray *_beDeletedFiles;
    
    NSString *_currentHourTime;
    
    NSString *_deviceModel;
    
    NSInteger _uploadLoopCount;
}

- (void)triggerUpload;
@end
