//
//  NSObject+ATObjectModel.m
//  runtime_字典转模型
//
//  Created by lg on 16/6/30.
//  Copyright © 2016年 at. All rights reserved.
//

#import "NSObject+ATObjectModel.h"
#import <objc/message.h>

@implementation NSObject (ATObjectModel)
+ (__kindof NSObject *)objectModelWithDict:(NSDictionary *)dict {
    //创建对应模型类
    id obj = [[self alloc] init];
    
    //成员属性数量
    unsigned int count = 0;
    //获取模型类属性列表数组
    Ivar *ivarList = class_copyIvarList(self, &count);
    //遍历所有成员属性
    for (int i = 0; i < count; i++) {
        //获取成员属性(Ivar)
        Ivar ivar = ivarList[i];
        //获取成员属性名
        NSString *propertyName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        //去掉proprtyName前面的下划线
        propertyName = [propertyName substringFromIndex:1];
        
        //获取value
        id value = nil;
        if ([propertyName isEqualToString:@"ID"]) {
            value = dict[@"id"];
        } else {
            value = dict[propertyName];
        }
        
        //二级转换
        //获取成员属性类型
        NSString *propertyType = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        //如果value是字典(实质是字典类型，但是不是NSDictionary，因为如果类型还是NSDictionary没有必要转换)
        if ([value isKindOfClass:[NSDictionary class]] && ![propertyType containsString:@"NS"]) {
            //            NSLog(@"%@", propertyType);
            //获取属性类型(剪切字符串@"@\"ATUser\"")
            NSString *type = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
            NSRange range = [type rangeOfString:@"\""];
            type = [type substringFromIndex:range.location + range.length];
            range = [type rangeOfString:@"\""];
            type = [type substringToIndex:range.location];
            
            Class modelClass = NSClassFromString(type);
            if (modelClass) { //有对应的类型才需要转
                value = [modelClass objectModelWithDict:value];
            }
        }
        
        //三级转换（如果value是数组，数组中再包含字典）
        if ([value isKindOfClass:[NSArray class]]) {
            //如果模型类实现了字典数组转模型数组的协议
            if ([self respondsToSelector:@selector(ModelClassInArray)]) {
                //转换成id类型，就能调用任何对象的方法
                id idSelf = self;
                //获取数组中的模型
                NSString *type = [idSelf ModelClassInArray][propertyName];
                Class modelClass = NSClassFromString(type);
                
                NSMutableArray *dictArr = [NSMutableArray array];
                //遍历数组
                for (NSDictionary *dict in value) {
                    //转模型
                    id model = [modelClass objectModelWithDict:dict];
                    [dictArr addObject:model];
                }
                //把模型数组赋值给value
                value = dictArr;
            }
        }
        
        
        
        if (value) {
            //KVC赋值，不能传空
            [obj setValue:value forKey:propertyName];
        }
        
    }
    //C语言函数，ARC不会自动释放，需要手动释放
    free(ivarList);
    return obj;
}
@end
