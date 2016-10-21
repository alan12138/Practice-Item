//
//  ATThreeMealsDish.h
//  ATXCF
//
//  Created by 谷士雄 on 16/10/18.
//  Copyright © 2016年 alan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATThreeMealsAuthor.h"

@interface ATThreeMealsDish : NSObject
@property (nonatomic, strong) NSDictionary *main_pic;
@property (nonatomic, strong) ATThreeMealsAuthor *author;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, assign) NSUInteger ndiggs;

@end
