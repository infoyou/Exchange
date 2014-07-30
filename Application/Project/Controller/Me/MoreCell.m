//
//  MoreCell.m
//  Project
//
//  Created by user on 13-10-15.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "MoreCell.h"
#import "GlobalConstants.h"

@implementation MoreCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.frame = CGRectMake(10, 0, 300, 44);
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)showRedDot:(BOOL)show
{
    if (show) {
        
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(118, 0, 20, 20)];
    [imageView setImage:IMAGE_WITH_IMAGE_NAME(@"communication_group_cell_pop.png")];
    
        [self addSubview:imageView];
        [imageView release];
    }
}

@end
