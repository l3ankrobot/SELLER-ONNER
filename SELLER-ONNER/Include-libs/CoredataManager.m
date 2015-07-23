//
//  CoredataManager.m
//  SELLER-ONNER
//
//  Created by Bank on 7/20/2558 BE.
//  Copyright (c) 2558 TANONGSAK SEANGLUM. All rights reserved.
//

#import "CoredataManager.h"

@implementation CoredataManager
@synthesize managedObjectContext = _managedObjectContext;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (CoredataManager *)sharedDatamanager
{
    static CoredataManager *sharedInstance = nil;
    if (sharedInstance == nil)
    {
        sharedInstance = [(CoredataManager *)[self alloc] init];
    }
    return sharedInstance;
}

#pragma mark - CoreData
- (void)didUpdateDataWithObject:(id) aObject
{
    [self.managedObjectContext refreshObject:aObject mergeChanges:YES];
    [[CoredataManager sharedDatamanager] saveData];
}

- (NSArray*)getDataListWithObjectNamed:(NSString*) aKey sortObject:(NSArray*) aSort ascending:(BOOL) aBool {
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    // Define our table/entity to use
    NSEntityDescription *entity = [NSEntityDescription entityForName:aKey inManagedObjectContext:managedObjectContext];
    if (!entity) return nil;
    // Setup the fetch request
    NSMutableArray *sortDescriptors = [NSMutableArray array];
    for (NSString *aString in aSort){
        NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc] initWithKey:aString ascending:aBool];
        [sortDescriptors addObject:sortDesc];
    }
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    if(sortDescriptors.count > 0)[request setSortDescriptors:sortDescriptors];
    
    [request setReturnsObjectsAsFaults:NO];
    [request setEntity:entity];
    
    // Fetch the records and handle an error
    NSError *error;
    NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    return mutableFetchResults;
}

- (NSArray*)getDataForKey:(NSString*) aKey sortBy:(NSString*) aValue ascending:(BOOL) sortType
{
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:aKey inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setReturnsObjectsAsFaults:NO];
    [request setEntity:entityDescription];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:aValue ascending:sortType];
    [request setSortDescriptors:@[sortDescriptor]];
    
    NSError *error;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    if (array == nil)
    {
        // Deal with error...
    }
    return array;
}

- (NSArray*)getDataListWithObjectNamed:(NSString*) aKey {
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    // Define our table/entity to use
    NSEntityDescription *entity = [NSEntityDescription entityForName:aKey inManagedObjectContext:managedObjectContext];
    if (!entity) return nil;
    // Setup the fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    //[request setSortDescriptors:sortDescriptors];
    
    [request setReturnsObjectsAsFaults:NO];
    [request setEntity:entity];
    
    // Fetch the records and handle an error
    NSError *error;
    NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    return mutableFetchResults;
}

- (NSManagedObject *)getDataListWithObjectNamed:(NSString*) aKey orderbyPredicate:(NSString *) aObject{
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    // Define our table/entity to use
    NSEntityDescription *entity = [NSEntityDescription entityForName:aKey inManagedObjectContext:managedObjectContext];
    if (!entity) return nil;
    // Setup the fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    //[request setSortDescriptors:sortDescriptors];
    if (aObject) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:aObject];
        [request setPredicate:predicate];
    }
    
    [request setReturnsObjectsAsFaults:NO];
    [request setEntity:entity];
    
    // Fetch the records and handle an error
    NSError *error;
    NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    return (mutableFetchResults.count > 0)? [mutableFetchResults lastObject] : nil;
}

- (id)getIntialForKey:(NSString*) aKey withObject:(NSString *) aObjectID
{
    NSString *aPredicateStr = [NSString stringWithFormat:@"id contains[cd] %@", aObjectID];
    NSManagedObject *aOld = [[CoredataManager sharedDatamanager] getDataListWithObjectNamed:aKey orderbyPredicate:aPredicateStr];
    if (aOld) return aOld;
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSUserDefaults *aUserDefault = [NSUserDefaults standardUserDefaults];
    NSMutableArray *aArrayObjectKey = [NSMutableArray arrayWithArray:[[aUserDefault arrayForKey:@"entieList"] mutableCopy]];
    
    NSMutableArray *aCurrentArray = [NSMutableArray new];
    for (NSString *aStringKey in aArrayObjectKey){
        if (![aStringKey isEqualToString:aKey]) {
            [aCurrentArray addObject:aStringKey];
        }
    }
    [aCurrentArray addObject:aKey];
    [aUserDefault setObject:aCurrentArray forKey:@"entieList"];
    [aUserDefault synchronize];
    return [NSEntityDescription insertNewObjectForEntityForName:aKey inManagedObjectContext:managedObjectContext];
}


- (NSArray *)sortDataWithString:(NSString *) aSearchText fromArray:(NSArray *)aItems searchForKey:(NSString *) aKey
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K contains[cd] %@", aKey, aSearchText];
    NSArray *filtered  = [aItems filteredArrayUsingPredicate:predicate];
    return filtered;
}

- (id)transformedValue:(id)value
{
    return [NSKeyedArchiver archivedDataWithRootObject:value];
}

- (id)reverseTransformedValue:(id)value
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:value];
}

- (BOOL)updateData
{
    BOOL hasupdate = NO;
    if ([self.managedObjectContext hasChanges])
    {
        hasupdate = YES;
        [self.managedObjectContext rollback];
        DLog(@"Rolled back changes.");
    }
    return hasupdate;
}

- (BOOL)saveData
{
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        return NO;
    }
    
    return YES;
}

@end
