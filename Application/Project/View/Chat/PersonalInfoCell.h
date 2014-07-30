//
//  PersonalInfoCell.h
//  Project
//
//  Created by user on 13-9-25.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GHImageView.h"

typedef enum {
    CellStyle_Header = 1 << 5,
    CellStyle_Content
}CellStyle;

typedef enum {
    IndexFlag_Top = 1 << 3,
    IndexFlag_Middle,
    IndexFlag_Bottom
}IndexFlag;

#define PERSONAL_INFO_CELL_HEIGHT   110.0f

#define HEADER_IMAGE_WIDTH  70.f
#define HEADER_IMAGE_HEIGHT 70.f

#define FONT_NAMELABEL [UIFont systemFontOfSize:20]
#define FONT_TITLE     [UIFont systemFontOfSize:18]
#define FONT_SUBTITLE  [UIFont systemFontOfSize:16]

#define LABEL_WIDTH  280.f

@interface PersonalInfoCell : UITableViewCell

@property (nonatomic, retain) GHImageView *headerImage;
@property (nonatomic, retain) UILabel *nameLabel;

@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *subTitLabel;

@property (nonatomic, assign) CellStyle cellStyle;
@property (nonatomic, assign) IndexFlag indexFlag;

- (id)initWithStyle:(CellStyle)style reId:(NSString *)reuseIdentifier ;

- (void)setBackgroundImageWithIndexFlag:(IndexFlag)indexFlag;

- (void)updateHeaderImageWithImageURL:(NSString *)imageURL;

@end
