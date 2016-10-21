//
//  ATHomeCellClickMealsTableHeaderView.m
//  ATXCF
//
//  Created by 谷士雄 on 16/10/21.
//  Copyright © 2016年 alan. All rights reserved.
//

#import "ATHomeCellClickMealsTableHeaderView.h"
#import "ATHomeCellClickMealsHeader.h"

static CGFloat const AT_LEFT_MARGIN = 20;

@interface ATHomeCellClickMealsTableHeaderView ()
@property (nonatomic, weak) ATLabel *titleLabel;
@property (nonatomic, weak) UIView *nameView;
@property (nonatomic, weak) ATLabel *fromLabel;
@property (nonatomic, weak) ATButton *nameBtn;
@property (nonatomic, weak) ATLabel *descLabel;
@end

@implementation ATHomeCellClickMealsTableHeaderView
- (void)setHeader:(ATHomeCellClickMealsHeader *)header {
    _header = header;
    self.titleLabel.text = header.name;
    [self.nameBtn setTitle:header.author.name];
    self.descLabel.text = header.desc;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubViews];
        [self autoLayoutSubViews];
    }
    return self;
}

- (void)setupSubViews {
    ATLabel *titleLabel = [[ATLabel alloc] init];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.numberOfLines = 2;
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UIView *nameView = [[UIView alloc] init];
    nameView.contentMode = UIViewContentModeCenter;
    [self addSubview:nameView];
    self.nameView = nameView;
    
    ATLabel *fromLabel = [[ATLabel alloc] init];
    fromLabel.textColor = [UIColor grayColor];
    fromLabel.font = [UIFont systemFontOfSize:10];
    fromLabel.text = @"来自:";
    [self.nameView addSubview:fromLabel];
    self.fromLabel = fromLabel;
    
    ATButton *nameBtn = [[ATButton alloc] init];
    nameBtn.titleColor = [UIColor redColor];
    nameBtn.titleFontSize = 10;
    [self.nameView addSubview:nameBtn];
    self.nameBtn = nameBtn;
    
    ATLabel *descLabel = [[ATLabel alloc] init];
    descLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:descLabel];
    self.descLabel = descLabel;
}

- (void)autoLayoutSubViews {
    CGFloat titleLabelTopMargin = 20;
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(titleLabelTopMargin);
    }];
    CGFloat nameViewWidth = 100;
    CGFloat nameViewHeigth = 44;
    [self.nameView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.titleLabel.bottom);
        make.height.equalTo(nameViewHeigth);
        make.width.equalTo(nameViewWidth);
    }];
    [self.fromLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameView);
        make.left.equalTo(self.nameView);
    }];
    [self.nameBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fromLabel.right);
        make.centerY.equalTo(self.fromLabel);
    }];
    [self.descLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(AT_LEFT_MARGIN);
        make.top.equalTo(self.nameView.bottom);
    }];
}

@end
