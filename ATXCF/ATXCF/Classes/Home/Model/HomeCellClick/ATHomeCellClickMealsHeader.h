//
//  ATHomeCellClickMealsHeader.h
//  ATXCF
//
//  Created by 谷士雄 on 16/10/21.
//  Copyright © 2016年 alan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATHomeCellClickMealsHeaderAuthor.h"

@interface ATHomeCellClickMealsHeader : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) ATHomeCellClickMealsHeaderAuthor *author;
@property (nonatomic, copy) NSString *desc;
@end
