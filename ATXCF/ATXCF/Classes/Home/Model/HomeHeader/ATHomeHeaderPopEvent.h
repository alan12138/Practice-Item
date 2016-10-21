//
//  ATHomeHeaderPopEvent.h
//  ATXCF
//
//  Created by 谷士雄 on 16/10/9.
//  Copyright © 2016年 alan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATHomeHeaderPopEvent : NSObject
@property (nonatomic, assign) NSUInteger n_dishes;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, strong) NSDictionary *dishes;

@property (nonatomic, copy) NSString *name;

@end
