//
//  CaseViewController.h
//  Project
//
//  Created by user on 13-10-8.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXWRootViewController.h"
#import "ChildSubCategory.h"

typedef enum {
    CellType_OnlyTitle = 100,
    CellType_WithDate
}CellType;

@interface CaseViewController : WXWRootViewController

- (id)initWithRootCategory:(ChildSubCategory *)rc cellType:(CellType)ctype;

@end
