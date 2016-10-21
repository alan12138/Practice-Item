//
//  ATHomeCellItem.h
//  ATXCF
//
//  Created by 谷士雄 on 16/10/10.
//  Copyright © 2016年 alan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATHomeCellItemContent.h"

@interface ATHomeCellItem : NSObject
@property (nonatomic, assign) NSUInteger ID;

@property (nonatomic, copy) NSString *column_name;

@property (nonatomic, copy) NSString *publish_time;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, assign) NSUInteger template;

@property (nonatomic, strong) ATHomeCellItemContent *contents;

@end
