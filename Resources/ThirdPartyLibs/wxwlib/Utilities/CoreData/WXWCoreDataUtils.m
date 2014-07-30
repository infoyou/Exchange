//
//  WXWCoreDataUtils.m
//  Project
//
//  Created by XXX on 11-11-9.
//  Copyright (c) 2011年 _CompanyName_. All rights reserved.
//

#import "WXWCoreDataUtils.h"
#import "WXWDebugLogOutput.h"
#import "WXWCommonUtils.h"
#import "WXWTextPool.h"


#define MAX_SAVED_RECORD_COUNT      50

@implementation WXWCoreDataUtils

#pragma mark - common utility methods
+ (NSManagedObject *)fetchObjectFromMOC:(NSManagedObjectContext *)MOC
                             entityName:(NSString *)entityName
                              predicate:(NSPredicate *)predicate {
    
	NSFetchRequest *fetchRequest1 = [[[NSFetchRequest alloc] init] autorelease];
    fetchRequest1.entity = [NSEntityDescription entityForName:entityName
                                       inManagedObjectContext:MOC];
    if (predicate) {
        fetchRequest1.predicate = predicate;
    }
    fetchRequest1.fetchLimit = 1;
    fetchRequest1.includesPropertyValues = NO;
	
	NSError *error = nil;
	NSArray *objects = [MOC executeFetchRequest:fetchRequest1
                                          error:&error] ;
    if (nil == objects || 0 == [objects count]) {
        return nil;
    } else {
        return [objects lastObject];
    }
}

+ (NSArray *)loadObjectsFromMOC:(NSManagedObjectContext *)MOC
                     entityName:(NSString *)entityName
                      predicate:(NSPredicate *)predicate
         includesPropertyValues:(BOOL)includesPropertyValues {
    
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    fetchRequest.entity = [NSEntityDescription entityForName:entityName
                                      inManagedObjectContext:MOC];
    if (predicate) {
        fetchRequest.predicate = predicate;
    }
    
    fetchRequest.includesPropertyValues = includesPropertyValues;
	
	NSError *error = nil;
	NSArray *objects = [MOC executeFetchRequest:fetchRequest
                                          error:&error] ;
    return objects;
    
}

+ (NSArray *)fetchObjectsFromMOC:(NSManagedObjectContext *)MOC
                      entityName:(NSString *)entityName
                       predicate:(NSPredicate *)predicate {
    
	return [self loadObjectsFromMOC:MOC entityName:entityName predicate:predicate includesPropertyValues:YES];
}

+ (NSInteger)objectCountsFromMOC:(NSManagedObjectContext *)MOC
                      entityName:(NSString *)entityName
                       predicate:(NSPredicate *)predicate {
    return [self loadObjectsFromMOC:MOC entityName:entityName predicate:predicate includesPropertyValues:NO].count;
}

+ (NSArray *)fetchObjectsFromMOC:(NSManagedObjectContext *)MOC
                      entityName:(NSString *)entityName
                       predicate:(NSPredicate *)predicate
                       sortDescs:(NSMutableArray *)sortDescs
                   limitedNumber:(NSInteger)limitedNumber {
    
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    fetchRequest.entity = [NSEntityDescription entityForName:entityName
                                      inManagedObjectContext:MOC];
    if (predicate) {
        fetchRequest.predicate = predicate;
    }
    
    if (limitedNumber > 0) {
        fetchRequest.fetchLimit = limitedNumber;
    }
    
    if (sortDescs && sortDescs.count > 0) {
        fetchRequest.sortDescriptors = sortDescs;
    }
	
	NSError *error = nil;
	NSArray *objects = [MOC executeFetchRequest:fetchRequest
                                          error:&error] ;
    return objects;
}

+ (NSArray *)fetchObjectsFromMOC:(NSManagedObjectContext *)MOC
                      entityName:(NSString *)entityName
                       predicate:(NSPredicate *)predicate
                       sortDescs:(NSMutableArray *)sortDescs {
    
    return [self fetchObjectsFromMOC:MOC
                          entityName:entityName
                           predicate:predicate
                           sortDescs:sortDescs
                       limitedNumber:-1];
}

+ (BOOL)objectInMOC:(NSManagedObjectContext *)MOC
         entityName:(NSString *)entityName
          predicate:(NSPredicate *)predicate {
    
    if ([self fetchObjectFromMOC:MOC entityName:entityName predicate:predicate] != nil) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)deleteEntitiesFromMOC:(NSManagedObjectContext *)MOC
                   entityName:(NSString *)entityName
                    predicate:(NSPredicate *)predicate {
    
    @autoreleasepool {
        
        NSFetchRequest * fetch = [[[NSFetchRequest alloc] init] autorelease];
        if (predicate) {
            fetch.predicate = predicate;
        }
        fetch.entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:MOC];
        fetch.includesPropertyValues = NO;
        NSError *error = nil;
        NSArray *result = [MOC executeFetchRequest:fetch error:&error];
        if ([result count] ==  0) {
            return YES;
        }
        
        if (nil == error) {
            for (id object in result) {
                [MOC deleteObject:object];
            }
            
            if (![MOC save:&error]) {
                debugLog(@"Delete all %@ failed: %@", entityName, [error domain]);
                return NO;
            } else {
                return YES;
            }
        } else {
            debugLog(@"Delete all %@ failed: %@", entityName, [error domain]);
            return NO;
        }
    }
}

+ (BOOL)deleteEntitiesFromMOC:(NSManagedObjectContext *)MOC
                     entities:(NSArray *)entities {
    
    @autoreleasepool {
        
        if (nil == MOC) {
            return NO;
        }
        
        if ([entities count] ==  0) {
            return YES;
        }
        
        NSError *error = nil;
        for (id object in entities) {
            [MOC deleteObject:object];
        }
        
        if (![MOC save:&error]) {
            debugLog(@"Delete failed: %@", [error domain]);
            return NO;
        } else {
            return YES;
        }
    }
}

#pragma mark - delete all objects

+ (BOOL)doDelete:(NSManagedObjectContext *)MOC
      entityName:(NSString *)entityName
       predicate:(NSPredicate *)predicate
{
	NSFetchRequest * fetch = [[[NSFetchRequest alloc] init] autorelease];
    if (predicate) {
        fetch.predicate = predicate;
    }
	[fetch setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:MOC]];
	NSError *error = nil;
	NSArray *result = [MOC executeFetchRequest:fetch error:&error];
	if ([result count] ==  0) {
		return YES;
	}
    
	if (!error) {
		for (id object in result) {
			[MOC deleteObject:object];
		}
		
		if (![MOC save:&error]) {
            NSLog(@"Delete all %@ failed: %@", entityName, [error domain]);
			debugLog(@"Delete all %@ failed: %@", entityName, [error domain]);
			return NO;
		} else {
			return YES;
		}
	} else {
		debugLog(@"Delete all %@ failed: %@", entityName, [error domain]);
		return NO;
	}
}

+ (BOOL)doDelete:(NSManagedObjectContext *)MOC entityName:(NSString *)entityName
{
	return [self doDelete:MOC entityName:entityName predicate:nil];
}

+ (BOOL)deleteAllObjects:(NSManagedObjectContext *)MOC
{
    
    if (![self doDelete:MOC entityName:@"Report"]) {
		return NO;
	} else if (![self doDelete:MOC entityName:@"Upcoming"]) {
		return NO;
	} else if (![self doDelete:MOC entityName:@"ClassGroup"]) {
		return NO;
	} else if (![self doDelete:MOC entityName:@"Industry"]) {
		return NO;
	} else if (![self doDelete:MOC entityName:@"UserCountry"]) {
		return NO;
	}
    
	return YES;
}

+ (NSArray *)objectsInMOC:(NSManagedObjectContext *)MOC
               entityName:(NSString *)entityName
             sortDescKeys:(NSArray *)sortDescKeys
                predicate:(NSPredicate *)predicate {
    
    @try {
        
        NSFetchRequest *fetchRequest1 = [[[NSFetchRequest alloc] init] autorelease];
        [fetchRequest1 setEntity:[NSEntityDescription entityForName:entityName
                                             inManagedObjectContext:MOC]];
        [fetchRequest1 setPredicate:predicate];
        [fetchRequest1 setSortDescriptors:sortDescKeys];
        //	[fetchRequest1 setFetchLimit:1];
        
        NSError *error = nil;
        NSArray *objects = [MOC executeFetchRequest:fetchRequest1
                                              error:&error] ;
        return objects;
    }
    @catch (NSException *exception) {
        DLog(@"%@", exception);
    }
    @finally {
    }
	
}

+ (NSManagedObject *)hasSameObjectAlready:(NSManagedObjectContext *)MOC
                               entityName:(NSString *)entityName
                             sortDescKeys:(NSArray *)sortDescKeys
                                predicate:(NSPredicate *)predicate {
	
	NSArray *objects = [self objectsInMOC:MOC entityName:entityName sortDescKeys:sortDescKeys predicate:predicate];
	
	if ([objects count] == 0) {
		return nil;
	}
	
	return (NSManagedObject *)objects[0];
}

+ (BOOL)saveMOCChange:(NSManagedObjectContext *)MOC {
    if ([MOC hasChanges]) {
        NSError *error;
        if (![MOC save:&error]) {
            return NO;
        }
    }
    
    return YES;
}

+ (void)unLoadObject:(NSManagedObjectContext *)MOC
           predicate:(NSPredicate *)predicate
          entityName:(NSString *)entityName {
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    
    [fetchRequest setEntity:[NSEntityDescription entityForName:entityName
                                        inManagedObjectContext:MOC]];
    
    [fetchRequest setPredicate:predicate];
    fetchRequest.includesPropertyValues = NO;
    
    NSError *error = nil;
	NSArray *result = [MOC executeFetchRequest:fetchRequest error:&error];
    for (id post in result) {
		[MOC deleteObject:post];
	}
    
    if ([MOC hasChanges]) {
		if (![MOC save:&error]) {
			debugLog(@"Clear class failed.");
        }
	}
	
    RELEASE_OBJ(pool);
}

+ (NSFetchedResultsController *)fetchObject:(NSManagedObjectContext *)aManagedObjectContext
                   fetchedResultsController:(NSFetchedResultsController *)aFetchedResultsController
                                 entityName:(NSString *)entityName
                         sectionNameKeyPath:(NSString *)sectionNameKeyPath
                            sortDescriptors:(NSMutableArray *)sortDescriptors
                                  predicate:(NSPredicate *)aPredicate {
    
    NSFetchedResultsController *result = nil;
    
    if (aFetchedResultsController == nil) {
		// set entity
		NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
		[fetchRequest setEntity:[NSEntityDescription entityForName:entityName
                                            inManagedObjectContext:aManagedObjectContext]];
		
		// set predicate
		if (aPredicate != nil) {
			[fetchRequest setPredicate:aPredicate];
		}
		
        [fetchRequest setSortDescriptors:sortDescriptors];
        
		// do fetch
		NSString *cacheName = [[NSString alloc] initWithFormat:@"%@Cache", entityName];
		
		// result should be released by caller, e.g., the method "segmentAction" of GuideNewsViewController
        result = [[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                      managedObjectContext:aManagedObjectContext
                                                        sectionNameKeyPath:sectionNameKeyPath
                                                                 cacheName:cacheName] autorelease];
        
        [cacheName release];
		cacheName = nil;
		
	} else {
		result = aFetchedResultsController;
	}
	
	return result;
}

+ (BOOL)objectInLocalStorage:(NSManagedObjectContext *)MOC entityName:(NSString *)entityName {
    NSArray *objs = [self objectsInMOC:MOC entityName:entityName sortDescKeys:nil predicate:nil];
    if ([objs count] > 0) {
        return YES;
    } else {
        return NO;
    }
}

@end
