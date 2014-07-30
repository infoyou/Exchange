//
//  MyMessageCell.m
//  Project
//
//  Created by XXX on 13-11-28.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "MyMessageCell.h"
#import "UIColor+expanded.h"

@implementation MyMessageCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initControl];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
 */
-(void)initControl
{
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,MORE_CELL_HEIGHT - 1, self.contentView.frame.size.width, 1)];
    [lineLabel setBackgroundColor:[UIColor colorWithHexString:@"0xc8c7cc"]];
    [self addSubview:lineLabel];
    [lineLabel release];
}


@end
