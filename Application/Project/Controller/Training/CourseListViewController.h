//
//  CourseListViewController.h
//  Project
//
//  Created by Yfeng__ on 13-11-1.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "BaseListViewController.h"
#import "TrainingList.h"


@protocol CourseListViewControllerDelegate;
@interface CourseListViewController : BaseListViewController

@property (nonatomic, assign) id<CourseListViewControllerDelegate> delegate;

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(WXWRootViewController *)PVC
     trainingList:(TrainingList *)trainingList;

@end

@protocol CourseListViewControllerDelegate <NSObject>

-(void)reloadCourseList:(LoadTriggerType)triggerType forNew:(BOOL)forNew;

@end
