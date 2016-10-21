//
//  ATThreeMealsHeaderCollectionReusableView.m
//  ATXCF
//
//  Created by 谷士雄 on 16/10/17.
//  Copyright © 2016年 alan. All rights reserved.
//

#import "ATThreeMealsHeaderCollectionReusableView.h"
#import "ATThreeMealsHeader.h"

static CGFloat const BIG_MARGIN = 20;
static CGFloat const MARGIN = 10;

@interface  ATThreeMealsHeaderCollectionReusableView()
@property (nonatomic, weak) ATLabel *mealLabel;
@property (nonatomic, weak) ATLabel *dishesCountLabel;
@property (nonatomic, weak) ATLabel *timeLabel;
@end

@implementation ATThreeMealsHeaderCollectionReusableView
- (void)setThreeMealsHeader:(ATThreeMealsHeader *)threeMealsHeader {
    _threeMealsHeader = threeMealsHeader;
    self.mealLabel.text = threeMealsHeader.name;
    self.dishesCountLabel.text = [NSString stringWithFormat:@"%ld作品",threeMealsHeader.n_dishes];
    self.timeLabel.text = threeMealsHeader.desc;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = ATMainBackgroundColor;
        [self setupSubViews];
        [self autoLayoutSubViews];
    }
    return self;
}
- (void)setupSubViews {
    ATLabel *mealLabel = [[ATLabel alloc] init];
    mealLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:mealLabel];
    self.mealLabel = mealLabel;
    
    ATLabel *dishesCountLabel = [[ATLabel alloc] init];
    dishesCountLabel.textColor = [UIColor grayColor];
    dishesCountLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:dishesCountLabel];
    self.dishesCountLabel = dishesCountLabel;
    
    ATLabel *timeLabel = [[ATLabel alloc] init];
    timeLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:timeLabel];
    self.timeLabel = timeLabel;
}
- (void)autoLayoutSubViews {
    [self.mealLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(BIG_MARGIN);
    }];
    [self.dishesCountLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mealLabel);
        make.top.equalTo(self.mealLabel.bottom).offset(MARGIN);
    }];
    [self.timeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.dishesCountLabel);
        make.top.equalTo(self.dishesCountLabel.bottom).offset(BIG_MARGIN);
    }];
}
+ (CGFloat)headerHeightWithHeader:(ATThreeMealsHeader *)threeMealsHeader {
    if (threeMealsHeader.desc.length) {
        return 120;
    } else {
        return 80;
    }
}
@end
