//
//  DataModelManage.m
//  Project
//
//  Created by XXX on 13-9-4.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "DataModelManage.h"
#import <CoreData/CoreData.h>

@interface DataModelManage()
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation DataModelManage

@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

static DataModelManage *instance = nil;

+ (DataModelManage *)getInstance {

    @synchronized(self) {
        if(instance == nil)
            instance = [[super allocWithZone:NULL] init];
    }
    
    return instance;
}

#if 0
- (void)initCoreData
{
    NSManagedObjectContext *context = [self managedObjectContext];
    BusinessItemModel *itemInfo = [NSEntityDescription
                                  insertNewObjectForEntityForName:@"BusinessItemModel"
                                  inManagedObjectContext:context];
    itemInfo.itemName = @"itemName";
    itemInfo.imageURL = @"imageURL";
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    // Test listing all FailedBankInfos from the store
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"BusinessItemModel"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (BusinessItemModel *info in fetchedObjects) {
        NSLog(@"Name: %@", info.itemName);
        NSLog(@"imageURL: %@", info.imageURL);
    }
}
#endif

//- (void)addBusinessItemModelCoreData:(BusinessItemModel *)item
//{
//     NSManagedObjectContext *context = [self managedObjectContext];
//    
//    BusinessItemModel *itemInfo = [NSEntityDescription
//                                   insertNewObjectForEntityForName:@"BusinessItemModel"
//                                   inManagedObjectContext:context];
//    
//    itemInfo = item;
//    NSError *error;
//    if (![context save:&error]) {
//        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
//    }
//}

- (NSArray *) getBusinessItemModelCoreData
{
#if 1
        NSError *error;
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"BusinessItemModel"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    return  [context executeFetchRequest:fetchRequest error:&error];
    
#elif 1
    
    NSManagedObjectContext *context2=[self managedObjectContext];
    NSFetchRequest *fetch2 = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity2=[NSEntityDescription entityForName:@"BusinessItemModel" inManagedObjectContext:context2];
    [fetch2 setEntity:entity2];
    [fetch2 setResultType:NSDictionaryResultType];

    NSError *error=nil;
    NSArray *objects2 = [context2 executeFetchRequest:fetch2 error:&error];
    if (objects2 == nil) {
        // Handle the error.
        NSLog(@"ERRORS IN SEARCH INSIDE VIEW SUCCESS");
    }
    return objects2;
    
#endif
    
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"GoHigh" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"GoHigh.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


- (NSManagedObjectContext *)getContext
{
    return [self managedObjectContext];
}

@end
