//
//  TradeInformationContentViewController.h
//  Project
//
//  Created by user on 13-10-10.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "WXWRootViewController.h"
#import "InformationList.h"

@interface TradeInformationContentViewController : WXWRootViewController

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(WXWRootViewController *)pVC
              url:(NSString *)url
      information:(InformationList *)list;

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(WXWRootViewController *)pVC
              url:(NSString *)url
    informationID:(int)informationID;

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(WXWRootViewController *)pVC
              url:(NSString *)url
            title:(NSString *)title
      information:(InformationList *)info;

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(WXWRootViewController *)pVC
              url:(NSString *)url
            title:(NSString *)title
      informationID:(int)informationID;

@end
