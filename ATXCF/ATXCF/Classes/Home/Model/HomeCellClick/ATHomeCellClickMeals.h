//
//  ATHomeCellClickMeals.h
//  ATXCF
//
//  Created by 谷士雄 on 16/10/21.
//  Copyright © 2016年 alan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATHomeCellClickMealsRecipe.h"

@interface ATHomeCellClickMeals : NSObject
@property (nonatomic, strong) ATHomeCellClickMealsRecipe *recipe;

@property (nonatomic, copy) NSString *track_info;

@property (nonatomic, copy) NSString *reason;
@end
