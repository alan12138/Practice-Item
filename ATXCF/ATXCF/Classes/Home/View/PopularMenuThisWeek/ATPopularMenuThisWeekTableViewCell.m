//
//  ATPopularMenuThisWeekTableViewCell.m
//  ATXCF
//
//  Created by 谷士雄 on 16/9/30.
//  Copyright © 2016年 alan. All rights reserved.
//

#import "ATPopularMenuThisWeekTableViewCell.h"
#import "ATPopularMenuThisWeek.h"

static CGFloat const LEFT_RIGHT_MARGIN = 20;
static CGFloat const TOP_MARGIN = 20;
static CGFloat const MENU_IMAGE_HEIGHT = 200;
static CGFloat const SEPERATORVIEW_HEIGHT = 1;
static CGFloat const SEPERATORVIEW_TOP_MARGIN = 20;
static CGFloat const USERICONIMAGEVIEW_WIDTH_HEIGHT = 50;
static CGFloat const TOP_TO_PERSONNUMLABEL = 10;
static CGFloat const TOP_TO_TITLELABEL = 10;
static CGFloat const LEFT_TO_SCORELABEL = 5;

@interface ATPopularMenuThisWeekTableViewCell ()
@property (nonatomic, weak) ATImageView *menuImageView;
@property (nonatomic, weak) ATLabel *markLabel;
@property (nonatomic, weak) ATLabel *titleLabel;
@property (nonatomic, weak) ATLabel *scoreLabel;
@property (nonatomic, weak) ATLabel *personNumLabel;
@property (nonatomic, weak) ATImageView *userIconImageView;
@property (nonatomic, weak) ATLabel *userNameLabel;
@property (nonatomic, strong) ATLabel *campaignLabel;
@property (nonatomic, weak) UIView *separatorView;
@end

@implementation ATPopularMenuThisWeekTableViewCell
- (void)setPopularMenuThisWeek:(ATPopularMenuThisWeek *)popularMenuThisWeek {
    _popularMenuThisWeek = popularMenuThisWeek;
    
    [self.menuImageView setMainImageURL:[NSURL URLWithString:popularMenuThisWeek.recipe.photo]];
    
    if (popularMenuThisWeek.recipe.is_exclusive) {
        self.markLabel.hidden = NO;
    } else {
        self.markLabel.hidden = YES;
    }
    self.titleLabel.text = popularMenuThisWeek.recipe.name;
    
    [self.userIconImageView setMainImageURL:[NSURL URLWithString:popularMenuThisWeek.recipe.author.photo]];
    
    self.userNameLabel.text = popularMenuThisWeek.recipe.author.name;
    
    if (popularMenuThisWeek.recipe.score.length) {
        self.scoreLabel.text = [NSString stringWithFormat:@"%@分", popularMenuThisWeek.recipe.score];
        [self.personNumLabel remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.scoreLabel.right).offset(LEFT_TO_SCORELABEL);
            make.top.equalTo(self.titleLabel.bottom).offset(TOP_TO_TITLELABEL);
        }];
    } else {
        self.scoreLabel.text = @"";
        [self.personNumLabel remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.left);
            make.top.equalTo(self.titleLabel.bottom).offset(TOP_TO_TITLELABEL);
        }];
    }
    self.personNumLabel.text = [NSString stringWithFormat:@"%@人做过", popularMenuThisWeek.recipe.stats.n_cooked];
    
    if (popularMenuThisWeek.reason.length) {
        [self.contentView addSubview:self.campaignLabel];
        self.campaignLabel.text = popularMenuThisWeek.reason;

        [self.campaignLabel remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.menuImageView);
            make.top.equalTo(self.personNumLabel.bottom).offset(TOP_TO_PERSONNUMLABEL);
        }];
        [self.separatorView remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.height.equalTo(SEPERATORVIEW_HEIGHT);
            make.top.equalTo(self.campaignLabel.bottom).offset(SEPERATORVIEW_TOP_MARGIN);
        }];
    } else {
        [self.campaignLabel removeFromSuperview];
        [self.separatorView remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.height.equalTo(SEPERATORVIEW_HEIGHT);
            make.top.equalTo(self.userNameLabel.bottom).offset(SEPERATORVIEW_TOP_MARGIN);
        }];

    }
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubViews];
        [self autoLayoutSubviews];
    }
    return self;
}
- (void)setupSubViews {
    
    ATImageView *menuImageView = [[ATImageView alloc] init];
    [self.contentView addSubview:menuImageView];
    self.menuImageView = menuImageView;
    
    ATLabel *markLabel = [[ATLabel alloc] init];
    markLabel.font = [UIFont systemFontOfSize:12];
    markLabel.text = @"独家";
    markLabel.textAlignment = NSTextAlignmentCenter;
    markLabel.hidden = YES;
    markLabel.backgroundColor = ATColor(254, 174, 9, 1.0);
    markLabel.textColor = [UIColor whiteColor];
    [self.menuImageView addSubview:markLabel];
    self.markLabel = markLabel;

    ATImageView *userIconImageView = [[ATImageView alloc] init];
    [self.contentView addSubview:userIconImageView];
    self.userIconImageView = userIconImageView;

    //剪切原型图片
    userIconImageView.layer.masksToBounds = YES;
    userIconImageView.layer.cornerRadius = USERICONIMAGEVIEW_WIDTH_HEIGHT / 2;

    ATLabel *titleLabel = [[ATLabel alloc] init];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    ATLabel *scoreLabel = [[ATLabel alloc] init];
    scoreLabel.textColor = [UIColor lightGrayColor];
    scoreLabel.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:scoreLabel];
    self.scoreLabel = scoreLabel;
    
    ATLabel *personNumLabel = [[ATLabel alloc] init];
    personNumLabel.textColor = [UIColor lightGrayColor];
    personNumLabel.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:personNumLabel];
    self.personNumLabel = personNumLabel;

    ATLabel *userNameLabel = [[ATLabel alloc] init];
    userNameLabel.textAlignment = NSTextAlignmentCenter;
    userNameLabel.textColor = [UIColor lightGrayColor];
    userNameLabel.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:userNameLabel];
    self.userNameLabel = userNameLabel;
    
    ATLabel *campaignLabel = [[ATLabel alloc] init];
    campaignLabel.textColor = [UIColor lightGrayColor];
    campaignLabel.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:campaignLabel];
    self.campaignLabel = campaignLabel;
    
    UIView *separatorView = [[UIView alloc] init];
    separatorView.backgroundColor = ATSeparatorBackgroundColor;
    [self.contentView addSubview:separatorView];
    self.separatorView = separatorView;
}
- (void)autoLayoutSubviews {
    [self.menuImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(TOP_MARGIN);
        make.left.equalTo(self).offset(LEFT_RIGHT_MARGIN);
        make.right.equalTo(self).offset(-LEFT_RIGHT_MARGIN);
        make.height.equalTo(MENU_IMAGE_HEIGHT);
    }];

    CGFloat marginToMenuImageView = 10;
    CGFloat markLabelWidth = 50;
    CGFloat markLabelHeight = 20;
    [self.markLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.menuImageView.top).offset(marginToMenuImageView);
        make.left.equalTo(self.menuImageView.left).offset(marginToMenuImageView);
        make.width.equalTo(markLabelWidth);
        make.height.equalTo(markLabelHeight);
    }];
    
    CGFloat topToMenuImageView = 10;
    [self.userIconImageView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.menuImageView);
        make.top.equalTo(self.menuImageView.bottom).offset(topToMenuImageView);
        make.width.equalTo(USERICONIMAGEVIEW_WIDTH_HEIGHT);
        make.height.equalTo(USERICONIMAGEVIEW_WIDTH_HEIGHT);
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.menuImageView);
        make.right.equalTo(self.userIconImageView.left);
        make.top.equalTo(self.menuImageView.bottom).offset(TOP_MARGIN);
    }];
    
    [self.scoreLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.bottom).offset(TOP_TO_TITLELABEL);
    }];
    
    [self.personNumLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scoreLabel.right).offset(LEFT_TO_SCORELABEL);
        make.top.equalTo(self.titleLabel.bottom).offset(TOP_TO_TITLELABEL);
    }];

    CGFloat topTouserIconImageView = 5;
    [self.userNameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userIconImageView);
        make.top.equalTo(self.userIconImageView.bottom).offset(topTouserIconImageView);
        make.right.equalTo(self.userIconImageView);
    }];
    
    [self.campaignLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.menuImageView);
        make.top.equalTo(self.personNumLabel.bottom).offset(TOP_TO_PERSONNUMLABEL);
    }];
    
    [self.separatorView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self.campaignLabel.bottom).offset(SEPERATORVIEW_TOP_MARGIN);
        make.height.equalTo(SEPERATORVIEW_HEIGHT);
    }];

}
@end
