//
//  ATHomeCellClickMealsRecipe.h
//  ATXCF
//
//  Created by 谷士雄 on 16/10/21.
//  Copyright © 2016年 alan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATHomeCellClickMealsRecipeAuthor.h"
#import "ATHomeCellClickMealsRecipeStats.h"

@interface ATHomeCellClickMealsRecipe : NSObject
@property (nonatomic, strong) ATHomeCellClickMealsRecipeAuthor *author;

@property (nonatomic, copy) NSString *score;

@property (nonatomic, copy) NSString *video_url;

@property (nonatomic, assign) BOOL is_exclusive;

@property (nonatomic, strong) ATHomeCellClickMealsRecipeStats *stats;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *photo;

@property (nonatomic, copy) NSString *name;

@end
