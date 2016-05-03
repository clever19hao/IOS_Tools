//
//  CE_DBData.m
//  CommanApp
//
//  Created by cxq on 15/12/3.
//  Copyright © 2015年 cxq. All rights reserved.
//

#import "CE_DBData.h"
#import <objc/runtime.h>

@implementation CE_DBData

- (NSMutableDictionary *)getSelfInfo
{
    NSMutableDictionary *dictionaryFormat = [NSMutableDictionary dictionary];
    
    //  取得当前类类型
    Class cls = [self class];
    
    do {
        unsigned int ivarsCnt = 0;
        //　获取类成员变量列表，ivarsCnt为类成员数量
        //Ivar *ivars = class_copyIvarList(cls, &ivarsCnt);
        objc_property_t *properties =class_copyPropertyList(cls, &ivarsCnt);
        
        //　遍历成员变量列表，其中每个变量都是Ivar类型的结构体
        //for (const Ivar *p = ivars; p < ivars + ivarsCnt; ++p)
        for (int i = 0; i < ivarsCnt; i++)
        {
            //Ivar const ivar = *p;
            //　 获取变量名
            //   NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
            //  若此变量未在类结构体中声明而只声明为Property，则变量名加前缀 '_'下划线
            //  比如 @property(retain) NSString *abc;则 key == _abc;
            //　获取变量值
            //id value = [self valueForKey:key];
            //
            objc_property_t property = properties[i];
            const char* char_f =property_getName(property);
            NSString *key = [NSString stringWithUTF8String:char_f];
            id value = [self valueForKey:key];
            
            //　取得变量类型
            // 通过 type[0]可以判断其具体的内置类型
            //const char *type = ivar_getTypeEncoding(ivar);
            
            if ([dictionaryFormat objectForKey:key]) {
                continue;
            }
            
            if (value && ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSData class]] || [value isKindOfClass:[NSDate class]])) {//coredata存储的数据类型
                
                [dictionaryFormat setObject:value forKey:key];
            }else if ([value isKindOfClass:[NSDictionary class]]){
                
                NSData *data = [NSJSONSerialization dataWithJSONObject:value options:NSJSONWritingPrettyPrinted error:nil];
                if(data) {
                    [dictionaryFormat setObject:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] forKey:key];
                }
            }
        }
        
        //free(ivars);
        free(properties);
        //
        //        NSMutableDictionary *props = [NSMutableDictionary dictionary];
        //        unsigned int outCount, i;
        //        objc_property_t *properties =class_copyPropertyList([self class], &outCount);
        //        for (i = 0; i<outCount; i++)
        //        {
        //            objc_property_t property = properties[i];
        //            const char* char_f =property_getName(property);
        //            NSString *propertyName = [NSString stringWithUTF8String:char_f];
        //            id propertyValue = [self valueForKey:(NSString *)propertyName];
        //            if (propertyValue) [props setObject:propertyValue forKey:propertyName];
        //        }
        //        free(properties);
        if (cls == [CE_DBData class]) {
            break;
        }
        
        cls = class_getSuperclass(cls);
        
    } while (1);
    
    return dictionaryFormat;
}

- (void)setSelfInfoBy:(NSDictionary *)info {
    
    [self setValuesForKeysWithDictionary:info];
    //    for (NSString *property in [info allKeys]) {
    //
    //        id value = [info objectForKey:property];
    //        
    //        [self setValue:value forKey:property];
    //    }
}

- (NSString *)tableName {

    return NSStringFromClass([self class]);
}

- (void)saveToDB {
    
    NSDictionary *info = [self getSelfInfo];
    
    dispatch_async(DB_QUEUE, ^{
        
        [[CE_CoreDataManager shareManager] saveTo:[self tableName] value:info isCover:YES error:nil];
    });
}

+ (void)saveArrayToDB:(NSArray <CE_DBData *> *)objArray {
    
    if ([objArray count]) {
        
        CE_DBData *first = [objArray firstObject];
        
        NSMutableArray *objInfos = [NSMutableArray arrayWithCapacity:1];
        for (CE_DBData *obj in objArray) {
            [objInfos addObject:[obj getSelfInfo]];
        }
        
        dispatch_async(DB_QUEUE, ^{
            
            [[CE_CoreDataManager shareManager] saveTo:[first tableName] valueArray:objInfos isCover:YES error:nil];
        });
    }
}

- (void)deleteFromDB {
    
    NSDictionary *info = [self getSelfInfo];
    
    dispatch_async(DB_QUEUE, ^{
        
        NSMutableDictionary *deleteInfo = [NSMutableDictionary dictionaryWithCapacity:1];
        
        for (NSString *key in [[CE_CoreDataManager shareManager] keysNameBy:[self tableName]]) {
            
            id value = [info objectForKey:key];
            if (value) {
                [deleteInfo setObject:value forKey:key];
            }
            else {
                return;
            }
        }
        
        [[CE_CoreDataManager shareManager] deleteFrom:[self tableName] keyValue:deleteInfo error:nil];
    });
}


@end
