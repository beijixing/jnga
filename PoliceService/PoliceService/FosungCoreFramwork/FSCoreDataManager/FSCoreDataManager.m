//
//  FSCoreDataManager.m
//  FosungCore
//
//  Created by horse on 2017/2/5.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "FSCoreDataManager.h"
#import <objc/runtime.h>
@interface FSCoreDataManager()

@property(strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property(strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation FSCoreDataManager
+(instancetype)sharedManager {
    static FSCoreDataManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        
        
    }
    return self;
}

#pragma mark Operations
-(id)insertObjectWithEntity:(NSString*)entity {
     NSManagedObject*object=[NSEntityDescription insertNewObjectForEntityForName:entity inManagedObjectContext:self.managedObjectContext];
    return object;
}
//第一种插入操作（根据字典传递数据）
-(id)insertObjectWithEntity:(NSString*)entity parameter:(NSDictionary*)paramDict{
    
    id object=[NSEntityDescription insertNewObjectForEntityForName:entity inManagedObjectContext:self.managedObjectContext];
    
//    typeof(self) __weak wself = self;
    [paramDict enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL * _Nonnull stop) {
        if (![value isKindOfClass:[NSArray class]]) {
            [object setValue:paramDict[key] forKey:key];
        }else {
//           Class class = NSClassFromString([key capitalizedString]);
//            if (class) {
//                NSArray *arr = paramDict[key];
//                [arr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                    NSManagedObject *subObj = [wself insertObjectWithEntity:[key capitalizedString] parameter:obj];
//                    
//                }];
//                
//            }else {
//                //转换为二进制存储
//            }
        }
    }];
    return object;
}



//第二种插入操作(利用Block)
-(id)insertObjectWithEntity:(NSString*)entity completion:(CDInsertBlock)completionHandle{
    
    NSManagedObject*object=[NSEntityDescription insertNewObjectForEntityForName:entity inManagedObjectContext:self.managedObjectContext];
    
    completionHandle(object);
    
    return object;
}

-(NSArray*)queryWithEntity:(NSString*)entity predicate:(NSPredicate*)predicate sortKey:(NSString*)key ascending:(BOOL)isAscending{
    //创建取回数据请求
    NSFetchRequest*request=[[NSFetchRequest alloc]init];
    //设置检索的实体描述
    NSEntityDescription*entityDes=[NSEntityDescription entityForName:entity inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entityDes];
    //谓词，筛选数据
    if (predicate) {
        request.predicate=predicate;
    }
        //指定对检索结果的排序方式
    if ( key ){
        //之所以添加判断，是因为如果key为nil，NSSortDescriptor则无法初始化，程序会奔溃
        NSSortDescriptor*sortDestor=[[NSSortDescriptor alloc]initWithKey:key ascending:isAscending];
        [request setSortDescriptors:@[sortDestor]];
    }
    NSError*error=nil;
    //执行请求，返回数组
    NSArray*fetchedResult=[self.managedObjectContext executeFetchRequest:request error:&error];
    if (!fetchedResult) {
        NSLog(@"error:%@ ,%@",error,[error userInfo]);
    }
    return fetchedResult;
}

-(BOOL)deleteObject:(id)object{
    if (object && [object isKindOfClass:[NSManagedObject class]]) {
        [self.managedObjectContext deleteObject:object];
        return YES;
    }
    return NO;
}

-(BOOL)deleteObjectSet:(NSSet *)objects {
    typeof(self) __weak weakSelf = self;
    [objects enumerateObjectsUsingBlock:^(NSManagedObject *obj, BOOL * _Nonnull stop) {
        [weakSelf.managedObjectContext deleteObject:obj];
    }];
    return YES;
}
-(BOOL)deleteObjects:(NSArray *)objects {
    typeof(self) __weak weakSelf = self;
    [objects enumerateObjectsUsingBlock:^(NSManagedObject *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [weakSelf.managedObjectContext deleteObject:obj];
    }];
    return YES;
}

- (BOOL)saveDataBase {
    NSError* error = nil;
    if (self.managedObjectContext != nil) {
        if ([self.managedObjectContext hasChanges] && [self.managedObjectContext save:&error]) {
            return YES;
        }else {
             [NSException raise:@"访问数据库错误" format:@"%@", [error userInfo]];
            return false;
        }
    }
    else {
        NSLog(@"%s, self.managedObjectContext is nil ", __FILE__);
        return false;
    }
}

// 获取应用的Documents目录
- (NSURL *)applicationDocumentsDirectory
{
    if (_dataFileRootPath) {
        return [NSURL fileURLWithPath:_dataFileRootPath];
    }else {
        return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                       inDomains:NSUserDomainMask] lastObject];
    }
}


#pragma mark Getters

// 初始化应用的托管对象上下文。
- (NSManagedObjectContext *)managedObjectContext
{
    // 如果_managedObjectContext已经被初始化过，直接返回该对象
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    // 获取持久化存储协调器
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    // 如果持久化存储协调器不为nil
    if (coordinator != nil)
    {
        // 创建NSManagedObjectContext对象
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        // 为NSManagedObjectContext对象设置持久化存储协调器
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
        
    }
    return _managedObjectContext;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    // 如果_persistentStoreCoordinator已经被初始化过，直接返回该对象
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    //获取SQLite数据库文件的存储目录
    NSURL *storeURL = [[self applicationDocumentsDirectory]
                       URLByAppendingPathComponent:self.databaseFileName];
    NSError *error = nil;
    // 以持久化对象模型为基础，创建NSPersistentStoreCoordinator对象
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                   initWithManagedObjectModel:[self managedObjectModel]];
    // 设置持久化存储协调器底层采用SQLite存储机制，如果设置失败记录错误信息
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                   configuration:nil URL:storeURL options:nil error:&error])
    {
        NSLog(@"设置持久化存储失败：%@, %@", error, [error userInfo]);
        abort();
    }
    return _persistentStoreCoordinator;
}

- (NSManagedObjectModel *)managedObjectModel
{
    // 如果_managedObjectModel已经被初始化过，直接返回该对象
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    // 获取实体模型文件对应的NSURL
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:self.modelFileName
                                              withExtension:@"momd"];
    // 加载应用的实体模型文件，并初始化NSManagedObjectModel对象
    _managedObjectModel = [[NSManagedObjectModel alloc]
                           initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}


@end
