//
//  CE_DBData.h
//  CommanApp
//
//  Created by cxq on 15/12/3.
//  Copyright © 2015年 cxq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CE_CoreDataManager.h"

@protocol CEData <NSObject>

@required

- (NSMutableDictionary *)getSelfInfo;

- (void)setSelfInfoBy:(NSDictionary *)info;

@end

/* 需要CoreData存储的数据都需要用@property声明 符合kvc*/
@interface CE_DBData : NSObject <CEData>

/**
 *  @param return 对象存储在数据库中的表名字
 */
- (NSString *)tableName;

/**
 *  存储对象到数据库
 */
- (void)saveToDB;

/**
 *  存储一组对象到数据库
 *
 *  @param objArray 对象数组
 */
+ (void)saveArrayToDB:(NSArray <CE_DBData *> *)objArray;

/**
 *  从数据库删除数据
 */
- (void)deleteFromDB;

@end


