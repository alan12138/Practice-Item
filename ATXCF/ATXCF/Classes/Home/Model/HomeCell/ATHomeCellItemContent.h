//
//  ATHomeCellItemContent.h
//  ATXCF
//
//  Created by 谷士雄 on 16/10/10.
//  Copyright © 2016年 alan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATHomeCellItemContentImage.h"
#import "ATHomeCellItemContentAuthor.h"

@interface ATHomeCellItemContent : NSObject
@property (nonatomic, copy) NSString *title_2nd;
@property (nonatomic, copy) NSString *title_1st;
@property (nonatomic, copy) NSString *whisper;
@property (nonatomic, strong) ATHomeCellItemContentImage *image;
@property (nonatomic, strong) ATHomeCellItemContentAuthor *author;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, assign) NSUInteger n_cooked;
@property (nonatomic, assign) NSUInteger n_discussions;
@property (nonatomic, copy) NSString *score;

@end
