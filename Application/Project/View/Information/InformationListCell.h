//
//  InformationListCell.h
//  Project
//
//  Created by user on 13-10-9.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTextBoardCell.h"

#define CELL_W  320.f
#define CELL_H  60.0f
@class InformationList;
@interface InformationListCell : BaseTextBoardCell {
    
}

@property (nonatomic, retain) WXWLabel *titleLabel;
@property (nonatomic, retain) WXWLabel *dateLabel;
@property (nonatomic, copy) NSString *zipURL;
@property (nonatomic, assign) NSInteger informationID;

- (void)drawInformationList:(InformationList *)infoList;

@end
