//
//  GlobalInfo.m
//  Project
//
//  Created by XXX on 13-6-22.
//  Copyright (c) 2013年 JIT. All rights reserved.
//

#import "GlobalInfo.h"

@implementation GlobalInfo


static GlobalInfo *instance = nil;

+ (GlobalInfo *)getInstance {
    
    @synchronized(self) {
        if(instance == nil)
            instance = [[super allocWithZone:NULL] init];
    }
    
    return instance;
}



+ (CGSize )getDeviceSize
{
    //1、得到当前屏幕的尺寸：
    CGRect rect_screen = [[UIScreen mainScreen] bounds];
    CGSize size_screen = rect_screen.size;
    return size_screen;
}


+ (UIImage *) createImageWithColor: (UIColor *) color withRect:(CGRect )rect
{
    //    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


+ (UIImage *)getCenterImage:(CGRect)rect withImage:(NSString *)imageName
{
#if 1
    UIImage * image = [UIImage imageNamed:imageName];
    UIGraphicsBeginImageContext(rect.size);
    
    NSLog(@"%f:%f", rect.size.height , image.size.height);
    
    int imageHeight = 0;
    int imageWidth = 0;
    int imageStartX = 0;
    int imageStartY = 0;
    float scareX = 1.0f;
    float scareY = 1.0f;
    
    if (rect.size.width - image.size.width > 0.001) {
        imageWidth = image.size.width;
        imageStartX = (rect.size.width - imageWidth ) /2.0;
        scareX = imageWidth * 1.0f / rect.size.width;
    }else{
        imageWidth = rect.size.width;
        imageStartX = 0;
        scareX = imageWidth * 1.0f / rect.size.width;
    }
    
    if (rect.size.height - image.size.height > 0.001) {
        imageHeight = image.size.height;
        imageStartY = (rect.size.height - imageHeight) / 2.0;
        scareY = imageHeight * 1.0f / rect.size.height;
    }else{
        imageHeight = rect.size.height;
        imageStartY = 0;
        scareY = imageHeight * 1.0f / rect.size.height;
    }
    
    NSLog(@"%.2f:%.2f", scareX, scareY);
    
    [image  drawInRect:CGRectMake(imageStartX, imageStartY, imageWidth, imageHeight)];
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return theImage;
#elif 0

    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    [[UIImage imageNamed:@"coupon_cal_background.png"]  drawInRect:CGRectMake(0, 0, BULKLOAD_BOARD_VIEW_WIDTH, BULKLOAD_BOARD_VIEW_HEIGHT)];

    
    
    CGContextBeginPath(context);//标记
    
    
        [[UIImage imageNamed:@"arrow_cal_left.png"]  drawInRect:CGRectMake(20, 55, 23, 22)];

    
    CGContextClosePath(context);//路径结束标志，不写默认封闭
    [[UIColor whiteColor] setFill];
    [[UIColor blackColor] setStroke];
    CGContextDrawPath(context, kCGPathFill);//绘制路径path
        
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    

    
#endif
}


@end