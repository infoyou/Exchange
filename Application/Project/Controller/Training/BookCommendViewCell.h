//
//  BookCommendViewCell.h
//  Project
//
//  Created by Yfeng__ on 13-11-1.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "ECImageConsumerCell.h"
#import "BookList.h"

#define BOOK_COMMEND_DEFAULT_HEIGHT 275.f / 2 + 10.f
#define LABEL_WIDTH 183.f

@interface BookCommendViewCell : ECImageConsumerCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (void)drawBookCommendCell:(BookList *)bookList;

@end
