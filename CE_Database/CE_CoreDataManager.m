//
//  CoreDataManager.m
//  CommanApp
//
//  Created by cxq on 15/12/2.
//  Copyright © 2015年 cxq. All rights reserved.
//

#import "CE_CoreDataManager.h"

#define DB_NAME     @"Ymr"

@implementation CE_CoreDataManager
{
    NSMutableDictionary *_tableNameDic;
    NSMutableDictionary *_classNameDic;
    NSMutableDictionary *_keysNameDic;
    
    dispatch_queue_t queue;
}

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "celink.googfit.GoogFit" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:DB_NAME withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",DB_NAME]];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    
    NSDictionary *optionsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],
                                       NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES],
                                       NSInferMappingModelAutomaticallyOption, nil];
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:optionsDictionary error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
    
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

+ (CE_CoreDataManager *)shareManager {
    
    static CE_CoreDataManager *ins = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        
        if (!ins) {
            ins = [[CE_CoreDataManager alloc] init];
        }
    });
    
    return ins;
}

- (id)init {
    
    if (self = [super init]) {
        
        _tableNameDic = [NSMutableDictionary dictionaryWithCapacity:1];
        _classNameDic = [NSMutableDictionary dictionaryWithCapacity:1];
        _keysNameDic = [NSMutableDictionary dictionaryWithCapacity:1];
        
        queue = dispatch_queue_create("com.ymr.coreData", DISPATCH_QUEUE_SERIAL);
    }
    
    return self;
}

- (dispatch_queue_t)coreDataQueue {
    
    return queue;
}

- (void)registTable:(NSString *)tableName className:(NSString *)className keyNames:(NSArray *)keyName {
    
    if (className.length) {
        [_classNameDic setObject:className forKey:tableName];
    }
    else {
        [_classNameDic removeObjectForKey:tableName];
    }
    
    if ([keyName count]) {
        [_keysNameDic setObject:keyName forKey:tableName];
    }
    else {
        [_keysNameDic removeObjectForKey:tableName];
    }
}

- (NSString *)classNameBy:(NSString *)tableName {
    
    return [_classNameDic objectForKey:tableName];
}

- (NSArray *)keysNameBy:(NSString *)tableName {
    
    return [_keysNameDic objectForKey:tableName];
}

#pragma mark - data add\delete\modify\select methods
/**
 *  插入或者更新一条数据
 *
 *  @param tableName  表类型
 *  @param saveValue  待保存的对象属性和值
 *  @param isCover    YES:存在则更新，不存在则插入 NO:存在则不更新，不存在则插入
 *  @param error
 *  @param return     YES:数据库更改成功 NO:更改失败
 */
- (BOOL)saveTo:(NSString *)tableName value:(NSDictionary *)saveValue isCover:(BOOL)isCover error:(NSError *__autoreleasing *)error {
    
    if (!saveValue) {
        return YES;
    }
    
    return [self saveTo:tableName valueArray:@[saveValue] isCover:isCover error:error];
}

/**
 *  插入或者更新多条数据
 *
 *  @param tableName        表类型
 *  @param saveValueArray   待保存的对象属性和值数组
 *  @param isCover          YES:存在则更新，不存在则插入 NO:存在则不更新，不存在则插入
 *  @param error
 *  @param return           YES:数据库更改成功 NO:更改失败
 */
- (BOOL)saveTo:(NSString *)tableName valueArray:(NSArray <NSDictionary *> *)saveValueArray isCover:(BOOL)isCover error:(NSError *__autoreleasing *)error {

    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:self.managedObjectContext];
    
    NSArray *keys = [self keysNameBy:tableName];
    
    NSArray *propertyName = [[entity attributesByName] allKeys];
    
    if ([keys count] < 1) {//直接插入
        
        for (NSDictionary *saveValue in saveValueArray) {
            
            NSManagedObject *addObj = [NSEntityDescription insertNewObjectForEntityForName:tableName inManagedObjectContext:self.managedObjectContext];
            
            for (NSString *property in [saveValue allKeys]) {
                
                if ([propertyName containsObject:property]) {
                    [addObj setValue:[saveValue objectForKey:property] forKey:property];
                }
                else {
                    DBG(@"unknown property %@",property);
                }
            }
        }
        
        return [self.managedObjectContext save:error];
    }
    else {
        
        for (NSDictionary *saveValue in saveValueArray) {
            
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            [request setEntity:entity];
            [request setReturnsObjectsAsFaults:NO];
            
            NSMutableString *str = [[NSMutableString alloc] init];
            
            NSString *firstKey = [keys firstObject];
            //            [str appendFormat:@"%@ == \"%@\"",firstKey,[saveValue objectForKey:firstKey]];
            //
            //            for (int i = 1; i < [keys count]; i++) {
            //
            //                NSString *keyName = [keys objectAtIndex:i];
            //                id value = [saveValue objectForKey:keyName];
            //
            //                [str appendFormat:@" AND %@ == \"%@\"",keyName,value];
            //            }
            //
            //            NSPredicate *predicate = [NSPredicate predicateWithFormat:str];
            
            NSMutableArray *values = [NSMutableArray arrayWithCapacity:1];
            [str appendFormat:@"%@ == %%@",firstKey];
            [values addObject:[saveValue objectForKey:firstKey]];
            
            for (int i = 1; i < [keys count]; i++) {
                
                NSString *keyName = [keys objectAtIndex:i];
                [str appendFormat:@" AND %@ == %%@",keyName];
                [values addObject:[saveValue objectForKey:keyName]];
            }
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:str argumentArray:values];
            [request setPredicate:predicate];
            
            NSError *error = nil;
            NSArray *dataArray = [self.managedObjectContext executeFetchRequest:request error:&error];
            
            NSManagedObject *obj = [dataArray firstObject];
            
            if (obj) {
                
                for (int i = 1; i < [dataArray count]; i++) {
                    
                    [self.managedObjectContext deleteObject:dataArray[i]];
                }
                
                if (isCover) {
                    
                    for (NSString *property in [saveValue allKeys]) {
                        
                        if ([propertyName containsObject:property]) {
                            [obj setValue:[saveValue objectForKey:property] forKey:property];
                        }
                        else {
                            DBG(@"unknown property %@",property);
                        }
                    }
                }
            }
            else {
                NSManagedObject *addObj = [NSEntityDescription insertNewObjectForEntityForName:tableName inManagedObjectContext:self.managedObjectContext];
                
                for (NSString *property in [saveValue allKeys]) {
                    
                    if ([propertyName containsObject:property]) {
                        [addObj setValue:[saveValue objectForKey:property] forKey:property];
                    }
                    else {
                        DBG(@"unknown property %@",property);
                    }
                }
            }
        }
        
        return [self.managedObjectContext save:error];
    }
    
    return YES;
}

/**
 *  删除一条数据
 *
 *  @param tableName        表类型
 *  @param deleteValue      被删除的对象属性和值(一般应为主键跟主键值)
 *  @param error
 *  @param return           YES:数据库更改成功 NO:更改失败
 */
- (BOOL)deleteFrom:(NSString *)tableName keyValue:(NSDictionary *)keyValue error:(NSError *__autoreleasing *)error {
    
    if (!keyValue) {
        return YES;
    }
    
    return [self deleteFrom:tableName keyValueArray:@[keyValue] error:error];
}

/**
 *  删除多条数据
 *
 *  @param tableName            表类型
 *  @param deleteValueArray     被删除的对象属性和值数组(一般应为主键跟主键值)
 *  @param error
 *  @param return               YES:数据库更改成功 NO:更改失败
 */
- (BOOL)deleteFrom:(NSString *)tableName keyValueArray:(NSArray <NSDictionary *> *)keyValueArray error:(NSError *__autoreleasing *)error {
    
    if ([keyValueArray count] > 0) {
        
        for (NSDictionary *deleteValue in keyValueArray) {
            
            NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:self.managedObjectContext];
            
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            [request setEntity:entity];
            [request setReturnsObjectsAsFaults:NO];
            
            NSMutableString *str = [[NSMutableString alloc] init];
            
            for (NSString *key in [deleteValue allKeys]) {
                
                [str appendFormat:@"%@ == %@",key,[deleteValue objectForKey:key]];
                [str appendFormat:@" AND "];
            }
            
            NSString *condition = str;
            if (str.length > 5) {
                condition = [str substringWithRange:NSMakeRange(0, str.length - 5)];
            }
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:condition];
            [request setPredicate:predicate];
            
            NSArray *dataArray = [self.managedObjectContext executeFetchRequest:request error:nil];
            
            for (NSManagedObject *dObj in dataArray) {
                
                [self.managedObjectContext deleteObject:dObj];
            }
        }
        
        return [self.managedObjectContext save:error];
    }
    
    return YES;
}

/**
 *  删除数据
 *
 *  @param tableName        表类型
 *  @param condition        删除条件(自定义删除条件)
 *  @param error
 *  @param return           YES:数据库更改成功 NO:更改失败
 */
- (BOOL)deleteFrom:(NSString *)tableName customCondition:(NSString *)condition error:(NSError *__autoreleasing *)error {
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    [request setReturnsObjectsAsFaults:NO];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:condition];
    [request setPredicate:predicate];
    
    NSArray *dataArray = [self.managedObjectContext executeFetchRequest:request error:nil];
    
    for (NSManagedObject *dObj in dataArray) {
        
        [self.managedObjectContext deleteObject:dObj];
    }
    
    return [self.managedObjectContext save:error];
}

/**
 *  查询数据
 *
 *  @param tableName        表类型
 *  @param condition        查询条件(一般应为主键跟主键值)
 *  @param error
 *  @param return           对象的属性跟值字典
 */
- (NSDictionary *)selectFrom:(NSString *)tableName keyValue:(NSDictionary *)keyValue error:(NSError *__autoreleasing *)error {
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    [request setReturnsObjectsAsFaults:NO];
    
    NSMutableString *str = [[NSMutableString alloc] init];
    
    for (NSString *key in [keyValue allKeys]) {
        
        [str appendFormat:@"%@ == %@",key,[keyValue objectForKey:key]];
        [str appendFormat:@" AND "];
    }
    
    NSString *condition = str;
    if (str.length > 5) {
        condition = [str substringWithRange:NSMakeRange(0, str.length - 5)];
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:condition];
    [request setPredicate:predicate];
    
    NSArray *dataArray = [self.managedObjectContext executeFetchRequest:request error:error];
    NSManagedObject *selectObj = [dataArray firstObject];
    if (selectObj) {
        
        NSArray *propertyName = [[entity attributesByName] allKeys];
        
        NSMutableDictionary *tmp = [NSMutableDictionary dictionaryWithCapacity:1];
        
        for (NSString *key in propertyName) {
            
            id value = [selectObj valueForKey:key];
            if (value) {
                [tmp setObject:value forKey:key];
            }
        }
        
        return tmp;
    }
    
    return nil;
    
}

/**
 *  查询多条数据
 *
 *  @param tableName        表类型
 *  @param condition        查询条件(自定义NSPreadicate语句)
 *  @param sortArray        排序方式
 *  @param range            查询范围(range.lenth为0时查询range.location之后的所有)
 *  @param error
 *  @param return           对象的属性跟值字典数组
 */
- (NSArray <NSDictionary *> *)selectFrom:(NSString *)tableName
                         customCondition:(NSString *)condition
                               sortArray:(NSArray <NSDictionary *>*)sortArray
                                   range:(NSRange)range
                                   error:(NSError *__autoreleasing *)error {
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    [request setReturnsObjectsAsFaults:NO];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:condition];
    [request setPredicate:predicate];
    
    NSMutableArray *sortDes = [NSMutableArray arrayWithCapacity:1];
    for (NSDictionary *sortInfo in sortArray) {
        
        NSString *sortKey = [[sortInfo allKeys] firstObject];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:[[sortInfo objectForKey:sortKey] boolValue]];
        [sortDes addObject:sortDescriptor];
    }
    
    [request setSortDescriptors:sortDes];
    
    [request setFetchOffset:range.location];
    if (range.length > 0) {
        [request setFetchLimit:range.length];
    }
    
    NSArray *dataArray = [self.managedObjectContext executeFetchRequest:request error:nil];
    
    NSMutableArray *select = [NSMutableArray arrayWithCapacity:1];
    
    NSArray *propertyName = [[entity attributesByName] allKeys];
    
    for (NSManagedObject *selectObj in dataArray) {
        
        NSMutableDictionary *objInfo = [NSMutableDictionary dictionaryWithCapacity:1];
        
        for (NSString *key in propertyName) {
            
            id value = [selectObj valueForKey:key];
            if (value) {
                [objInfo setObject:value forKey:key];
            }
        }
        
        if ([objInfo count]) {
            [select addObject:objInfo];
        }
    }
    
    return select;
}
@end
