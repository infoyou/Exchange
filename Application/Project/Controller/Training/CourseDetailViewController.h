//
//  CourseDetailViewController.h
//  Project
//
//  Created by Yfeng__ on 13-11-4.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "BaseListViewController.h"
#import "CourseList.h"

@interface CourseDetailViewController : BaseListViewController

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(WXWRootViewController *)PVC
       courseList:(CourseList *)list
     trainingList:(TrainingList *)trainingList;

@end
