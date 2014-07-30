//
//  UPOMP.h
//  UPOMP
//
//  Created by pei xunjun on 12-3-6.
//  Copyright (c) 2012年 _MyCompanyName_. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UPOMPDelegate<NSObject>
@required
-(void)viewClose:(NSData*)data;
@end

@interface UPOMP : UIViewController{
}
- (void)setXmlData:(NSData*)data;
- (void)closeView:(NSData*)data;
@property (nonatomic, assign) id <UPOMPDelegate> viewDelegate;
@end
