//
//  CE_CachePool.h
//  Ymr
//
//  Created by cxq on 16/4/5.
//  Copyright © 2016年 celink. All rights reserved.
//

#import <Foundation/Foundation.h>

//APP全局缓存池，统一管理。需要缓存的数据都应该缓存到这里
@interface CE_CachePool : NSObject

//各功能模块加载数据时，如果需要缓存，则通过此方法获取，存取数据规则字定义
+ (NSCache *)cacheWithIdentifier:(NSString *)identifier;
+ (void)removeCacheWithIdentifier:(NSString *)identifier;

//默认缓存，存一些比较杂的对象，比如图片缩略图，UIView等
+ (void)saveObjToDefualtCache:(id)obj key:(id)key;
+ (id)getObjByKey:(id)key;
+ (void)removeObjByKey:(id)key;

//注销或者需要清理数据时，调用该方法
+ (void)clearAllCache;

@end
