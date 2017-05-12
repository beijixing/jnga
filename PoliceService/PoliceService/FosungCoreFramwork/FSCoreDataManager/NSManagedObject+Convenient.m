//
//  NSManagedObject+Convenient.m
//  FosungCore
//
//  Created by horse on 2017/2/6.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "NSManagedObject+Convenient.h"
#import "FSCoreDataManager+Private.h"
#import <objc/runtime.h>

@implementation NSManagedObject (Convenient)
+(id)insertItemInContext:(FSCoreDataManager *)cdm {
    if (!cdm) {
        return nil;
    }
    id item = [cdm insertObjectWithEntity:NSStringFromClass([self class])];
    return item;
}

+(id)insertItemInContext:(FSCoreDataManager *)cdm completion:(CDInsertBlock)completionHandler {
    if (!cdm) {
        return nil;
    }
    id item = [cdm insertObjectWithEntity:NSStringFromClass([self class])];
    if (completionHandler) {
        completionHandler(item);
    }
    return item;
}

+(NSArray *)itemsInContext:(FSCoreDataManager *)cdm {
    if (!cdm) {
        return nil;
    }
    NSArray *items = [cdm queryWithEntity:NSStringFromClass([self class]) predicate:nil sortKey:nil ascending:YES];
    return items;
}

+(NSArray *)itemsInContext:(FSCoreDataManager *)cdm usingPredicate:(NSPredicate *)predicate {
    if (!cdm) {
        return nil;
    }
    NSArray *items = [cdm queryWithEntity:NSStringFromClass([self class]) predicate:predicate sortKey:nil ascending:YES];
    return items;
}

+ (NSArray *)itemsInContext:(FSCoreDataManager *)cdm withFormat:(NSString *)fmt, ...
{
    if (!cdm) {
        return nil;
    }
    va_list args;
    va_start(args, fmt);
    NSPredicate *pred = [NSPredicate predicateWithFormat:fmt arguments:args];
    va_end(args);
    
    NSArray *items = [cdm queryWithEntity:NSStringFromClass(self) predicate:pred sortKey:nil ascending:YES];
    return items;
}

+ (NSArray *)itemsInContext:(FSCoreDataManager *)cdm usingPredicate:(NSPredicate *)predicate sortKey:(NSString *)key ascending:(BOOL)isAscending {
    if (!cdm) {
        return nil;
    }
    NSArray *items = [cdm queryWithEntity:NSStringFromClass(self) predicate:predicate sortKey:key ascending:isAscending];
    return items;
}

- (void)removeFromContext:(FSCoreDataManager *)cdm {
    if (!cdm) {
        return;
    }
    [cdm deleteObject:self];
}
- (void)remove {
    FSCoreDataManager *cdm = [FSCoreDataManager sharedManager];
    [cdm deleteObject:self];
}

- (BOOL)saveToContext:(FSCoreDataManager *)cdm {
    if (!cdm) {
        return nil;
    }
    return [cdm saveDataBase];
}

- (BOOL)save {
    FSCoreDataManager *cdm = [FSCoreDataManager sharedManager];
    return [cdm saveDataBase];
}

- (void)updateData:(NSDictionary *)dict {
    
}

@end
