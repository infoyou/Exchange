//
//  WXWCoreDataUtils.h
//  Project
//
//  Created by XXX on 11-11-9.
//  Copyright (c) 2011年 _CompanyName_. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "WXWConstants.h"

@interface WXWCoreDataUtils : NSObject {
  
}

#pragma mark - common utility methods
+ (NSManagedObject *)fetchObjectFromMOC:(NSManagedObjectContext *)MOC 
                             entityName:(NSString *)entityName 
                              predicate:(NSPredicate *)predicate;

+ (NSArray *)fetchObjectsFromMOC:(NSManagedObjectContext *)MOC 
                      entityName:(NSString *)entityName 
                       predicate:(NSPredicate *)predicate 
                       sortDescs:(NSMutableArray *)sortDescs
                   limitedNumber:(NSInteger)limitedNumber;

+ (NSArray *)fetchObjectsFromMOC:(NSManagedObjectContext *)MOC 
                      entityName:(NSString *)entityName 
                       predicate:(NSPredicate *)predicate 
                       sortDescs:(NSMutableArray *)sortDescs;

+ (NSArray *)fetchObjectsFromMOC:(NSManagedObjectContext *)MOC 
                      entityName:(NSString *)entityName 
                       predicate:(NSPredicate *)predicate;

+ (NSInteger)objectCountsFromMOC:(NSManagedObjectContext *)MOC 
                      entityName:(NSString *)entityName 
                       predicate:(NSPredicate *)predicate;

+ (BOOL)objectInMOC:(NSManagedObjectContext *)MOC 
         entityName:(NSString *)entityName 
          predicate:(NSPredicate *)predicate;

+ (BOOL)saveMOCChange:(NSManagedObjectContext *)MOC;

+ (NSFetchedResultsController *)fetchObject:(NSManagedObjectContext *)aManagedObjectContext 
                   fetchedResultsController:(NSFetchedResultsController *)aFetchedResultsController
                                 entityName:(NSString *)entityName 
                         sectionNameKeyPath:(NSString *)sectionNameKeyPath 
                            sortDescriptors:(NSMutableArray *)sortDescriptors
                                  predicate:(NSPredicate *)aPredicate;

+ (BOOL)deleteEntitiesFromMOC:(NSManagedObjectContext *)MOC
                   entityName:(NSString *)entityName 
                    predicate:(NSPredicate *)predicate;

+ (BOOL)deleteEntitiesFromMOC:(NSManagedObjectContext *)MOC
                     entities:(NSArray *)entities;

+ (BOOL)doDelete:(NSManagedObjectContext *)MOC entityName:(NSString *)entityName;
+ (NSArray *)objectsInMOC:(NSManagedObjectContext *)MOC
               entityName:(NSString *)entityName
             sortDescKeys:(NSArray *)sortDescKeys
                predicate:(NSPredicate *)predicate;
+ (NSManagedObject *)hasSameObjectAlready:(NSManagedObjectContext *)MOC
                               entityName:(NSString *)entityName
                             sortDescKeys:(NSArray *)sortDescKeys
                                predicate:(NSPredicate *)predicate;

+ (void)unLoadObject:(NSManagedObjectContext *)MOC
           predicate:(NSPredicate *)predicate
          entityName:(NSString *)entityName;
+ (BOOL)deleteAllObjects:(NSManagedObjectContext *)MOC;

/*
#pragma mark - hot news
+ (void)clearOldItems:(NSManagedObjectContext *)MOC itemType:(ItemType)itemType;

#pragma mark - tag
+ (void)resetTags:(NSManagedObjectContext *)MOC clearAll:(BOOL)clearAll;
+ (void)createComposerTagsForGroupId:(NSString *)groupId
                                 MOC:(NSManagedObjectContext *)MOC;

#pragma mark - sort options
+ (void)prepareVenueSortOptions:(NSManagedObjectContext *)MOC;
+ (void)preparePostSortOptions:(NSManagedObjectContext *)MOC;
+ (void)resetSortOptions:(NSManagedObjectContext *)MOC;

#pragma mark - place
+ (void)resetPlaces:(NSManagedObjectContext *)MOC;
+ (void)resetComposerPlaces:(NSManagedObjectContext *)MOC;
+ (void)createComposerPlaces:(NSManagedObjectContext *)MOC;
+ (void)resetDistance:(NSManagedObjectContext *)MOC;

#pragma mark - country
+ (void)resetCountries:(NSManagedObjectContext *)MOC;
+ (void)resetCountryAllObjectName:(NSManagedObjectContext *)MOC;

#pragma mark - assemble email from address book
+ (void)resetSelectedInvitee:(NSManagedObjectContext *)MOC snsType:(UserSnsType)snsType;
*/
@end
