//
//  NSObject+ATObjectModel.h
//  runtime_字典转模型
//
//  Created by lg on 16/6/30.
//  Copyright © 2016年 at. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ObjectModelDelegate <NSObject>

+ (NSDictionary *)ModelClassInArray;

@end

@interface NSObject (ATObjectModel)
+ (__kindof NSObject *)objectModelWithDict:(NSDictionary *)dict;
@end
