//
//  ItemPropertyCell.m
//  Project
//
//  Created by XXX on 11-11-23.
//  Copyright (c) 2011年 _CompanyName_. All rights reserved.
//

#import "ItemPropertyCell.h"
#import "Tag.h"
#import "CommonUtils.h"
#import "UIUtils.h"
#import "WXWCoreDataUtils.h"
#import "Distance.h"
#import "WXWCommonUtils.h"
#import "TextPool.h"

#pragma mark - Two line
#define ONE_BUTTON_WIDTH  320.0f
#define ONE_IMG_EDGE      UIEdgeInsetsMake(0.0, 289, 0.0, 0.0)
#define ONE_TITLE_EDGE    UIEdgeInsetsMake(0.0, -20, 0.0, 30.0)

#pragma mark - Two line
#define TWO_BUTTON_WIDTH  159.0f
#define TWO_IMG_EDGE      UIEdgeInsetsMake(0.0, 130, 0.0, 0.0)
#define TWO_TITLE_EDGE    UIEdgeInsetsMake(0.0, -20, 0.0, 30.0)

@interface ItemPropertyCell()
@property (nonatomic, retain) Distance *leftDistance;
@property (nonatomic, retain) Distance *rightDistance;
@end

@implementation ItemPropertyCell

@synthesize leftDistance = _leftDistance;
@synthesize rightDistance = _rightDistance;

- (void)selectTag:(Tag *)tag {
  
  tag.selected = [NSNumber numberWithBool:(!tag.selected.boolValue)];
  
  if (tag.selected.boolValue) {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"( (type == %d) AND (selected == 1) AND (tagId != %d))", _tagType, [tag.tagId intValue]];
    Tag *lastSelectedTag = (Tag *)[WXWCoreDataUtils fetchObjectFromMOC:_MOC entityName:@"Tag" predicate:predicate];
    lastSelectedTag.selected = @NO;
  }
  
  [WXWCoreDataUtils saveMOCChange:tag.managedObjectContext];
  
  switch (_tagType) {
    case THING_TY:
    {
//      [AppManager instance].defaultThing = @"tagName"; //tag.tagName;
      [_delegate chooseTags];
      break;
    }
      
    case PLACE_TY:
    {
//      [AppManager instance].defaultPlace = @"tagName"; //tag.tagName;
      [_delegate choosePlace];
      break;
    }
    
    case SHARE_TY:
    {
      [_delegate chooseTags];
      break;
    }
      
    default:
      break;
  }
}

- (void)selectShareTag:(Tag *)tag {
  tag.selected = [NSNumber numberWithBool:(!tag.selected.boolValue)]; 
  if (tag.tagId.longLongValue == TAG_ALL_ID && tag.selected.boolValue) {
    // means current select "All" tag, so all the other tags should be set as unselected
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(tagId != %lld)", TAG_ALL_ID];
    NSArray *tags = [WXWCoreDataUtils fetchObjectsFromMOC:_MOC
                                            entityName:@"Tag" 
                                             predicate:predicate];
    for (Tag *otherTag in tags) {
      otherTag.selected = @NO;
    }
  } else if (tag.tagId.longLongValue != TAG_ALL_ID && tag.selected.boolValue) {
    // if user selects one specify tag, then the selected "All" tag should be set as unselected
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(tagId == %lld)", TAG_ALL_ID];
    Tag *allTag = (Tag *)[WXWCoreDataUtils fetchObjectFromMOC:_MOC
                                                entityName:@"Tag" 
                                                 predicate:predicate];
    allTag.selected = @NO;
  }
  
  // if no selected tag, then "All" tag should be selected, which means there is one tag should be selected at least
  NSInteger selectedTagCount = [WXWCoreDataUtils objectCountsFromMOC:_MOC entityName:@"Tag" predicate:SELECTED_PREDICATE];
  if (0 == selectedTagCount) {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(tagId == %lld)", TAG_ALL_ID];
    Tag *allTag = (Tag *)[WXWCoreDataUtils fetchObjectFromMOC:_MOC
                                                entityName:@"Tag" 
                                                 predicate:predicate];
    allTag.selected = @YES;
  }
  
  [WXWCoreDataUtils saveMOCChange:tag.managedObjectContext];
  
  [_delegate chooseTags];
}

- (void)selectDistance:(Distance *)distance {
  distance.selected = [NSNumber numberWithBool:(!distance.selected.boolValue)];
  
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(valueString != %@)", distance.valueString];
  NSArray *distances = [WXWCoreDataUtils fetchObjectsFromMOC:distance.managedObjectContext
                                               entityName:@"Distance" 
                                                predicate:predicate];
  for (Distance *obj in distances) {
    obj.selected = @NO;
  }
  
  SAVE_MOC(distance.managedObjectContext);
  
  [_delegate chooseDistance];
}

- (void)selectFavorite:(ItemFavoriteCategory)favoriteType {
  switch (favoriteType) {
    case ALL_CATEGORY_TY:
      [_leftButton setImage:[UIImage imageNamed:@"radioButton.png"] forState:UIControlStateNormal];
      [_rightButton setImage:UNSELECTED_IMG forState:UIControlStateNormal];
      break;
      
    case FAVORITED_CATEGORY_TY:
      [_rightButton setImage:[UIImage imageNamed:@"radioButton.png"] forState:UIControlStateNormal];
      [_leftButton setImage:UNSELECTED_IMG forState:UIControlStateNormal];
      break;
      
    default:
      break;
  }
  
  [_delegate chooseFavoriteType:favoriteType];
}

- (void)selectLeftItem:(id)sender {
  switch (_tagType) {
    case THING_TY:
      [self selectTag:_leftTag];        
      break;
      
    case PLACE_TY:
      [self selectTag:_leftPlace];
      break;
      
    case SHARE_TY:
      switch (_sharingFilterType) {
        case DISTANTCE_FILTER_TY:
          [self selectDistance:self.leftDistance];
          break;
          
        case TAG_FILTER_TY:
          [self selectShareTag:_leftTag];
          break;
          
        case FAVORITE_FILTER_TY:
          [self selectFavorite:ALL_CATEGORY_TY];
          break;
          
        default:
          break;
      }
      
      break;
      
    default:
      break;
  }
}

- (void)selectRightItem:(id)sender {
  switch (_tagType) {
    case THING_TY:
      [self selectTag:_rightTag];
      break;
      
    case PLACE_TY:
      [self selectTag:_rightPlace];
      break;
      
    case SHARE_TY:
      switch (_sharingFilterType) {
        case DISTANTCE_FILTER_TY:
          [self selectDistance:self.rightDistance];
          break;
          
        case TAG_FILTER_TY:
          [self selectShareTag:_rightTag];
          break;
          
        case FAVORITE_FILTER_TY:
          [self selectFavorite:FAVORITED_CATEGORY_TY];
          break;
          
        default:
          break;
      }
      
      break;
      
    default:
      break;
  }
}

- (void)initButton:(UIButton **)button frame:(CGRect)frame {
  
  *button = [UIButton buttonWithType:UIButtonTypeCustom];
  (*button).frame = frame;
  
  switch (_itemType) {
    case ONE_TY:
    {
      (*button).imageEdgeInsets = ONE_IMG_EDGE;
      (*button).titleEdgeInsets = ONE_TITLE_EDGE;
      break;
    }
    case TWO_TY:
    {
      (*button).imageEdgeInsets = TWO_IMG_EDGE;
      (*button).titleEdgeInsets = TWO_TITLE_EDGE;
      break;
    }
  }
  
  (*button).backgroundColor = [UIColor whiteColor];
  [(*button) setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  (*button).titleLabel.font = FONT(15);
  (*button).titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
  (*button).contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
  [self.contentView addSubview:*button];
}

- (id)initWithStyle:(UITableViewCellStyle)style 
    reuseIdentifier:(NSString *)reuseIdentifier 
     editorDelegate:(id<ECEditorDelegate>)editorDelegate
           itemType:(TagShowType)itemType
                MOC:(NSManagedObjectContext *)MOC
            tagType:(TagType)tagType
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    
    _MOC = MOC;
    _tagType = tagType;
    _itemType = itemType;
    
    switch (_itemType) {
      case ONE_TY:
      {
        [self initButton:&_leftButton frame:CGRectMake(0, 0, ONE_BUTTON_WIDTH, ITEM_PROPERTY_CELL_HEIGHT)];
        [_leftButton addTarget:self action:@selector(selectLeftItem:) forControlEvents:UIControlEventTouchUpInside];
      }
        break;
        
      case TWO_TY:
      {
        [self initButton:&_leftButton frame:CGRectMake(0, 0, TWO_BUTTON_WIDTH, ITEM_PROPERTY_CELL_HEIGHT)];
        [_leftButton addTarget:self action:@selector(selectLeftItem:) forControlEvents:UIControlEventTouchUpInside];
        
        [self initButton:&_rightButton frame:CGRectMake(TWO_BUTTON_WIDTH + 2, 0, TWO_BUTTON_WIDTH + 1, ITEM_PROPERTY_CELL_HEIGHT)];
        [_rightButton addTarget:self action:@selector(selectRightItem:) forControlEvents:UIControlEventTouchUpInside];
      }
        break;
        
      default:
        break;
    }
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryNone;
    
    _delegate = editorDelegate;
  }
  return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style 
    reuseIdentifier:(NSString *)reuseIdentifier 
     editorDelegate:(id<ECEditorDelegate>)editorDelegate
           itemType:(TagShowType)itemType
                MOC:(NSManagedObjectContext *)MOC
  sharingFilterType:(SharingFilterType)sharingFilterType
{
  self = [self initWithStyle:style 
             reuseIdentifier:reuseIdentifier 
              editorDelegate:editorDelegate
                    itemType:itemType
                         MOC:MOC
                     tagType:SHARE_TY];
  if (self) {
    
    _MOC = MOC;
    _sharingFilterType = sharingFilterType;
    _itemType = itemType;
    
  }
  return self;
}

- (void)dealloc {
  
  self.rightDistance = nil;
  self.leftDistance = nil;
  
  [super dealloc];
}

- (void)drawThing:(NSManagedObject *)leftTag rightTag:(NSManagedObject *)rightTag {
    NSString *leftTitle = nil;
    NSString *rightTitle = nil;
    BOOL leftSelected = NO;
    BOOL rightSelected = NO;
    BOOL leftHighlight = NO;
    BOOL rightHighlight = NO;
    switch (_itemType) {
        case TWO_TY:
        {
            _leftTag = (Tag *)leftTag;
            _rightTag = (Tag *)rightTag;  
            leftTitle = _leftTag.tagName;
            leftSelected = _leftTag.selected.boolValue;
            leftHighlight = _leftTag.highlight.boolValue;
            
            rightTitle = _rightTag.tagName;
            rightSelected = _rightTag.selected.boolValue;
            rightHighlight = _rightTag.highlight.boolValue;
            break;
        }
            
        default:
            break;
    }
    
    if (leftTag) {
        _leftButton.hidden = NO;
        [_leftButton setTitle:leftTitle forState:UIControlStateNormal];
        [_leftButton setTitleColor:(leftHighlight ? [UIColor redColor] : [UIColor blackColor])
                          forState:UIControlStateNormal];
        
        if (leftSelected) {
            [_leftButton setImage:RADIO_IMG forState:UIControlStateNormal];
        } else {
            [_leftButton setImage:UNSELECTED_IMG forState:UIControlStateNormal];
        }
        
    } else {
        _leftButton.hidden = YES;
    }
    
    if (rightTag) {
        
        _rightButton.hidden = NO;
        
        [_rightButton setTitle:rightTitle forState:UIControlStateNormal];
        [_rightButton setTitleColor:(rightHighlight ? [UIColor redColor] : [UIColor blackColor])
                           forState:UIControlStateNormal];
        
        if (rightSelected) {
            [_rightButton setImage:RADIO_IMG forState:UIControlStateNormal];
        } else {
            [_rightButton setImage:UNSELECTED_IMG forState:UIControlStateNormal];
        }
    } else {
        _rightButton.hidden = YES;
    }
}

- (void)drawTag:(NSManagedObject *)leftTag rightTag:(NSManagedObject *)rightTag {
  
  NSString *leftTitle = nil;
  NSString *rightTitle = nil;
  BOOL leftSelected = NO;
  BOOL rightSelected = NO;
  BOOL leftHighlight = NO;
  BOOL rightHighlight = NO;

  switch (_itemType) {
    case TWO_TY:
    {
      _leftTag = (Tag *)leftTag;
      _rightTag = (Tag *)rightTag;  
      leftTitle = _leftTag.tagName;
      leftSelected = _leftTag.selected.boolValue;
      leftHighlight = _leftTag.highlight.boolValue;
      
      rightTitle = _rightTag.tagName;
      rightSelected = _rightTag.selected.boolValue;
      rightHighlight = _rightTag.highlight.boolValue;
      break;
    }
      
    default:
      break;
  }
  
  if (leftTag) {
    _leftButton.hidden = NO;
    [_leftButton setTitle:leftTitle forState:UIControlStateNormal];
    [_leftButton setTitleColor:(leftHighlight ? [UIColor redColor] : [UIColor blackColor])
                      forState:UIControlStateNormal];
    
    if (leftSelected) {
      [_leftButton setImage:SELECTED_IMG forState:UIControlStateNormal];
    } else {
      [_leftButton setImage:UNSELECTED_IMG forState:UIControlStateNormal];
    }
    
  } else {
    _leftButton.hidden = YES;
  }
  
  if (rightTag) {
    
    _rightButton.hidden = NO;
    
    [_rightButton setTitle:rightTitle forState:UIControlStateNormal];
    [_rightButton setTitleColor:(rightHighlight ? [UIColor redColor] : [UIColor blackColor])
                       forState:UIControlStateNormal];
    
    if (rightSelected) {
      [_rightButton setImage:SELECTED_IMG forState:UIControlStateNormal];
    } else {
      [_rightButton setImage:UNSELECTED_IMG forState:UIControlStateNormal];
    }
  } else {
    _rightButton.hidden = YES;
  }
}

- (void)drawPlace:(NSManagedObject *)leftPlace {
  
  NSString *leftTitle = nil;
  BOOL leftSelected = NO;
  
  switch (_itemType) {
    case ONE_TY:
    {
      _leftPlace = (Tag *)leftPlace;
      leftTitle = _leftPlace.tagName;
      leftSelected = _leftPlace.selected.boolValue;
      break;
    }
      
    default:
      break;
  }
  
  if (_leftPlace) {
    _leftButton.hidden = NO;
    
    [_leftButton setTitle:leftTitle forState:UIControlStateNormal];
    if (leftSelected) {
      [_leftButton setImage:RADIO_IMG forState:UIControlStateNormal];
    } else {
      [_leftButton setImage:UNSELECTED_IMG forState:UIControlStateNormal];
    }
  } else {
    _leftButton.hidden = YES;
  }
}

- (void)drawFavoriteFilterCell:(ItemFavoriteCategory)favoriteType {
  
  _itemFavoriteCategory = favoriteType;
  
  _leftButton.hidden = NO;
  
  [_leftButton setTitle:LocaleStringForKey(NSAllTitle, nil)
               forState:UIControlStateNormal];
  if (favoriteType == ALL_CATEGORY_TY) {
    [_leftButton setImage:[UIImage imageNamed:@"radioButton.png"] forState:UIControlStateNormal];
  } else {
    [_leftButton setImage:UNSELECTED_IMG forState:UIControlStateNormal];
  }
  
  _rightButton.hidden = NO;
  
  [_rightButton setTitle:LocaleStringForKey(NSFavoritedTitle, nil)
                forState:UIControlStateNormal];
  if (favoriteType == FAVORITED_CATEGORY_TY) {
    [_rightButton setImage:[UIImage imageNamed:@"radioButton.png"] forState:UIControlStateNormal];
  } else {
    [_rightButton setImage:UNSELECTED_IMG forState:UIControlStateNormal];
  }
  
}

- (void)drawLeftDistance:(Distance *)leftDistance rightDistance:(Distance *)rightDistance {
  
  //_dealPlace = YES;
  //_dealTag = NO;
  
  NSString *leftTitle = nil;
  NSString *rightTitle = nil;
  BOOL leftSelected = NO;
  BOOL rightSelected = NO;
  
  leftTitle = leftDistance.desc;
  rightTitle = rightDistance.desc;
  leftSelected = leftDistance.selected.boolValue;
  rightSelected = rightDistance.selected.boolValue;
  
  self.leftDistance = leftDistance;
  self.rightDistance = rightDistance;
  
  if (leftDistance) {
    _leftButton.hidden = NO;
    
    [_leftButton setTitle:leftTitle forState:UIControlStateNormal];
    if (leftSelected) {
      [_leftButton setImage:[UIImage imageNamed:@"radioButton.png"] forState:UIControlStateNormal];
    } else {
      [_leftButton setImage:UNSELECTED_IMG forState:UIControlStateNormal];
    }
  } else {
    _leftButton.hidden = YES;
  }
  
  if (rightDistance) {
    
    _rightButton.hidden = NO;
    
    [_rightButton setTitle:rightTitle forState:UIControlStateNormal];
    if (rightSelected) {
      [_rightButton setImage:[UIImage imageNamed:@"radioButton.png"] forState:UIControlStateNormal];
    } else {
      [_rightButton setImage:UNSELECTED_IMG forState:UIControlStateNormal];
    }
  } else {
    _rightButton.hidden = YES;
  }
}

- (void)drawRect:(CGRect)rect {
  
  CGPoint startPoint = CGPointMake(160, 0);
  CGPoint endPoint = CGPointMake(160, rect.size.height);
  
  CGColorRef borderColorRef = CELL_BORDER_COLOR.CGColor;
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  [UIUtils draw1PxStroke:context
              startPoint:startPoint 
                endPoint:endPoint
                   color:borderColorRef 
            shadowOffset:CGSizeMake(0.0f, 0.0f)
             shadowColor:TRANSPARENT_COLOR];
}

@end
