//
//  ATPopularMenuThisWeekRecipe.h
//  ATXCF
//
//  Created by 谷士雄 on 16/9/30.
//  Copyright © 2016年 alan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATPopularMenuThisWeekRecipeAuthor.h"
#import "ATATPopularMenuThisWeekRecipeStats.h"

@interface ATPopularMenuThisWeekRecipe : NSObject
@property (nonatomic, strong) ATPopularMenuThisWeekRecipeAuthor *author;

@property (nonatomic, copy) NSString *score;

@property (nonatomic, copy) NSString *video_url;

@property (nonatomic, assign) BOOL is_exclusive;

@property (nonatomic, strong) ATATPopularMenuThisWeekRecipeStats *stats;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *photo;

@property (nonatomic, copy) NSString *name;
@end
