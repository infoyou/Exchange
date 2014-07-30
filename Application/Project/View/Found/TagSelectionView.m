//
//  TagSelectionView.m
//  Project
//
//  Created by XXX on 13-9-16.
//
//

#import "TagSelectionView.h"
#import <QuartzCore/QuartzCore.h>
#import "Tag.h"
#import "UIUtils.h"
#import "WXWCoreDataUtils.h"
#import "WXWCommonUtils.h"
#import "TextPool.h"

#define LAST_ROW_HEIGHT   50.0f

#define TAG_LIST_WIDTH    230.0f

#define MAX_LIST_HEIGHT   270.0f//154.0f

#define BTN_WIDTH         100.0f
#define BTN_HEIGHT        30.0f

enum {
  LEFT_BTN_TAG = 100,
  RIGHT_BTN_TAG,
};

#pragma mark - tag button
@interface BizTagButton : UIButton {
  
}

@property (nonatomic, retain) Tag *bizTag;

+ (id)buttonWithType:(UIButtonType)buttonType;
@end

@implementation BizTagButton

+ (id)buttonWithType:(UIButtonType)buttonType {
  return [super buttonWithType:buttonType];
}

- (void)setBizTag:(Tag *)bizTag {
  
  if (bizTag == nil) {
    return;
  }
  
  RELEASE_OBJ(_bizTag);
  _bizTag = [bizTag retain];
  
  [self setTitle:bizTag.tagName forState:UIControlStateNormal];
}

- (void)dealloc {
  
  self.bizTag = nil;
  
  [super dealloc];
}

@end

@interface TagLitView : UIView {
@private
  NSManagedObjectContext *_MOC;
  
  NSInteger _rowCount;
  
  SEL _closeAction;
  
  SEL _confirmAction;
  
  UITableView *_tableView;
}
@property (nonatomic, retain) NSArray *tags;
@property (nonatomic, assign) TagSelectionView *parentView;
@end

@implementation TagLitView

#pragma mark - user actions

- (void)doClose {
  if ([self.parentView respondsToSelector:_closeAction]) {
    [self.parentView performSelector:_closeAction];
  }
}

- (void)cancelSelection:(id)sender {
  
  // reset tag selection status for cancel selection
  for (Tag *tag in self.tags) {
    if (tag.changed.boolValue) {
      tag.selected = @(!tag.selected.boolValue);
      tag.changed = @(NO);
    }
  }
  SAVE_MOC(_MOC);
  
  [self doClose];
}

- (void)confirmSelection:(id)sender {
  
  if (_parentView) {
    
    // reset tag 'changed' property
    for (Tag *tag in self.tags) {
      tag.changed = @(NO);
    }
    SAVE_MOC(_MOC);
    
    [_parentView performSelector:_confirmAction];
  }
  
  [self doClose];
}

#pragma mark - arrange views

- (void)calcRowCount {
  if (self.tags.count % 2 == 0) {
    _rowCount = self.tags.count/2;
  } else {
    _rowCount = self.tags.count/2 + 1;
  }
}

- (void)arrangeViews {
  
  [self calcRowCount];
  
  CGFloat height = _rowCount * DEFAULT_CELL_HEIGHT;
  height = height > MAX_LIST_HEIGHT ? MAX_LIST_HEIGHT : height;
  
  height += LAST_ROW_HEIGHT;
  
  self.frame = CGRectMake(0, 0, TAG_LIST_WIDTH, height);
  self.backgroundColor = [UIColor whiteColor];
  self.center = self.parentView.center;
  self.layer.masksToBounds = YES;
  self.layer.cornerRadius = 4.0f;
  
  [self initTableView];
  
  [self addButtons];
}

- (void)addButtons {
  
  UIView *backgroundView = [[[UIView alloc] initWithFrame:CGRectMake(0, _tableView.frame.origin.y + _tableView.frame.size.height, self.bounds.size.width, LAST_ROW_HEIGHT)] autorelease];
  backgroundView.backgroundColor = [UIColor whiteColor];
  backgroundView.layer.shadowPath = [UIBezierPath bezierPathWithRect:backgroundView.bounds].CGPath;
  backgroundView.layer.shadowColor = [UIColor grayColor].CGColor;
  backgroundView.layer.shadowOffset = CGSizeZero;
  backgroundView.layer.shadowOpacity = 0.9f;
  backgroundView.layer.shadowRadius = 2.0f;
  [self addSubview:backgroundView];
  
  CGFloat halfWidth = self.bounds.size.width/2.0f;
  
  UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  cancelBtn.backgroundColor = COLOR(51, 51, 51);
  cancelBtn.frame = CGRectMake((halfWidth - BTN_WIDTH)/2.0f,
                               (LAST_ROW_HEIGHT - BTN_HEIGHT)/2.0f,
                               BTN_WIDTH, BTN_HEIGHT);
  cancelBtn.titleLabel.font = BOLD_FONT(16);
  [cancelBtn setTitle:LocaleStringForKey(NSCancelTitle, nil) forState:UIControlStateNormal];
  [cancelBtn addTarget:self action:@selector(cancelSelection:) forControlEvents:UIControlEventTouchUpInside];
  [backgroundView addSubview:cancelBtn];
  
  UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  confirmBtn.backgroundColor = [UIColor colorWithHexString:STYLE_BLUE_COLOR];
  confirmBtn.frame = CGRectMake(halfWidth + (halfWidth - BTN_WIDTH)/2.0f,
                                cancelBtn.frame.origin.y,
                                BTN_WIDTH, BTN_HEIGHT);
  confirmBtn.titleLabel.font = BOLD_FONT(16);
  [confirmBtn setTitle:LocaleStringForKey(NSSureTitle, nil) forState:UIControlStateNormal];
  [confirmBtn addTarget:self action:@selector(confirmSelection:) forControlEvents:UIControlEventTouchUpInside];
  [backgroundView addSubview:confirmBtn];
}

- (void)initTableView {
  
  CGFloat height = _rowCount * DEFAULT_CELL_HEIGHT;
  
  height = height > MAX_LIST_HEIGHT ? MAX_LIST_HEIGHT : height;
  
  _tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, height)
                                             style:UITableViewStylePlain] autorelease];
  _tableView.delegate = self.parentView;
  _tableView.dataSource = self.parentView;
  _tableView.backgroundColor = [UIColor whiteColor];
  [self addSubview:_tableView];
}

#pragma mark - life cycle methods
- (id)initWithMOC:(NSManagedObjectContext *)MOC
             tags:(NSArray *)tags
       parentView:(TagSelectionView *)parentView
      closeAction:(SEL)closeAction
 confirmSelection:(SEL)confirmSelection {
  self = [super init];
  if (self) {
    
    _MOC = MOC;
    
    self.tags = tags;
    
    self.parentView = parentView;
    
    _closeAction = closeAction;
    
    _confirmAction = confirmSelection;
    
    [self arrangeViews];
  }
  return self;
}

- (void)dealloc {
  
  self.parentView = nil;
  self.tags = nil;
  _tableView.delegate = nil;
  _tableView.dataSource = nil;
  
  [super dealloc];
}

@end

@interface TagSelectionView ()
@property (nonatomic, retain) NSArray *tags;
@end

@implementation TagSelectionView

#pragma mark - user action
- (void)selectTag:(id)sender {
  
  BizTagButton *btn = (BizTagButton *)sender;
  if (btn.bizTag != nil) {
    btn.bizTag.selected = @(!btn.bizTag.selected.boolValue);
    
    btn.bizTag.changed = @(YES);
    
    SAVE_MOC(_MOC);
    
    NSString *imageName = nil;
    if (btn.bizTag.selected.boolValue) {
      imageName = @"redSelected.png";
    } else {
      imageName = @"squareUnselected.png";
    }
    
    [btn setImage:IMAGE_WITH_NAME(imageName) forState:UIControlStateNormal];

  }
}

- (void)close:(id)sender {
  
  [UIView animateWithDuration:0.2f
                   animations:^{
                     self.alpha = 0.0f;
                   }
                   completion:^(BOOL finished){
                    [self removeFromSuperview];
                   }];
  
}

- (void)confirmSelection {
  if (_tagSelector && _confirmAction) {
    [_tagSelector performSelector:_confirmAction];
  }
}

#pragma mark - life cycle methods
- (void)calcRowCount {
  if (self.tags.count % 2 == 0) {
    _rowCount = self.tags.count/2;
  } else {
    _rowCount = self.tags.count/2 + 1;
  }
}

- (id)initWithFrame:(CGRect)frame
               tags:(NSArray *)tags
                MOC:(NSManagedObjectContext *)MOC
        tagSelector:(id)tagSelector
      confirmAction:(SEL)confirmAction
{
  self = [super initWithFrame:frame];
  if (self) {
    
    self.backgroundColor = [UIColor colorWithWhite:0.3f alpha:0.6f];

    _MOC = MOC;
    
    _tagSelector = tagSelector;
    _confirmAction = confirmAction;
    
    self.tags = tags;
    
    [self calcRowCount];
    
    [self arrangeTagList];
  }
  return self;
}

- (void)dealloc {
  
  self.tags = nil;
  
  [super dealloc];
}

#pragma mark - arrange view
- (void)arrangeTagList {
  
  TagLitView *listView = [[[TagLitView alloc] initWithMOC:nil
                                                     tags:self.tags
                                               parentView:self
                                              closeAction:@selector(close:)
                                         confirmSelection:@selector(confirmSelection)] autorelease];
  [self addSubview:listView];
}

#pragma mark - draw cell
- (void)addButtonsInCell:(UITableViewCell *)cell {
  
  CGFloat buttonWidth = TAG_LIST_WIDTH/2.0f;
  
  BizTagButton *leftButton = [BizTagButton buttonWithType:UIButtonTypeCustom];
  leftButton.tag = LEFT_BTN_TAG;
  leftButton.backgroundColor = TRANSPARENT_COLOR;
  leftButton.titleLabel.font = BOLD_FONT(13);
  leftButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
  [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [leftButton addTarget:self action:@selector(selectTag:) forControlEvents:UIControlEventTouchUpInside];
  [leftButton setImage:IMAGE_WITH_NAME(@"squareUnselected.png") forState:UIControlStateNormal];
  leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
  leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, MARGIN, 0, 0);
  leftButton.titleEdgeInsets = UIEdgeInsetsMake(0, MARGIN, 0, 0);
  
  leftButton.frame = CGRectMake(0, 0, buttonWidth, DEFAULT_CELL_HEIGHT);
  [cell.contentView addSubview:leftButton];
  
  BizTagButton *rightButton = [BizTagButton buttonWithType:UIButtonTypeCustom];
  rightButton.tag = RIGHT_BTN_TAG;
  rightButton.backgroundColor = TRANSPARENT_COLOR;
  rightButton.titleLabel.font = BOLD_FONT(13);
  rightButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
  [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [rightButton addTarget:self action:@selector(selectTag:) forControlEvents:UIControlEventTouchUpInside];
  [rightButton setImage:IMAGE_WITH_NAME(@"squareUnselected.png") forState:UIControlStateNormal];
  rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
  rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, MARGIN, 0, 0);
  rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, MARGIN, 0, 0);
  
  rightButton.frame = CGRectMake(buttonWidth, 0, buttonWidth, DEFAULT_CELL_HEIGHT);
  [cell.contentView addSubview:rightButton];
  
}

#pragma mark - UITableViewDelegate, UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
  
  return _rowCount;
}

- (void)disableButton:(BizTagButton *)button {
  button.hidden = YES;
  button.enabled = NO;
  button.bizTag = nil;
}

- (void)enableButton:(BizTagButton *)button withTag:(Tag *)tag {
  button.bizTag = tag;
  button.hidden = NO;
  button.enabled = YES;
  
  NSString *imageName = nil;
  if (button.bizTag.selected.boolValue) {
    imageName = @"redSelected.png";
  } else {
    imageName = @"squareUnselected.png";
  }
  
  [button setImage:IMAGE_WITH_NAME(imageName) forState:UIControlStateNormal];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *kCellIdentifier = @"cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
  if (nil == cell) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:kCellIdentifier] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self addButtonsInCell:cell];
  }
  
  BizTagButton *leftButton = (BizTagButton *)[cell.contentView viewWithTag:LEFT_BTN_TAG];
  BizTagButton *rightButton = (BizTagButton *)[cell.contentView viewWithTag:RIGHT_BTN_TAG];
  
  if (self.tags.count > indexPath.row * 2) {
    Tag *leftTag = self.tags[indexPath.row * 2];
    if (leftTag != nil) {
      [self enableButton:leftButton withTag:leftTag];
    } else {
      [self disableButton:leftButton];
    }    
  } else {
    [self disableButton:leftButton];
  }
  
  if (self.tags.count > indexPath.row * 2 + 1) {
    Tag *rightTag = self.tags[indexPath.row * 2 + 1];
    if (rightTag != nil) {
      [self enableButton:rightButton withTag:rightTag];
    } else {
      [self disableButton:rightButton];
    }
  } else {
    [self disableButton:rightButton];
  }
  
  return cell;
}

@end
