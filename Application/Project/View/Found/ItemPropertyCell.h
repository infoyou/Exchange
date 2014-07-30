//
//  ItemPropertyCell.h
//  Project
//
//  Created by XXX on 11-11-23.
//  Copyright (c) 2011年 _CompanyName_. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "GlobalConstants.h"
#import "ECEditorDelegate.h"
#import "BaseUITableViewCell.h"

@class Tag;
@class Distance;

@interface ItemPropertyCell : BaseUITableViewCell {
@private
  
  UIButton *_leftButton;
  UIButton *_rightButton;
  
  TagShowType _itemType;
  
  Tag *_leftTag;
  Tag *_rightTag;
  Tag *_leftPlace;
  Tag *_rightPlace;
  Distance *_leftDistance;
  Distance *_rightDistance;
  
  id<ECEditorDelegate> _delegate;
  
  TagType _tagType;
  
  SharingFilterType _sharingFilterType;
  
  ItemFavoriteCategory _itemFavoriteCategory;
}

- (id)initWithStyle:(UITableViewCellStyle)style 
    reuseIdentifier:(NSString *)reuseIdentifier 
     editorDelegate:(id<ECEditorDelegate>)editorDelegate
           itemType:(TagShowType)itemType
                MOC:(NSManagedObjectContext *)MOC
            tagType:(TagType)tagType;

- (id)initWithStyle:(UITableViewCellStyle)style 
    reuseIdentifier:(NSString *)reuseIdentifier 
     editorDelegate:(id<ECEditorDelegate>)editorDelegate
           itemType:(TagShowType)itemType
                MOC:(NSManagedObjectContext *)MOC
  sharingFilterType:(SharingFilterType)sharingFilterType;

- (void)drawThing:(NSManagedObject *)leftTag rightTag:(NSManagedObject *)rightTag;
- (void)drawTag:(NSManagedObject *)leftTag rightTag:(NSManagedObject *)rightTag;
- (void)drawPlace:(NSManagedObject *)leftPlace;
- (void)drawLeftDistance:(Distance *)leftDistance rightDistance:(Distance *)rightDistance;
- (void)drawFavoriteFilterCell:(ItemFavoriteCategory)favoriteType;

@end
