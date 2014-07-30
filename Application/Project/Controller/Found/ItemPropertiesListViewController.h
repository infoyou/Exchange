//
//  ItemPropertiesListViewController.h
//  Project
//
//  Created by XXX on 11-11-22.
//  Copyright (c) 2011年 _CompanyName_. All rights reserved.
//

#import "BaseListViewController.h"
#import <CoreData/CoreData.h>
#import "GlobalConstants.h"
#import "ECEditorDelegate.h"
#import "ECPickerViewDelegate.h"

@class ItemListSectionView;
@class ECPickerView;

@interface ItemPropertiesListViewController : BaseListViewController <ECEditorDelegate> {
@private
  ItemPropertyType _type;
  NSFetchedResultsController *_filterTagFetchedRC;
  NSFetchedResultsController *_filterPlaceFetchedRC;
  NSFetchedResultsController *_filterCountryFetchedRC;
  
  ItemListSectionView *_placeHeaderView;
  ItemListSectionView *_tagHeaderView;
  ItemListSectionView *_favoriteHeaderView;
  
  ECPickerView *_pickerView;
  
  long long _lastSelectedCountryId;
  
  BOOL _moveDownUI;
  
  TagType _tagType;

  id<ECEditorDelegate> _parentEditorDelegate;
}

- (id)initWithMOC:(NSManagedObjectContext *)MOC
           holder:(id)holder
 backToHomeAction:(SEL)backToHomeAction
     propertyType:(ItemPropertyType)propertyType
          tagType:(TagType)tagType;

- (id)initWithMOC:(NSManagedObjectContext *)MOC
           holder:(id)holder
 backToHomeAction:(SEL)backToHomeAction
parentEditorDelegate:(id<ECEditorDelegate>)parentEditorDelegate
     propertyType:(ItemPropertyType)propertyType 
  filterCountryId:(long long)filterCountryId
          tagType:(TagType)tagType;

- (id)initWithMOC:(NSManagedObjectContext *)MOC
           holder:(id)holder
 backToHomeAction:(SEL)backToHomeAction
     propertyType:(ItemPropertyType)propertyType 
       moveDownUI:(BOOL)moveDownUI
          tagType:(TagType)tagType;

@end
