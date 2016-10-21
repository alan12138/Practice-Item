//
//  ATHomeTableViewHeaderView.m
//  ATXCF
//
//  Created by 谷士雄 on 16/10/10.
//  Copyright © 2016年 alan. All rights reserved.
//

#import "ATHomeTableViewHeaderView.h"
#import "ATLabel.h"

@interface ATHomeTableViewHeaderView ()
@property (nonatomic, weak) UIView *separatorView;
@property (nonatomic, weak) ATLabel *timeLabel;
@end
@implementation ATHomeTableViewHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        [self setupSubViews];
        [self autoLayoutSubviews];
        
    }
    return self;
}
- (void)setupSubViews {
    UIView *separatorView = [[UIView alloc] init];
    separatorView.backgroundColor = ATMainBackgroundColor;
    [self.contentView addSubview:separatorView];
    self.separatorView = separatorView;
    
    ATLabel *timeLabel = [[ATLabel alloc] init];
    timeLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
}
- (void)autoLayoutSubviews {
    CGFloat separatorViewheight = 10;
    [self.separatorView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.equalTo(separatorViewheight);
    }];

    [self.timeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
    }];

}
- (void)setTitle:(NSString *)title {
    _title = title;
    self.timeLabel.text = title;
}
@end
