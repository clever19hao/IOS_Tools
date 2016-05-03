//
//  CE_CoreDataManager.h
//  CommanApp
//
//  Created by cxq on 15/12/2.
//  Copyright © 2015年 cxq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#define DB_QUEUE [[CE_CoreDataManager shareManager] coreDataQueue]

/* 非线程安全, 需要将对象通过KVC转化成字典进行存储 */
@interface CE_CoreDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (CE_CoreDataManager *)shareManager;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (dispatch_queue_t)coreDataQueue;

- (NSArray <NSString *> *)keysNameBy:(NSString *)tableName;

/**
 *  声明一张表，需要在数据库中先建好
 *
 *  @param tableName    在数据库中新建的表名字
 *  @param className    该表存储的数据类名字,目前没有操作类,使用的是对象转化的字典，所以该参数可为nil
 *  @param keyName      表的主键
 *  @param return
 */
- (void)registTable:(NSString *)tableName className:(NSString *)className keyNames:(NSArray *)keyName;

/**
 *  插入或者更新一条数据
 *
 *  @param tableName  表类型
 *  @param saveValue  待保存的对象属性和值
 *  @param isCover    YES:存在则更新，不存在则插入 NO:存在则不更新，不存在则插入
 *  @param error
 *  @param return     YES:数据库更改成功 NO:更改失败
 */
- (BOOL)saveTo:(NSString *)tableName value:(NSDictionary *)saveValue isCover:(BOOL)isCover error:(NSError *__autoreleasing *)error;

/**
 *  插入或者更新多条数据
 *
 *  @param tableName        表类型
 *  @param saveValueArray   待保存的对象属性和值数组
 *  @param isCover          YES:存在则更新，不存在则插入 NO:存在则不更新，不存在则插入
 *  @param error
 *  @param return           YES:数据库更改成功 NO:更改失败
 */
- (BOOL)saveTo:(NSString *)tableName valueArray:(NSArray <NSDictionary *> *)saveValueArray isCover:(BOOL)isCover error:(NSError *__autoreleasing *)error;

/**
 *  删除一条数据
 *
 *  @param tableName        表类型
 *  @param keyValue         被删除的对象属性和值(一般应为主键跟主键值)
 *  @param error
 *  @param return           YES:数据库更改成功 NO:更改失败
 */
- (BOOL)deleteFrom:(NSString *)tableName keyValue:(NSDictionary *)keyValue error:(NSError *__autoreleasing *)error;

/**
 *  删除多条数据
 *
 *  @param tableName            表类型
 *  @param keyValueArray        被删除的对象属性和值数组(一般应为主键跟主键值)
 *  @param error
 *  @param return               YES:数据库更改成功 NO:更改失败
 */
- (BOOL)deleteFrom:(NSString *)tableName keyValueArray:(NSArray <NSDictionary *> *)keyValueArray error:(NSError *__autoreleasing *)error;

/**
 *  删除数据
 *
 *  @param tableName        表类型
 *  @param condition        删除条件(自定义NSPreadicate语句)
 *  @param error
 *  @param return           YES:数据库更改成功 NO:更改失败
 */
- (BOOL)deleteFrom:(NSString *)tableName customCondition:(NSString *)condition error:(NSError *__autoreleasing *)error;

/**
 *  查询数据
 *
 *  @param tableName        表类型
 *  @param keyValue         查询条件(一般应为主键跟主键值)
 *  @param error
 *  @param return           对象的属性跟值字典
 */
- (NSDictionary *)selectFrom:(NSString *)tableName keyValue:(NSDictionary *)keyValue error:(NSError *__autoreleasing *)error;

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
                                   error:(NSError *__autoreleasing *)error;
@end
