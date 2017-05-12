//
//  FSCoreDataManager.h
//  FosungCore
//
//  Created by horse on 2017/2/5.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef void(^CDInsertBlock)(id obj);
@interface FSCoreDataManager : NSObject

@property(strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, strong) NSString *modelFileName;
@property(nonatomic, strong) NSString *databaseFileName;
@property(nonatomic, strong) NSString *dataFileRootPath;
+(instancetype)sharedManager;
- (BOOL)saveDataBase;

/*
 增加数据操作
 @param entity 实体名称。
 @param paramDict 参数字典。
 @return 成功添加数据后返回类为entity 的对象。
 */
-(id)insertObjectWithEntity:(NSString*)entity;

-(id)insertObjectWithEntity:(NSString*)entity parameter:(NSDictionary*)paramDict;

-(id)insertObjectWithEntity:(NSString*)entity completion:(CDInsertBlock)completionHandle;

/*
 查询操作
 @param entity 实体名称。
 @param predicate 查询条件。
 @param key 排序字段。
 @param isAscending 排序规则，true 为从小到大。
 @return 返回实体类的对象数组。
    NSPredicate*predicate=[NSPredicate predicateWithFormat:@"sex=%@",@"Man"];
 */
-(NSArray*)queryWithEntity:(NSString*)entity predicate:(NSPredicate*)predicate sortKey:(NSString*)key ascending:(BOOL)isAscending;
/*
    删除操作
 */
-(BOOL)deleteObject:(id)object;
-(BOOL)deleteObjectSet:(NSSet *)objects;
-(BOOL)deleteObjects:(NSArray *)objects;
@end


