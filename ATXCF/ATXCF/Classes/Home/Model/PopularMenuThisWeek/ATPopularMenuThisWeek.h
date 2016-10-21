//
//  ATPopularMenuThisWeek.h
//  ATXCF
//
//  Created by 谷士雄 on 16/9/30.
//  Copyright © 2016年 alan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATPopularMenuThisWeekRecipe.h"

@interface ATPopularMenuThisWeek : NSObject

@property (nonatomic, strong) ATPopularMenuThisWeekRecipe *recipe;

@property (nonatomic, copy) NSString *track_info;

@property (nonatomic, copy) NSString *reason;
@end
