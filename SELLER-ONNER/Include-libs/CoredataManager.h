//
//  CoredataManager.h
//  SELLER-ONNER
//
//  Created by Bank on 7/20/2558 BE.
//  Copyright (c) 2558 TANONGSAK SEANGLUM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoredataManager : NSObject
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (CoredataManager *)sharedDatamanager;
- (NSArray *)sortDataWithString:(NSString *) aSearchText fromArray:(NSArray *)aItems searchForKey:(NSString *) aKey;
- (NSArray*)getDataListWithObjectNamed:(NSString*) aKey sortObject:(NSArray*) aSort ascending:(BOOL) aBool;
- (NSManagedObject *)getDataListWithObjectNamed:(NSString*) aKey orderbyPredicate:(NSString *) aObject;
- (NSArray*)getDataForKey:(NSString*) aKey sortBy:(NSString*) aValue ascending:(BOOL) sortType;
- (id)getIntialForKey:(NSString*) aKey withObject:(NSString *) aObjectID;
- (NSArray*)getDataListWithObjectNamed:(NSString*) aKey;
- (void)didUpdateDataWithObject:(id) aObject;
- (id)reverseTransformedValue:(id)value;
- (id)transformedValue:(id)value;
- (BOOL)updateData;
- (BOOL)saveData;

@end
