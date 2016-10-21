//
//  ATThreeMealsHeaderCollectionReusableView.h
//  ATXCF
//
//  Created by 谷士雄 on 16/10/17.
//  Copyright © 2016年 alan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ATThreeMealsHeader;
@interface ATThreeMealsHeaderCollectionReusableView : UICollectionReusableView
@property (nonatomic, strong) ATThreeMealsHeader *threeMealsHeader;
+ (CGFloat)headerHeightWithHeader:(ATThreeMealsHeader *)threeMealsHeader;
@end
