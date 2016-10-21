//
//  ATThreeMealsCollectionViewCell.m
//  ATXCF
//
//  Created by 谷士雄 on 16/10/17.
//  Copyright © 2016年 alan. All rights reserved.
//

#import "ATThreeMealsCollectionViewCell.h"
#import "ATThreeMealsDish.h"

@interface ATThreeMealsCollectionViewCell ()
@property (nonatomic, weak) ATImageView *dishImageView;
@property (nonatomic, weak) ATLabel *nameLabel;
@property (nonatomic, weak) ATLabel *descLabel;
@property (nonatomic, weak) ATButton *goodBtn;
@end

@implementation ATThreeMealsCollectionViewCell
- (void)setDish:(ATThreeMealsDish *)dish {
    _dish = dish;
    [self.dishImageView setMainImageURL:[NSURL URLWithString:(dish.main_pic)[@"360w_360h"]]];
    self.nameLabel.text = dish.author.name;
    
    dish.desc = [dish.desc stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"#%@#",dish.name] withString:@""];
    self.descLabel.text = dish.desc;
    
    [self.goodBtn setTitle:[NSString stringWithFormat:@"%ld",dish.ndiggs]];
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubViews];
        [self autoLayoutSubViews];
    }
    return self;
}
- (void)setupSubViews {
    ATImageView *dishImageView = [[ATImageView alloc] init];
    dishImageView.userInteractionEnabled = NO;
    [self.contentView addSubview:dishImageView];
    self.dishImageView = dishImageView;
    
    ATLabel *nameLabel = [[ATLabel alloc] init];
    nameLabel.font = [UIFont systemFontOfSize:12];
    nameLabel.textColor = [UIColor redColor];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    ATLabel *descLabel = [[ATLabel alloc] init];
    descLabel.numberOfLines = 2;
    descLabel.font = [UIFont systemFontOfSize:12];
    descLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:descLabel];
    self.descLabel = descLabel;
    
    ATButton *goodBtn = [[ATButton alloc] init];
    goodBtn.buttonStyle = ATButtonStyleUpImageDownTitle;
    [goodBtn setImage:[UIImage imageNamed:@"common_like"]];
    [goodBtn setTitleColor:[UIColor grayColor]];
    [goodBtn setTitleFontSize:12];
    [self.contentView addSubview:goodBtn];
    self.goodBtn = goodBtn;
}
- (void)autoLayoutSubViews {
    [self.dishImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.top.equalTo(self.contentView);
        make.height.equalTo(screenWidth / 2);
    }];
    CGFloat nameLabelToImageViewMargin = 10;
    [self.nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.dishImageView.bottom).offset(nameLabelToImageViewMargin);
    }];
    CGFloat descLabelToNameLabelMargin = 20;
    CGFloat descLabelLeftRightMargin = 15;
    [self.descLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.nameLabel.bottom).offset(descLabelToNameLabelMargin);
        make.left.equalTo(self.dishImageView).offset(descLabelLeftRightMargin);
        make.right.equalTo(self.dishImageView).offset(-descLabelLeftRightMargin);
    }];
    CGFloat goodBtnWidth = 40;
    CGFloat goodBtnHeight = 40;
    CGFloat goodBtnBottomMargin = 5;
    [self.goodBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.width.equalTo(goodBtnWidth);
        make.height.equalTo(goodBtnHeight);
        make.bottom.equalTo(self).offset(-goodBtnBottomMargin);
    }];
}
@end
