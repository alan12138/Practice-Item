//
//  NSObject+ATProperty.m
//  自动生成模型属性工具类
//
//  Created by lg on 16/6/29.
//  Copyright © 2016年 at. All rights reserved.
//

#import "NSObject+ATProperty.h"

@implementation NSObject (ATProperty)
+ (void)createPropertyCodeWithDict:(NSDictionary *)dict {
    NSMutableString *propertyCode = [NSMutableString string];
    
    //遍历字典
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//        NSLog(@"%@ %@", key, [obj class]);
        
        NSString *code = nil;
        //判断不同类型的属性定义代码(注意：字典改成对象的时候copy要改成strong)
        if ([obj isKindOfClass:NSClassFromString(@"__NSCFString")]) {
            code = [NSString stringWithFormat:@"@property (nonatomic, copy) NSString *%@;", key];
        } else if ([obj isKindOfClass:NSClassFromString(@"__NSCFBoolean")]) {
            code = [NSString stringWithFormat:@"@property (nonatomic, assign) BOOL %@;", key];
        } else if ([obj isKindOfClass:NSClassFromString(@"__NSCFNumber")]) {
            code = [NSString stringWithFormat:@"@property (nonatomic, assign) NSUInteger %@;", key];
        } else if ([obj isKindOfClass:NSClassFromString(@"__NSCFDictionary")]) {
            code = [NSString stringWithFormat:@"@property (nonatomic, copy) NSDictionary *%@;", key];
        } else if ([obj isKindOfClass:NSClassFromString(@"__NSCFArray")]) {
            code = [NSString stringWithFormat:@"@property (nonatomic, copy) NSArray *%@;", key];
        }
        //拼接字符串
        [propertyCode appendFormat:@"\n%@\n", code];
    }];
    NSLog(@"%@",propertyCode);
}
@end
