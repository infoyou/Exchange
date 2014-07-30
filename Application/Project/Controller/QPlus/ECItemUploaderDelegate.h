//
//  ECItemUploaderDelegate.h
//  Project
//
//  Created by XXX on 13-10-29.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalConstants.h"

@protocol ECItemUploaderDelegate <NSObject>

@required
- (void)afterUploadFinishAction:(WebItemType)actionType;
@end
