//
//  NSManagedObject+Convenient.h
//  FosungCore
//
//  Created by horse on 2017/2/6.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "FSCoreDataManager.h"
@interface NSManagedObject (Convenient)
+ (id)insertItemInContext:(FSCoreDataManager *)cdm;
+ (id)insertItemInContext:(FSCoreDataManager *)cdm completion:(CDInsertBlock)completionHandler;

+ (NSArray *)itemsInContext:(FSCoreDataManager *)cdm;
+ (NSArray *)itemsInContext:(FSCoreDataManager *)cdm usingPredicate:(NSPredicate *)predicate;
+ (NSArray *)itemsInContext:(FSCoreDataManager *)cdm withFormat:(NSString *)fmt, ...;
+ (NSArray *)itemsInContext:(FSCoreDataManager *)cdm usingPredicate:(NSPredicate *)predicate sortKey:(NSString *)key ascending:(BOOL)isAscending;

- (void)removeFromContext:(FSCoreDataManager *)cdm;
- (void)remove;

- (BOOL)saveToContext:(FSCoreDataManager *)cdm;
- (BOOL)save;

- (void)updateData:(NSDictionary *)dict;
@end
