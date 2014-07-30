//
//  BizListCell.m
//  Project
//
//  Created by user on 13-9-24.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "BizListCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+expanded.h"
#import "GlobalConstants.h"
#import "CommonHeader.h"
#import "CommunicationPersonalInfoViewController.h"
#import "Post.h"
#import "WXWLabel.h"
#import "TextPool.h"
#import "SupplyDemandItemViewController.h"

#define CELL_HEIGHT   88.0 + 14.0f

#define FLAG_SIDE_LEN 42.0f

#define ICON_SIDE_LEN  16.0f

#define TAG_FONT_SIZE 12

CellMargin SupplyDemandSRCM = {10.f, 10.f, 10.f, 10.f};

@interface BizListCell()
{
    UIImageView *_flagIcon;
    WXWLabel *_nameLabel;
    WXWLabel *_classLabel;
    WXWLabel *_timeline;
    WXWLabel *_contentLabel;
    WXWLabel *_createdAtLabel;
    UIImageView *_tagIcon;
}

@property (nonatomic, retain) NSMutableArray *buttons;

@end

@implementation BizListCell {
    Post *post;
}

- (CGFloat)cellHeight {
    return 85.f;
}

- (CGFloat)cellWidth {
    return 320.f;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // Initialization code
        [self initSubViews];
        
//        [CommonMethod viewAddGuestureRecognizer:self withTarget:self withSEL:@selector(viewTapped:)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.frame];
        imageView.image = IMAGE_WITH_IMAGE_NAME(@"communication_group_list_cell_background.png");
        self.backgroundView = imageView;
        [imageView release];
        
    }
    return self;
}

-(void)prepareForReuse
{
    
    _nameLabel.text = @"";
    _classLabel.text = @"";
    _timeline.text = @"";
    _createdAtLabel.text = @"";
}

- (void)viewTapped:(UISwipeGestureRecognizer *)recognizer
{
    CommunicationPersonalInfoViewController *vc = [[CommunicationPersonalInfoViewController alloc] initWithMOC:nil parentVC:nil userId:post.authorId  withDelegate:self isFromChatVC:FALSE];
    [CommonMethod pushViewController:vc withAnimated:YES];
}

- (void)initSubViews {
    
    // set name Label
    _nameLabel = [[[WXWLabel alloc] initWithFrame:CGRectZero
                        textColor:[UIColor blackColor]
                      shadowColor:[UIColor whiteColor]] autorelease];
    _nameLabel.font = BOLD_FONT(14);
    _nameLabel.lineBreakMode = UILineBreakModeTailTruncation;
    [self.contentView addSubview:_nameLabel];
    
    // set _classLabel
    _classLabel = [[[WXWLabel alloc]  initWithFrame:CGRectZero
                         textColor:[UIColor darkGrayColor]
                       shadowColor:[UIColor whiteColor]] autorelease];
    [_classLabel setFont:FONT(13)];
    [self.contentView addSubview:_classLabel];
    
    _timeline = [[[WXWLabel alloc]  initWithFrame:CGRectZero
                       textColor:BASE_INFO_COLOR
                     shadowColor:[UIColor whiteColor]] autorelease];
    _timeline.font = FONT(10);
    [self.contentView addSubview:_timeline];
    
    _contentLabel = [[[WXWLabel alloc]  initWithFrame:CGRectZero
                           textColor:DARK_TEXT_COLOR
                         shadowColor:[UIColor whiteColor]] autorelease];
    _contentLabel.font = BOLD_FONT(14);
    _contentLabel.numberOfLines = 1;
    _contentLabel.lineBreakMode = UILineBreakModeTailTruncation;
    [self.contentView addSubview:_contentLabel];
    
    _tagIcon = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tag.png"]] autorelease];
    _tagIcon.frame = CGRectMake(MARGIN * 2 + FLAG_SIDE_LEN + MARGIN * 2, MARGIN * 2 + FLAG_SIDE_LEN + MARGIN, ICON_SIDE_LEN, ICON_SIDE_LEN);
    [self.contentView addSubview:_tagIcon];
    
    // create
    _createdAtLabel = [[[WXWLabel alloc]  initWithFrame:CGRectZero
                             textColor:BASE_INFO_COLOR
                           shadowColor:TEXT_SHADOW_COLOR] autorelease];
    _createdAtLabel.font = FONT(10);
    [self.contentView addSubview:_createdAtLabel];
    
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.buttons = [NSMutableArray array];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - arrange views

- (void)arrangeFlagViewWithType:(PostType)type {
    
    if (nil == _flagIcon) {
        
        _flagIcon = [[[UIImageView alloc] initWithFrame:CGRectMake(MARGIN * 2, MARGIN * 2, 50, 50)] autorelease];
        
        [self.contentView addSubview:_flagIcon];
    }
    
    switch (type) {
        case SUPPLY_POST_TY:
            _flagIcon.image = [UIImage imageNamed:@"supply"];
            break;
            
        case DEMAND_POST_TY:
            _flagIcon.image = [UIImage imageNamed:@"demand"];
            break;
            
        default:
            break;
    }
}

- (void)arrangeTags:(NSString *)tags {
    
    if (tags.length > 0) {
        
        tags = [tags stringByReplacingOccurrencesOfString:HALF_WIDTH_COMMA withString:FULL_WIDTH_COMMA];
        
        NSArray *tagList = [tags componentsSeparatedByString:FULL_WIDTH_COMMA];
        
        CGFloat startX = _tagIcon.frame.origin.x + _tagIcon.frame.size.width + MARGIN;
        
        for (NSString *tag in tagList) {
            
            CGSize size = [tag sizeWithFont:FONT(TAG_FONT_SIZE)];
            
            CGFloat width = size.width + 4.0f;
            
            if (startX > self.frame.size.width - MARGIN * 6) {
                break;
            }
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(startX, _tagIcon.frame.origin.y, width, size.height);
            [button setTitle:tag forState:UIControlStateNormal];
            [button setTitleColor:TAG_COLOR forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [button setBackgroundImage:[UIImage imageNamed:@"darkBlueButton.png"]
                              forState:UIControlStateHighlighted];
            button.titleLabel.font = FONT(TAG_FONT_SIZE);
            button.backgroundColor = TRANSPARENT_COLOR;
//            [button addTarget:self
//                       action:@selector(selectTag:)
//             forControlEvents:UIControlEventTouchUpInside];
            
            [self.contentView addSubview:button];
            
            [self.buttons addObject:button];
            
            startX += width + MARGIN * 2;
        }
    }
}

- (void)clearTagButtons {
    for (UIButton *btn in self.buttons) {
        [btn removeFromSuperview];
    }
    
    [self.buttons removeAllObjects];
}

- (void)updateCell:(Post *)item{
    post = item;
    
    [self clearTagButtons];
    
    [self arrangeFlagViewWithType:item.postType.intValue];
    
    CGSize nameSize = [item.authorName sizeWithFont:_nameLabel.font
                                  constrainedToSize:CGSizeMake(144, CGFLOAT_MAX)];
    
    _nameLabel.frame = CGRectMake(_flagIcon.frame.origin.x + _flagIcon.frame.size.width + MARGIN * 2, 2*MARGIN, nameSize.width, nameSize.height);
	_nameLabel.text = item.authorName;
    
    // Class
    NSString *className = item.authorSchoolInfo;
    CGSize constraint   = CGSizeMake(144, 20);
    
    if (![@"" isEqualToString:className] && className.length > 0) {
        _classLabel.text = [NSString stringWithFormat:@" | %@", className];
    }
    CGSize classNameSize = [_classLabel.text sizeWithFont:_classLabel.font
                                        constrainedToSize:constraint
                                            lineBreakMode:UILineBreakModeTailTruncation];
    
    _classLabel.frame = CGRectMake(MARGIN+nameSize.width+_nameLabel.frame.origin.x, MARGIN * 2, 144, classNameSize.height);
    
    
    _contentLabel.text = item.content;
    int contentWidth = self.frame.size.width - MARGIN * 2 - (_flagIcon.frame.origin.x + _flagIcon.frame.size.width + MARGIN * 2);
    CGSize size = [_contentLabel.text sizeWithFont:_contentLabel.font
                                 constrainedToSize:CGSizeMake(contentWidth, 20.0f)
                                     lineBreakMode:_contentLabel.lineBreakMode];
    _contentLabel.frame = CGRectMake(_nameLabel.frame.origin.x,
                                     _nameLabel.frame.origin.y + _nameLabel.frame.size.height + MARGIN,
                                     size.width, size.height);
    
    _tagIcon.frame = CGRectMake(_nameLabel.frame.origin.x, _tagIcon.frame.origin.y, _tagIcon.frame.size.width, _tagIcon.frame.size.height);
    
    [self arrangeTags:item.tagNames];
    
    _timeline.text = item.createdTime;
    size = [_timeline.text sizeWithFont:_timeline.font
                      constrainedToSize:CGSizeMake(200, CGFLOAT_MAX)
                          lineBreakMode:UILineBreakModeWordWrap];
    _timeline.frame = CGRectMake(_tagIcon.frame.origin.x, _tagIcon.frame.origin.y + TAG_FONT_SIZE + MARGIN, size.width, size.height);
    
    // create
    _createdAtLabel.text = STR_FORMAT(@"%@ %@ %@", LocaleStringForKey(NSFromTitle, nil), item.plat, item.version);
    CGSize createdAtLabelSize = [_createdAtLabel.text sizeWithFont:_createdAtLabel.font];
    _createdAtLabel.frame = CGRectMake(self.frame.size.width - MARGIN * 2 - createdAtLabelSize.width,
                                       _timeline.frame.origin.y, createdAtLabelSize.width, createdAtLabelSize.height);
}

- (void)dealloc {

    self.buttons = nil;
    
    [super dealloc];
}

@end
