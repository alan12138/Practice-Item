//
//  ATHomeCellIssue.h
//  ATXCF
//
//  Created by 谷士雄 on 16/10/12.
//  Copyright © 2016年 alan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATHomeCellIssue : NSObject
@property (nonatomic, assign) NSUInteger items_count;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSArray *items;

@property (nonatomic, assign) NSUInteger issue_id;

@property (nonatomic, copy) NSString *publish_date;

@end
