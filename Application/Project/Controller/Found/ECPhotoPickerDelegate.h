//
//  ECPhotoPickerDelegate.h
//  Project
//
//  Created by XXX on 11-11-21.
//  Copyright (c) 2011年 _CompanyName_. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ECPhotoPickerDelegate <NSObject>

@required
- (void)selectPhoto:(UIImage *)selectedImage;

@end
