//
//  CE_CachePool.m
//  Ymr
//
//  Created by cxq on 16/4/5.
//  Copyright © 2016年 celink. All rights reserved.
//

#import "CE_CachePool.h"


@interface CE_CachePool ()

@property (nonatomic,strong) NSMutableDictionary *allCacheDic;
@property (nonatomic,strong) NSCache *defualtCache;

@end

@implementation CE_CachePool

+ (CE_CachePool *)defualtCachePool {
    
    static CE_CachePool *ins = nil;
    static dispatch_once_t cacheOnce;
    dispatch_once(&cacheOnce, ^{
        
        if (!ins) {
            ins = [[CE_CachePool alloc] init];
        }
    });
    
    return ins;
}

- (id)init {
    
    if (self = [super init]) {
        
        _allCacheDic = [NSMutableDictionary dictionaryWithCapacity:1];
        _defualtCache = [[NSCache alloc] init];
    }
    
    return self;
}

+ (NSCache *)cacheWithIdentifier:(NSString *)identifier {
    
    NSCache *cache = [[CE_CachePool defualtCachePool].allCacheDic objectForKey:identifier];
    
    if (!cache) {
        cache = [[NSCache alloc] init];
        [[CE_CachePool defualtCachePool].allCacheDic setObject:cache forKey:identifier];
    }
    
    return cache;
}

+ (void)removeCacheWithIdentifier:(NSString *)identifier {
    
    [[CE_CachePool defualtCachePool].allCacheDic removeObjectForKey:identifier];
}

+ (void)saveObjToDefualtCache:(id)obj key:(id)key {
    
    if (!obj || !key) {
        return;
    }
    
    [[CE_CachePool defualtCachePool].defualtCache setObject:obj forKey:key];
}

+ (id)getObjByKey:(id)key {
    
    return [[CE_CachePool defualtCachePool].defualtCache objectForKey:key];
}

+ (void)removeObjByKey:(id)key {
    
    [[CE_CachePool defualtCachePool].defualtCache removeObjectForKey:key];
}

+ (void)clearAllCache {
    
    [[CE_CachePool defualtCachePool].allCacheDic removeAllObjects];
    [[CE_CachePool defualtCachePool].defualtCache removeAllObjects];
}

@end
