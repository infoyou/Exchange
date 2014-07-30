//
//  ECItemUploaderDelegate.h
//  Project
//
//  Created by XXX on 11-11-22.
//  Copyright (c) 2011年 _CompanyName_. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalConstants.h"

@protocol ECItemUploaderDelegate <NSObject>

@required
- (void)afterUploadFinishAction:(WebItemType)actionType;

@end
