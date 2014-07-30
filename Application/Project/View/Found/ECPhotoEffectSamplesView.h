//
//  ECPhotoEffectSamplesView.h
//  Project
//
//  Created by XXX on 12-1-12.
//  Copyright (c) 2012年 _MyCompanyName_. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalConstants.h"

@interface ECPhotoEffectSamplesView : UIView {
@private
  id _target;
  SEL _action;
  
  UIScrollView *_samplesContainer;
  
  NSMutableDictionary *_effectedPhotos;
  
  NSMutableArray *_buttons;
}

- (id)initWithFrame:(CGRect)frame
      originalImage:(UIImage *)originalImage 
             target:(id)target 
             action:(SEL)action;

@end
