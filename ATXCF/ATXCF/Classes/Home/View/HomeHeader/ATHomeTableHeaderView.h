//
//  ATHomeTableHeaderView.h
//  ATXCF
//
//  Created by 谷士雄 on 16/9/28.
//  Copyright © 2016年 alan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ATHomeHeaderSection;
typedef void (^ATHomeHeaderSectionClick)(ATHomeHeaderSection *section);
typedef void (^ATHomeHeaderPicClick)(void);
typedef void (^ATHomeHeaderCarouselClick)(NSUInteger index);

@interface ATHomeTableHeaderView : UIView
@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic, strong) NSMutableArray *events;
@property (nonatomic, copy) NSString *headerleftPicUrlStr;
@property (nonatomic, copy) ATHomeHeaderSectionClick sectionClick;
@property (nonatomic, copy) ATHomeHeaderPicClick picClick;
@property (nonatomic, copy) ATHomeHeaderCarouselClick carouselClick;
@end
