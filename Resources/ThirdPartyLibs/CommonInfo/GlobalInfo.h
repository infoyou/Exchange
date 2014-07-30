//
//  GlobalInfo.h
//  Project
//
//  Created by XXX on 13-6-22.
//  Copyright (c) 2013年 JIT. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KEY_VIEW_CONTROLLER @"viewController"
#define KEY_NAME    @"name"
#define KEY_IMAGE_NORMAL   @"imageNormal"
#define KEY_IMAGE_SELECTED   @"imageSelected"


//#define FONT_SYSTEM_SIZE(size) [UIFont systemFontOfSize:size]
//#define FONT_BOLD_SYSTEM_SIZE(size) [UIFont boldSystemFontOfSize:size]

//-----------------
#define LOADING_TIP    @"加载中，请稍后！"

//---------------------------------------

#define TEXT_WARM_TIP    @"温馨提示"


//---------------------------------------

#define CELL_TOP_HEIGHT 7
#define CELL_HEIGHT (61 + CELL_TOP_HEIGHT)
#define TABEL_VIEW_DIST_X_WIDTH 10

#define TOP_BUTTON_HEIGHT   33
#define CALL_PHONE_BUTTON_WIDTH 13

#define CELL_INFO_FONT_SIZE 15
#define CELL_MEMBER_INFO_FONT_SIZE 14


//-----

#define TAB_HEIGHT 44
#define TAB_TOP_SCROLL_HEIGHT   4
#define TOP_BUTTON_LINE_WIDTH 1

@interface GlobalInfo : NSObject

+ (GlobalInfo *)getInstance;
+ (CGSize )getDeviceSize;
+ (UIImage *) createImageWithColor: (UIColor *) color withRect:(CGRect )rect;
+ (UIImage *)getCenterImage:(CGRect)rect withImage:(NSString *)imageName;

@property (nonatomic, assign) float monthlySchedule;

@end
